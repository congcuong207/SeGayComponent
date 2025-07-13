import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_text.dart';

class MenuItem {
  final IconData icon;
  final String label;
  final String? idMenu;
  final List<MenuItem>? children; // submenu
  const MenuItem({
    required this.icon,
    required this.label,
    this.idMenu,
    this.children,
  });
}

class SGSidebar extends StatefulWidget {
  final List<MenuItem> menuItems;
  final int selectedIndex;
  final Function(int, [int? subIndex]) onItemSelected;
  final nameWeb;
  const SGSidebar({
    Key? key,
    required this.menuItems,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.nameWeb,
  }) : super(key: key);

  @override
  State<SGSidebar> createState() => _SGSidebarState();
}

class _SGSidebarState extends State<SGSidebar> {
  int? expandedIndex; // Lưu index menu đang mở submenu
  int? selectedSubIndex;
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCollapsed ? 64 : 240,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(2, 0), // Đổ bóng sang phải
          ),
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: isCollapsed
                ? Center(
                    child: IconButton(
                      icon: Icon(Icons.menu, color: Colors.grey[700], size: 32),
                      onPressed: () {
                        setState(() {
                          isCollapsed = !isCollapsed;
                          if (isCollapsed) expandedIndex = null;
                        });
                      },
                    ),
                  )
                : Row(
                    children: [
                      const SizedBox(width: 8),
                      SGText(
                        text: widget.nameWeb,
                        color: Colors.cyan,
                        fontWeight: FontWeight.bold,
                        size: 22,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.menu,
                            size: 28, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            isCollapsed = !isCollapsed;
                            if (isCollapsed) expandedIndex = null;
                          });
                        },
                      ),
                    ],
                  ),
          ),
          // Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                for (int i = 0; i < widget.menuItems.length; i++)
                  _buildMenuItem(i, widget.menuItems[i]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index, MenuItem item) {
    final isActive = index == widget.selectedIndex && selectedSubIndex == null;
    final hasChildren = item.children != null && item.children!.isNotEmpty;
    final isExpanded = expandedIndex == index;

    return Column(
      children: [
        Material(
          color:
              isActive && !isCollapsed ? Colors.cyan[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              if (hasChildren) {
                setState(() {
                  expandedIndex = isExpanded ? null : index;
                });
              } else {
                setState(() {
                  expandedIndex = null;
                  selectedSubIndex = null;
                });
                widget.onItemSelected(index);
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isCollapsed ? 0 : 12,
                  vertical: isCollapsed ? 0 : 10),
              child: isCollapsed
                  ? Tooltip(
                      message: item.label,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: isActive
                            ? BoxDecoration(
                                color: Colors.cyan[50],
                                borderRadius: BorderRadius.circular(12),
                              )
                            : null,
                        width: 40,
                        height: 40,
                        child: Icon(
                          item.icon,
                          color: isActive ? Colors.orange : Colors.grey[600],
                          size: 24,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          item.icon,
                          color: isActive ? Colors.orange : Colors.grey[600],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            item.label,
                            style: TextStyle(
                              color: isActive
                                  ? Colors.cyan[700]
                                  : Colors.grey[700],
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (hasChildren)
                          Icon(
                            isExpanded
                                ? Icons.subdirectory_arrow_left
                                : Icons.subdirectory_arrow_right,
                            color: isActive ? Colors.orange : Colors.grey[400],
                            size: 20,
                          ),
                      ],
                    ),
            ),
          ),
        ),
        // Submenu
        if (hasChildren && isExpanded && !isCollapsed)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              children: [
                for (int j = 0; j < item.children!.length; j++)
                  _buildSubMenuItem(index, j, item.children![j]),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSubMenuItem(int parentIndex, int subIndex, MenuItem subItem) {
    final isActive =
        parentIndex == widget.selectedIndex && selectedSubIndex == subIndex;
    return Material(
      color: isActive ? Colors.cyan[100] : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          setState(() {
            selectedSubIndex = subIndex;
          });
          widget.onItemSelected(parentIndex, subIndex);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              // Dấu gạch ngang đầu dòng
              const Text(
                "—",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subItem.label,
                  style: TextStyle(
                    color: isActive ? Colors.cyan[700] : Colors.grey[700],
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
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
