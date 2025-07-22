import 'package:flutter/material.dart';
import 'package:se_gay_components/main_wrapper/main_wrapper.dart';
import 'package:se_gay_components/main_wrapper/sg_header.dart';
import 'package:se_gay_components/main_wrapper/sg_sidebar_horizontal.dart';

class MainWrapperExample extends StatefulWidget {
  const MainWrapperExample({super.key});

  @override
  State<MainWrapperExample> createState() => _MainWrapperExampleState();
}

class _MainWrapperExampleState extends State<MainWrapperExample> {
  int _selectedIndex = 0;
  int _selectedSubIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MainWrapper(
      header: const SGHeader(),
      sidebar: SGSidebarHorizontal(
        items: [
          SGSidebarHorizontalItem(
            label: 'Tổng quan',
            icon: Icons.dashboard,
            isActive: _selectedIndex == 0,
            onTap: () => setState(() {
              _selectedIndex = 0;
              _selectedSubIndex = 0;
            }),
            subItems: [
              SGSidebarSubItem(
                label: 'Báo cáo ngày',
                icon: Icons.calendar_today,
                isActive: _selectedIndex == 0 && _selectedSubIndex == 0,
                onTap: () => setState(() {
                  _selectedIndex = 0;
                  _selectedSubIndex = 0;
                }),
              ),
              SGSidebarSubItem(
                label: 'Báo cáo tuần',
                icon: Icons.date_range,
                isActive: _selectedIndex == 0 && _selectedSubIndex == 1,
                onTap: () => setState(() {
                  _selectedIndex = 0;
                  _selectedSubIndex = 1;
                }),
              ),
              SGSidebarSubItem(
                label: 'Báo cáo tháng',
                icon: Icons.event_note,
                isActive: _selectedIndex == 0 && _selectedSubIndex == 2,
                onTap: () => setState(() {
                  _selectedIndex = 0;
                  _selectedSubIndex = 2;
                }),
              ),
            ],
          ),
          SGSidebarHorizontalItem(
            label: 'Sản phẩm',
            icon: Icons.shopping_bag,
            isActive: _selectedIndex == 1,
            onTap: () => setState(() {
              _selectedIndex = 1;
              _selectedSubIndex = 0;
            }),
            subItems: [
              SGSidebarSubItem(
                label: 'Danh sách sản phẩm',
                icon: Icons.list,
                isActive: _selectedIndex == 1 && _selectedSubIndex == 0,
                onTap: () => setState(() {
                  _selectedIndex = 1;
                  _selectedSubIndex = 0;
                }),
              ),
              SGSidebarSubItem(
                label: 'Thêm sản phẩm',
                icon: Icons.add_circle_outline,
                isActive: _selectedIndex == 1 && _selectedSubIndex == 1,
                onTap: () => setState(() {
                  _selectedIndex = 1;
                  _selectedSubIndex = 1;
                }),
              ),
            ],
          ),
          SGSidebarHorizontalItem(
            label: 'Khách hàng',
            icon: Icons.people,
            isActive: _selectedIndex == 2,
            onTap: () => setState(() {
              _selectedIndex = 2;
              _selectedSubIndex = 0;
            }),
            subItems: [
              SGSidebarSubItem(
                label: 'Danh sách khách hàng',
                icon: Icons.people_outline,
                isActive: _selectedIndex == 2 && _selectedSubIndex == 0,
                onTap: () => setState(() {
                  _selectedIndex = 2;
                  _selectedSubIndex = 0;
                }),
              ),
              SGSidebarSubItem(
                label: 'Nhóm khách hàng',
                icon: Icons.group_work,
                isActive: _selectedIndex == 2 && _selectedSubIndex == 1,
                onTap: () => setState(() {
                  _selectedIndex = 2;
                  _selectedSubIndex = 1;
                }),
              ),
            ],
          ),
          SGSidebarHorizontalItem(
            label: 'Báo cáo',
            icon: Icons.bar_chart,
            isActive: _selectedIndex == 3,
            onTap: () => setState(() => _selectedIndex = 3),
          ),
          SGSidebarHorizontalItem(
            label: 'Cài đặt',
            icon: Icons.settings,
            isActive: _selectedIndex == 4,
            onTap: () => setState(() => _selectedIndex = 4),
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_selectedIndex == 0) {
      switch (_selectedSubIndex) {
        case 0:
          return const Center(child: Text('Báo cáo ngày', style: TextStyle(fontSize: 24)));
        case 1:
          return const Center(child: Text('Báo cáo tuần', style: TextStyle(fontSize: 24)));
        case 2:
          return const Center(child: Text('Báo cáo tháng', style: TextStyle(fontSize: 24)));
        default:
          return const Center(child: Text('Trang tổng quan', style: TextStyle(fontSize: 24)));
      }
    } else if (_selectedIndex == 1) {
      switch (_selectedSubIndex) {
        case 0:
          return const Center(child: Text('Danh sách sản phẩm', style: TextStyle(fontSize: 24)));
        case 1:
          return const Center(child: Text('Thêm sản phẩm', style: TextStyle(fontSize: 24)));
        default:
          return const Center(child: Text('Trang sản phẩm', style: TextStyle(fontSize: 24)));
      }
    } else if (_selectedIndex == 2) {
      switch (_selectedSubIndex) {
        case 0:
          return const Center(child: Text('Danh sách khách hàng', style: TextStyle(fontSize: 24)));
        case 1:
          return const Center(child: Text('Nhóm khách hàng', style: TextStyle(fontSize: 24)));
        default:
          return const Center(child: Text('Trang khách hàng', style: TextStyle(fontSize: 24)));
      }
    } else if (_selectedIndex == 3) {
      return const Center(child: Text('Trang báo cáo', style: TextStyle(fontSize: 24)));
    } else if (_selectedIndex == 4) {
      return const Center(child: Text('Trang cài đặt', style: TextStyle(fontSize: 24)));
    }

    return const Center(child: Text('Trang không tồn tại', style: TextStyle(fontSize: 24)));
  }
}
