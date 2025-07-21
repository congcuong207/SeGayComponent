import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_header/sg_header.dart';

class SGHeaderExample extends StatelessWidget {
  const SGHeaderExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SGHeader(
            title: "Dreams POS",
            userAvatarUrl: "", // Add a URL for avatar image
            notificationCount: 3,
            selectedBusiness: "Freshmart",
            onMenuPressed: () {
              // Handle menu button press
              debugPrint("Menu button pressed");
            },
            onAddNewPressed: () {
              // Handle add new button press
              debugPrint("Add new button pressed");
            },
            onPOSPressed: () {
              // Handle POS button press
              debugPrint("POS button pressed");
            },
            onSearchSubmitted: (query) {
              // Handle search submission
              debugPrint("Search query: $query");
            },
          ),
          const Expanded(
            child: Center(
              child: Text("Main Content Area"),
            ),
          ),
        ],
      ),
    );
  }
} 