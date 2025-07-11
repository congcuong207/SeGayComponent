import 'package:flutter/material.dart';
import 'package:se_gay_components/utils/constants/colors.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorValues.color1890FF,
      body: Column(
        children: [
          Text("Product"),
        ],
      ),
    );
  }
}