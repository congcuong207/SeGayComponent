import 'package:flutter/material.dart';
import 'package:se_gay_components/base/input/sg_input_search.dart';
import 'package:se_gay_components/utils/constants/colors.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
      backgroundColor: ColorValues.whiteColor,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SGInputSearch(
                controller: _controller,
                icon: Icons.search,
                hintText: "Search here...",
                width: 300,
                height: 40,
                onChanged: (value) {
                  // Xử lý tìm kiếm
                },
              ),
              const SizedBox(height: 10),
              SGInputSearch(
                controller: _controller,
                title: "Search",
                hintText: "Search",
                width: 300,
                height: 40,
                onChanged: (value) {
                  // Xử lý tìm kiếm
                },
              ),
            ]),
      ),
    );
  }
}
