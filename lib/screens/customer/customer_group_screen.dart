import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerGroupScreen extends StatefulWidget {
  const CustomerGroupScreen({Key? key}) : super(key: key);

  @override
  State<CustomerGroupScreen> createState() => _CustomerGroupScreenState();
}

class _CustomerGroupScreenState extends State<CustomerGroupScreen> {
  final List<Map<String, dynamic>> _groups = [
    {
      'id': 'G001',
      'name': 'Khách hàng VIP',
      'description': 'Khách hàng đã chi tiêu trên 10 triệu đồng',
      'count': 28,
      'color': Colors.purple,
    },
    {
      'id': 'G002',
      'name': 'Khách hàng thân thiết',
      'description': 'Khách hàng đã mua hàng từ 5 lần trở lên',
      'count': 64,
      'color': Colors.blue,
    },
    {
      'id': 'G003',
      'name': 'Khách hàng mới',
      'description': 'Khách hàng mới đăng ký hoặc mua hàng dưới 5 lần',
      'count': 143,
      'color': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/customers/list'),
                tooltip: 'Quay lại',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              const Text(
                'Quản lý nhóm khách hàng',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showAddGroupDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Thêm nhóm'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildGroupList(),
        ],
      ),
    );
  }

  Widget _buildGroupList() {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListView.separated(
          itemCount: _groups.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final group = _groups[index];
            return _buildGroupItem(group);
          },
        ),
      ),
    );
  }

  Widget _buildGroupItem(Map<String, dynamic> group) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: CircleAvatar(
        backgroundColor: group['color'].withOpacity(0.2),
        child: Icon(
          Icons.group,
          color: group['color'],
        ),
      ),
      title: Text(
        group['name'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(group['description']),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.person,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                '${group['count']} khách hàng',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditGroupDialog(context, group),
            tooltip: 'Chỉnh sửa',
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteConfirmation(context, group),
            tooltip: 'Xóa',
          ),
        ],
      ),
      onTap: () {
        // View group details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xem chi tiết nhóm: ${group['name']}')),
        );
      },
    );
  }

  void _showAddGroupDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Thêm nhóm khách hàng mới'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên nhóm',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Mô tả',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Màu sắc:'),
                      const SizedBox(width: 16),
                      _buildColorPicker(
                        selectedColor: selectedColor,
                        onColorChanged: (color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    setState(() {
                      _groups.add({
                        'id': 'G00${_groups.length + 1}',
                        'name': nameController.text,
                        'description': descriptionController.text,
                        'count': 0,
                        'color': selectedColor,
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thêm nhóm mới thành công'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('Thêm'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditGroupDialog(BuildContext context, Map<String, dynamic> group) {
    final nameController = TextEditingController(text: group['name']);
    final descriptionController = TextEditingController(text: group['description']);
    Color selectedColor = group['color'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Chỉnh sửa nhóm ${group['name']}'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên nhóm',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Mô tả',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Màu sắc:'),
                      const SizedBox(width: 16),
                      _buildColorPicker(
                        selectedColor: selectedColor,
                        onColorChanged: (color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    setState(() {
                      final index = _groups.indexWhere((g) => g['id'] == group['id']);
                      if (index != -1) {
                        _groups[index] = {
                          'id': group['id'],
                          'name': nameController.text,
                          'description': descriptionController.text,
                          'count': group['count'],
                          'color': selectedColor,
                        };
                      }
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cập nhật nhóm thành công'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('Cập nhật'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Map<String, dynamic> group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa nhóm'),
        content: Text(
          'Bạn có chắc chắn muốn xóa nhóm "${group['name']}" không? Hành động này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _groups.removeWhere((g) => g['id'] == group['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã xóa nhóm thành công'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker({
    required Color selectedColor,
    required Function(Color) onColorChanged,
  }) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];

    return Row(
      children: colors.map((color) {
        final isSelected = selectedColor.value == color.value;
        return GestureDetector(
          onTap: () => onColorChanged(color),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
} 