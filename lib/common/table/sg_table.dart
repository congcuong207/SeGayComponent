// Import các thư viện cần thiết
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'dart:async'; // Import Timer
import 'dart:collection'; // Import LinkedHashMap
import 'sg_table_header.dart'; // Import component header
import 'sg_table_row.dart'; // Import component row

// Enum để định nghĩa hướng sắp xếp
enum SortDirection { none, ascending, descending }

// Widget chính SgTable - Bảng dữ liệu có thể tùy chỉnh với nhiều tính năng
class SgTable<T> extends StatefulWidget {
  //---------------------------
  // NHÓM DỮ LIỆU CHÍNH
  //---------------------------
  /// Danh sách các cột của bảng
  final List<SgTableColumn<T>> columns;
  
  /// Dữ liệu hiển thị trong bảng
  final List<T> data;
  
  //---------------------------
  // NHÓM KÍCH THƯỚC & GIAO DIỆN
  //---------------------------
  /// Chiều cao của mỗi hàng
  final double rowHeight;
  
  /// Bo tròn viền của bảng
  final BorderRadius? borderRadius;
  
  /// Controller để điều khiển cuộn dọc
  final ScrollController? verticalController;

  //---------------------------
  // NHÓM MÀU SẮC
  //---------------------------
  /// Màu chữ trong header
  final Color? textHeaderColor;
  
  /// Màu nền của header
  final Color headerBackgroundColor;
  
  /// Màu nền cho hàng lẻ
  final Color oddRowBackgroundColor;
  
  /// Màu nền cho hàng chẵn
  final Color evenRowBackgroundColor;
  
  /// Màu khi hàng được chọn (hover hoặc click)
  final Color selectedRowColor;
  
  /// Màu khi hàng được đánh dấu với checkbox
  final Color checkedRowColor;

  //---------------------------
  // NHÓM ĐƯỜNG KẺ LƯỚI
  //---------------------------
  /// Màu của đường kẻ lưới
  final Color gridLineColor;
  
  /// Độ dày của đường kẻ lưới
  final double gridLineWidth;
  
  /// Hiển thị đường kẻ dọc
  final bool showVerticalLines;
  
  /// Hiển thị đường kẻ ngang
  final bool showHorizontalLines;
  
  /// Hiển thị đường kẻ cuối cùng bên trái/phải
  final bool showLastLineLeftRight;
  
  /// Hiển thị đường kẻ cuối cùng trên/dưới
  final bool showLastLineTopBottom;

  //---------------------------
  // NHÓM TƯƠNG TÁC & LỰA CHỌN
  //---------------------------
  /// Cho phép chọn hàng khi click
  final bool allowRowSelection;
  
  /// Callback khi nhấp vào một hàng
  final Function(T)? onRowTap;

  //---------------------------
  // NHÓM TÌM KIẾM & LỌC
  //---------------------------
  /// Từ khóa tìm kiếm
  final String? searchTerm;
  
  /// Tìm kiếm phân biệt chữ hoa/thường
  final bool caseSensitiveSearch;
  
  /// Hàm lọc tùy chỉnh
  final bool Function(T)? customFilter;

  //---------------------------
  // NHÓM CHECKBOX
  //---------------------------
  /// Hiển thị cột checkbox chọn nhiều
  final bool showCheckboxes;
  
  /// Callback khi thay đổi lựa chọn checkbox
  final Function(List<T>)? onSelectionChanged;
  
  /// Chiều rộng của cột checkbox
  final double checkboxColumnWidth;
  
  /// Tỷ lệ kích thước checkbox
  final double? scaleCheckbox;
  
  /// Màu khi checkbox được chọn
  final Color? activeColor;
  
  /// Màu dấu check
  final Color? checkColor;
  
  /// Viền của checkbox
  final BorderSide? side;
  
  /// Hình dạng của checkbox
  final BeveledRectangleBorder? shape;

  //---------------------------
  // NHÓM CỘT HÀNH ĐỘNG
  //---------------------------
  /// Hiển thị cột hành động
  final bool showActions;
  
  /// Callback khi nhấn nút xem chi tiết
  final Function(T)? onViewAction;
  
  /// Callback khi nhấn nút chỉnh sửa
  final Function(T)? onEditAction;
  
