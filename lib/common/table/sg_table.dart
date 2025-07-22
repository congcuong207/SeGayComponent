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
  final Color gridLineColor;
  final double gridLineWidth;
  final bool showVerticalLines;
  final bool showHorizontalLines;
  final bool allowRowSelection;
  final BorderRadius? borderRadius;
  final Function(T)? onRowTap;
  final String? searchTerm;
  final bool caseSensitiveSearch;
  final bool Function(T)? customFilter;

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
    this.headerBackgroundColor = SGAppColors.neutral100,
    this.oddRowBackgroundColor = Colors.white,
    this.evenRowBackgroundColor = SGAppColors.neutral200,
    this.selectedRowColor = SGAppColors.info100,
    this.gridLineColor = SGAppColors.neutral200,
    this.gridLineWidth = 1.0,
    this.showVerticalLines = true,
    this.showHorizontalLines = true,
    this.allowRowSelection = true,
    this.borderRadius,
    this.onRowTap,
    this.searchTerm,
    this.caseSensitiveSearch = false,
    this.customFilter,
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
  });

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
  void didUpdateWidget(SgTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      _sortedData = List.from(widget.data);
      _filterAndSortData();
    }

    if (widget.columns != oldWidget.columns ||
        widget.showActions != oldWidget.showActions ||
        widget.actionColumnTitle != oldWidget.actionColumnTitle) {
      _buildEffectiveColumns();
      _initColumnWidths();
    }

    if (widget.searchTerm != _lastSearchTerm) {
      _lastSearchTerm = widget.searchTerm;
      _filterAndSortData();
    }
  }

  void _buildEffectiveColumns() {
    _effectiveColumns = List.from(widget.columns);

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
      return const SizedBox(width: 20);
    }

    return Icon(
      _sortDirection == SortDirection.ascending
          ? Icons.arrow_upward
          : Icons.arrow_downward,
      size: 16,
      color: SGAppColors.neutral700,
    );
  }

  double _calculateTotalWidth() {
    double totalWidth = 0;
    for (int i = 0; i < _effectiveColumns.length; i++) {
      totalWidth += _columnWidths[i] ?? (_effectiveColumns[i].width ?? 120.0);
    }
    return totalWidth;
  }

  @override
  Widget build(BuildContext context) {
    final totalWidth = _calculateTotalWidth();
    final effectiveWidth = totalWidth;

    final exactHeight =
        widget.rowHeight + (_sortedData.length * widget.rowHeight);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: effectiveWidth,
            height: exactHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
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
                      children:
                          _buildHeaderCells(false, effectiveWidth, totalWidth),
                    ),
                  ),
                ),
                // Table body rows
                SizedBox(
                  height: _sortedData.length * widget.rowHeight,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _sortedData.length,
                    itemBuilder: (context, index) {
                      final isEven = index % 2 == 0;
                      final isLast = index == _sortedData.length - 1;
                      final isSelected = _selectedRowIndex == index;

                      Color backgroundColor;
                      if (isSelected) {
                        backgroundColor = widget.selectedRowColor;
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
                              children: _buildRowCells(_sortedData[index],
                                  false, effectiveWidth, totalWidth),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildHeaderCells(
      bool shouldExpand, double screenWidth, double totalWidth) {
    return List.generate(_effectiveColumns.length, (index) {
      final column = _effectiveColumns[index];
      final hasSort = column.sortValueGetter != null;
      final isLast = index == _effectiveColumns.length - 1;

      return _buildCell(
        child: InkWell(
          onTap: hasSort ? () => _onSortColumn(index) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  ),
                ),
                if (hasSort) _buildSortIcon(index),
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

  List<Widget> _buildRowCells(
      T item, bool shouldExpand, double screenWidth, double totalWidth) {
    return List.generate(_effectiveColumns.length, (index) {
      final column = _effectiveColumns[index];
      final isLast = index == _effectiveColumns.length - 1;

      return _buildCell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: column.cellAlignment == TextAlign.center
                ? Alignment.center
                : column.cellAlignment == TextAlign.right
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            child: column.cellBuilder(item),
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

  Widget _buildCell(
      {required Widget child,
      double? width,
      bool isLast = false,
      int? columnIndex,
      bool shouldExpand = false,
      double? screenWidth,
      double? totalWidth}) {
    final baseWidth = columnIndex != null
        ? (_columnWidths[columnIndex] ?? (width ?? 120.0))
        : (width ?? 120.0);

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
    final originalWidth = _originalColumnWidths[_resizingColumnIndex] ?? 120.0;
    final newWidth = _resizeStartWidth! + delta;

    if (newWidth >= originalWidth) {
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
