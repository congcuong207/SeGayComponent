import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:se_gay_components/utils/constants/colors.dart';

class SGDropdownButton<T> extends StatelessWidget {
  final String? label;
  final double? width;
  final double? height;
  final Color? colorBoder;
  final Color? colorBoderMenuItem;
  final Color? colorSelectedText;
  final double? sizeBoder;
  final double? sizeBoderMenuItem;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hintText;
  final bool showSearch;

  const SGDropdownButton({
    super.key,
    this.label,
    this.width,
    this.height,
    this.colorBoder,
    this.colorBoderMenuItem,
    this.colorSelectedText,
    this.sizeBoder,
    this.sizeBoderMenuItem,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.showSearch = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      buttonStyleData: ButtonStyleData(
        height: height,
        width: width, // nếu muốn set cả width
      ),
      decoration: InputDecoration(
        // labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: colorBoder ?? ColorValues.colorBorderGray,
              width: sizeBoder ?? 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      isExpanded: true,
      value: value,
      hint: hintText != null ? Text(hintText!) : null,
      items: items,
      onChanged: onChanged,
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: colorBoderMenuItem ?? ColorValues.colorBorderGray,
              width: sizeBoderMenuItem ?? sizeBoder ?? 1),
        ),
        offset: const Offset(0, -2),
      ),
      menuItemStyleData: MenuItemStyleData(
        selectedMenuItemBuilder: (context, child) {
          return DefaultTextStyle.merge(
            style: TextStyle(color: colorSelectedText ?? Colors.blue),
            child: child,
          );
        },
      ),
      dropdownSearchData: showSearch
          ? DropdownSearchData(
              searchController: TextEditingController(),
              searchInnerWidget: const Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              searchInnerWidgetHeight: 50,
              searchMatchFn: (item, searchValue) {
                return item.value
                    .toString()
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            )
          : null,
    );
  }
}
