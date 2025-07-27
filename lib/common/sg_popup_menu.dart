import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SGPopupMenu extends StatelessWidget {
  final List<Widget> items;
  final double width;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double? maxHeight;
  final bool enableScroll;
  final ScrollController? scrollController;

  const SGPopupMenu({
    super.key,
    required this.items,
    this.width = 200,
    this.backgroundColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
    this.maxHeight,
    this.enableScroll = true,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // Widget content to display
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );

    // Add ScrollView if enabled or maxHeight is set
    if (enableScroll || maxHeight != null) {
      content = SingleChildScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        child: content,
      );
    }

    // If maxHeight is set, constrain the container
    if (maxHeight != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight!,
        ),
        child: content,
      );
    }

    // Wrap in GestureDetector to prevent clicks from propagating to parent
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: padding,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      ),
    );
  }
}

class SGPopupMenuItem extends StatefulWidget {
  final String? title;
  final List<Widget>? buttons;
  final Widget? content;
  final EdgeInsetsGeometry padding;
  final Color? hoverColor;
  final VoidCallback? onTap;
  final Function(PointerEnterEvent event)? onEnter;
  final Function(PointerExitEvent event)? onExit;
  final double? spacing;

  const SGPopupMenuItem({
    super.key,
    this.title,
    this.buttons,
    this.content,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
    this.hoverColor,
    this.onTap,
    this.spacing,
    this.onEnter,
    this.onExit,
  });

  @override
  State<SGPopupMenuItem> createState() => _SGPopupMenuItemState();
}

class _SGPopupMenuItemState extends State<SGPopupMenuItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    Widget itemContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: widget.spacing ?? 0,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        if (widget.content != null) widget.content!,
        if (widget.buttons != null && widget.buttons!.isNotEmpty)
          Row(
            children: widget.buttons!.map((button) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: button,
              );
            }).toList(),
          ),
      ],
    );

    // Wrap with hover detection
    Widget result = MouseRegion(
      onEnter: (event) {
        setState(() {
          isHovered = true;
        });
        widget.onEnter?.call(event);
      },
      onExit: (event) {
        setState(() {
          isHovered = false;
        });
        widget.onExit?.call(event);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isHovered ? Colors.grey.shade300 : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: widget.padding,
        child: itemContent,
      ),
    );

    // Wrap in GestureDetector if onTap is provided
    if (widget.onTap != null) {
      result = GestureDetector(
        onTap: widget.onTap,
        child: result,
      );
    }

    return result;
  }
}
