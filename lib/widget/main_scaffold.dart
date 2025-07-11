import 'package:flutter/material.dart';
import 'package:se_gay_components/base/model/nav_menu_item.dart';
import 'package:se_gay_components/base/navBar/component/sidebar_overlay.dart';
import 'package:se_gay_components/base/navBar/sidebar.dart';
import 'package:se_gay_components/utils/constants/colors.dart';
import 'package:se_gay_components/widget/page/categories_page.dart';
import 'package:se_gay_components/widget/page/dashboard_page.dart';
import 'package:se_gay_components/widget/page/products_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int selectedIndex = 0;
  bool isCollapsed = false;
  bool isSizeMin = false;
  bool showSidebarOverlay = false;

  final List<NavMenuItem> menuItems = [
    NavMenuItem(
        title: "Dashboards",
        icon: Icons.dashboard,
        page: const DashboardPage()),
    NavMenuItem(
        title: "Products",
        icon: Icons.shopping_cart,
        page: const ProductsPage()),
    NavMenuItem(
        title: "Categories",
        icon: Icons.category,
        page: const CategoriesPage()),
    // ... add more items
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    isSizeMin = size.width < 900;
    if (isSizeMin && isCollapsed) {
      isCollapsed = false;
    }

    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              if (!isSizeMin)
                Sidebar(
                  items: menuItems,
                  selectedIndex: selectedIndex,
                  onItemSelected: _onSidebarItemSelected,
                  isCollapsed: isCollapsed,
                  onMenuPressed: _toggleSidebarCollapse,
                ),
              Expanded(
                child: Container(
                  color: ColorValues.grayColor,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildAppBar(size),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: menuItems[selectedIndex].page,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isSizeMin)
            SidebarOverlay(
              show: showSidebarOverlay,
              onClose: () => setState(() => showSidebarOverlay = false),
              sidebar: Sidebar(
                items: menuItems,
                selectedIndex: selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                    showSidebarOverlay = false;
                  });
                },
                isCollapsed: false,
                onMenuPressed: () => setState(() => showSidebarOverlay = false),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar(Size size) {
    if (!isSizeMin) return Container(color: ColorValues.whiteColor, height: 70);
    return Container(
      color: ColorValues.whiteColor,
      height: 70,
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: const Icon(Icons.menu, size: 24),
          onPressed: () => setState(() => showSidebarOverlay = true),
        ),
      ),
    );
  }

  void _onSidebarItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _toggleSidebarCollapse() {
    setState(() {
      isCollapsed = !isCollapsed;
    });
  }
}