  /// Callback khi nhấn nút xóa
  final Function(T)? onDeleteAction;
  
  /// Màu nút xem chi tiết
  final Color? actionViewColor;
  
  /// Màu nút chỉnh sửa
  final Color? actionEditColor;
  
  /// Màu nút xóa
  final Color? actionDeleteColor;
  
  /// Kích thước icon trong cột hành động
  final double? actionIconSize;
  
  /// Chiều rộng của cột hành động
  final double? actionColumnWidth;
  
  /// Tiêu đề của cột hành động
  final String? actionColumnTitle;

  // Constructor với nhiều tham số có giá trị mặc định
  const SgTable(
      {super.key,
      // NHÓM DỮ LIỆU CHÍNH
      required this.columns,
      required this.data,
      
      // NHÓM KÍCH THƯỚC & GIAO DIỆN
      this.rowHeight = 48.0,
      this.borderRadius,
      this.verticalController,
      
      // NHÓM MÀU SẮC
      this.textHeaderColor,
      this.headerBackgroundColor = SGAppColors.neutral100,
      this.oddRowBackgroundColor = Colors.white,
      this.evenRowBackgroundColor = SGAppColors.neutral200,
      this.selectedRowColor = SGAppColors.info100,
      this.checkedRowColor = const Color(0xFFE3F2FD),
      
      // NHÓM ĐƯỜNG KẺ LƯỚI
      this.gridLineColor = SGAppColors.neutral200,
      this.gridLineWidth = 1.0,
      this.showVerticalLines = true,
      this.showHorizontalLines = true,
      this.showLastLineLeftRight = false,
      this.showLastLineTopBottom = false,
      
      // NHÓM TƯƠNG TÁC & LỰA CHỌN
      this.allowRowSelection = true,
      this.onRowTap,
      
      // NHÓM TÌM KIẾM & LỌC
      this.searchTerm,
      this.caseSensitiveSearch = false,
      this.customFilter,
      
      // NHÓM CHECKBOX
      this.showCheckboxes = false,
      this.onSelectionChanged,
      this.checkboxColumnWidth = 50.0,
      this.scaleCheckbox = 1,
      this.activeColor = Colors.blueAccent,
      this.checkColor = Colors.white,
      this.side,
      this.shape,
      
      // NHÓM CỘT HÀNH ĐỘNG
      this.showActions = false,
      this.onViewAction,
      this.onEditAction,
      this.onDeleteAction,
      this.actionViewColor,
      this.actionEditColor,
      this.actionDeleteColor,
      this.actionIconSize,
      this.actionColumnWidth = 120.0,
      this.actionColumnTitle = "Hành động"});

  @override
  State<SgTable<T>> createState() => _SgTableState<T>();
}

// State class để quản lý trạng thái của bảng
class _SgTableState<T> extends State<SgTable<T>> {
  //---------------------------
  // BIẾN TRẠNG THÁI
  //---------------------------
  // Trạng thái sắp xếp
  int? _sortColumnIndex;
  SortDirection _sortDirection = SortDirection.none;
  
  // Trạng thái dữ liệu
  late List<T> _sortedData;
  late List<T> _filteredData;
  
  // ValueNotifiers để giảm thiểu setState
  final ValueNotifier<int?> _selectedRowNotifier = ValueNotifier<int?>(null);
  final ValueNotifier<bool> _allSelectedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<Set<T>> _selectedItemsNotifier = ValueNotifier<Set<T>>({});
  
  late List<SgTableColumn<T>> _effectiveColumns;
  String? _lastSearchTerm;

  // Trạng thái checkbox selection
  final Set<T> _selectedItems = {};
  bool _allSelected = false;

  // Trạng thái kích thước cột
  Map<int, double> _columnWidths = {};
  Map<int, double> _originalColumnWidths = {};
  int? _resizingColumnIndex;
  double? _resizeStartX;
  double? _resizeStartWidth;

  // Trạng thái cuộn và tối ưu hiệu suất
  bool _isScrolling = false;
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollEndTimer;
  Timer? _resizeDebounceTimer; // Debounce timer cho resize

  // Cache để tối ưu hiệu suất render
  final Map<int, Widget> _rowCache = {};
  final Map<int, List<Widget>> _cellsCache = {};
  bool _shouldRebuildCache = true;
  
