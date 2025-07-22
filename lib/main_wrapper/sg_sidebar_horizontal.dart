import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';

class SGSidebarHorizontalItem {
  final String label;
  final IconData? icon;
  final bool isActive;
  final VoidCallback onTap;
  final List<SGSidebarSubItem>? subItems;

  SGSidebarHorizontalItem({
    required this.label,
    this.icon,
    this.isActive = false,
    required this.onTap,
    this.subItems,
  });
}

class SGSidebarSubItem {
  final String label;
  final IconData? icon;
  final bool isActive;
  final VoidCallback onTap;

  SGSidebarSubItem({
    required this.label,
    this.icon,
    this.isActive = false,
    required this.onTap,
  });
}

class SGSidebarHorizontal extends StatefulWidget {
  final List<SGSidebarHorizontalItem> items;
  final Function(List<SGSidebarSubItem>?)? onShowSubItems;

  const SGSidebarHorizontal({
    super.key,
    required this.items,
    this.onShowSubItems,
  });

  @override
  State<SGSidebarHorizontal> createState() => _SGSidebarHorizontalState();
}

class _SGSidebarHorizontalState extends State<SGSidebarHorizontal> {
  SGSidebarHorizontalItem? _selectedItem;

  @override
  void initState() {
    super.initState();
    // Tìm item active mặc định
    _findActiveItem();

    // Thông báo subItems ban đầu sau khi frame đầu tiên hoàn thành
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedItem != null && widget.onShowSubItems != null) {
        widget.onShowSubItems?.call(_selectedItem!.subItems);
      }
    });
  }

  void _findActiveItem() {
    try {
      _selectedItem = widget.items.firstWhere((item) => item.isActive);
    } catch (e) {
      // Nếu không tìm thấy item active, chọn item đầu tiên
      if (widget.items.isNotEmpty) {
        _selectedItem = widget.items.first;
      }
    }
  }

  @override
  void didUpdateWidget(covariant SGSidebarHorizontal oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cập nhật item được chọn khi widget cập nhật
    _findActiveItem();
  }

  void _handleItemTap(SGSidebarHorizontalItem item) {
    item.onTap();
    _selectedItem = item;
    // Thông báo subItems khi có thay đổi item
    if (widget.onShowSubItems != null) {
      widget.onShowSubItems?.call(item.subItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          color: SGAppColors.neutral300,
        ),
        Container(
          width: double.infinity,
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widget.items.map((item) => _buildItem(item)).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItem(SGSidebarHorizontalItem item) {
    return InkWell(
      onTap: () => _handleItemTap(item),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: item.isActive ? Colors.blue : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  color: item.isActive ? Colors.blue : Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                item.label,
                style: TextStyle(
                  color: item.isActive ? Colors.blue : Colors.grey[800],
                  fontWeight: item.isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              if (item.subItems != null && item.subItems!.isNotEmpty) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: item.isActive ? Colors.blue : Colors.grey[600],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
