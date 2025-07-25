import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_button_icon_with_popup.dart';
import 'package:se_gay_components/common/sg_button_v2.dart';
import 'package:se_gay_components/common/sg_popup_menu.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

// Thêm class mới cho nhóm sub-items
class SGSubItemGroup {
  final String title;
  final List<SGSidebarSubItem> items;
  final TextStyle? titleStyle;

  SGSubItemGroup({
    required this.title,
    required this.items,
    this.titleStyle,
  });
}

class SGSidebarHorizontalItem {
  final String label;
  final IconData? icon;
  final bool isActive;
  final bool isHover;
  final VoidCallback onTap;
  final List<SGSidebarSubItem>? subItems;
  final List<SGSubItemGroup>? subItemGroups; // Thêm thuộc tính mới
  final double popupWidth;
  final Color? popupBackgroundColor;
  final Color? buttonEnterColor;
  final double popupBorderRadius;
  final EdgeInsetsGeometry popupPadding;
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
  final double popupOffsetX;
  final double popupOffsetY;
  final double? spacing;
  final bool isShowPopupLeft;
  final String? groupTitle;
  final TextStyle? groupTitleStyle;
  final EdgeInsetsGeometry? groupTitlePadding;
  final bool showGroupTitle;

  const SGSidebarHorizontalItem({
    required this.label,
    this.icon,
    this.isActive = false,
    this.isHover = false,
    required this.onTap,
    this.subItems,
    this.subItemGroups, // Thêm tham số mới
    this.popupWidth = 200,
    this.buttonEnterColor = Colors.transparent,
    this.popupBackgroundColor = Colors.white,
    this.popupBorderRadius = 8.0,
    this.popupPadding = EdgeInsets.zero,
    this.preferBelow = true,
    this.onPopupOpened,
    this.onPopupClosed,
    this.animationDuration = const Duration(milliseconds: 42),
    this.popupMaxHeight,
    this.popupEnableScroll = true,
    this.paddingButton,
    this.marginButton,
    this.heightButton = 24,
    this.borderRadiusButton,
    this.popupOffsetY = 5,
    this.popupOffsetX = 0,
    this.spacing,
    this.isShowPopupLeft = true,
    this.groupTitle,
    this.groupTitleStyle,
    this.groupTitlePadding = const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 8),
    this.showGroupTitle = false,
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
  // Thêm Map để lưu GlobalKey cho mỗi item
  final Map<String, GlobalKey> _itemKeys = {};
  // Map lưu offset cho mỗi item
  final Map<String, double> _itemOffsets = {};

  @override
  void initState() {
    super.initState();
    // Tạo GlobalKey cho mỗi item - sử dụng index + label để đảm bảo duy nhất
    for (int i = 0; i < widget.items.length; i++) {
      var item = widget.items[i];
      _itemKeys['${i}_${item.label}'] = GlobalKey();
      _itemOffsets['${i}_${item.label}'] = 10.0; // Giá trị mặc định
    }

    // Tìm item active mặc định
    _findActiveItem();

    // Thêm post frame callback để đo kích thước sau khi render lần đầu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAllItemSizes();
    });