  // Cache cho header để tối ưu hiệu suất
  Widget? _headerCache;
  bool _shouldRebuildHeader = true;
  
  // LRU Cache cho rows để tránh memory leak
  final LinkedHashMap<int, Widget> _lruRowCache = LinkedHashMap<int, Widget>();
  final int _maxCacheSize = 100; // Số lượng row tối đa cache

  // Memoization cho tổng chiều rộng bảng
  late double _cachedTotalWidth;
  bool _shouldRecalculateWidth = true;

  //---------------------------
  // QUẢN LÝ VÒNG ĐỜI WIDGET
  //---------------------------
  @override
  void initState() {
    super.initState();
    _processData();
    _cachedTotalWidth = _calculateTotalWidth();
    _shouldRecalculateWidth = false;
    
    // Đồng bộ giá trị ValueNotifiers
    _selectedItemsNotifier.value = _selectedItems;
    _allSelectedNotifier.value = _allSelected;

    // Đăng ký listener sau khi build frame đầu tiên
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollController.addListener(_scrollListener);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _scrollEndTimer?.cancel();
    _resizeDebounceTimer?.cancel(); // Hủy timer resize
    _clearCaches();
    _backgroundColorCache.clear(); // Xóa cache màu nền
    
    // Dispose các ValueNotifier
    _selectedRowNotifier.dispose();
    _allSelectedNotifier.dispose();
    _selectedItemsNotifier.dispose();
    
    super.dispose();
  }

  @override
  void didUpdateWidget(SgTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Kiểm tra các thay đổi quan trọng để cập nhật bảng
    final bool dataChanged = widget.data != oldWidget.data;
    final bool columnsChanged = widget.columns != oldWidget.columns ||
        widget.showActions != oldWidget.showActions ||
        widget.showCheckboxes != oldWidget.showCheckboxes ||
        widget.actionColumnTitle != oldWidget.actionColumnTitle;
    final bool searchChanged = widget.searchTerm != _lastSearchTerm;
    final bool headerStyleChanged = 
        widget.headerBackgroundColor != oldWidget.headerBackgroundColor ||
        widget.gridLineColor != oldWidget.gridLineColor ||
        widget.gridLineWidth != oldWidget.gridLineWidth ||
        widget.textHeaderColor != oldWidget.textHeaderColor;

    if (dataChanged || columnsChanged || searchChanged || headerStyleChanged) {
      _shouldRebuildCache = true;
      _shouldRecalculateWidth = true;
      if (columnsChanged || headerStyleChanged) {
        _shouldRebuildHeader = true;
      }
      _clearCaches();

      if (dataChanged) {
        _sortedData = List.from(widget.data);
        _filterAndSortData();

        // Cập nhật danh sách item đã chọn khi dữ liệu thay đổi
        if (widget.showCheckboxes) {
          _selectedItems.removeWhere((item) => !widget.data.contains(item));
          _updateAllSelectedState();
        }
      }

      if (columnsChanged) {
        _buildEffectiveColumns();
        _initColumnWidths();
      }

      if (searchChanged) {
        _lastSearchTerm = widget.searchTerm;
        _filterAndSortData();
      }
    }
  }

  //---------------------------
  // XỬ LÝ DỮ LIỆU BAN ĐẦU
  //---------------------------
  // Xử lý dữ liệu ban đầu
  void _processData() {
    _sortedData = List.from(widget.data);
    _filteredData = List.from(_sortedData);
    _buildEffectiveColumns();
    _initColumnWidths();
    _lastSearchTerm = widget.searchTerm;
    _filterData();
  }

  // Xóa các cache để giải phóng bộ nhớ
  void _clearCaches() {
    _rowCache.clear();
    _cellsCache.clear();
    _lruRowCache.clear();
    _headerCache = null;
  }

  // Cập nhật LRU cache
  void _updateLRUCache(int index, Widget widget) {
    // Nếu cache đã đầy, xóa phần tử cũ nhất (đầu tiên trong LinkedHashMap)
    if (_lruRowCache.length >= _maxCacheSize) {
      final firstKey = _lruRowCache.keys.first;
      _lruRowCache.remove(firstKey);
    }
    
    // Thêm hoặc cập nhật phần tử trong cache
    _lruRowCache[index] = widget;
  }

