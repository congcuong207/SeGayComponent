import 'package:flutter/material.dart';
import 'package:se_gay_components/base/model/nav_menu_item.dart';
import 'package:se_gay_components/base/navBar/component/item_sidebar.dart';
import 'package:se_gay_components/base/sg_text.dart';
import 'package:se_gay_components/utils/constants/colors.dart';
import 'package:se_gay_components/utils/constants/styles.dart';

class Sidebar extends StatefulWidget {
  final List<NavMenuItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool isCollapsed;
  final VoidCallback onMenuPressed;
  final void Function(int parentIndex, int childIndex, Widget page)? onChildItemSelected;

  const Sidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.isCollapsed,
    required this.onMenuPressed,
    this.onChildItemSelected,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int? hoveredIndex;
  Set<int> expandedIndexes = {};
  int? selectedChildIndex;
  int? hoveredChildIndex;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: widget.isCollapsed ? 70 : 320,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader(),
          ..._buildMenuItems(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    double sizePadingLogo = widget.isCollapsed ? 8.0 : 16;
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: Padding(
        padding: EdgeInsets.all(sizePadingLogo),
        child: widget.isCollapsed
            ? _buildCollapsedHeader()
            : _buildExpandedHeader(),
      ),
    );
  }

  Widget _buildCollapsedHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: const Icon(Icons.menu, size: 24),
        onPressed: widget.onMenuPressed,
      ),
    );
  }

  Widget _buildExpandedHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const LogoApp(
          nameApp: "POSDash",
          logoImage: "assets/images/logo_design.png",
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.menu, size: 24),
          onPressed: widget.onMenuPressed,
          constraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
            maxWidth: 40,
            maxHeight: 40,
          ),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  List<Widget> _buildMenuItems() {
    List<Widget> widgets = [];
    for (int index = 0; index < widget.items.length; index++) {
      final item = widget.items[index];
      final bool isParentSelected = widget.selectedIndex == index && (selectedChildIndex == null || (item.children != null && item.children!.isNotEmpty && selectedChildIndex != null));
      final isHovered = hoveredIndex == index;
      final color = _getTextColor(isParentSelected, isHovered);
      final colorIcon = _getIconColor(isParentSelected, isHovered);
      final hasChildren = item.children != null && item.children!.isNotEmpty;
      final isExpanded = expandedIndexes.contains(index);

      widgets.add(
        ItemSidebar(
          isSelected: isParentSelected,
          isHovered: isHovered,
          color: color,
          colorIcon: colorIcon,
          item: item,
          isCollapsed: widget.isCollapsed,
          onEnter: (_) => setState(() => hoveredIndex = index),
          onExit: (_) => setState(() => hoveredIndex = null),
          onTap: () {
            if (hasChildren) {
              setState(() {
                if (isExpanded) {
                  expandedIndexes.remove(index);
                } else {
                  expandedIndexes.add(index);
                }
              });
            } else {
              setState(() {
                selectedChildIndex = null;
              });
              widget.onItemSelected(index);
            }
          },
          showExpandIcon: hasChildren,
          isExpanded: isExpanded,
          isChild: false,
        ),
      );

      // Nếu có children và đang mở, render thêm các item con
      if (hasChildren && isExpanded && !widget.isCollapsed) {
        for (int childIdx = 0; childIdx < item.children!.length; childIdx++) {
          final child = item.children![childIdx];
          final isChildSelected = widget.selectedIndex == index && selectedChildIndex == childIdx;
          final isChildHovered = hoveredChildIndex == childIdx && hoveredIndex == index;
          final childColor = _getTextColor(isChildSelected, isChildHovered);
          final childColorIcon = _getIconColor(isChildSelected, isChildHovered);
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: ItemSidebar(
                isSelected: isChildSelected,
                isHovered: isChildHovered,
                color: childColor,
                colorIcon: childColorIcon,
                item: child,
                isCollapsed: widget.isCollapsed,
                onEnter: (_) => setState(() { hoveredChildIndex = childIdx; hoveredIndex = index; }),
                onExit: (_) => setState(() { hoveredChildIndex = null; }),
                onTap: () {
                  setState(() {
                    selectedChildIndex = childIdx;
                  });
                  if (widget.onChildItemSelected != null) {
                    widget.onChildItemSelected!(index, childIdx, child.page!);
                  } else {
                    widget.onItemSelected(index);
                  }
                },
                isChild: true,
              ),
            ),
          );
        }
      }
    }
    return widgets;
  }

  Color _getTextColor(bool isSelected, bool isHovered) {
    if (isSelected || isHovered) {
      return ColorValues.blackColor;
    }
    // ignore: deprecated_member_use
    return ColorValues.blackColor.withOpacity(0.3);
  }

  Color _getIconColor(bool isSelected, bool isHovered) {
    if (isSelected || isHovered) {
      return ColorValues.colorOrange;
    }
    return ColorValues.colorBorderGray;
  }
}

class LogoApp extends StatelessWidget {
  final String nameApp;
  final String? logoImage;
  const LogoApp({super.key, required this.nameApp, this.logoImage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // const Icon(Icons.dashboard, color: ColorValues.color1890FF),
        if (logoImage != null)
          SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(
              logoImage!,
              fit: BoxFit.cover,
            ),
          ),
        // Image(image: image)
        const SizedBox(width: 8),
        SGText(
          text: nameApp,
          textStyle: AppStyles.appNameTextStyle,
        )
      ],
    );
  }
}
