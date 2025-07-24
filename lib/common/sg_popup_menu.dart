import 'package:flutter/material.dart';

class SGPopupMenu extends StatelessWidget {
  final List<SGPopupMenuItem> items;
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
    return GestureDetector(
      // This prevents the tap from propagating to the root GestureDetector
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
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
      ),
    );
  }
}

class SGPopupMenuItem extends StatelessWidget {
  final String? title;
  final List<Widget>? buttons;
  final Widget? content;
  final EdgeInsetsGeometry padding;
  final Color? hoverColor;
  final VoidCallback? onTap;
  
  const SGPopupMenuItem({
    super.key,
    this.title,
    this.buttons,
    this.content,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    this.hoverColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget itemContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        if (content != null) content!,
        if (buttons != null && buttons!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: buttons!.map((button) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: button,
                );
              }).toList(),
            ),
          ),
      ],
    );
    
    // Wrap in InkWell if onTap is provided
    if (onTap != null) {
      itemContent = InkWell(
        onTap: onTap,
        hoverColor: hoverColor ?? Theme.of(context).hoverColor,
        splashColor: Theme.of(context).splashColor,
        highlightColor: Theme.of(context).highlightColor,
        child: itemContent,
      );
    }

    return Padding(
      padding: padding,
      child: itemContent,
    );
  }
}
