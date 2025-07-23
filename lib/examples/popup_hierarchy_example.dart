import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_button.dart';
import 'package:se_gay_components/common/sg_popup_menu_hierarchy.dart';

class PopupMenuHierarchyExample extends StatefulWidget {
  const PopupMenuHierarchyExample({super.key});

  @override
  State<PopupMenuHierarchyExample> createState() => _PopupMenuHierarchyExampleState();
}

class _PopupMenuHierarchyExampleState extends State<PopupMenuHierarchyExample> {
  String _selectedItem = 'None';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hierarchical Popup Menu Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selected Item: $_selectedItem',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            SGPopupMenuHierarchy(
              items: _buildMenuItems(),
              child: SizedBox(
                width: 200,
                child: SGButton(
                  text: 'Show Menu',
                  onclick: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<SGPopupMenuItem> _buildMenuItems() {
    return [
      SGPopupMenuItem(
        id: 'a1',
        label: 'a1',
        icon: Icons.folder,
        children: [
          SGPopupMenuItem(
            id: 'a1_1',
            label: 'a1 1',
            icon: Icons.folder_open,
            children: [
              SGPopupMenuItem(
                id: 'a1_1_1',
                label: 'a1 1 1',
                icon: Icons.file_present,
                children: [
                  SGPopupMenuItem(
                    id: 'a1_1_1_1',
                    label: 'a1 1 1 1',
                    icon: Icons.description,
                    onTap: () => _handleMenuItemSelected('a1 1 1 1'),
                  ),
                ],
              ),
              SGPopupMenuItem(
                id: 'a1_1_2',
                label: 'a1 1 2',
                icon: Icons.file_present,
                onTap: () => _handleMenuItemSelected('a1 1 2'),
              ),
              SGPopupMenuItem(
                id: 'a1_1_3',
                label: 'a1 1 3',
                icon: Icons.file_present,
                onTap: () => _handleMenuItemSelected('a1 1 3'),
              ),
            ],
          ),
          SGPopupMenuItem(
            id: 'a1_2',
            label: 'a1 2',
            icon: Icons.folder_open,
            onTap: () => _handleMenuItemSelected('a1 2'),
          ),
          SGPopupMenuItem(
            id: 'a1_3',
            label: 'a1 3',
            icon: Icons.folder_open,
            onTap: () => _handleMenuItemSelected('a1 3'),
          ),
        ],
      ),
      SGPopupMenuItem(
        id: 'a2',
        label: 'a2',
        icon: Icons.folder,
        onTap: () => _handleMenuItemSelected('a2'),
      ),
      SGPopupMenuItem(
        id: 'a3',
        label: 'a3',
        icon: Icons.folder,
        onTap: () => _handleMenuItemSelected('a3'),
      ),
      SGPopupMenuItem(
        id: 'a4',
        label: 'a4',
        icon: Icons.folder,
        onTap: () => _handleMenuItemSelected('a4'),
      ),
    ];
  }

  void _handleMenuItemSelected(String item) {
    setState(() {
      _selectedItem = item;
    });
  }
} 