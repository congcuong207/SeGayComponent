import 'package:flutter/material.dart';

class NavMenuItem {
  final String title;
  final IconData icon;
  final Widget? page;
  final List<NavMenuItem>? children;

  NavMenuItem({
    required this.title,
    required this.icon,
    this.page,
    this.children,
  });
}