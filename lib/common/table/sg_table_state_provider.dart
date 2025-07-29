import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sg_table.dart';
import 'sg_table_component.dart';

/// Provider để quản lý trạng thái của SgTable
class SgTableStateProvider<T> extends ChangeNotifier {
  // Dữ liệu
  final List<T> _data;
  List<T> _filteredData = [];
  List<T> _sortedData = [];
  
  // Trạng thái sắp xếp
  int? _sortColumnIndex;
  SortDirection _sortDirection = SortDirection.none;
  
  // Trạng thái chọn hàng và checkbox
  int? _selectedRowIndex;
  final Set<T> _selectedItems = {};
  bool _allSelected = false;
  
  // Trạng thái kích thước cột
  final Map<int, double> _columnWidths = {};
  Map<int, double> _originalColumnWidths = {}; // Không phải final để có thể cập nhật
  int? _resizingColumnIndex;
  double? _resizeStartX;
  double? _resizeStartWidth;
  
  // Các hàm callback
  final Function(T)? onRowTap;
  final Function(List<T>)? onSelectionChanged;
  
  // Constructor
  SgTableStateProvider({
    required List<T> data,
    required List<SgTableColumn<T>> columns,
    this.onRowTap,
    this.onSelectionChanged,
  }) : _data = List<T>.from(data) {
    _initData();
    _initColumnWidths(columns);
  }
  
  // Getters
  List<T> get data => _data;
  List<T> get sortedData => _sortedData;
  int? get sortColumnIndex => _sortColumnIndex;
  SortDirection get sortDirection => _sortDirection;
  int? get selectedRowIndex => _selectedRowIndex;
  Set<T> get selectedItems => Set.from(_selectedItems);
  bool get allSelected => _allSelected;
  Map<int, double> get columnWidths => Map.from(_columnWidths);
  
  // Khởi tạo dữ liệu
  void _initData() {
    _filteredData = List.from(_data);
    _sortedData = List.from(_filteredData);
  }
  
  // Khởi tạo chiều rộng cột
  void _initColumnWidths(List<SgTableColumn<T>> columns) {
    _columnWidths.clear();
    for (int i = 0; i < columns.length; i++) {
      _columnWidths[i] = columns[i].width ?? 120.0;
    }
    _originalColumnWidths = Map.from(_columnWidths);
  }
  
  // Cập nhật dữ liệu
  void updateData(List<T> newData) {
    if (listEquals(_data, newData)) return;
    
    _data.clear();
    _data.addAll(newData);
    
    // Cập nhật danh sách item đã chọn
    _selectedItems.removeWhere((item) => !_data.contains(item));
    _updateAllSelectedState();
    
    _filterAndSortData();
    notifyListeners();
  }
  
