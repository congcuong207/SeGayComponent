import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'dart:async'; // Import Timer

enum SortDirection { none, ascending, descending }

class SgTable<T> extends StatefulWidget {
  final List<SgTableColumn<T>> columns;
  final List<T> data;
  final double rowHeight;
  final Color? textHeaderColor;
  final Color headerBackgroundColor;
  final Color oddRowBackgroundColor;
  final Color evenRowBackgroundColor;
  final Color selectedRowColor;
  final Color checkedRowColor;
  final Color gridLineColor;
  final double gridLineWidth;
  final bool showVerticalLines;
  final bool showHorizontalLines;
  final bool showLastLineLeftRight;
  final bool showLastLineTopBottom;
  final bool allowRowSelection;
  final BorderRadius? borderRadius;
  final Function(T)? onRowTap;
  final String? searchTerm;
  final bool caseSensitiveSearch;
  final bool Function(T)? customFilter;

  final bool showCheckboxes;
  final Function(List<T>)? onSelectionChanged;
  final double checkboxColumnWidth;

  // Action column options
  final bool showActions;
  final Function(T)? onViewAction;
  final Function(T)? onEditAction;
  final Function(T)? onDeleteAction;
  final Color? actionViewColor;
  final Color? actionEditColor;
  final Color? actionDeleteColor;
  final double? actionIconSize;
  final double? actionColumnWidth;
  final String? actionColumnTitle;

  final double? scaleCheckbox;

  final Color? activeColor;
  final Color? checkColor;
  final BorderSide? side;
  final BeveledRectangleBorder? shape;

  final ScrollController? verticalController;

  const SgTable(
      {super.key,
      required this.columns,
      required this.data,
      this.rowHeight = 48.0,
      this.textHeaderColor,
      this.headerBackgroundColor = SGAppColors.neutral100,
      this.oddRowBackgroundColor = Colors.white,
      this.evenRowBackgroundColor = SGAppColors.neutral200,
      this.selectedRowColor = SGAppColors.info100,
      this.checkedRowColor = const Color(0xFFE3F2FD),
      this.gridLineColor = SGAppColors.neutral200,
      this.gridLineWidth = 1.0,
      this.showVerticalLines = true,
      this.showHorizontalLines = true,
      this.allowRowSelection = true,
      this.showLastLineLeftRight = false,
      this.showLastLineTopBottom = false,
      this.borderRadius,
      this.onRowTap,
      this.searchTerm,
      this.caseSensitiveSearch = false,
      this.customFilter,
      this.showCheckboxes = false,
      this.onSelectionChanged,
      this.checkboxColumnWidth = 50.0,
      this.showActions = false,
      this.onViewAction,
      this.onEditAction,
      this.onDeleteAction,
      this.actionViewColor,
      this.actionEditColor,
      this.actionDeleteColor,
      this.actionIconSize,
      this.actionColumnWidth = 120.0,
      this.actionColumnTitle = "Hành động",
      this.scaleCheckbox = 1,
      this.activeColor = Colors.blueAccent,
      this.checkColor = Colors.white,
      this.side,
      this.shape,
      this.verticalController});

  @override
  State<SgTable<T>> createState() => _SgTableState<T>();
}

class _SgTableState<T> extends State<SgTable<T>> {
  int? _sortColumnIndex;
  SortDirection _sortDirection = SortDirection.none;
  late List<T> _sortedData;
  late List<T> _filteredData;
  int? _selectedRowIndex;
  late List<SgTableColumn<T>> _effectiveColumns;
  String? _lastSearchTerm;

  // Checkbox selection state
  final Set<T> _selectedItems = {};
  bool _allSelected = false;

  Map<int, double> _columnWidths = {};
  Map<int, double> _originalColumnWidths = {};
  int? _resizingColumnIndex;
  double? _resizeStartX;
  double? _resizeStartWidth;

  // Thêm biến để theo dõi trạng thái cuộn
  bool _isScrolling = false;
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollEndTimer;

