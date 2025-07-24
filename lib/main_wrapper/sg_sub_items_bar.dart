import 'package:flutter/material.dart';
import 'package:se_gay_components/main_wrapper/sg_sidebar_horizontal.dart';

class SGSubItemsBar extends StatelessWidget {
  final List<SGSidebarSubItem>? subItems;
  
  const SGSubItemsBar({
    super.key,
    this.subItems,
  });

  @override
  Widget build(BuildContext context) {
    if (subItems == null || subItems!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 24),
            ...subItems!.map((subItem) => _buildSubItem(subItem)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubItem(SGSidebarSubItem subItem) {
    return InkWell(
      onTap: subItem.onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (subItem.icon != null) ...[
                Icon(
                  subItem.icon,
                  color: subItem.isActive ? Colors.blue : Colors.grey[600],
                  size: 16,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                subItem.label,
                style: TextStyle(
                  color: subItem.isActive ? Colors.blue : Colors.grey[700],
                  fontWeight: subItem.isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 