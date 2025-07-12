import 'package:flutter/material.dart';
import 'package:se_gay_components/base/button/sg_dropdown_button.dart';
import 'package:se_gay_components/base/input/sg_input_search.dart';
import 'package:se_gay_components/utils/constants/colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    String? _selectedProductType;

    final List<String> _productTypes = [
      'Standard',
      'Combo',
      'Digital',
      'Service',
    ];
    return Scaffold(
      backgroundColor: ColorValues.whiteColor,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SGDropdownButton<String>(
                showSearch: false,
                label: 'Product Type *',
                value: _selectedProductType,
                hintText: 'Select Product Type',
                items: _productTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProductType = value;
                  });
                },
              ),
              const SizedBox(),
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
