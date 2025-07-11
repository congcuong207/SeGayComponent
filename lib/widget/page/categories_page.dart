import 'package:flutter/material.dart';
import 'package:se_gay_components/utils/constants/colors.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorValues.primaryColor,
      body: Column(
        children: [
          Text("Categories"),
        ],
      ),
    );
  }
}