  // Lấy widget từ LRU cache
  Widget? _getFromLRUCache(int index) {
    final widget = _lruRowCache[index];
    if (widget != null) {
      // Di chuyển phần tử này lên cuối (mới nhất) bằng cách xóa và thêm lại
      _lruRowCache.remove(index);
      _lruRowCache[index] = widget;
    }
    return widget;
  }

  //---------------------------
  // QUẢN LÝ CUỘN
  //---------------------------
  // Lắng nghe sự kiện cuộn để tối ưu hiệu suất
  void _scrollListener() {
    // Kiểm tra nếu controller không có client
    if (!_scrollController.hasClients) return;

    // Đánh dấu đang cuộn khi có bất kỳ thay đổi nào về vị trí cuộn
    if (_scrollController.position.isScrollingNotifier.value && !_isScrolling) {
      // Không gọi setState liên tục khi đang cuộn
      _isScrolling = true;

      // Reset timer mỗi khi nhận sự kiện cuộn
      _scrollEndTimer?.cancel();
      _scrollEndTimer = Timer(const Duration(milliseconds: 300), () {
        if (mounted) {
          _isScrolling = false;
        }
      });
    }
  }

  // Cuộn đến một hàng cụ thể với animation
  void _animateToIndex(int index) {
    if (!_scrollController.hasClients) return;

    final itemPosition = index * widget.rowHeight;
    _scrollController.animateTo(
      itemPosition.toDouble(),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  //---------------------------
  // QUẢN LÝ CỘT
  //---------------------------
  // Xây dựng danh sách cột hiệu quả, bao gồm cột checkbox và hành động nếu cần
  void _buildEffectiveColumns() {
    _effectiveColumns = [];

    // Thêm cột checkbox nếu cần
    if (widget.showCheckboxes) {
      _effectiveColumns.add(
        SgTableColumn<T>(
          title: '',
          width: widget.checkboxColumnWidth,
          cellBuilder: (item) => Transform.scale(
            scale: widget.scaleCheckbox,
            child: Checkbox(
              value: _selectedItems.contains(item),
              onChanged: (selected) => _toggleSelectItem(item, selected),
              activeColor: widget.activeColor,
              checkColor: widget.checkColor,
              side: widget.side,
              shape: widget.shape,
            ),
          ),
          cellAlignment: TextAlign.center,
          titleAlignment: TextAlign.center,
        ),
      );
    }

    // Thêm các cột thông thường
    _effectiveColumns.addAll(widget.columns);

    // Thêm cột hành động nếu được bật
    if (widget.showActions) {
      _effectiveColumns.add(
        SgTableActionColumn<T>(
          colorItemView: widget.actionViewColor,
          colorItemEdit: widget.actionEditColor,
          colorItemDelete: widget.actionDeleteColor,
          sizeIcon: widget.actionIconSize,
          title: widget.actionColumnTitle ?? 'Hành động',
          width: widget.actionColumnWidth,
          onViewAction: widget.onViewAction,
          onEditAction: widget.onEditAction,
          onDeleteAction: widget.onDeleteAction,
        ),
      );
    }
  }

  // Khởi tạo chiều rộng các cột
  void _initColumnWidths() {
    _columnWidths = {};
    for (int i = 0; i < _effectiveColumns.length; i++) {
      _columnWidths[i] = _effectiveColumns[i].width ?? 120.0;
    }
    _originalColumnWidths = Map.from(_columnWidths);
  }

  //---------------------------
  // QUẢN LÝ RESIZE CỘT
  //---------------------------
  // Bắt đầu quá trình resize cột
  void _startResize(int columnIndex, double startX) {
    setState(() {
      _resizingColumnIndex = columnIndex;
      _resizeStartX = startX;
      _resizeStartWidth = _columnWidths[columnIndex];
    });
  }

  // Cập nhật kích thước cột khi đang resize
  void _updateResize(double currentX) {
    if (_resizingColumnIndex == null || _resizeStartX == null || _resizeStartWidth == null) {
      return;
    }

    final delta = currentX - _resizeStartX!;
    final originalWidth = _originalColumnWidths[_resizingColumnIndex] ?? 120.0;
    final newWidth = _resizeStartWidth! + delta;

    if (newWidth >= originalWidth) {
      // Debounce resize updates để tránh rebuild quá nhiều
      _resizeDebounceTimer?.cancel();
      _resizeDebounceTimer = Timer(const Duration(milliseconds: 16), () {
        if (mounted) {
          setState(() {
            _columnWidths[_resizingColumnIndex!] = newWidth;
            _shouldRebuildCache = true;
            _shouldRecalculateWidth = true; // Đánh dấu cần tính toán lại width
          });
        }
      });
    }
  }

  // Kết thúc quá trình resize cột
  void _endResize() {
    _resizeDebounceTimer?.cancel(); // Hủy bất kỳ resize updates nào đang chờ xử lý
    setState(() {
      _resizingColumnIndex = null;
      _resizeStartX = null;
      _resizeStartWidth = null;
      _shouldRebuildCache = true;
      _shouldRecalculateWidth = true; // Đánh dấu cần tính toán lại width
      _clearCaches();
    });
  }

  //---------------------------
  // XỬ LÝ LỌC & SẮP XẾP
  //---------------------------
  // Lọc và sắp xếp dữ liệu
  void _filterAndSortData() {
    if ((widget.searchTerm == null || widget.searchTerm!.isEmpty) && widget.customFilter == null) {
      // Nếu không có điều kiện lọc, chỉ sắp xếp
      _sortedData = List.from(widget.data);
      if (_sortColumnIndex != null && _sortDirection != SortDirection.none) {
        _sortData();
      }
    } else {
      // Áp dụng filter và sort trong cùng một lần duyệt mảng
      _filterAndSortCombined();
    }
    
    setState(() {
      _shouldRebuildCache = true;
    });
  }
  
  // Phương thức kết hợp filter và sort để tối ưu hiệu năng
  void _filterAndSortCombined() {
    // Tạo danh sách mới và filter dữ liệu
    _sortedData = widget.data.where((item) {
      // Áp dụng custom filter trước
      if (widget.customFilter != null && !widget.customFilter!(item)) {
        return false;
      }

      // Sau đó áp dụng search term filter nếu có
      if (widget.searchTerm != null && widget.searchTerm!.isNotEmpty) {
        final term = widget.caseSensitiveSearch ? widget.searchTerm! : widget.searchTerm!.toLowerCase();
        
        for (var column in widget.columns) {
          if (column.searchable && column.searchValueGetter != null) {
            final value = column.searchValueGetter!(item);
            final stringValue = widget.caseSensitiveSearch ? value : value.toLowerCase();
            if (stringValue.contains(term)) {
              return true;
            }
          }
        }
        return false;
      }
      return true;
    }).toList();

    // Sắp xếp trực tiếp sau khi filter nếu cần
    if (_sortColumnIndex != null && 
        _sortDirection != SortDirection.none &&
        _sortColumnIndex! < widget.columns.length &&
        widget.columns[_sortColumnIndex!].sortValueGetter != null) {
      
      final sortValueGetter = widget.columns[_sortColumnIndex!].sortValueGetter!;
      
      // Sử dụng compute cho dataset lớn
      if (_sortedData.length > 1000) {
        compute<_SortParams<T>, List<T>>(
          _sortCompute,
          _SortParams(
            data: _sortedData,
            getter: sortValueGetter,
            direction: _sortDirection,
          )
        ).then((result) {
          setState(() {
            _sortedData = result;
            _shouldRebuildCache = true;
          });
        });
      } else {
        // Sort trực tiếp cho dataset nhỏ
        _sortedData.sort((a, b) {
          return _compareItems(a, b, sortValueGetter, _sortDirection);
        });
      }
    }
  }

  // Lọc dữ liệu không được dùng nữa - giữ lại để tương thích API
  void _filterData() {
    _filterAndSortData();
  }

  // Sắp xếp dữ liệu dựa trên cột được chọn
  void _sortData() {
    if (_sortColumnIndex == null ||
        _sortDirection == SortDirection.none ||
        _sortColumnIndex! >= widget.columns.length ||
        widget.columns[_sortColumnIndex!].sortValueGetter == null) {
      return;
    }

    final sortValueGetter = widget.columns[_sortColumnIndex!].sortValueGetter!;

    // Sử dụng compute để đưa việc sắp xếp vào thread riêng nếu danh sách lớn
    if (_sortedData.length > 1000) {
      compute<_SortParams<T>, List<T>>(
          _sortCompute,
          _SortParams(
            data: _sortedData,
            getter: sortValueGetter,
            direction: _sortDirection,
          )).then((result) {
        setState(() {
          _sortedData = result;
          _shouldRebuildCache = true;
        });
      });
    } else {
      setState(() {
        _sortedData.sort((a, b) {
          return _compareItems(a, b, sortValueGetter, _sortDirection);
        });
        _shouldRebuildCache = true;
      });
    }
  }

  // Phương thức so sánh để sử dụng trong cả sắp xếp thường và compute
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

  // Phương thức sắp xếp cho compute
  static List<T> _sortCompute<T>(_SortParams<T> params) {
    final result = List<T>.from(params.data);
    result.sort((a, b) => _compareItems(a, b, params.getter, params.direction));
    return result;
  }

  // Xử lý sự kiện sắp xếp khi nhấp vào tiêu đề cột
  void _onSortColumn(int columnIndex) {
    setState(() {
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
        _sortData();
      }

      _shouldRebuildCache = true;
      _shouldRebuildHeader = true; // Đánh dấu cần rebuild header khi thay đổi sắp xếp
      _clearCaches();
    });
  }

  //---------------------------
  // QUẢN LÝ CHECKBOX
  //---------------------------
  // Xử lý chọn tất cả các hàng
  void _toggleSelectAll(bool? selected) {
    if (selected == null) return;

    _allSelected = selected;
    _allSelectedNotifier.value = selected;

    if (_allSelected) {
      _selectedItems.addAll(_sortedData);
    } else {
      _selectedItems.clear();
    }
    
    _selectedItemsNotifier.value = Set.from(_selectedItems);
    _notifySelectionChanged();
    _shouldRebuildCache = true;
  }

  // Xử lý chọn một hàng cụ thể
  void _toggleSelectItem(T item, bool? selected) {
    if (selected == null) return;

    if (selected) {
      _selectedItems.add(item);
    } else {
      _selectedItems.remove(item);
    }
    
    _selectedItemsNotifier.value = Set.from(_selectedItems);
    _updateAllSelectedState();
    _notifySelectionChanged();

    // Chỉ rebuild row cần thiết
    final index = _sortedData.indexOf(item);
    if (index >= 0) {
      _rowCache.remove(index);
      _cellsCache.remove(index);
    }
  }

  // Cập nhật trạng thái chọn tất cả dựa trên các mục đã chọn
  void _updateAllSelectedState() {
    if (_sortedData.isEmpty) {
      _allSelected = false;
      _allSelectedNotifier.value = false;
      return;
    }

    final allSelected = _sortedData.every((item) => _selectedItems.contains(item));
    _allSelected = allSelected;
    _allSelectedNotifier.value = allSelected;
  }

  // Thông báo thay đổi lựa chọn qua callback
  void _notifySelectionChanged() {
    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged!(_selectedItems.toList());
    }
  }

