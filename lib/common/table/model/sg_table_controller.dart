import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:se_gay_components/common/table/enum/sort_direction.dart';
import 'package:se_gay_components/common/table/model/sg_table_props.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

/// TableController xử lý tất cả logic thao tác dữ liệu cho SgTable
class SgTableController<T> extends ChangeNotifier {
  // Trạng thái dữ liệu
  List<T> _data = [];
  List<T> _sortedData = [];
  List<T> _filteredData = [];
  List<SgTableColumn<T>> _effectiveColumns = [];
  String? _searchTerm;
  Timer? _debounceTimer;

  // Trạng thái lựa chọn
  final Set<T> _selectedItems = {};
  bool _allSelected = false;
  int? _selectedRowIndex;

  // Trạng thái sắp xếp
  int? _sortColumnIndex;
  SortDirection _sortDirection = SortDirection.none;

  // Trạng thái chiều rộng cột
  Map<int, double> _columnWidths = {};
  Map<int, double> _originalColumnWidths = {};
  int? _resizingColumnIndex;
  double? _resizeStartX;
  double? _resizeStartWidth;

  // Caching để tối ưu hiệu năng
  final Map<String, List<Widget>> _cachedRows = {};
  final Map<int, List<Widget>> _cachedHeaderCells = {};
  bool _layoutDirty = true;

  // Các getter
  List<T> get data => _data;
  List<T> get sortedData => _sortedData;
  List<T> get filteredData => _filteredData;
  List<SgTableColumn<T>> get effectiveColumns => _effectiveColumns;
  Set<T> get selectedItems => _selectedItems;
  bool get allSelected => _allSelected;
  int? get selectedRowIndex => _selectedRowIndex;
  int? get sortColumnIndex => _sortColumnIndex;
  SortDirection get sortDirection => _sortDirection;
  Map<int, double> get columnWidths => _columnWidths;
  int? get resizingColumnIndex => _resizingColumnIndex;
  // Lấy dữ liệu cho trang hiện tại (API cho phân trang bên ngoài)
  List<T> getPagedData(int page, int itemsPerPage) {
    if (_sortedData.isEmpty) return [];

    final startIndex = page * itemsPerPage;
    if (startIndex >= _sortedData.length) return [];

    final endIndex = (startIndex + itemsPerPage) < _sortedData.length ? startIndex + itemsPerPage : _sortedData.length;

    return _sortedData.sublist(startIndex, endIndex);
  }

  // Callbacks
  final Function(List<T>)? onSelectionChanged;
  final Function(T)? onRowTap;

  SgTableController({
    required List<T> initialData,
    required List<SgTableColumn<T>> columns,
    this.onSelectionChanged,
    this.onRowTap,
    String? searchTerm,
    bool showCheckboxes = false,
    bool showActions = false,
    String? actionColumnTitle,
    double? actionColumnWidth,
    double checkboxColumnWidth = 50.0,
    double widthScreen = 800.0,
  }) {
    _data = List.from(initialData);
    _sortedData = List.from(_data);
    _filteredData = List.from(_data);
    _searchTerm = searchTerm;

    _buildEffectiveColumns(
        columns, showCheckboxes, showActions, actionColumnTitle, actionColumnWidth, checkboxColumnWidth, widthScreen);
    _initColumnWidths(widthScreen, showCheckboxes, showActions, actionColumnWidth, checkboxColumnWidth);
    _filterData(columns, searchTerm);
  }

  // Tạo khóa cache cho các hàng
  String _getRowCacheKey(T item, double width) {
    return '${item.hashCode}_${width}_${_sortDirection}_${_selectedRowIndex}_${_selectedItems.contains(item)}';
  }

