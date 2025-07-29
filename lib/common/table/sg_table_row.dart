import 'package:flutter/material.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'sg_table_cell.dart';

/// StatefulWidget riêng cho Row của bảng
class SgTableRow<T> extends StatefulWidget {
  final T item;
  final int index;
  final int totalRows;
  final List<SgTableColumn<T>> columns;
  final double rowHeight;
  final double totalWidth;
  final double effectiveWidth;
  final bool isSelected;
  final bool isChecked;
  final bool showHorizontalLines;
  final bool showLastLineTopBottom;
  final Color gridLineColor;
  final double gridLineWidth;
  final Color backgroundColor;
  final Function(int) onRowSelected;
  final Function(int, bool) onHover;
  final Map<int, double> columnWidths;
  final bool showVerticalLines;
  final bool showLastLineLeftRight;
  final bool showCheckboxes;
  
  const SgTableRow({
    super.key,
    required this.item,
    required this.index,
    required this.totalRows,
    required this.columns,
    required this.rowHeight,
    required this.totalWidth,
    required this.effectiveWidth,
    required this.isSelected,
    required this.isChecked,
    required this.showHorizontalLines,
    required this.showLastLineTopBottom,
    required this.gridLineColor,
    required this.gridLineWidth,
    required this.backgroundColor,
    required this.onRowSelected,
    required this.onHover,
    required this.columnWidths,
    required this.showVerticalLines,
    required this.showLastLineLeftRight,
    required this.showCheckboxes,
  });
  
  @override
  State<SgTableRow<T>> createState() => _SgTableRowState<T>();
}

class _SgTableRowState<T> extends State<SgTableRow<T>> {
  bool _isHovering = false;
  
  @override
  Widget build(BuildContext context) {
    final isLast = widget.index == widget.totalRows - 1;
    
    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          border: (widget.showHorizontalLines && (!isLast || widget.showLastLineTopBottom))
              ? Border(
                  bottom: BorderSide(
                    color: widget.gridLineColor,
                    width: widget.gridLineWidth,
                  ),
                )
              : null,
        ),
        child: SizedBox(
          width: widget.totalWidth,
          height: widget.rowHeight,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () => widget.onRowSelected(widget.index),
              onHover: (isHovering) {
                if (_isHovering != isHovering) {
                  setState(() {
                    _isHovering = isHovering;
                  });
                  widget.onHover(widget.index, isHovering);
                }
              },
              child: Row(
                children: _buildCells(),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  List<Widget> _buildCells() {
    return List.generate(widget.columns.length, (index) {
      final column = widget.columns[index];
      final isLast = index == widget.columns.length - 1;
      final baseWidth = widget.columnWidths[index] ?? (column.width ?? 120.0);
      
      return SgTableCell<T>(
        item: widget.item,
        cellBuilder: column.cellBuilder,
        width: baseWidth,
        height: widget.rowHeight,
        isLast: isLast,
        cellAlignment: column.cellAlignment,
        showVerticalLines: widget.showVerticalLines,
        showLastLineLeftRight: widget.showLastLineLeftRight,
        gridLineColor: widget.gridLineColor,
        gridLineWidth: widget.gridLineWidth,
      );
    });
  }
  
  // Không cần _buildCell nữa vì đã dùng SgTableCell
} 