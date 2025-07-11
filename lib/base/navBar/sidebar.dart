import 'package:flutter/material.dart';
import 'package:se_gay_components/base/model/nav_menu_item.dart';
import 'package:se_gay_components/utils/constants/colors.dart';

class Sidebar extends StatefulWidget {
  final List<NavMenuItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool isCollapsed;
  final VoidCallback onMenuPressed;

  const Sidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.isCollapsed,
    required this.onMenuPressed,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int? hoveredIndex;

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
        const LogoApp(),
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
    return List.generate(widget.items.length, (index) {
      final isSelected = widget.selectedIndex == index;
      final isHovered = hoveredIndex == index;
      final color = _getTextColor(isSelected, isHovered);
      final colorIcon = _getIconColor(isSelected, isHovered);
      
      return _buildMenuItem(index, isSelected, isHovered, color, colorIcon);
    });
  }

  Widget _buildMenuItem(int index, bool isSelected, bool isHovered, Color color, Color colorIcon) {
    return MouseRegion(
      onEnter: (_) => setState(() => hoveredIndex = index),
      onExit: (_) => setState(() => hoveredIndex = null),
      child: GestureDetector(
        onTap: () => widget.onItemSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: isSelected
              ? Colors.blue.withOpacity(0.08)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(widget.items[index].icon, color: colorIcon, size: 24),
              const SizedBox(width: 12),
              Visibility(
                visible: !widget.isCollapsed,
                child: Expanded(
                  child: AnimatedOpacity(
                    opacity: widget.isCollapsed ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      widget.items[index].title,
                      style: TextStyle(
                        color: color,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
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

  Color _getTextColor(bool isSelected, bool isHovered) {
    if (isSelected || isHovered) {
      return ColorValues.blackColor;
    }
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
  const LogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.dashboard, color: ColorValues.color1890FF),
        SizedBox(width: 8),
        Text(
          "POSDash",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: ColorValues.color1890FF,
          ),
        ),
      ],
    );
  }
}
