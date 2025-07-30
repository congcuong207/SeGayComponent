import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'sg_table.dart';

/// StatefulWidget riêng cho Header của bảng
class SgTableHeader<T> extends StatefulWidget {
  final List<SgTableColumn<T>> columns;
  final Color headerBackgroundColor;
  final Color gridLineColor;
  final double gridLineWidth;
  final Color? textHeaderColor;
  final bool showLastLineLeftRight;
  final bool showVerticalLines;
  final double rowHeight;
  final double totalWidth;
  final double effectiveWidth;
  final bool showCheckboxes;
  final Map<int, double> columnWidths;
  final Function(int columnIndex) onSortColumn;
  final Function(int columnIndex, double startX) onStartResize;
  final Function(double currentX) onUpdateResize;
  final Function() onEndResize;
  final Function(bool? selected) onToggleSelectAll;
  final bool allSelected;
  final int? sortColumnIndex;
  final SortDirection sortDirection;
  final double? checkboxColumnWidth;
  final double? scaleCheckbox;
  final Color? activeColor;
  final Color? checkColor;
  final BorderSide? side;
  final BeveledRectangleBorder? shape;

  const SgTableHeader({
    super.key,
    required this.columns,
    required this.headerBackgroundColor,
    required this.gridLineColor,
    required this.gridLineWidth,
    this.textHeaderColor,
    required this.showLastLineLeftRight,
    required this.showVerticalLines,
    required this.rowHeight,
    required this.totalWidth,
    required this.effectiveWidth,
    required this.showCheckboxes,
    required this.columnWidths,
    required this.onSortColumn,
    required this.onStartResize,
    required this.onUpdateResize,
    required this.onEndResize,
    required this.onToggleSelectAll,
    required this.allSelected,
    this.sortColumnIndex,
    required this.sortDirection,
    this.checkboxColumnWidth,
    this.scaleCheckbox,
    this.activeColor,
    this.checkColor,
    this.side,
    this.shape,
  });

  @override
  State<SgTableHeader<T>> createState() => _SgTableHeaderState<T>();
}

class _SgTableHeaderState<T> extends State<SgTableHeader<T>> {
  // Cache header cells
  late List<Widget> _headerCells;
  bool _needsRebuild = true;

  @override
  void initState() {
    super.initState();
    _buildHeaderCells();
  }

  @override
  void didUpdateWidget(SgTableHeader<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Chỉ rebuild khi cần thiết
    _needsRebuild = widget.columns != oldWidget.columns ||
        widget.columnWidths != oldWidget.columnWidths ||
        widget.sortColumnIndex != oldWidget.sortColumnIndex ||
        widget.sortDirection != oldWidget.sortDirection ||
        widget.allSelected != oldWidget.allSelected ||
        widget.showVerticalLines != oldWidget.showVerticalLines ||
        widget.showLastLineLeftRight != oldWidget.showLastLineLeftRight ||
        widget.textHeaderColor != oldWidget.textHeaderColor ||
        widget.gridLineColor != oldWidget.gridLineColor ||
        widget.gridLineWidth != oldWidget.gridLineWidth;

    if (_needsRebuild) {
      _buildHeaderCells();
    }
  }

  void _buildHeaderCells() {
    _headerCells = List.generate(widget.columns.length, (index) {
      final column = widget.columns[index];
      final hasSort = column.sortValueGetter != null;
      final isLast = index == widget.columns.length - 1;

      // Trường hợp đặc biệt cho cột checkbox
      if (widget.showCheckboxes && index == 0) {
        return _buildCell(
          child: Center(
            child: Transform.scale(
              scale: widget.scaleCheckbox ?? 1.0,
              child: Checkbox(
                value: widget.allSelected,
                onChanged: widget.onToggleSelectAll,
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
        );
      }

      return _buildCell(
        child: InkWell(
          onTap: hasSort ? () => widget.onSortColumn(index) : null,
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
                // Chỉ thêm biểu tượng sắp xếp khi cần thiết
                if (hasSort && widget.sortColumnIndex == index && widget.sortDirection != SortDirection.none)
                  _buildSortIcon(index),
              ],
            ),
          ),
        ),
        width: column.width,
        isLast: isLast,
        columnIndex: index,
      );
    });

    _needsRebuild = false;
  }

  @override
  Widget build(BuildContext context) {
    // Nếu cần rebuild, làm điều đó trước
    if (_needsRebuild) {
      _buildHeaderCells();
    }

    return RepaintBoundary(
      child: DecoratedBox(
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
          width: widget.totalWidth,
          height: widget.rowHeight,
          child: Row(
            children: _headerCells,
          ),
        ),
      ),
    );
  }

  Widget _buildSortIcon(int columnIndex) {
    if (widget.sortColumnIndex != columnIndex || widget.sortDirection == SortDirection.none) {
      return const SizedBox.shrink(); // Return no space at all
    }

    return Icon(
      widget.sortDirection == SortDirection.ascending ? Icons.arrow_upward : Icons.arrow_downward,
      size: 16,
      color: SGAppColors.neutral700,
    );
  }

  Widget _buildCell({
    required Widget child,
    double? width,
    bool isLast = false,
    int? columnIndex,
  }) {
    final baseWidth = columnIndex != null ? (widget.columnWidths[columnIndex] ?? (width ?? 120.0)) : (width ?? 120.0);
    SGLog.info("BaseWidth", "baseWidth: $baseWidth");
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
        // Thêm handler để có thể resize cột
        if (columnIndex != null && !isLast)
          Positioned(
            right: -5,
            top: 0,
            bottom: 0,
            width: 10,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              child: GestureDetector(
                onHorizontalDragStart: (details) => widget.onStartResize(columnIndex, details.globalPosition.dx),
                onHorizontalDragUpdate: (details) => widget.onUpdateResize(details.globalPosition.dx),
                onHorizontalDragEnd: (_) => widget.onEndResize(),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
