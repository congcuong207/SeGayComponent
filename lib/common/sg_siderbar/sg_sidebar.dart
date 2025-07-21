import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/sg_colors.dart';

class SGMenuItem {
  final IconData icon;
  final String label;
  final String? id;
  final List<SGSubMenuItem>? subMenuItems;
  final bool hasArrow;
  
  const SGMenuItem({
    required this.icon,
    required this.label,
    this.id,
    this.subMenuItems,
    this.hasArrow = true,
  });
}

class SGSubMenuItem {
  final String label;
  final String? id;
  final IconData? icon;
  
  const SGSubMenuItem({
    required this.label,
    this.id,
    this.icon,
  });
}

class SGSidebar extends StatefulWidget {
  final List<SGMenuItem> menuItems;
  final int selectedMenuIndex;
  final Function(int menuIndex, {int? subMenuIndex}) onMenuSelected;
  final bool initialExpanded;
  final Color primaryColor;
  final Color selectedColor;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  
  const SGSidebar({
    super.key,
    required this.menuItems,
    this.selectedMenuIndex = 0,
    required this.onMenuSelected,
    this.initialExpanded = true,
    this.primaryColor = Colors.orange,
    this.selectedColor = const Color(0xFFF5F5F5),
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    this.width = 240,
  });

  @override
  State<SGSidebar> createState() => _SGSidebarState();
}

class _SGSidebarState extends State<SGSidebar> {
  late int selectedIndex;
  int? expandedMenuIndex;
  int? selectedSubMenuIndex;
  bool isExpanded = true;
  
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedMenuIndex;
    isExpanded = widget.initialExpanded;
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isExpanded ? widget.width : 80,
      color: widget.backgroundColor,
      child: Column(
        children: [
          _buildSidebarHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _buildMenuItems(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSidebarHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: isExpanded ? Alignment.centerLeft : Alignment.center,
      child: isExpanded 
        ? Row(
            children: [
              const SGText(
                text: "Main Menu",
                color: SGAppColors.neutral700,
                size: 16,
                fontWeight: FontWeight.bold,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                    if (!isExpanded) {
                      expandedMenuIndex = null;
                    }
                  });
                },
                icon: const Icon(Icons.menu, color: SGAppColors.neutral700),
              )
            ],
          )
        : IconButton(
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            icon: const Icon(Icons.menu, color: SGAppColors.neutral700),
          ),
    );
  }

  List<Widget> _buildMenuItems() {
    List<Widget> menuWidgets = [];
    
    for (int i = 0; i < widget.menuItems.length; i++) {
      final SGMenuItem item = widget.menuItems[i];
      final bool isSelected = selectedIndex == i && selectedSubMenuIndex == null;
      final bool isExpanded = expandedMenuIndex == i;
      
      // Add main menu item
      menuWidgets.add(
        _buildMenuItem(
          item,
          isSelected,
          i,
          isExpanded,
        ),
      );
      
      // Add submenu items if expanded
      if (isExpanded && item.subMenuItems != null && item.subMenuItems!.isNotEmpty && this.isExpanded) {
        menuWidgets.add(
          Container(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              children: item.subMenuItems!.asMap().entries.map((entry) {
                final int subIndex = entry.key;
                final SGSubMenuItem subItem = entry.value;
                final bool isSubSelected = selectedIndex == i && selectedSubMenuIndex == subIndex;
                
                return _buildSubMenuItem(subItem, isSubSelected, i, subIndex);
              }).toList(),
            ),
          ),
        );
      }
    }
    
    return menuWidgets;
  }

  Widget _buildMenuItem(SGMenuItem item, bool isSelected, int index, bool isExpanded) {
    final hasChildren = item.subMenuItems != null && item.subMenuItems!.isNotEmpty;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? widget.selectedColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            setState(() {
              if (hasChildren) {
                if (expandedMenuIndex == index) {
                  expandedMenuIndex = null;
                } else {
                  expandedMenuIndex = index;
                }
              } else {
                selectedIndex = index;
                selectedSubMenuIndex = null;
                expandedMenuIndex = null;
                widget.onMenuSelected(index);
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: this.isExpanded
                ? Row(
                    children: [
                      Icon(
                        item.icon,
                        color: isSelected ? widget.primaryColor : SGAppColors.neutral700,
                        size: 22,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? widget.primaryColor : widget.textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasChildren && item.hasArrow)
                        Icon(
                          isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                          color: SGAppColors.neutral600,
                          size: 20,
                        ),
                    ],
                  )
                : Tooltip(
                    message: item.label,
                    child: Icon(
                      item.icon,
                      color: isSelected ? widget.primaryColor : SGAppColors.neutral700,
                      size: 24,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubMenuItem(SGSubMenuItem item, bool isSelected, int parentIndex, int subIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? widget.selectedColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            setState(() {
              selectedIndex = parentIndex;
              selectedSubMenuIndex = subIndex;
            });
            widget.onMenuSelected(parentIndex, subMenuIndex: subIndex);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: Row(
              children: [
                const Text(
                  "—",
                  style: TextStyle(
                    color: SGAppColors.neutral600,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? widget.primaryColor : widget.textColor,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 