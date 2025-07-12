import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/web_base/sg_sidebar/sg_sidebar.dart';

class SGWebBase extends StatelessWidget {
  List<MenuItem> menuItems;
  int selectedIndex = 0;
  int? selectedSubIndex;
  ImageProvider? backgroundImage;
  Widget? body;
  String name;
  final Function(int, [int? subIndex]) onItemSelected;

  SGWebBase(
      {super.key,
      required this.menuItems,
      required this.selectedIndex,
      required this.name,
      this.selectedSubIndex,
      required this.onItemSelected,
      this.backgroundImage,
      this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SGAppColors.neutral0,
      body: Row(
        children: [
          SGSidebar(
            nameWeb: name,
            menuItems: menuItems,
            selectedIndex: selectedIndex,
            onItemSelected: (index, [subIndex]) {
              onItemSelected(index, subIndex);
            },
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              children: [SGHeader(), Expanded(child: body ?? const SizedBox())],
            ),
          ),
        ],
      ),
    );
  }
  Widget SGHeader(){
    return Container(
      height: 64,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const Spacer(),
          // Language button
          const SizedBox(width: 12),
          // Mail icon
          IconButton(
            icon: Icon(Icons.mail_outline, color: Colors.grey[600]),
            onPressed: () {},
          ),
          // Notification icon
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.grey[600]),
            onPressed: () {},
          ),
          // Avatar
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.orange[100],
            backgroundImage: backgroundImage,
            child: Icon(Icons.person, color: Colors.deepOrange, size: 32),
          ),
        ],
      ),
    );
  }
}


