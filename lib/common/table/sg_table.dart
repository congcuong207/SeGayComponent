import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

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
  final bool allowRowSelection;
  final bool showRowNumber;
  final BorderRadius? borderRadius;
  final Function(T)? onRowTap;
  final String? searchTerm;
  final bool caseSensitiveSearch;
  final bool Function(T)? customFilter;
  final bool useFullWidth;
  final bool autoWidth; // Tự động điều chỉnh chiều rộng dựa trên kích thước màn hình
  final double? maxWidth;
  final double minColumnWidth;
  
  // Horizontal Scrollbar options
  final bool showHorizontalScrollbar;
  final double scrollbarThickness;
  final Radius scrollbarRadius;
  final bool scrollbarAlwaysVisible;
  final Color? scrollbarColor;
  
  // Column Action
  final Widget Function(T item, int index)? columnAction;
  final String? columnActionTitle;
  final double columnActionWidth;
  final bool showColumnAction;
  
  // Checkbox selection
  final bool showCheckboxes;
  final Function(List<T>)? onSelectionChanged;
  final double checkboxColumnWidth;
  final double numberColumnWidth;
  
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

  const SgTable({
    super.key,
    required this.columns,
    required this.data,
    this.rowHeight = 48.0,
    this.textHeaderColor,
    this.headerBackgroundColor = Colors.white,
    this.oddRowBackgroundColor = Colors.white,
    this.evenRowBackgroundColor = const Color(0xFFF9FAFB),
    this.selectedRowColor = SGAppColors.info100,
    this.checkedRowColor = const Color(0xFFE8F4FE),
    this.gridLineColor = const Color(0xFFEAECF0),
    this.gridLineWidth = 1.0,
    this.showVerticalLines = false,
    this.showHorizontalLines = true,
    this.allowRowSelection = true,
    this.showRowNumber = true,
    this.borderRadius,
    this.onRowTap,
    this.searchTerm,
    this.caseSensitiveSearch = false,
    this.customFilter,
    this.useFullWidth = true,
    this.autoWidth = true, // Mặc định là true - tự động điều chỉnh
    this.maxWidth,
    this.minColumnWidth = 80.0,
    // Horizontal Scrollbar options
    this.showHorizontalScrollbar = true,
    this.scrollbarThickness = 8.0,
    this.scrollbarRadius = const Radius.circular(4.0),
    this.scrollbarAlwaysVisible = true,
    this.scrollbarColor,
    // Column Action
    this.columnAction,
    this.columnActionTitle = "Thao tác",
    this.columnActionWidth = 120,
    this.showColumnAction = false,
    // Checkbox
    this.showCheckboxes = false,
    this.onSelectionChanged,
    this.checkboxColumnWidth = 40.0,
    this.numberColumnWidth = 40.0,
    // Default action column
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
  }) : assert(!(showActions && showColumnAction), 
          'Không thể sử dụng đồng thời cả showActions và showColumnAction');

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
  
  // ScrollController cho thanh cuộn ngang
  ScrollController? _horizontalScrollController;
  
  // Checkbox selection state
  final Set<T> _selectedItems = {};
  bool _allSelected = false;

  Map<int, double> _columnWidths = {};
  Map<int, double> _originalColumnWidths = {};
  int? _resizingColumnIndex;
  double? _resizeStartX;
  double? _resizeStartWidth;

  @override
  void initState() {
    super.initState();
    _sortedData = List.from(widget.data);
    _filteredData = List.from(_sortedData);
    _buildEffectiveColumns();
    _initColumnWidths();
    _lastSearchTerm = widget.searchTerm;
    _filterData();
  }
  
  @override
  void dispose() {
    _horizontalScrollController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SgTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      _sortedData = List.from(widget.data);
      _filterAndSortData();
      
      // Update selected items when data changes
      if (widget.showCheckboxes) {
        _selectedItems.removeWhere((item) => !widget.data.contains(item));
        _updateAllSelectedState();
      }
    }
    
    if (widget.columns != oldWidget.columns || 
        widget.showActions != oldWidget.showActions ||
        widget.showCheckboxes != oldWidget.showCheckboxes ||
        widget.showRowNumber != oldWidget.showRowNumber ||
        widget.showColumnAction != oldWidget.showColumnAction ||
        widget.actionColumnTitle != oldWidget.actionColumnTitle) {
      _buildEffectiveColumns();
      _initColumnWidths();
    }

    if (widget.searchTerm != _lastSearchTerm) {
      _lastSearchTerm = widget.searchTerm;
      _filterAndSortData();
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
          fixedWidth: true,
          cellBuilder: (item) => Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: _selectedItems.contains(item),
              onChanged: (selected) => _toggleSelectItem(item, selected),
              activeColor: Colors.blue,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          cellAlignment: TextAlign.center,
          titleAlignment: TextAlign.center,
        ),
      );
    }
    
    // Add row number column if needed
    if (widget.showRowNumber) {
      _effectiveColumns.add(
        SgTableColumn<T>(
          title: '#',
          width: widget.numberColumnWidth,
          fixedWidth: true,
          cellBuilder: (item) {
            final index = _sortedData.indexOf(item) + 1;
            return SGText(
              text: index.toString(),
              color: Colors.grey.shade600,
            );
          },
          cellAlignment: TextAlign.center,
          titleAlignment: TextAlign.center,
        ),
      );
    }
    
    // Add regular columns
    _effectiveColumns.addAll(widget.columns);
    
    // Add custom action column if enabled
    if (widget.showColumnAction && widget.columnAction != null) {
      _effectiveColumns.add(
        SgTableColumn<T>(
          title: widget.columnActionTitle ?? 'Thao tác',
          width: widget.columnActionWidth,
          fixedWidth: true,
          cellBuilder: (item) {
            final index = _sortedData.indexOf(item);
            return widget.columnAction!(item, index);
          },
          cellAlignment: TextAlign.center,
          titleAlignment: TextAlign.center,
        ),
      );
    }
    
    // Add standard action column if enabled
    else if (widget.showActions) {
      _effectiveColumns.add(
        SgTableActionColumn<T>(
          colorItemView: widget.actionViewColor,
          colorItemEdit: widget.actionEditColor,
          colorItemDelete: widget.actionDeleteColor,
          sizeIcon: widget.actionIconSize,
          title: widget.actionColumnTitle ?? 'Hành động',
          width: widget.actionColumnWidth,
          fixedWidth: true,
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
    setState(() {
      if ((widget.searchTerm == null || widget.searchTerm!.isEmpty) &&
          widget.customFilter == null) {
        _filteredData = List.from(widget.data);
      } else {
        _filteredData = widget.data.where((item) {
          if (widget.customFilter != null && !widget.customFilter!(item)) {
            return false;
          }

          if (widget.searchTerm != null && widget.searchTerm!.isNotEmpty) {
            final term = widget.caseSensitiveSearch
                ? widget.searchTerm!
                : widget.searchTerm!.toLowerCase();

            bool foundMatch = false;
            for (var column in widget.columns) {
              if (column.searchable && column.searchValueGetter != null) {
                final value = column.searchValueGetter!(item);
                final stringValue =
                    widget.caseSensitiveSearch ? value : value.toLowerCase();
                if (stringValue.contains(term)) {
                  foundMatch = true;
                  break;
                }
              }
            }
            return foundMatch;
          }
          return true;
        }).toList();
      }

      _sortedData = List.from(_filteredData);
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

    setState(() {
      _sortedData.sort((a, b) {
        final aValue = sortValueGetter(a);
        final bValue = sortValueGetter(b);

        if (aValue == null && bValue == null) return 0;
        if (aValue == null) {
          return _sortDirection == SortDirection.ascending ? -1 : 1;
        }
        if (bValue == null) {
          return _sortDirection == SortDirection.ascending ? 1 : -1;
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

        return _sortDirection == SortDirection.ascending
            ? comparison
            : -comparison;
      });
    });
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
    });
  }

  void _onRowSelected(int index) {
    if (!widget.allowRowSelection) return;

    setState(() {
      if (_selectedRowIndex == index) {
        _selectedRowIndex = null;
      } else {
        _selectedRowIndex = index;
      }
    });

    if (widget.onRowTap != null) {
      widget.onRowTap!(_sortedData[index]);
    }
  }

  Widget _buildSortIcon(int columnIndex) {
    if (_sortColumnIndex != columnIndex ||
        _sortDirection == SortDirection.none) {
      return const SizedBox.shrink(); // Return no space at all
    }

    return Icon(
      _sortDirection == SortDirection.ascending
          ? Icons.arrow_upward
          : Icons.arrow_downward,
      size: 16,
      color: SGAppColors.neutral700,
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor = Colors.white;
    
    switch(status.toLowerCase()) {
      case 'open':
        backgroundColor = const Color(0xFF4573D2);
        break;
      case 'paid':
        backgroundColor = const Color(0xFF12B76A);
        break;
      case 'inactive':
        backgroundColor = const Color(0xFF667085);
        break;
      case 'due':
        backgroundColor = const Color(0xFFF04438);
        break;
      default:
        backgroundColor = const Color(0xFF667085);
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _formatCurrency(String amount, String currency, {bool colored = false}) {
    final isNegative = amount.startsWith('-');
    final color = colored 
        ? (isNegative ? const Color(0xFFF04438) : const Color(0xFF12B76A))
        : Colors.black;
        
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          currency,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Cập nhật cách tính toán chiều rộng tổng thể
  double _calculateTotalWidth() {
    double totalWidth = 0;
    int flexibleColumnsCount = 0;
    double fixedColumnsWidth = 0;
    
    // Tính tổng chiều rộng các cột cố định
    for (int i = 0; i < _effectiveColumns.length; i++) {
      if (_effectiveColumns[i].fixedWidth) {
        final width = _columnWidths[i] ?? (_effectiveColumns[i].width ?? widget.minColumnWidth);
        fixedColumnsWidth += width;
      } else {
        flexibleColumnsCount++;
      }
    }
    
    // Nếu không có cột linh hoạt, trả về tổng chiều rộng cột cố định
    if (flexibleColumnsCount == 0) {
      return fixedColumnsWidth;
    }
    
    // Nếu không sử dụng chiều rộng đầy đủ, chỉ trả về tổng chiều rộng của tất cả các cột
    if (!widget.useFullWidth) {
      for (int i = 0; i < _effectiveColumns.length; i++) {
        if (!_effectiveColumns[i].fixedWidth) {
          totalWidth += _columnWidths[i] ?? (_effectiveColumns[i].width ?? widget.minColumnWidth);
        }
      }
      return fixedColumnsWidth + totalWidth;
    }
    
    // Nếu có maxWidth và sử dụng chiều rộng đầy đủ
    return widget.maxWidth ?? double.infinity;
  }
  
  // Tính chiều rộng cho một cột dựa trên chiều rộng có sẵn
  double _calculateColumnWidth(int columnIndex, double availableWidth) {
    final column = _effectiveColumns[columnIndex];
    
    // Nếu cột có chiều rộng cố định, sử dụng giá trị đó
    if (column.fixedWidth) {
      return _columnWidths[columnIndex] ?? (column.width ?? widget.minColumnWidth);
    }
    
    // Đếm số cột linh hoạt
    int flexibleColumnsCount = _effectiveColumns.where((col) => !col.fixedWidth).length;
    
    if (flexibleColumnsCount == 0) return widget.minColumnWidth;
    
    // Tính tổng chiều rộng đã sử dụng bởi các cột cố định
    double usedWidth = 0;
    for (int i = 0; i < _effectiveColumns.length; i++) {
      if (_effectiveColumns[i].fixedWidth) {
        usedWidth += _columnWidths[i] ?? (_effectiveColumns[i].width ?? widget.minColumnWidth);
      }
    }
    
    // Tính chiều rộng có sẵn cho các cột linh hoạt, trừ đi 2px để tránh tràn
    double availableFlexWidth = availableWidth - usedWidth - 2;
    if (availableFlexWidth <= 0) return widget.minColumnWidth;
    
    // Phân bổ chiều rộng đồng đều cho các cột linh hoạt
    return availableFlexWidth / flexibleColumnsCount;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Tính toán tổng chiều rộng cần thiết cho tất cả các cột
        double totalRequiredWidth = 0;
        for (int i = 0; i < _effectiveColumns.length; i++) {
          totalRequiredWidth += _columnWidths[i] ?? 
              (_effectiveColumns[i].width ?? widget.minColumnWidth);
        }
        
        // Tính toán chiều rộng hiệu quả dựa trên không gian có sẵn
        final availableWidth = constraints.maxWidth;
        
        // Quyết định chiều rộng bảng
        double effectiveWidth;
        bool shouldScroll = false;
        
        if (widget.autoWidth) {
          // Nếu tổng chiều rộng cột lớn hơn chiều rộng có sẵn => cần scroll
          if (totalRequiredWidth > availableWidth) {
            effectiveWidth = totalRequiredWidth;
            shouldScroll = true;
          } 
          // Nếu không, sử dụng toàn bộ chiều rộng có sẵn
          else {
            effectiveWidth = availableWidth - 2; // Trừ đi 2px cho border
          }
        } else {
          // Nếu không dùng autoWidth, dùng logic cũ
          effectiveWidth = widget.useFullWidth ? availableWidth - 2 : _calculateTotalWidth();
          shouldScroll = effectiveWidth > availableWidth;
        }
        
        // Nếu có maxWidth và effectiveWidth vượt quá, giới hạn lại
        if (widget.maxWidth != null && effectiveWidth > widget.maxWidth!) {
          effectiveWidth = widget.maxWidth!;
        }
        
        final tableContent = Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.gridLineColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          width: effectiveWidth,
          // Bỏ height cố định
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row - giữ nguyên
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: widget.headerBackgroundColor,
                    border: Border(
                      bottom: BorderSide(
                        color: widget.gridLineColor,
                        width: widget.gridLineWidth,
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: effectiveWidth,
                    height: widget.rowHeight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children:
                          _buildHeaderCells(widget.useFullWidth, effectiveWidth, availableWidth),
                    ),
                  ),
                ),
                // Table body rows - thay đổi để cho phép scroll
                LayoutBuilder(
                  builder: (context, bodyConstraints) {
                    return Container(
                      // Chiều cao sẽ được quyết định bởi constraints của parent
                      width: effectiveWidth,
                      constraints: BoxConstraints(
                        // Giới hạn chiều cao tối đa nếu cần
                        maxHeight: constraints.maxHeight - widget.rowHeight - 2, // Trừ thêm 2px để tránh tràn
                      ),
                      child: ListView.builder(
                        // Cho phép scroll
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero, // Đảm bảo không có padding
                        itemCount: _sortedData.length,
                        itemBuilder: (context, index) {
                          final isEven = index % 2 == 0;
                          final isLast = index == _sortedData.length - 1;
                          final isSelected = _selectedRowIndex == index;
                          final isChecked = _selectedItems.contains(_sortedData[index]);

                          Color backgroundColor;
                          if (isSelected) {
                            backgroundColor = widget.selectedRowColor;
                          } else if (isChecked) {
                            backgroundColor = widget.checkedRowColor;
                          } else {
                            backgroundColor = isEven
                                ? widget.evenRowBackgroundColor
                                : widget.oddRowBackgroundColor;
                          }

                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              border: widget.showHorizontalLines && !isLast
                                  ? Border(
                                      bottom: BorderSide(
                                        color: widget.gridLineColor,
                                        width: widget.gridLineWidth,
                                      ),
                                    )
                                  : null,
                            ),
                            child: SizedBox(
                              width: effectiveWidth,
                              height: widget.rowHeight,
                              child: InkWell(
                                onTap: () => _onRowSelected(index),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: _buildRowCells(_sortedData[index],
                                      widget.useFullWidth, effectiveWidth, availableWidth),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        );
        
        // Nếu cần cuộn ngang (có quá nhiều cột), bọc trong SingleChildScrollView
        if (shouldScroll) {
          // Tạo controller khi cần thiết
          _horizontalScrollController ??= ScrollController();
          
          if (widget.showHorizontalScrollbar) {
            return Theme(
              // Áp dụng màu cho thanh cuộn
              data: Theme.of(context).copyWith(
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(
                    widget.scrollbarColor ?? Colors.grey[400]!,
                  ),
                  trackColor: MaterialStateProperty.all(
                    widget.scrollbarColor != null 
                        ? widget.scrollbarColor!.withOpacity(0.2) 
                        : Colors.grey[300],
                  ),
                  trackBorderColor: MaterialStateProperty.all(Colors.transparent),
                  thickness: MaterialStateProperty.all(widget.scrollbarThickness),
                  radius: widget.scrollbarRadius,
                ),
              ),
              child: Scrollbar(
                thickness: widget.scrollbarThickness,
                radius: widget.scrollbarRadius,
                interactive: true,
                thumbVisibility: widget.scrollbarAlwaysVisible,
                trackVisibility: widget.scrollbarAlwaysVisible,
                controller: _horizontalScrollController,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _horizontalScrollController,
                  child: tableContent,
                ),
              ),
            );
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _horizontalScrollController,
              child: tableContent,
            );
          }
        }
        
        // Ngược lại, trả về trực tiếp bảng
        return tableContent;
      },
    );
  }

  // Update the header checkbox to match the style
  List<Widget> _buildHeaderCells(
      bool shouldExpand, double effectiveWidth, double availableWidth) {
    return List.generate(_effectiveColumns.length, (index) {
      final column = _effectiveColumns[index];
      final hasSort = column.sortValueGetter != null;
      final isLast = index == _effectiveColumns.length - 1;
      
      // Tính chiều rộng cột dựa trên loại cột và không gian có sẵn
      final colWidth = shouldExpand 
          ? _calculateColumnWidth(index, availableWidth)
          : (_columnWidths[index] ?? (column.width ?? widget.minColumnWidth));
      
      // Special case for checkbox column
      if (widget.showCheckboxes && index == 0) {
        return _buildCell(
          child: Center(
            child: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: _allSelected,
                onChanged: _toggleSelectAll,
                activeColor: Colors.blue,
                checkColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          width: colWidth,
          isLast: isLast,
          columnIndex: index,
          shouldExpand: shouldExpand,
          effectiveWidth: effectiveWidth,
          availableWidth: availableWidth,
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
                  child: Text(
                    column.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                    textAlign: column.titleAlignment,
                  ),
                ),
                // Only add the icon when it should actually be visible
                if (hasSort && _sortColumnIndex == index && _sortDirection != SortDirection.none) 
                  _buildSortIcon(index),
              ],
            ),
          ),
        ),
        width: colWidth,
        isLast: isLast,
        columnIndex: index,
        shouldExpand: shouldExpand,
        effectiveWidth: effectiveWidth,
        availableWidth: availableWidth,
      );
    });
  }

  List<Widget> _buildRowCells(
      T item, bool shouldExpand, double effectiveWidth, double availableWidth) {
    return List.generate(_effectiveColumns.length, (index) {
      final column = _effectiveColumns[index];
      final isLast = index == _effectiveColumns.length - 1;
      
      // Tính chiều rộng cột dựa trên loại cột và không gian có sẵn
      final colWidth = shouldExpand 
          ? _calculateColumnWidth(index, availableWidth)
          : (_columnWidths[index] ?? (column.width ?? widget.minColumnWidth));
      
      // Special handling for checkbox column
      if (widget.showCheckboxes && index == 0) {
        return _buildCell(
          child: Center(
            child: column.cellBuilder(item),
          ),
          width: colWidth,
          isLast: isLast,
          columnIndex: index,
          shouldExpand: shouldExpand,
          effectiveWidth: effectiveWidth,
          availableWidth: availableWidth,
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
        width: colWidth,
        isLast: isLast,
        columnIndex: index,
        shouldExpand: shouldExpand,
        effectiveWidth: effectiveWidth,
        availableWidth: availableWidth,
      );
    });
  }

  Widget _buildCell({
    required Widget child,
    required double width,
    bool isLast = false,
    int? columnIndex,
    bool shouldExpand = false,
    double? effectiveWidth,
    double? availableWidth,
  }) {
    // Điều chỉnh cho cột cuối cùng để tránh overflow
    final adjustedWidth = isLast ? width - 2.0 : width;
    
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
          decoration: widget.showVerticalLines && !isLast
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
                onHorizontalDragStart: (details) =>
                    _startResize(columnIndex, details.globalPosition.dx),
                onHorizontalDragUpdate: (details) =>
                    _updateResize(details.globalPosition.dx),
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
    if (_resizingColumnIndex == null ||
        _resizeStartX == null ||
        _resizeStartWidth == null) {
      return;
    }

    final delta = currentX - _resizeStartX!;
    final newWidth = _resizeStartWidth! + delta;

    if (newWidth >= widget.minColumnWidth) {
      setState(() {
        _columnWidths[_resizingColumnIndex!] = newWidth;
      });
    }
  }

  void _endResize() {
    setState(() {
      _resizingColumnIndex = null;
      _resizeStartX = null;
      _resizeStartWidth = null;
    });
  }
}