  // Cập nhật dữ liệu từ props
  void updateFromProps(SgTableProps<T> props) {
    bool needsNotify = false;
    bool columnsChanged = false;

    if (!listEquals(_data, props.data)) {
      _data = List.from(props.data);
      _sortedData = List.from(_data);
      needsNotify = true;

      // Cập nhật các mục đã chọn khi dữ liệu thay đổi
      if (props.showCheckboxes) {
        _selectedItems.removeWhere((item) => !props.data.contains(item));
        _updateAllSelectedState();
      }

      _filterAndSortData(props);
    }

    if (_searchTerm != props.searchTerm) {
      _searchTerm = props.searchTerm;
      needsNotify = true;
      _filterAndSortData(props);
    }

    // Xác định xem cấu trúc cột có thay đổi không
    if (props.columns.length != _effectiveColumns.length || !_haveSameColumns(props.columns)) {
      columnsChanged = true;
    }

    // Xây dựng lại các cột nếu cần nhưng giữ nguyên kích thước cột đã thay đổi
    if (columnsChanged) {
      // Lưu kích thước cột hiện tại trước khi cập nhật
      final currentWidths = Map<int, double>.from(_columnWidths);

      _buildEffectiveColumns(props.columns, props.showCheckboxes, props.showActions, props.actionColumnTitle,
          props.actionColumnWidth, props.checkboxColumnWidth, props.widthScreen);

      // Chỉ khởi tạo lại chiều rộng cột nếu cấu trúc cột thực sự thay đổi
      _initColumnWidths(props.widthScreen, props.showCheckboxes, props.showActions, props.actionColumnWidth,
          props.checkboxColumnWidth);

      // Khôi phục chiều rộng cột đã được người dùng thay đổi
      for (final entry in currentWidths.entries) {
        // Chỉ khôi phục cho các cột còn tồn tại
        if (entry.key < _effectiveColumns.length) {
          _columnWidths[entry.key] = entry.value;
        }
      }

      _layoutDirty = true;
      needsNotify = true;
      // Xóa cache khi các cột thay đổi
      _cachedRows.clear();
      _cachedHeaderCells.clear();
    }

    // Chỉ thông báo nếu cần thiết
    if (needsNotify) {
      notifyListeners();
    }
  }

  // Helper method để kiểm tra xem cấu trúc cột có thay đổi không
  bool _haveSameColumns(List<SgTableColumn<T>> newColumns) {
    if (newColumns.length != _effectiveColumns.length) return false;

    for (int i = 0; i < newColumns.length; i++) {
      // Kiểm tra nếu tiêu đề cột giống nhau (đơn giản hóa, có thể mở rộng với nhiều tiêu chí hơn)
      if (i >= _effectiveColumns.length || newColumns[i].title != _effectiveColumns[i].title) {
        return false;
      }
    }

    return true;
  }

  // Xây dựng các cột hiệu quả (bao gồm checkbox và hành động)
  void _buildEffectiveColumns(
    List<SgTableColumn<T>> columns,
    bool showCheckboxes,
    bool showActions,
    String? actionColumnTitle,
    double? actionColumnWidth,
    double checkboxColumnWidth,
    double widthScreen,
  ) {
    _effectiveColumns = [];

    // Thêm cột checkbox nếu cần
    if (showCheckboxes) {
      _effectiveColumns.add(
        SgTableColumn<T>(
          title: '',
          width: checkboxColumnWidth,
          cellBuilder: (item) => Checkbox(
            value: _selectedItems.contains(item),
            onChanged: (selected) => toggleSelectItem(item, selected),
          ),
          cellAlignment: TextAlign.center,
          titleAlignment: TextAlign.center,
        ),
      );
    }

    // Thêm các cột thông thường
    _effectiveColumns.addAll(columns);

    // Thêm cột hành động nếu được bật
    if (showActions) {
      _effectiveColumns.add(
        SgTableActionColumn<T>(
          title: actionColumnTitle ?? 'Hành động',
          width: actionColumnWidth,
        ),
      );
    }
  }

