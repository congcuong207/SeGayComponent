import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:se_gay_components/main_wrapper/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:se_gay_components/constants/sg_app_svgs.dart';

class MainWrapperExample extends StatefulWidget {
  final Widget child;
  
  const MainWrapperExample({
    super.key,
    required this.child,
  });

  @override
  State<MainWrapperExample> createState() => _MainWrapperExampleState();
}

class _MainWrapperExampleState extends State<MainWrapperExample> {
  @override
  Widget build(BuildContext context) {
    final String currentPath = GoRouterState.of(context).uri.path;

    // 获取当前选中的主菜单和子菜单
    final _MenuItem selectedMainMenuItem = _getSelectedMainMenuItem(currentPath);
    final String selectedSubMenu = _getSelectedSubMenu(currentPath);

    return MainWrapper(
      backgroundColor: const Color.fromARGB(255, 241, 245, 249),
      header: _buildHeader(),
      sidebar: _buildSidebar(context, selectedMainMenuItem.id),
      body: widget.child,
    );
  }

  _MenuItem _getSelectedMainMenuItem(String currentPath) {
    // 先检查子路径
    for (var item in _mainMenuItems) {
      for (var subItem in item.subItems) {
        if (currentPath == subItem.route) {
          return item;
        }
      }
    }

    // 再检查主路径
    for (var item in _mainMenuItems) {
      if (currentPath == item.route || currentPath.startsWith('${item.route}/')) {
        return item;
      }
    }

    // 默认返回第一个菜单项
    return _mainMenuItems.first;
  }

  String _getSelectedSubMenu(String currentPath) {
    // 查找对应于当前路径的子菜单
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

  Widget _buildHeader() {
    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('SG Components', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // 跳转到通知页面
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
                  // 跳转到聊天页面
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
                  // 跳转到设置页面
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, String selectedId) {
    return Container(
      width: 200,
      color: const Color(0xFF232D3F),
      child: ListView(
        shrinkWrap: true,
        children: _mainMenuItems.map((item) {
          final bool isSelected = item.id == selectedId;
          return ListTile(
            leading: SvgPicture.asset(
              item.icon,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : Colors.grey.shade400, 
                BlendMode.srcIn
              ),
            ),
            title: Text(
              item.title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade400,
              ),
            ),
            selected: isSelected,
            onTap: () {
              // 跳转到该菜单的首页或第一个子菜单
              if (item.subItems.isEmpty) {
                context.go(item.route);
              } else {
                context.go(item.subItems.first.route);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}

// 菜单项模型
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

// 子菜单项模型
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

// 菜单列表
final List<_MenuItem> _mainMenuItems = [
  _MenuItem(
    id: 'dashboard',
    title: 'Dashboard',
    icon: SGAppSvgs.iconLogo,
    iconActive: SGAppSvgs.iconLogo,
    route: '/dashboard',
    subItems: [
      _SubMenuItem(
        id: 'daily',
        title: '报告日报',
        route: '/dashboard/daily',
      ),
      _SubMenuItem(
        id: 'weekly',
        title: '报告周报',
        route: '/dashboard/weekly',
      ),
      _SubMenuItem(
        id: 'monthly',
        title: '报告月报',
        route: '/dashboard/monthly',
      ),
    ],
  ),
  _MenuItem(
    id: 'products',
    title: '产品',
    icon: SGAppSvgs.iconSliders,
    iconActive: SGAppSvgs.iconSliders,
    route: '/products',
    subItems: [
      _SubMenuItem(
        id: 'product_list',
        title: '产品列表',
        route: '/products/list',
      ),
      _SubMenuItem(
        id: 'add_product',
        title: '添加产品',
        route: '/products/add',
      ),
    ],
  ),
  _MenuItem(
    id: 'customers',
    title: '客户',
    icon: SGAppSvgs.iconSliders,
    iconActive: SGAppSvgs.iconSliders,
    route: '/customers',
    subItems: [
      _SubMenuItem(
        id: 'customer_list',
        title: '客户列表',
        route: '/customers/list',
      ),
      _SubMenuItem(
        id: 'customer_group',
        title: '客户群组',
        route: '/customers/groups',
      ),
    ],
  ),
  _MenuItem(
    id: 'reports',
    title: '报告',
    icon: SGAppSvgs.iconSliders,
    iconActive: SGAppSvgs.iconSliders,
    route: '/reports',
  ),
  _MenuItem(
    id: 'settings',
    title: '设置',
    icon: SGAppSvgs.iconSliders,
    iconActive: SGAppSvgs.iconSliders,
    route: '/settings',
  ),
];
