import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';

class MainWrapper extends StatefulWidget {
  final Widget? body;
  final Widget? header;
  final Widget? sidebar;
  final Color backgroundColor;

  const MainWrapper({
    super.key,
    this.body,
    this.header,
    this.sidebar,
    this.backgroundColor = SGAppColors.neutral0,
  });

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Column(
        children: [
          widget.header ?? const SizedBox(),
          widget.sidebar ?? const SizedBox(),
          Expanded(
            child: widget.body ?? const SizedBox(),
          ),
        ],
      ),
    );
  }
}