  // Khởi tạo chiều rộng cột
  void _initColumnWidths(
    double widthScreen,
    bool showCheckboxes,
    bool showActions,
    double? actionColumnWidth,
    double checkboxColumnWidth,
  ) {
    _columnWidths = {};
    for (int i = 0; i < _effectiveColumns.length; i++) {
      if (_effectiveColumns[i].width != null) {
        _columnWidths[i] = _effectiveColumns[i].width!;
      } else {
        // Chiều rộng mặc định nếu không được chỉ định
        _columnWidths[i] = 120.0;
        if (_effectiveColumns[i].isFullWidth) {
          if (showCheckboxes && showActions) {
            _columnWidths[i] =
                (widthScreen - checkboxColumnWidth - actionColumnWidth!) / (_effectiveColumns.length - 2);
          } else if (showCheckboxes) {
            _columnWidths[i] = (widthScreen - checkboxColumnWidth) / (_effectiveColumns.length - 1);
          } else if (showActions) {
            _columnWidths[i] = (widthScreen - actionColumnWidth!) / (_effectiveColumns.length - 1);
          } else {
            _columnWidths[i] = widthScreen / _effectiveColumns.length;
          }
        }
      }
    }
    _originalColumnWidths = Map.from(_columnWidths);
    _layoutDirty = true;
    _cachedHeaderCells.clear(); // Xóa cache ô tiêu đề khi chiều rộng cột thay đổi
  }

  //---------------------------
  // OPERATIONS LỌC & SẮP XẾP
  //---------------------------

