import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedGroup = 'Tất cả';
  
  final List<Map<String, dynamic>> _customers = [
    {
      'id': 'C001',
      'name': 'Nguyễn Văn A',
      'phone': '0987654321',
      'email': 'nguyenvana@example.com',
      'group': 'Khách hàng thân thiết',
      'orders': 12,
      'spent': 4500000,
      'lastOrder': '15/05/2024',
    },
    {
      'id': 'C002',
      'name': 'Trần Thị B',
      'phone': '0912345678',
      'email': 'tranthib@example.com',
      'group': 'Khách hàng mới',
      'orders': 3,
      'spent': 1200000,
      'lastOrder': '10/05/2024',
    },
    {
      'id': 'C003',
      'name': 'Lê Văn C',
      'phone': '0976543210',
      'email': 'levanc@example.com',
      'group': 'Khách hàng VIP',
      'orders': 28,
      'spent': 15800000,
      'lastOrder': '12/05/2024',
    },
    {
      'id': 'C004',
      'name': 'Phạm Thị D',
      'phone': '0932145678',
      'email': 'phamthid@example.com',
      'group': 'Khách hàng thân thiết',
      'orders': 9,
      'spent': 3600000,
      'lastOrder': '05/05/2024',
    },
    {
      'id': 'C005',
      'name': 'Hoàng Văn E',
      'phone': '0965432109',
      'email': 'hoangvane@example.com',
      'group': 'Khách hàng mới',
      'orders': 2,
      'spent': 850000,
      'lastOrder': '08/05/2024',
    },
    {
      'id': 'C006',
      'name': 'Ngô Thị F',
      'phone': '0943215678',
      'email': 'ngothif@example.com',
      'group': 'Khách hàng VIP',
      'orders': 32,
      'spent': 18400000,
      'lastOrder': '14/05/2024',
    },
    {
      'id': 'C007',
      'name': 'Đỗ Văn G',
      'phone': '0954321678',
      'email': 'dovang@example.com',
      'group': 'Khách hàng thân thiết',
      'orders': 15,
      'spent': 5700000,
      'lastOrder': '03/05/2024',
    },
  ];
  
  final List<String> _groups = [
    'Tất cả',
    'Khách hàng mới',
    'Khách hàng thân thiết',
    'Khách hàng VIP',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredCustomers {
    return _customers.where((customer) {
      final matchesQuery = 
          customer['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          customer['phone'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          customer['email'].toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesGroup = _selectedGroup == 'Tất cả' || customer['group'] == _selectedGroup;
      
      return matchesQuery && matchesGroup;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Danh sách khách hàng',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      context.go('/customers/groups');
                    },
                    icon: const Icon(Icons.group),
                    label: const Text('Quản lý nhóm'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add new customer
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Thêm khách hàng'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFilterBar(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildCustomerList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm theo tên, email hoặc số điện thoại...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGroup,
                icon: const Icon(Icons.keyboard_arrow_down),
                isExpanded: true,
                hint: const Text('Nhóm khách hàng'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGroup = newValue!;
                  });
                },
                items: _groups.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerList() {
    if (_filteredCustomers.isEmpty) {
      return const Center(
        child: Text(
          'Không tìm thấy khách hàng nào',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Khách hàng',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Liên hệ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Nhóm',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Đơn hàng',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Chi tiêu',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 80),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredCustomers.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final customer = _filteredCustomers[index];
                return _buildCustomerRow(customer);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerRow(Map<String, dynamic> customer) {
    return InkWell(
      onTap: () {
        // Show customer details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xem chi tiết khách hàng: ${customer['name']}')),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade200,
                    child: Text(
                      customer['name'].toString().substring(0, 1),
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer['name'],
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mã KH: ${customer['id']}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer['phone'],
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    customer['email'],
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildGroupBadge(customer['group']),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '${customer['orders']}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gần đây: ${customer['lastOrder']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                '${_formatCurrency(customer['spent'])}đ',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () {
                      // Edit customer
                    },
                    tooltip: 'Sửa',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: () {
                      // Delete customer
                    },
                    tooltip: 'Xóa',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupBadge(String group) {
    Color color;
    switch (group) {
      case 'Khách hàng VIP':
        color = Colors.purple;
        break;
      case 'Khách hàng thân thiết':
        color = Colors.blue;
        break;
      case 'Khách hàng mới':
      default:
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        group,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }
} 