  //---------------------------
  // XỬ LÝ CHỌN HÀNG
  //---------------------------
  // Xử lý sự kiện khi chọn hàng với hiệu ứng animation
  void _onRowSelected(int index) {
    if (!widget.allowRowSelection) return;

    final currentSelectedRowIndex = _selectedRowNotifier.value;
    
    if (currentSelectedRowIndex == index) {
      _selectedRowNotifier.value = null;
    } else {
      _selectedRowNotifier.value = index;
    }

    // Chỉ rebuild các row cần thiết
    _rowCache.remove(_selectedRowNotifier.value);
    _rowCache.remove(index);

    // Đảm bảo hàng được chọn nằm trong tầm nhìn
    _animateToIndex(index);

    if (widget.onRowTap != null) {
      widget.onRowTap!(_sortedData[index]);
    }
  }

  //---------------------------
  // TÍNH TOÁN CHIỀU RỘNG
  //---------------------------
  // Tính tổng chiều rộng của bảng với caching để tối ưu
  double _calculateTotalWidth() {
    if (!_shouldRecalculateWidth) {
      return _cachedTotalWidth;
    }

    double totalWidth = 0;
    for (int i = 0; i < _effectiveColumns.length; i++) {
      totalWidth += _columnWidths[i] ?? (_effectiveColumns[i].width ?? 120.0);
    }
    _cachedTotalWidth = totalWidth;
    _shouldRecalculateWidth = false;
    return totalWidth;
  }