  // Lọc và sắp xếp dữ liệu với debounce
  void _filterAndSortData(SgTableProps<T> props) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 150), () {
      _filterData(props.columns, props.searchTerm, props.customFilter, props.caseSensitiveSearch);
      _sortData(props.columns);
      notifyListeners();
    });
  }

  // Lọc dữ liệu dựa trên từ khóa tìm kiếm
  void _filterData(List<SgTableColumn<T>> columns, String? searchTerm,
      [bool Function(T)? customFilter, bool caseSensitiveSearch = false]) {
    if ((searchTerm == null || searchTerm.isEmpty) && customFilter == null) {
      _filteredData = List.from(_data);
    } else {
      _filteredData = _data.where((item) {
        if (customFilter != null && !customFilter(item)) {
          return false;
        }

        if (searchTerm != null && searchTerm.isNotEmpty) {
          final term = caseSensitiveSearch ? searchTerm : searchTerm.toLowerCase();

          for (var column in columns) {
            if (column.searchable && column.searchValueGetter != null) {
              final value = column.searchValueGetter!(item);
              final stringValue = caseSensitiveSearch ? value : value.toLowerCase();
              if (stringValue.contains(term)) {
                return true;
              }
            }
          }
          return false;
        }
        return true;
      }).toList();
    }

    _sortedData = List.from(_filteredData);
    _cachedRows.clear(); // Xóa cache hàng khi dữ liệu được lọc
  }

  // Sắp xếp dữ liệu dựa trên cột đã chọn
  void _sortData(List<SgTableColumn<T>> columns) {
    if (_sortColumnIndex == null ||
        _sortDirection == SortDirection.none ||
        _sortColumnIndex! >= columns.length ||
        columns[_sortColumnIndex!].sortValueGetter == null) {
      return;
    }

    final sortValueGetter = columns[_sortColumnIndex!].sortValueGetter!;

    // Sử dụng compute cho các tập dữ liệu lớn
    if (_sortedData.length > 1000) {
      compute<_SortParams<T>, List<T>>(
          _sortCompute,
          _SortParams(
            data: _sortedData,
            getter: sortValueGetter,
            direction: _sortDirection,
          )).then((result) {
        _sortedData = result;
        _cachedRows.clear();
        notifyListeners();
      });
    } else {
      _sortedData.sort((a, b) {
        return _compareItems(a, b, sortValueGetter, _sortDirection);
      });
      _cachedRows.clear();
    }
  }

  // So sánh các item để sắp xếp
  static int _compareItems<T>(T a, T b, dynamic Function(T) getter, SortDirection direction) {
    final aValue = getter(a);
    final bValue = getter(b);

    if (aValue == null && bValue == null) return 0;
    if (aValue == null) {
      return direction == SortDirection.ascending ? -1 : 1;
    }
    if (bValue == null) {
      return direction == SortDirection.ascending ? 1 : -1;
    }

    int comparison;
    if (aValue is String && bValue is String) {
      comparison = aValue.toLowerCase().compareTo(bValue.toLowerCase());
    } else if (aValue is num && bValue is num) {
      comparison = aValue.compareTo(bValue);
    } else if (aValue is DateTime && bValue is DateTime) {
      comparison = aValue.compareTo(bValue);
    } else if (aValue is bool && bValue is bool) {
      comparison = aValue ? (bValue ? 0 : 1) : (bValue ? -1 : 0);
    } else {
      comparison = aValue.toString().compareTo(bValue.toString());
    }

    return direction == SortDirection.ascending ? comparison : -comparison;
  }

  // Phương thức tĩnh cho hàm compute
  static List<T> _sortCompute<T>(_SortParams<T> params) {
    final result = List<T>.from(params.data);
    result.sort((a, b) => _compareItems(a, b, params.getter, params.direction));
    return result;
  }

  // Xử lý khi nhấp vào tiêu đề cột để sắp xếp
  void onSortColumn(int columnIndex) {
    if (_sortColumnIndex == columnIndex) {
      if (_sortDirection == SortDirection.none) {
        _sortDirection = SortDirection.ascending;
      } else if (_sortDirection == SortDirection.ascending) {
        _sortDirection = SortDirection.descending;
      } else {
        _sortDirection = SortDirection.none;
      }
    } else {
      _sortColumnIndex = columnIndex;
      _sortDirection = SortDirection.ascending;
    }

    if (_sortDirection == SortDirection.none) {
      _sortedData = List.from(_filteredData);
    } else {
      _sortData(_effectiveColumns);
    }

    _cachedRows.clear();
    _cachedHeaderCells.clear();
    notifyListeners();
  }

  //---------------------------
  // QUẢN LÝ LỰA CHỌN
  //---------------------------

  // Chọn/bỏ chọn tất cả
  void toggleSelectAll(bool? selected) {
    if (selected == null) return;

    _allSelected = selected;

    if (_allSelected) {
      _selectedItems.addAll(_sortedData);
    } else {
      _selectedItems.clear();
    }

    _notifySelectionChanged();
    _cachedRows.clear(); // Xóa cache hàng khi thay đổi lựa chọn
    notifyListeners();
  }

  // Chọn/bỏ chọn một mục
  void toggleSelectItem(T item, bool? selected) {
    if (selected == null) return;

    if (selected) {
      _selectedItems.add(item);
    } else {
      _selectedItems.remove(item);
    }

    _updateAllSelectedState();
    _notifySelectionChanged();

    // Chỉ xóa cache cho mục cụ thể
    final key = _getRowCacheKey(item, 0);
    _cachedRows.remove(key);

    notifyListeners();
  }

  // Cập nhật trạng thái chọn tất cả
  void _updateAllSelectedState() {
    if (_sortedData.isEmpty) {
      _allSelected = false;
      return;
    }

    _allSelected = _sortedData.every((item) => _selectedItems.contains(item));
  }

  // Thông báo thay đổi lựa chọn
  void _notifySelectionChanged() {
    if (onSelectionChanged != null) {
      onSelectionChanged!(_selectedItems.toList());
    }
  }

  // Xử lý khi chọn hàng
  void onRowSelected(int index) {
    if (_selectedRowIndex == index) {
      _selectedRowIndex = null;
    } else {
      _selectedRowIndex = index;
    }

    if (onRowTap != null && index < _sortedData.length) {
      onRowTap!(_sortedData[index]);
    }

    _cachedRows.clear(); // Xóa cache hàng khi thay đổi lựa chọn hàng
    notifyListeners();
  }

  //---------------------------
  // THAY ĐỔI KÍCH THƯỚC CỘT
  //---------------------------

  // Bắt đầu thay đổi kích thước
  void startResize(int columnIndex, double startX) {
    _resizingColumnIndex = columnIndex;
    _resizeStartX = startX;
    _resizeStartWidth = _columnWidths[columnIndex];
    _layoutDirty = true;
    notifyListeners();
  }

  // Cập nhật kích thước khi đang thay đổi
  void updateResize(double currentX) {
    if (_resizingColumnIndex == null || _resizeStartX == null || _resizeStartWidth == null) {
      return;
    }

    final delta = currentX - _resizeStartX!;
    final originalWidth = _originalColumnWidths[_resizingColumnIndex] ?? 120.0;
    final newWidth = _resizeStartWidth! + delta;

    if (newWidth >= originalWidth) {
      // Cập nhật trực tiếp và thông báo ngay lập tức
      _columnWidths[_resizingColumnIndex!] = newWidth;
      _layoutDirty = true;
      _cachedHeaderCells.clear(); // Xóa cache tiêu đề khi thay đổi kích thước
      _cachedRows.clear(); // Xóa cache hàng khi chiều rộng cột thay đổi
      notifyListeners();
    }
  }

  // Kết thúc thay đổi kích thước
  void endResize() {
    _resizingColumnIndex = null;
    _resizeStartX = null;
    _resizeStartWidth = null;
    notifyListeners();
  }

  // Tính tổng chiều rộng
  double calculateTotalWidth() {
    if (!_layoutDirty) {
      // Kiểm tra nếu có giá trị đã cache
      return _cachedTotalWidth;
    }

    double totalWidth = 0;
    for (int i = 0; i < _effectiveColumns.length; i++) {
      totalWidth += _columnWidths[i] ?? (_effectiveColumns[i].width ?? 120.0);
    }

    _cachedTotalWidth = totalWidth;
    _layoutDirty = false;
    return totalWidth;
  }

  // Cache cho tổng chiều rộng
  double _cachedTotalWidth = 0.0;

  // Kiểm soát cache
  void clearCache() {
    _cachedRows.clear();
    _cachedHeaderCells.clear();
    _layoutDirty = true;
  }

  // Kiểm tra nếu có cache cho hàng
  bool hasRowCache(T item, double width) {
    final key = _getRowCacheKey(item, width);
    return _cachedRows.containsKey(key);
  }

  // Lưu hàng vào cache
  void cacheRow(T item, double width, List<Widget> rowCells) {
    final key = _getRowCacheKey(item, width);
    _cachedRows[key] = rowCells;
  }

  // Lấy hàng từ cache
  List<Widget>? getCachedRow(T item, double width) {
    final key = _getRowCacheKey(item, width);
    return _cachedRows[key];
  }

  // Cache ô tiêu đề
  void cacheHeaderCells(int key, List<Widget> cells) {
    _cachedHeaderCells[key] = cells;
  }

  // Lấy ô tiêu đề từ cache
  List<Widget>? getCachedHeaderCells(int key) {
    return _cachedHeaderCells[key];
  }

  // Phương thức mới để cập nhật dữ liệu mà không cần xây dựng lại toàn bộ bảng
  void updateData(List<T> newData) {
    // Lưu trữ kích thước cột và trạng thái sắp xếp hiện tại
    final currentColumnWidths = Map<int, double>.from(_columnWidths);
    final currentSortColumnIndex = _sortColumnIndex;
    final currentSortDirection = _sortDirection;

    // Cập nhật dữ liệu
    _data = List.from(newData);
    _filteredData = List.from(newData);
    _sortedData = List.from(newData);

    // Duy trì các mục đã chọn hiện tại nếu chúng vẫn tồn tại trong dữ liệu mới
    _selectedItems.removeWhere((item) => !newData.contains(item));
    _updateAllSelectedState();

    // Khôi phục kích thước cột hiện tại
    _columnWidths = currentColumnWidths;

    // Áp dụng bộ lọc và sắp xếp hiện tại
    if (_searchTerm != null && _searchTerm!.isNotEmpty) {
      _filterData(_effectiveColumns, _searchTerm);
    }

    // Khôi phục trạng thái sắp xếp
    _sortColumnIndex = currentSortColumnIndex;
    _sortDirection = currentSortDirection;

    if (_sortColumnIndex != null && _sortDirection != SortDirection.none) {
      _sortData(_effectiveColumns);
    }

    // Xóa cache để đảm bảo hiển thị chính xác
    _cachedRows.clear();

    // Thông báo về thay đổi
    notifyListeners();
  }
}

// Lớp helper cho hàm compute sắp xếp
class _SortParams<T> {
  final List<T> data;
  final dynamic Function(T) getter;
  final SortDirection direction;

  _SortParams({
    required this.data,
    required this.getter,
    required this.direction,
  });
}
