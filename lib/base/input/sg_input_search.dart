import 'package:flutter/material.dart';
import 'package:se_gay_components/base/sg_text.dart';
import 'package:se_gay_components/utils/constants/colors.dart';
import 'package:se_gay_components/utils/constants/styles.dart';

class SGInputSearch extends StatelessWidget {
  final TextEditingController controller;
  final String? title;
  final String? iconUrl;
  final IconData? icon;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final double? width;
  final double? height;

  const SGInputSearch({
    super.key,
    required this.controller,
    this.title,
    this.iconUrl,
    this.icon,
    this.hintText = "Search...",
    this.onChanged,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          title != null
              ? SGText(text: "${title!}:" , textStyle: AppStyles.defaultTextStyleBold)
              : const SizedBox(),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                prefixIcon: icon != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 24, right: 8), // chỉnh right để tăng khoảng cách
                        // ignore: deprecated_member_use
                        child: Icon(icon, size: 24,color: ColorValues.grayColor,),
                      )
                    : iconUrl != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            child: iconUrl!.startsWith('http')
                                ? Image.network(iconUrl!, width: 24, height: 24)
                                : Image.asset(iconUrl!, width: 24, height: 24),
                          )
                        : null,
                hintText: hintText,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: AppStyles.defaultTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