    // Thông báo subItems ban đầu sau khi frame đầu tiên hoàn thành
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedItem != null && widget.onShowSubItems != null) {
        widget.onShowSubItems?.call(_selectedItem!.subItems);
      }
    });
  }

  void _updateAllItemSizes() {
    for (var item in widget.items) {
      _updateItemSize(item);
    }
    if (mounted) {
      setState(() {});
    }
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

  void _handleItemTap(SGSidebarHorizontalItem item) {
    setState(() {
      _selectedItem = item;
    });
    item.onTap();
    if (widget.onShowSubItems != null) {
      widget.onShowSubItems?.call(item.subItems);
    }
  }

  void _handleSubItemTap(SGSidebarSubItem subItem, SGSidebarHorizontalItem parentItem) {
    setState(() {
      _selectedItem = parentItem;
    });
    subItem.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48, // Đặt chiều cao cố định để đảm bảo không có vấn đề về kích thước
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min, // Cho phép Row chỉ chiếm không gian cần thiết
          crossAxisAlignment: CrossAxisAlignment.center, // Canh giữa các items theo chiều dọc
          children: widget.items.map((item) => _buildItem(item)).toList(),
        ),
      ),
    );
  }

  // Lấy key cho item
  String _getKeyForItem(SGSidebarHorizontalItem item) {
    // Tìm index của item
    int index = widget.items.indexOf(item);
    return '${index}_${item.label}';
  }

  Widget _buildItem(SGSidebarHorizontalItem item) {
    // Hiển thị tiêu đề nhóm nếu được yêu cầu
    if (item.showGroupTitle && item.groupTitle != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: item.groupTitlePadding ?? const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 8),
            child: Text(
              item.groupTitle!,
              style: item.groupTitleStyle ??
                  TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
            ),
          ),
          _buildItemWidget(item),
        ],
      );
    }

    // Nếu không có tiêu đề, chỉ trả về item thông thường
    return _buildItemWidget(item);
  }

  // Tách phần tạo widget item ra thành một phương thức riêng
  Widget _buildItemWidget(SGSidebarHorizontalItem item) {
    // Chuyển đổi subItems thành SGPopupMenuItem
    List<Widget> popupItems = [];

    // Xử lý subItemGroups nếu có (ưu tiên hơn subItems)
    if (item.subItemGroups != null && item.subItemGroups!.isNotEmpty) {
      for (var group in item.subItemGroups!) {
        // Thêm tiêu đề nhóm
        popupItems.add(
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 12, right: 12),
            child: Text(
              group.title,
              style: group.titleStyle ??
                  const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Colors.black,
                  ),
            ),
          ),
        );

        // Thêm các items trong nhóm
        popupItems.addAll(group.items.map((subItem) => _buildSubItemWidget(subItem, item, 16.0)));
      }
    }
    // Xử lý subItems thông thường
    else if (item.subItems != null && item.subItems!.isNotEmpty) {
      popupItems = item.subItems!.map((subItem) => _buildSubItemWidget(subItem, item, 0)).toList();
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

    final Color backgroundColor = isHovered ? (item.buttonEnterColor ?? Colors.grey.shade300) : Colors.transparent;
    SGLog.debug("SGSidebarHorizontal", ' isHovered: $isHovered, _hoveredItem: ${_hoveredItem?.label}, item: ${item.label}');

    // Bọc trong MouseRegion để xử lý hover trực tiếp
    return MouseRegion(
      onEnter: (_) {
        if (_hoveredItem != item) {
          setState(() {
            _hoveredItem = item;
          });
          if (widget.onShowSubItems != null) {
            widget.onShowSubItems?.call(item.subItems);
          }
        }
      },
      onExit: (_) {
        if (_hoveredItem == item) {
          setState(() {
            _hoveredItem = null;
          });
          if (_selectedItem != null && widget.onShowSubItems != null) {
            widget.onShowSubItems?.call(_selectedItem!.subItems);
          }
        }
      },
      // Giới hạn kích thước bằng Container với constraints
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 200, // Giới hạn chiều rộng tối đa cho mỗi item
          minWidth: 80, // Đảm bảo chiều rộng tối thiểu
        ),
        child: Container(
          key: _itemKeys[_getKeyForItem(item)],
          child: SGButtonIconWithPopup(
            popupItems: popupItems,
            popupWidth: item.popupWidth,
            popupOffset: _calculateOffset(item),
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
            onclick: (_) {
              _handleItemTap(item);
            },
            contentAlignmentButton: MainAxisAlignment.spaceBetween,
            contentCrossAxisAlignmentButton: CrossAxisAlignment.end,
            textStyleButton: TextStyle(
              color: item.isActive ? Colors.deepOrangeAccent : Colors.grey[800],
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  // Tạo một phương thức riêng để xây dựng widget cho subItem
  SGPopupMenuItem _buildSubItemWidget(SGSidebarSubItem subItem, SGSidebarHorizontalItem parentItem, double leftPadding) {
    return SGPopupMenuItem(
      spacing: parentItem.spacing ?? 0,
      content: InkWell(
        onTap: () {
          _handleSubItemTap(subItem, parentItem);
        },
        child: Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Row(
            children: [
              if (subItem.icon != null) ...[
                Icon(
                  subItem.icon,
                  color: subItem.isActive ? Colors.deepOrangeAccent : Colors.grey[600],
                  size: 16,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                subItem.label,
                style: TextStyle(
                  color: subItem.isActive ? Colors.deepOrangeAccent : Colors.grey[800],
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Thêm phương thức tính toán offset
  Offset _calculateOffset(SGSidebarHorizontalItem item) {
    final buttonWidth = _itemOffsets[_getKeyForItem(item)] ?? 10.0;
    final popupWidth = item.popupWidth;
    final double horizontalOffset = (item.isShowPopupLeft ? 1 : -1) * ((popupWidth / 2) - (buttonWidth / 2)) + item.popupOffsetX;
    return Offset(horizontalOffset, item.popupOffsetY);
  }

  // Cập nhật kích thước và trả về giá trị
  void _updateItemSize(SGSidebarHorizontalItem item) {
    final key = _itemKeys[_getKeyForItem(item)];
    final RenderBox? renderBox = key?.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      final width = size.width;
      _itemOffsets[_getKeyForItem(item)] = width;
    }
  }
}
