import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se_gay_components/base/model/nav_menu_item.dart';

class ItemSidebar extends StatefulWidget {
  final NavMenuItem item;
  final bool isCollapsed;
  final int? hoveredIndex;
  final bool isSelected;
  final bool isHovered;
  final Color color;
  final Color colorIcon;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;
  final VoidCallback onTap;
  final bool showExpandIcon;
  final bool isExpanded;
  final bool isChild;
  const ItemSidebar({
    super.key,
    required this.isSelected,
    required this.isHovered,
    required this.color,
    required this.colorIcon,
    required this.item,
    required this.isCollapsed,
    this.hoveredIndex,
    required this.onEnter,
    required this.onExit,
    required this.onTap,
    this.showExpandIcon = false,
    this.isExpanded = false,
    this.isChild = false,
  });

  @override
  State<ItemSidebar> createState() => _ItemSidebarState();
}

class _ItemSidebarState extends State<ItemSidebar> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.onEnter,
      onExit: widget.onExit,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: (widget.isSelected && !widget.isChild)
              // ignore: deprecated_member_use
              ? Colors.blue.withOpacity(0.08)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(widget.isChild ? Icons.remove : widget.item.icon,
                  color: widget.colorIcon, size: 24),
              const SizedBox(width: 12),
              Visibility(
                visible: !widget.isCollapsed,
                child: Expanded(
                  child: AnimatedOpacity(
                    opacity: widget.isCollapsed ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.item.title,
                            style: TextStyle(
                              color: widget.color,
                              fontWeight: widget.isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.showExpandIcon)
                          Icon(
                            widget.isExpanded
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_right,
                            size: 20,
                            color: widget.color,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