  //---------------------------
  // XỬ LÝ MÀU NỀN
  //---------------------------
  // Cache màu nền để tối ưu hiệu suất
  static const Map<bool, Map<bool, Map<bool, String>>> _backgroundColorKeys = {
    true: {
      true: {true: 'selected_checked_even', false: 'selected_checked_odd'},
      false: {true: 'selected_even', false: 'selected_odd'}
    },
    false: {
      true: {true: 'checked_even', false: 'checked_odd'},
      false: {true: 'even', false: 'odd'}
    }
  };

  // Pre-compute colors khi khởi tạo
  final Map<String, Color> _backgroundColorCache = {};
  
  // Khởi tạo cache màu sắc
  void _initColorCache() {
    // Selected & checked
    _backgroundColorCache['selected_checked_even'] = widget.selectedRowColor;
    _backgroundColorCache['selected_checked_odd'] = widget.selectedRowColor;
    
    // Selected only
    _backgroundColorCache['selected_even'] = widget.selectedRowColor;
    _backgroundColorCache['selected_odd'] = widget.selectedRowColor;
    
    // Checked only
    _backgroundColorCache['checked_even'] = widget.checkedRowColor;
    _backgroundColorCache['checked_odd'] = widget.checkedRowColor;
    
    // Normal rows
    _backgroundColorCache['even'] = widget.evenRowBackgroundColor;
    _backgroundColorCache['odd'] = widget.oddRowBackgroundColor;
  }

