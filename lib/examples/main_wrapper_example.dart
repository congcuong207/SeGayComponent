import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:se_gay_components/main_wrapper/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:se_gay_components/constants/sg_app_svgs.dart';

class MainWrapperExample extends StatefulWidget {
  final Widget child;
  
  const MainWrapperExample({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<MainWrapperExample> createState() => _MainWrapperExampleState();
}

class _MainWrapperExampleState extends State<MainWrapperExample> {
  @override
  Widget build(BuildContext context) {
    final String currentPath = GoRouterState.of(context).uri.path;

    // Xác định menu hiện tại đang được chọn từ path
    final selectedMainMenuItem = _getSelectedMainMenuItem(currentPath);
    final selectedSubMenu = _getSelectedSubMenu(currentPath);

    return MainWrapper(
      headerHeight: 60,
      sidebarWidth: 200,
      bgHeader: Colors.white,
      bgSidebar: const Color(0xFF232D3F),
      bgContent: const Color.fromARGB(255, 241, 245, 249),
      showSubItems: selectedMainMenuItem.subItems.isNotEmpty,
      elevation: 1,
      headerItems: _buildHeaderItems(),
      sidebarItems: _buildSidebarItems(context, selectedMainMenuItem.id),
      subItems: selectedMainMenuItem.subItems,
      selectedItemId: selectedMainMenuItem.id,
      selectedSubItemId: selectedSubMenu,
      onSelectedMainItem: (id) {
        // Chỉ cần điều hướng đến trang đầu tiên của menu chính nếu được chọn
        final mainMenuItem = _getMenuItemById(id);
        if (mainMenuItem != null) {
          if (mainMenuItem.subItems.isEmpty) {
            context.go(mainMenuItem.route);
          } else {
            context.go(mainMenuItem.subItems.first.route);
          }
        }
      },
      onSelectedSubItem: (id) {
        // Tìm route tương ứng và điều hướng
        final route = _findRouteBySubItemId(id);
        if (route.isNotEmpty) {
          context.go(route);
        }
      },
      child: widget.child,
    );
  }

  String _getSelectedMainMenuItem(String currentPath) {
    // Check sub-paths first
    for (var item in _mainMenuItems) {
      for (var subItem in item.subItems) {
        if (currentPath == subItem.route) {
          return item;
        }
      }
    }

    // Then check main paths
    for (var item in _mainMenuItems) {
      if (currentPath == item.route || currentPath.startsWith('${item.route}/')) {
        return item.id;
      }
    }

    // Default to first item
    return _mainMenuItems.first.id;
  }

  String _getSelectedSubMenu(String currentPath) {
    // Tìm sub menu tương ứng với path hiện tại
    for (var item in _mainMenuItems) {
      for (var subItem in item.subItems) {
        if (currentPath == subItem.route) {
          return subItem.id;
        }
      }
    }

    return '';
  }

  _MenuItem? _getMenuItemById(String id) {
    for (var item in _mainMenuItems) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  String _findRouteBySubItemId(String id) {
    for (var item in _mainMenuItems) {
      for (var subItem in item.subItems) {
        if (subItem.id == id) {
          return subItem.route;
        }
      }
    }
    return '';
  }

  List<Widget> _buildHeaderItems() {
    return [
      IconButton(
        onPressed: () {
          // Điều hướng đến trang thông báo
        },
        icon: SvgPicture.asset(
          SGAppSvgs.iconBell,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        ),
        splashRadius: 20,
      ),
      IconButton(
        onPressed: () {
          // Điều hướng đến trang chat
        },
        icon: SvgPicture.asset(
          SGAppSvgs.iconChat,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        ),
        splashRadius: 20,
      ),
      IconButton(
        onPressed: () {
          // Điều hướng đến trang cài đặt
          context.go('/settings');
        },
        icon: SvgPicture.asset(
          SGAppSvgs.iconSetting,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        ),
        splashRadius: 20,
      ),
      const SizedBox(width: 10),
      const CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(
            'https://ui-avatars.com/api/?name=John+Doe&background=0D8ABC&color=fff'),
      ),
      const SizedBox(width: 10),
    ];
  }

  List<SGSideBarHorizontalItem> _buildSidebarItems(BuildContext context, String selectedId) {
    return _mainMenuItems.map((item) {
      return SGSideBarHorizontalItem(
        id: item.id,
        title: item.title,
        icon: item.icon,
        iconActive: item.iconActive,
        activeColor: Colors.white,
        inactiveColor: Colors.grey.shade400,
      );
    }).toList();
  }
}

// Model cho menu item
class _MenuItem {
  final String id;
  final String title;
  final String icon;
  final String iconActive;
  final String route;
  final List<_SubMenuItem> subItems;

  _MenuItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.iconActive,
    required this.route,
    this.subItems = const [],
  });
}

// Model cho sub menu item
class _SubMenuItem {
  final String id;
  final String title;
  final String route;

  _SubMenuItem({
    required this.id,
    required this.title,
    required this.route,
  });
}

// Danh sách menu
final List<_MenuItem> _mainMenuItems = [
  _MenuItem(
    id: 'dashboard',
    title: 'Dashboard',
    icon: SGAppSvgs.logo,
    iconActive: SGAppSvgs.logo,
    route: '/dashboard',
    subItems: [
      _SubMenuItem(
        id: 'daily',
        title: 'Báo cáo ngày',
        route: '/dashboard/daily',
      ),
      _SubMenuItem(
        id: 'weekly',
        title: 'Báo cáo tuần',
        route: '/dashboard/weekly',
      ),
      _SubMenuItem(
        id: 'monthly',
        title: 'Báo cáo tháng',
        route: '/dashboard/monthly',
      ),
    ],
  ),
  _MenuItem(
    id: 'products',
    title: 'Sản phẩm',
    icon: SGAppSvgs.iconSliders,
    iconActive: SGAppSvgs.iconSliders,
    route: '/products',
    subItems: [
      _SubMenuItem(
        id: 'product_list',
        title: 'Danh sách sản phẩm',
        route: '/products/list',
      ),
      _SubMenuItem(
        id: 'add_product',
        title: 'Thêm sản phẩm',
        route: '/products/add',
      ),
    ],
  ),
  _MenuItem(
    id: 'customers',
    title: 'Khách hàng',
    icon: SGAppSvgs.iconSliders,
    iconActive: SGAppSvgs.iconSliders,
    route: '/customers',
    subItems: [
      _SubMenuItem(
        id: 'customer_list',
        title: 'Danh sách khách hàng',
        route: '/customers/list',
      ),
      _SubMenuItem(
        id: 'customer_group',
        title: 'Nhóm khách hàng',
        route: '/customers/groups',
      ),
    ],
  ),
  _MenuItem(
    id: 'reports',
    title: 'Báo cáo',
    icon: SGAppSvgs.iconSliders,
    iconActive: SGAppSvgs.iconSliders,
    route: '/reports',
  ),
  _MenuItem(
    id: 'settings',
    title: 'Cài đặt',
    icon: SGAppSvgs.iconSliders,
    iconActive: SGAppSvgs.iconSliders,
    route: '/settings',
  ),
];
