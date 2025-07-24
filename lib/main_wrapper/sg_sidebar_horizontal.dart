import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_button_icon_with_popup.dart';
import 'package:se_gay_components/common/sg_button_v2.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_popup_menu.dart';

class SGSidebarHorizontalItem {
  final String label;
  final IconData? icon;
  final bool isActive;
  final bool isHover;
  final VoidCallback onTap;
  final List<SGSidebarSubItem>? subItems;
  final double popupWidth;
  final Color? popupBackgroundColor;
  final Color? buttonEnterColor;
  final double popupBorderRadius;
  final EdgeInsetsGeometry popupPadding;
  final Offset popupOffset;
  final bool preferBelow;
  final VoidCallback? onPopupOpened;
  final VoidCallback? onPopupClosed;
  final Duration animationDuration;
  final double? popupMaxHeight;
  final bool popupEnableScroll;
  final EdgeInsetsGeometry? paddingButton;
  final EdgeInsetsGeometry? marginButton;
  final double? heightButton;
  final double? borderRadiusButton;

  const SGSidebarHorizontalItem({
    required this.label,
    this.icon,
    this.isActive = false,
    this.isHover = false,
    required this.onTap,
    this.subItems,
    this.popupWidth = 200,
    this.buttonEnterColor = Colors.transparent,
    this.popupBackgroundColor = Colors.white,
    this.popupBorderRadius = 8.0,
    this.popupPadding = const EdgeInsets.symmetric(vertical: 8.0),
    this.popupOffset = const Offset(0, 5),
    this.preferBelow = true,
    this.onPopupOpened,
    this.onPopupClosed,
    this.animationDuration = const Duration(milliseconds: 150),
    this.popupMaxHeight,
    this.popupEnableScroll = true,
    this.paddingButton,
    this.marginButton,
    this.heightButton = 24,
    this.borderRadiusButton,
  });
}

class SGSidebarSubItem {
  final String label;
  final IconData? icon;
  final bool isActive;
  final VoidCallback onTap;

  SGSidebarSubItem({
    required this.label,
    this.icon,
    this.isActive = false,
    required this.onTap,
  });
}

class SGSidebarHorizontal extends StatefulWidget {
  final List<SGSidebarHorizontalItem> items;
  final Function(List<SGSidebarSubItem>?)? onShowSubItems;

  const SGSidebarHorizontal({
    super.key,
    required this.items,
    this.onShowSubItems,
  });

  @override
  State<SGSidebarHorizontal> createState() => _SGSidebarHorizontalState();
}

class _SGSidebarHorizontalState extends State<SGSidebarHorizontal> {
  SGSidebarHorizontalItem? _selectedItem;
  SGSidebarHorizontalItem? _hoveredItem;

  @override
  void initState() {
    super.initState();
    // Tìm item active mặc định
    _findActiveItem();

    // Thông báo subItems ban đầu sau khi frame đầu tiên hoàn thành
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedItem != null && widget.onShowSubItems != null) {
        widget.onShowSubItems?.call(_selectedItem!.subItems);
      }
    });
  }

  void _findActiveItem() {
    try {
      _selectedItem = widget.items.firstWhere((item) => item.isActive);
    } catch (e) {
      // Nếu không tìm thấy item active, chọn item đầu tiên
      if (widget.items.isNotEmpty) {
        _selectedItem = widget.items.first;
      }
    }
  }

  @override
  void didUpdateWidget(covariant SGSidebarHorizontal oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cập nhật item được chọn khi widget cập nhật
    _findActiveItem();
  }

  void _handleItemEnter(SGSidebarHorizontalItem item) {
    setState(() {
      _hoveredItem = item;
    });
    if (widget.onShowSubItems != null) {
      widget.onShowSubItems?.call(item.subItems);
    }
  }

  void _handleItemExit(SGSidebarHorizontalItem item) {
    setState(() {
      _hoveredItem = null;
    });
    if (_selectedItem != null && widget.onShowSubItems != null) {
      widget.onShowSubItems?.call(_selectedItem!.subItems);
    }
  }

  void _handleItemTap(SGSidebarHorizontalItem item) {
    item.onTap();
    _selectedItem = item;
    if (widget.onShowSubItems != null) {
      widget.onShowSubItems?.call(item.subItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: widget.items.map((item) => _buildItem(item)).toList(),
      ),
    );
  }

  Widget _buildItem(SGSidebarHorizontalItem item) {
    // Chuyển đổi subItems thành SGPopupMenuItem
    List<SGPopupMenuItem> popupItems = [];
    if (item.subItems != null && item.subItems!.isNotEmpty) {
      popupItems = item.subItems!
          .map((subItem) => SGPopupMenuItem(
                content: InkWell(
                  onTap: subItem.onTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      children: [
                        if (subItem.icon != null) ...[
                          Icon(
                            subItem.icon,
                            color: subItem.isActive ? Colors.deepOrangeAccent : Colors.grey[600],
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          subItem.label,
                          style: TextStyle(
                            color: subItem.isActive ? Colors.deepOrangeAccent : Colors.grey[800],
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList();
    }

    // Tạo widget icon cho button (nếu có)
    Widget? iconWidget;
    if (item.icon != null) {
      iconWidget = Icon(
        item.icon,
        color: item.isActive ? Colors.deepOrangeAccent : Colors.grey[600],
        size: 16,
      );
    }

    final bool isHovered = _hoveredItem == item;

    final Color backgroundColor = isHovered ? (item.buttonEnterColor ?? Colors.grey.shade100) : Colors.transparent;

    return SGButtonIconWithPopup(
      popupItems: popupItems,
      popupWidth: item.popupWidth,
      popupOffset: item.popupOffset,
      preferBelow: item.preferBelow,
      popupBackgroundColor: item.popupBackgroundColor ?? Colors.white,
      popupBorderRadius: item.popupBorderRadius,
      popupPadding: item.popupPadding,
      popupMaxHeight: item.popupMaxHeight,
      popupEnableScroll: item.popupEnableScroll,
      onPopupOpened: item.onPopupOpened,
      onPopupClosed: item.onPopupClosed,
      textButton: item.label,
      iconChildButton: iconWidget,
      colorTextButton: item.isActive ? Colors.deepOrangeAccent : Colors.grey[800],
      colorBackgroundButton: backgroundColor,
      buttonType: SGButtonType.text,
      heightButton: item.heightButton,
      paddingButton: item.paddingButton ?? const EdgeInsets.symmetric(horizontal: 12),
      marginButton: item.marginButton,
      borderRadiusButton: item.borderRadiusButton,
      onclick: (_) => _handleItemTap(item),
      onEnter: (context, event) {
        _handleItemEnter(item);
      },
      onExit: (context, event) {
        _handleItemExit(item);
      },
      contentAlignmentButton: MainAxisAlignment.spaceBetween,
      contentCrossAxisAlignmentButton: CrossAxisAlignment.end,
      // Thêm icon mũi tên xuống nếu có subItems
      textStyleButton: TextStyle(
        color: item.isActive ? Colors.deepOrangeAccent : Colors.grey[800],
        fontWeight: FontWeight.normal,
        fontSize: 12,
      ),
    );
  }
}