  // Lấy màu nền cho hàng dựa trên trạng thái
  Color _getBackgroundColor(int index, bool isSelected, bool isChecked) {
    final isEven = index % 2 == 0;
    final key = _backgroundColorKeys[isSelected]![isChecked]![isEven]!;

    // Sử dụng pre-computed color
    return _backgroundColorCache[key] ?? (() {
      if (isSelected) {
        return widget.selectedRowColor;
      } else if (isChecked) {
        return widget.checkedRowColor;
      } else {
        return isEven ? widget.evenRowBackgroundColor : widget.oddRowBackgroundColor;
      }
    })();
  }

  //---------------------------
  // XÂY DỰNG GIAO DIỆN
  //---------------------------
  // Xây dựng và cache header cho table
  Widget _buildHeaderWithCache(double totalWidth, double effectiveWidth) {
    if (!_shouldRebuildHeader && _headerCache != null) {
      return _headerCache!;
    }
    
    final headerWidget = SgTableHeader<T>(
      key: ValueKey('header_${widget.hashCode}'),
      columns: _effectiveColumns,
      headerBackgroundColor: widget.headerBackgroundColor,
      gridLineColor: widget.gridLineColor,
      gridLineWidth: widget.gridLineWidth,
      textHeaderColor: widget.textHeaderColor,
      showLastLineLeftRight: widget.showLastLineLeftRight,
      showVerticalLines: widget.showVerticalLines,
      rowHeight: widget.rowHeight,
      totalWidth: totalWidth,
      effectiveWidth: effectiveWidth,
      showCheckboxes: widget.showCheckboxes,
      columnWidths: _columnWidths,
      onSortColumn: _onSortColumn,
      onStartResize: _startResize,
      onUpdateResize: _updateResize,
      onEndResize: _endResize,
      onToggleSelectAll: _toggleSelectAll,
      allSelected: _allSelected,
      sortColumnIndex: _sortColumnIndex,
      sortDirection: _sortDirection,
      checkboxColumnWidth: widget.checkboxColumnWidth,
      scaleCheckbox: widget.scaleCheckbox,
      activeColor: widget.activeColor,
      checkColor: widget.checkColor,
      side: widget.side,
      shape: widget.shape,
    );
    
    _headerCache = headerWidget;
    _shouldRebuildHeader = false;
    return headerWidget;
  }

