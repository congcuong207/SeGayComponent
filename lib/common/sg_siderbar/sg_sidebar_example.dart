import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_siderbar/sg_sidebar.dart';

class SGSidebarExample extends StatefulWidget {
  const SGSidebarExample({super.key});

  @override
  State<SGSidebarExample> createState() => _SGSidebarExampleState();
}

class _SGSidebarExampleState extends State<SGSidebarExample> {
  int _selectedMenuIndex = 0;
  int? _selectedSubMenuIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SGSidebar(
            menuItems: _getMenuItems(),
            selectedMenuIndex: _selectedMenuIndex,
            onMenuSelected: (menuIndex, {subMenuIndex}) {
              setState(() {
                _selectedMenuIndex = menuIndex;
                _selectedSubMenuIndex = subMenuIndex;
              });

              // Handle menu selection
              debugPrint("Selected menu: $menuIndex, submenu: $subMenuIndex");
            },
          ),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: Center(
                child: Text(
                  "Selected: ${_getSelectedMenuName()}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSelectedMenuName() {
    final item = _getMenuItems()[_selectedMenuIndex];
    if (_selectedSubMenuIndex != null && item.subMenuItems != null && _selectedSubMenuIndex! < item.subMenuItems!.length) {
      return "${item.label} > ${item.subMenuItems![_selectedSubMenuIndex!].label}";
    }
    return item.label;
  }

  List<SGMenuItem> _getMenuItems() {
    return [
      const SGMenuItem(
        icon: Icons.menu,
        label: "Main Menu",
      ),
      const SGMenuItem(
        icon: Icons.inventory_2_outlined,
        label: "Inventory",
        subMenuItems: [
          SGSubMenuItem(label: "Stock"),
          SGSubMenuItem(label: "Products"),
          SGSubMenuItem(label: "Categories"),
        ],
      ),
      const SGMenuItem(
        icon: Icons.shopping_cart_outlined,
        label: "Sales & Purchase",
        subMenuItems: [
          SGSubMenuItem(label: "Sales"),
          SGSubMenuItem(label: "Invoices"),
          SGSubMenuItem(label: "Sales Return"),
          SGSubMenuItem(label: "Quotation"),
          SGSubMenuItem(label: "POS"),
        ],
      ),
      const SGMenuItem(
        icon: Icons.dashboard_outlined,
        label: "UI Interface",
      ),
      const SGMenuItem(
        icon: Icons.pages_outlined,
        label: "Pages",
      ),
      const SGMenuItem(
        icon: Icons.bar_chart_outlined,
        label: "Reports",
      ),
      const SGMenuItem(
        icon: Icons.settings_outlined,
        label: "Settings",
      ),
      const SGMenuItem(
        icon: Icons.more_horiz,
        label: "More",
      ),
    ];
  }
}