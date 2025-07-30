import 'package:flutter/material.dart';

/// StatefulWidget riêng cho Cell của bảng
class SgTableCell<T> extends StatefulWidget {
  final T item;
  final Widget Function(T) cellBuilder;
  final double width;
  final double height;
  final bool isLast;
  final TextAlign cellAlignment;
  final bool showVerticalLines;
  final bool showLastLineLeftRight;
  final Color gridLineColor;
  final double gridLineWidth;
  
  const SgTableCell({
    super.key,
    required this.item,
    required this.cellBuilder,
    required this.width,
    required this.height,
    this.isLast = false,
    required this.cellAlignment,
    required this.showVerticalLines,
    required this.showLastLineLeftRight,
    required this.gridLineColor,
    required this.gridLineWidth,
  });
  
  @override
  State<SgTableCell<T>> createState() => _SgTableCellState<T>();
}

class _SgTableCellState<T> extends State<SgTableCell<T>> {
  // Widget caching
  late Widget _cellContent;
  bool _isContentBuilt = false;
  
  // Cache style và alignment
  late Alignment _alignment;
  late EdgeInsetsGeometry _padding;
  
  @override
  void initState() {
    super.initState();
    _buildCellContent();
    _initAlignmentAndPadding();
  }
  
  @override
  void didUpdateWidget(SgTableCell<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // So sánh sâu hơn, không chỉ reference equality
    final bool needsRebuild = widget.item != oldWidget.item || 
        widget.cellBuilder != oldWidget.cellBuilder;
    
    final bool needsUpdateAlignment = widget.cellAlignment != oldWidget.cellAlignment;
        
    if (needsRebuild) {
      _buildCellContent();
    }
    
    if (needsUpdateAlignment) {
      _initAlignmentAndPadding();
    }
  }
  
  void _buildCellContent() {
    _cellContent = widget.cellBuilder(widget.item);
    _isContentBuilt = true;
  }
  
  void _initAlignmentAndPadding() {
    // Xác định alignment dựa trên cellAlignment
    _alignment = widget.cellAlignment == TextAlign.center
        ? Alignment.center
        : widget.cellAlignment == TextAlign.right
            ? Alignment.centerRight
            : Alignment.centerLeft;
    
    // Chỉ áp dụng padding cho text cells (không phải center)
    _padding = widget.cellAlignment == TextAlign.center
        ? EdgeInsets.zero
        : const EdgeInsets.symmetric(horizontal: 8);
  }
  
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _buildCellContainer(),
    );
  }
  
  Widget _buildCellContainer() {
    if (widget.isLast) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: _buildInnerContent(),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: widget.showVerticalLines && (!widget.isLast || widget.showLastLineLeftRight)
          ? BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: widget.gridLineColor,
                  width: widget.gridLineWidth,
                ),
              ),
            )
          : null,
      child: _buildInnerContent(),
    );
  }
  
  Widget _buildInnerContent() {
    if (!_isContentBuilt) {
      _buildCellContent();
    }
    
    // Nếu là checkbox hoặc action column, trả về trực tiếp
    if (widget.cellAlignment == TextAlign.center) {
      return Center(child: _cellContent);
    }
    
    return Container(
      padding: _padding,
      alignment: _alignment,
      child: _cellContent,
    );
  }
} 