  @override
  Widget build(BuildContext context) {
    final totalWidth = _calculateTotalWidth();
    final screenWidth = MediaQuery.of(context).size.width;
    final effectiveWidth = totalWidth > screenWidth ? totalWidth : screenWidth;

    final exactHeight = widget.rowHeight + (_sortedData.length * widget.rowHeight);

    // Rebuild cache nếu cần
    if (_shouldRebuildCache) {
      _clearCaches();
      _initColorCache(); // Khởi tạo cache màu sắc
      _shouldRebuildCache = false;
    }

    return SizedBox(
      width: totalWidth,
      height: exactHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header với cache
          _buildHeaderWithCache(totalWidth, effectiveWidth),
          
          // Phần thân bảng - với ListView.builder được tối ưu
          Expanded(
            child: ListView.builder(
              controller: widget.verticalController ?? _scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: RangeMaintainingScrollPhysics(),
              ),
              key: PageStorageKey<String>('table_${widget.hashCode}'),
              clipBehavior: Clip.hardEdge,
              cacheExtent: widget.rowHeight * 20, // Tăng cache lên 20 rows trước/sau
              itemCount: _sortedData.length,
              // Không sử dụng cả itemExtent và prototypeItem cùng lúc
              // itemExtent: widget.rowHeight, // Cố định chiều cao row để tối ưu hơn
              addAutomaticKeepAlives: false, // Tắt để tối ưu hiệu năng
              addRepaintBoundaries: true, // Giữ lại tính năng này để tối ưu render
              prototypeItem: _sortedData.isNotEmpty ? _buildPrototypeRow(effectiveWidth, totalWidth) : null, // Thêm prototype để tối ưu hiệu suất
              itemBuilder: (context, index) {
                // Sử dụng LRU cache thông minh
                Widget? cachedWidget = _getFromLRUCache(index);
                if (cachedWidget != null) {
                  return cachedWidget;
                }
    
                final item = _sortedData[index];

                return ValueListenableBuilder<int?>(
                  valueListenable: _selectedRowNotifier,
                  builder: (context, selectedRowIndex, _) {
                    final isSelected = selectedRowIndex == index;
                    
                    return ValueListenableBuilder<Set<T>>(
                      valueListenable: _selectedItemsNotifier,
                      builder: (context, selectedItems, _) {
                        final isChecked = selectedItems.contains(item);
                        
                        // Tạo widget mới với key để tối ưu
                        final rowWidget = SgTableRow<T>(
                          key: ValueKey('${widget.hashCode}_row_$index'),
                          item: item,
                          index: index,
                          totalRows: _sortedData.length,
                          columns: _effectiveColumns,
                          rowHeight: widget.rowHeight,
                          totalWidth: totalWidth,
                          effectiveWidth: effectiveWidth,
                          isSelected: isSelected,
                          isChecked: isChecked,
                          showHorizontalLines: widget.showHorizontalLines,
                          showLastLineTopBottom: widget.showLastLineTopBottom,
                          gridLineColor: widget.gridLineColor,
                          gridLineWidth: widget.gridLineWidth,
                          backgroundColor: _getBackgroundColor(index, isSelected, isChecked),
                          onRowSelected: _onRowSelected,
                          onHover: (idx, isHovering) {
                            if (!_isScrolling && isHovering && _selectedRowNotifier.value != idx) {
                              _selectedRowNotifier.value = idx;
                              _rowCache.remove(_selectedRowNotifier.value);
                            } else if (!_isScrolling && !isHovering && _selectedRowNotifier.value == idx) {
                              _selectedRowNotifier.value = null;
                              _rowCache.remove(idx);
                            }
                          },
                          columnWidths: _columnWidths,
                          showVerticalLines: widget.showVerticalLines,
                          showLastLineLeftRight: widget.showLastLineLeftRight,
                          showCheckboxes: widget.showCheckboxes,
                        );
                        
                        // Cập nhật LRU cache
                        _updateLRUCache(index, rowWidget);
                        return rowWidget;
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  // Tạo một row mẫu để sử dụng làm prototype
  Widget _buildPrototypeRow(double effectiveWidth, double totalWidth) {
    return SizedBox(
      height: widget.rowHeight,
      width: totalWidth,
      child: const SizedBox(), // Container trống có kích thước đúng
    );
  }
}

// Lớp helper cho hàm compute
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
