import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Tất cả';
  
  final List<Map<String, dynamic>> _products = [
    {
      'id': 'P001',
      'name': 'Áo thun nam cổ tròn',
      'category': 'Áo Nam',
      'price': 180000,
      'stock': 150,
      'image': 'https://picsum.photos/id/1/100/100',
    },
    {
      'id': 'P002',
      'name': 'Quần jean nữ ống suông',
      'category': 'Quần Nữ',
      'price': 350000,
      'stock': 85,
      'image': 'https://picsum.photos/id/2/100/100',
    },
    {
      'id': 'P003',
      'name': 'Áo sơ mi trắng',
      'category': 'Áo Nam',
      'price': 250000,
      'stock': 120,
      'image': 'https://picsum.photos/id/3/100/100',
    },
    {
      'id': 'P004',
      'name': 'Đầm suông nữ',
      'category': 'Váy Đầm',
      'price': 420000,
      'stock': 45,
      'image': 'https://picsum.photos/id/4/100/100',
    },
    {
      'id': 'P005',
      'name': 'Áo khoác dù',
      'category': 'Áo Khoác',
      'price': 450000,
      'stock': 60,
      'image': 'https://picsum.photos/id/5/100/100',
    },
    {
      'id': 'P006',
      'name': 'Chân váy xếp ly',
      'category': 'Váy Đầm',
      'price': 280000,
      'stock': 38,
      'image': 'https://picsum.photos/id/6/100/100',
    },
    {
      'id': 'P007',
      'name': 'Áo polo nam',
      'category': 'Áo Nam',
      'price': 220000,
      'stock': 95,
      'image': 'https://picsum.photos/id/7/100/100',
    },
    {
      'id': 'P008',
      'name': 'Quần jeans nam slim fit',
      'category': 'Quần Nam',
      'price': 380000,
      'stock': 72,
      'image': 'https://picsum.photos/id/8/100/100',
    },
  ];
  
  final List<String> _categories = [
    'Tất cả',
    'Áo Nam',
    'Áo Nữ',
    'Quần Nam',
    'Quần Nữ',
    'Váy Đầm',
    'Áo Khoác',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredProducts {
    return _products.where((product) {
      final matchesQuery = product['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product['id'].toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == 'Tất cả' || product['category'] == _selectedCategory;
      
      return matchesQuery && matchesCategory;
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
                'Danh sách sản phẩm',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.go('/products/add');
                },
                icon: const Icon(Icons.add),
                label: const Text('Thêm sản phẩm'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFilterBar(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildProductList(),
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
              hintText: 'Tìm kiếm sản phẩm...',
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
                value: _selectedCategory,
                icon: const Icon(Icons.keyboard_arrow_down),
                isExpanded: true,
                hint: const Text('Danh mục'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: _categories.map<DropdownMenuItem<String>>((String value) {
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

  Widget _buildProductList() {
    if (_filteredProducts.isEmpty) {
      return const Center(
        child: Text(
          'Không tìm thấy sản phẩm nào',
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
              children: [
                const SizedBox(width: 60),
                const Expanded(
                  flex: 3,
                  child: Text(
                    'Tên sản phẩm',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Danh mục',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Giá',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Kho',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredProducts.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return _buildProductRow(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(Map<String, dynamic> product) {
    return InkWell(
      onTap: () {
        // Show product details or edit screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xem chi tiết sản phẩm: ${product['name']}')),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                product['image'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) => Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SKU: ${product['id']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                product['category'],
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              child: Text(
                '${_formatCurrency(product['price'])}đ',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: Text(
                '${product['stock']}',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () {
                      // Edit product
                    },
                    tooltip: 'Sửa',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: () {
                      // Delete product
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

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }
} 