  // Caching
  final Map<int, Widget> _rowCache = {};
  final Map<int, List<Widget>> _cellsCache = {};
  bool _shouldRebuildCache = true;

  // Thêm memoization để tránh tính toán lại total width quá nhiều lần
  late double _cachedTotalWidth;
  bool _shouldRecalculateWidth = true;

  @override
  void initState() {
    super.initState();
    _processData();
    _cachedTotalWidth = _calculateTotalWidth();
    _shouldRecalculateWidth = false;

    // Đăng ký listener sau khi build frame đầu tiên
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollController.addListener(_scrollListener);
      }
    });
  }

  void _processData() {
    _sortedData = List.from(widget.data);
    _filteredData = List.from(_sortedData);
    _buildEffectiveColumns();
    _initColumnWidths();
    _lastSearchTerm = widget.searchTerm;
    _filterData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _scrollEndTimer?.cancel();
    _clearCaches();
    super.dispose();
  }

  void _clearCaches() {
    _rowCache.clear();
    _cellsCache.clear();
  }

  // Thêm hàm lắng nghe sự kiện cuộn
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
          setState(() {
            _isScrolling = false;
          });
        }
      });
    }
  }

  // Thêm phương thức để thực hiện cuộn với animation
  void _animateToIndex(int index) {
    if (!_scrollController.hasClients) return;

    final itemPosition = index * widget.rowHeight;
    _scrollController.animateTo(
      itemPosition.toDouble(),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(SgTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Kiểm tra nếu dữ liệu đã thay đổi để cập nhật
    final bool dataChanged = widget.data != oldWidget.data;
    final bool columnsChanged = widget.columns != oldWidget.columns ||
        widget.showActions != oldWidget.showActions ||
        widget.showCheckboxes != oldWidget.showCheckboxes ||
        widget.actionColumnTitle != oldWidget.actionColumnTitle;
    final bool searchChanged = widget.searchTerm != _lastSearchTerm;

    if (dataChanged || columnsChanged || searchChanged) {
      _shouldRebuildCache = true;
      _shouldRecalculateWidth = true;
      _clearCaches();

      if (dataChanged) {
        _sortedData = List.from(widget.data);
        _filterAndSortData();

        // Update selected items when data changes
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

  // Add methods for checkbox handling
  void _toggleSelectAll(bool? selected) {
    if (selected == null) return;

    setState(() {
      _allSelected = selected;

      if (_allSelected) {
        _selectedItems.addAll(_sortedData);
      } else {
        _selectedItems.clear();
      }

      _notifySelectionChanged();
      _shouldRebuildCache = true;
    });
  }

  void _toggleSelectItem(T item, bool? selected) {
    if (selected == null) return;

    setState(() {
      if (selected) {
        _selectedItems.add(item);
      } else {
        _selectedItems.remove(item);
      }

      _updateAllSelectedState();
      _notifySelectionChanged();

      // Chỉ rebuild row cần thiết
      final index = _sortedData.indexOf(item);
      if (index >= 0) {
        _rowCache.remove(index);
        _cellsCache.remove(index);
      }
    });
  }

  void _updateAllSelectedState() {
    if (_sortedData.isEmpty) {
      _allSelected = false;
      return;
    }

    _allSelected = _sortedData.every((item) => _selectedItems.contains(item));
  }

  void _notifySelectionChanged() {
    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged!(_selectedItems.toList());
    }
  }

  // Update the _buildEffectiveColumns method for better checkbox visuals
  void _buildEffectiveColumns() {
    _effectiveColumns = [];

    // Add checkbox column if needed
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

    // Add regular columns
    _effectiveColumns.addAll(widget.columns);

    // Add action column if enabled
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

  void _initColumnWidths() {
    _columnWidths = {};
    for (int i = 0; i < _effectiveColumns.length; i++) {
      _columnWidths[i] = _effectiveColumns[i].width ?? 120.0;
    }
    _originalColumnWidths = Map.from(_columnWidths);
  }

  void _filterAndSortData() {
    _filterData();
    _sortData();
  }

  void _filterData() {
    if ((widget.searchTerm == null || widget.searchTerm!.isEmpty) && widget.customFilter == null) {
      _filteredData = List.from(widget.data);
    } else {
      _filteredData = widget.data.where((item) {
        if (widget.customFilter != null && !widget.customFilter!(item)) {
          return false;
        }

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
    }

    setState(() {
      _sortedData = List.from(_filteredData);
      _shouldRebuildCache = true;
    });
  }

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

  // Helper method for comparison to use in both regular sort and compute
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

  static List<T> _sortCompute<T>(_SortParams<T> params) {
    final result = List<T>.from(params.data);
    result.sort((a, b) => _compareItems(a, b, params.getter, params.direction));
    return result;
  }

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
      _clearCaches();
    });
  }

  // Cải tiến onRowSelected để có animation khi chọn
  void _onRowSelected(int index) {
    if (!widget.allowRowSelection) return;

    setState(() {
      if (_selectedRowIndex == index) {
        _selectedRowIndex = null;
      } else {
        _selectedRowIndex = index;
      }

      // Chỉ rebuild row cần thiết
      _rowCache.remove(_selectedRowIndex);
      _rowCache.remove(index);
    });

    // Đảm bảo hàng được chọn nằm trong tầm nhìn
    _animateToIndex(index);

    if (widget.onRowTap != null) {
      widget.onRowTap!(_sortedData[index]);
    }
  }

  Widget _buildSortIcon(int columnIndex) {
    if (_sortColumnIndex != columnIndex || _sortDirection == SortDirection.none) {
      return const SizedBox.shrink(); // Return no space at all
    }

    return Icon(
      _sortDirection == SortDirection.ascending ? Icons.arrow_upward : Icons.arrow_downward,
      size: 16,
      color: SGAppColors.neutral700,
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final totalWidth = _calculateTotalWidth();
    final effectiveWidth = totalWidth;

    final exactHeight = widget.rowHeight + (_sortedData.length * widget.rowHeight);

    // Rebuild cache nếu cần
    if (_shouldRebuildCache) {
      _clearCaches();
      _shouldRebuildCache = false;
    }

    return SizedBox(
      width: effectiveWidth,
      height: exactHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row - optimize with const and memoization
          DecoratedBox(
            decoration: BoxDecoration(
              color: widget.headerBackgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: widget.gridLineColor,
                  width: widget.gridLineWidth,
                ),
                top: BorderSide(
                  color: widget.gridLineColor,
                  width: widget.gridLineWidth,
                ),
              ),
            ),
            child: SizedBox(
              width: effectiveWidth,
              height: widget.rowHeight,
              child: Row(
                children: _buildHeaderCells(false, effectiveWidth, totalWidth),
              ),
            ),
          ),
          // Table body rows - với ListView.builder được tối ưu
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ListView.builder(
                controller: widget.verticalController ?? _scrollController,
                // Điều chỉnh physics để cuộn mượt hơn
                physics: const AlwaysScrollableScrollPhysics(
                  parent: RangeMaintainingScrollPhysics(),
                ),
                key: PageStorageKey<String>('table_${widget.hashCode}'),
                clipBehavior: Clip.hardEdge,
                cacheExtent: 1000, // Tăng cache để cuộn mượt hơn
                itemCount: _sortedData.length,
                itemExtent: widget.rowHeight, // Cố định chiều cao row để tối ưu hơn
                addAutomaticKeepAlives: false, // Tắt để tối ưu hiệu năng
                addRepaintBoundaries: true, // Giữ lại tính năng này để tối ưu render
                itemBuilder: (context, index) {
                  // Sử dụng cache để tránh rebuild các row không thay đổi
                  if (_rowCache.containsKey(index)) {
                    return _rowCache[index]!;
                  }

                  // Wrap trong RepaintBoundary để giảm vẽ lại không cần thiết
                  final rowWidget = RepaintBoundary(
                    child: _buildTableRow(index, effectiveWidth, totalWidth),
                  );

                  // Lưu vào cache
                  _rowCache[index] = rowWidget;
                  return rowWidget;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tách logic xây dựng hàng ra khỏi build method
  Widget _buildTableRow(int index, double effectiveWidth, double totalWidth) {
    final isEven = index % 2 == 0;
    final isLast = index == _sortedData.length - 1;
    final isChecked = _selectedItems.contains(_sortedData[index]);
    final item = _sortedData[index];

    // Pre-calculate background color to tránh tính toán khi render
    Color backgroundColor;
    if (_selectedRowIndex == index) {
      backgroundColor = widget.selectedRowColor;
    } else if (isChecked) {
      backgroundColor = widget.checkedRowColor;
    } else {
      backgroundColor = isEven ? widget.evenRowBackgroundColor : widget.oddRowBackgroundColor;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: (widget.showHorizontalLines && (!isLast || widget.showLastLineTopBottom))
            ? Border(
                bottom: BorderSide(
                  color: widget.gridLineColor,
                  width: widget.gridLineWidth,
                ),
              )
            : null,
      ),
      child: MouseRegion(
        onEnter: (event) {
          // Chỉ xử lý sự kiện khi không đang cuộn
          if (!_isScrolling && _selectedRowIndex != index) {
            setState(() {
              _selectedRowIndex = index;
              // Chỉ rebuild row cần thiết
              _rowCache.remove(_selectedRowIndex);
            });
          }
        },
        onExit: (event) {
          // Chỉ xử lý sự kiện khi không đang cuộn
          if (!_isScrolling && _selectedRowIndex == index) {
            setState(() {
              _selectedRowIndex = null;
              // Chỉ rebuild row cần thiết
              _rowCache.remove(index);
            });
          }
        },
        child: SizedBox(
          width: effectiveWidth,
          height: widget.rowHeight,
          child: InkWell(
            onTap: () => _onRowSelected(index),
            child: Row(
              children: _buildRowCells(item, false, effectiveWidth, totalWidth, index),
            ),
          ),
        ),
      ),
    );
  }

  // Update the header checkbox to match the style
  List<Widget> _buildHeaderCells(bool shouldExpand, double screenWidth, double totalWidth) {
    return List.generate(_effectiveColumns.length, (index) {
      final column = _effectiveColumns[index];
      final hasSort = column.sortValueGetter != null;
      final isLast = index == _effectiveColumns.length - 1;

      // Special case for checkbox column
      if (widget.showCheckboxes && index == 0) {
        return _buildCell(
          child: Center(
            child: Transform.scale(
              scale: widget.scaleCheckbox,
              child: Checkbox(
                value: _allSelected,
                onChanged: _toggleSelectAll,
                activeColor: widget.activeColor,
                checkColor: widget.checkColor,
                side: widget.side,
                shape: widget.shape,
              ),
            ),
          ),
          width: column.width,
          isLast: isLast,
          columnIndex: index,
          shouldExpand: shouldExpand,
          screenWidth: screenWidth,
          totalWidth: totalWidth,
        );
      }

      return _buildCell(
        child: InkWell(
          onTap: hasSort ? () => _onSortColumn(index) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: column.titleAlignment == TextAlign.center
                  ? MainAxisAlignment.center
                  : column.titleAlignment == TextAlign.right
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SGText(
                    text: column.title,
                    fontWeight: FontWeight.bold,
                    textAlign: column.titleAlignment,
                    color: widget.textHeaderColor ?? Colors.white,
                    style: column.titleStyle,
                    maxLines: column.maxLinesTitle,
                    overflow: column.maxLinesTitle == 1 ? TextOverflow.ellipsis : null,
                  ),
                ),
                // Only add the icon when it should actually be visible
                if (hasSort && _sortColumnIndex == index && _sortDirection != SortDirection.none) _buildSortIcon(index),
              ],
            ),
          ),
        ),
        width: column.width,
        isLast: isLast,
        columnIndex: index,
        shouldExpand: shouldExpand,
        screenWidth: screenWidth,
        totalWidth: totalWidth,
      );
    });
  }

  List<Widget> _buildRowCells(T item, bool shouldExpand, double screenWidth, double totalWidth, int rowIndex) {
    // Sử dụng cache nếu có
    if (_cellsCache.containsKey(rowIndex)) {
      return _cellsCache[rowIndex]!;
    }

    final cells = List.generate(_effectiveColumns.length, (index) {
      final column = _effectiveColumns[index];
      final isLast = index == _effectiveColumns.length - 1;

      // Special handling for checkbox column
      if (widget.showCheckboxes && index == 0) {
        return _buildCell(
          child: Center(
            child: column.cellBuilder(item),
          ),
          width: column.width,
          isLast: isLast,
          columnIndex: index,
          shouldExpand: shouldExpand,
          screenWidth: screenWidth,
          totalWidth: totalWidth,
        );
      }

      // For regular data columns
      return _buildCell(
        child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          alignment: column.cellAlignment == TextAlign.center
              ? Alignment.center
              : column.cellAlignment == TextAlign.right
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
          child: column.cellBuilder(item),
        ),
        width: column.width,
        isLast: isLast,
        columnIndex: index,
        shouldExpand: shouldExpand,
        screenWidth: screenWidth,
        totalWidth: totalWidth,
      );
    });

    // Lưu vào cache
    _cellsCache[rowIndex] = cells;
    return cells;
  }

  Widget _buildCell({required Widget child, double? width, bool isLast = false, int? columnIndex, bool shouldExpand = false, double? screenWidth, double? totalWidth}) {
    final baseWidth = columnIndex != null ? (_columnWidths[columnIndex] ?? (width ?? 120.0)) : (width ?? 120.0);

    final adjustedWidth = baseWidth;

    if (isLast) {
      return SizedBox(
        width: adjustedWidth,
        height: widget.rowHeight,
        child: child,
      );
    }

    return Stack(
      children: [
        Container(
          width: adjustedWidth,
          height: widget.rowHeight,
          decoration: widget.showVerticalLines && (!isLast || widget.showLastLineLeftRight)
              ? BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: widget.gridLineColor,
                      width: widget.gridLineWidth,
                    ),
                  ),
                )
              : null,
          child: child,
        ),
        if (columnIndex != null && !isLast)
          Positioned(
            right: -5,
            top: 0,
            bottom: 0,
            width: 10,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              child: GestureDetector(
                onHorizontalDragStart: (details) => _startResize(columnIndex, details.globalPosition.dx),
                onHorizontalDragUpdate: (details) => _updateResize(details.globalPosition.dx),
                onHorizontalDragEnd: (_) => _endResize(),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _startResize(int columnIndex, double startX) {
    setState(() {
      _resizingColumnIndex = columnIndex;
      _resizeStartX = startX;
      _resizeStartWidth = _columnWidths[columnIndex];
    });
  }

  void _updateResize(double currentX) {
    if (_resizingColumnIndex == null || _resizeStartX == null || _resizeStartWidth == null) {
      return;
    }

    final delta = currentX - _resizeStartX!;
    final originalWidth = _originalColumnWidths[_resizingColumnIndex] ?? 120.0;
    final newWidth = _resizeStartWidth! + delta;

    if (newWidth >= originalWidth) {
      setState(() {
        _columnWidths[_resizingColumnIndex!] = newWidth;
        _shouldRebuildCache = true;
      });
    }
  }

  void _endResize() {
    setState(() {
      _resizingColumnIndex = null;
      _resizeStartX = null;
      _resizeStartWidth = null;
      _shouldRebuildCache = true;
      _clearCaches();
    });
  }
}

// Helper class cho hàm compute
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