  // Lọc và sắp xếp dữ liệu
  void _filterAndSortData({
    String? searchTerm,
    bool caseSensitiveSearch = false,
    bool Function(T)? customFilter,
    List<SgTableColumn<T>>? columns,
  }) {
    // Nếu không có điều kiện lọc
    if ((searchTerm == null || searchTerm.isEmpty) && customFilter == null) {
      _filteredData = List.from(_data);
    } else {
      // Áp dụng các điều kiện lọc
      _filteredData = _data.where((item) {
        if (customFilter != null && !customFilter(item)) {
          return false;
        }
        
        if (searchTerm != null && searchTerm.isNotEmpty && columns != null) {
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
    
    // Áp dụng sắp xếp nếu cần
    if (_sortColumnIndex != null && 
        _sortDirection != SortDirection.none && 
        columns != null &&
        _sortColumnIndex! < columns.length) {
      _applySorting(columns[_sortColumnIndex!]);
    }
  }
  
  // Áp dụng sắp xếp
  void _applySorting(SgTableColumn<T> column) {
    if (column.sortValueGetter == null) return;
    
    final sortValueGetter = column.sortValueGetter!;
    
    _sortedData.sort((a, b) {
      return _compareItems(a, b, sortValueGetter, _sortDirection);
    });
  }
  
  // So sánh hai item để sắp xếp
  int _compareItems(T a, T b, dynamic Function(T) getter, SortDirection direction) {
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
  
  // Thay đổi sắp xếp
  void toggleSort(int columnIndex, List<SgTableColumn<T>> columns) {
    if (columnIndex >= columns.length) return;
    
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
      _filterAndSortData(columns: columns);
    }
    
    notifyListeners();
  }
  
  // Chọn hàng
  void selectRow(int? index) {
    if (_selectedRowIndex == index) {
      _selectedRowIndex = null;
    } else {
      _selectedRowIndex = index;
    }
    
    if (index != null && onRowTap != null && index < _sortedData.length) {
      onRowTap!(_sortedData[index]);
    }
    
    notifyListeners();
  }
  
  // Chọn tất cả checkboxes
  void toggleSelectAll(bool? selected) {
    if (selected == null) return;
    
    _allSelected = selected;
    
    if (_allSelected) {
      _selectedItems.addAll(_sortedData);
    } else {
      _selectedItems.clear();
    }
    
    _notifySelectionChanged();
    notifyListeners();
  }
  
  // Chọn một item với checkbox
  void toggleSelectItem(T item, bool? selected) {
    if (selected == null) return;
    
    if (selected) {
      _selectedItems.add(item);
    } else {
      _selectedItems.remove(item);
    }
    
    _updateAllSelectedState();
    _notifySelectionChanged();
    notifyListeners();
  }
  
  // Cập nhật trạng thái "chọn tất cả"
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
  
  // Bắt đầu resize cột
  void startResize(int columnIndex, double startX) {
    _resizingColumnIndex = columnIndex;
    _resizeStartX = startX;
    _resizeStartWidth = _columnWidths[columnIndex];
    notifyListeners();
  }
  
  // Cập nhật resize cột
  void updateResize(double currentX) {
    if (_resizingColumnIndex == null || _resizeStartX == null || _resizeStartWidth == null) {
      return;
    }
    
    final delta = currentX - _resizeStartX!;
    final newWidth = _resizeStartWidth! + delta;
    final originalWidth = _originalColumnWidths[_resizingColumnIndex] ?? 120.0;
    
    if (newWidth >= originalWidth) {
      _columnWidths[_resizingColumnIndex!] = newWidth;
      notifyListeners();
    }
  }
  
  // Kết thúc resize cột
  void endResize() {
    _resizingColumnIndex = null;
    _resizeStartX = null;
    _resizeStartWidth = null;
    notifyListeners();
  }
  
  // Lọc dữ liệu dựa trên từ khóa tìm kiếm
  void filter({
    String? searchTerm,
    bool caseSensitiveSearch = false,
    bool Function(T)? customFilter,
    required List<SgTableColumn<T>> columns,
  }) {
    _filterAndSortData(
      searchTerm: searchTerm,
      caseSensitiveSearch: caseSensitiveSearch,
      customFilter: customFilter,
      columns: columns,
    );
    notifyListeners();
  }
  
  /// Helper static để tạo và sử dụng SgTableStateProvider
  static Widget create<T>({
    required Widget Function(BuildContext context, SgTableStateProvider<T> provider, Widget? child) builder,
    required List<T> data,
    required List<SgTableColumn<T>> columns,
    Function(T)? onRowTap,
    Function(List<T>)? onSelectionChanged,
    Widget? child,
  }) {
    return ChangeNotifierProvider<SgTableStateProvider<T>>(
      create: (context) => SgTableStateProvider<T>(
        data: data,
        columns: columns,
        onRowTap: onRowTap,
        onSelectionChanged: onSelectionChanged,
      ),
      child: Consumer<SgTableStateProvider<T>>(
        builder: (context, provider, _) => builder(context, provider, child),
      ),
    );
  }
  
  /// Lấy provider từ context
  static SgTableStateProvider<T> of<T>(BuildContext context, {bool listen = true}) {
    return Provider.of<SgTableStateProvider<T>>(context, listen: listen);
  }
} 