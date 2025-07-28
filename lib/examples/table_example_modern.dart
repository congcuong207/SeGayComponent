import 'package:flutter/material.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class CustomerData {
  final String id;
  final String name;
  final String description;
  final String status;
  final double rate;
  final double balance;
  final double deposit;

  CustomerData({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.rate,
    required this.balance,
    required this.deposit,
  });
}

class ModernTableExample extends StatefulWidget {
  const ModernTableExample({super.key});

  @override
  State<ModernTableExample> createState() => _ModernTableExampleState();
}

class _ModernTableExampleState extends State<ModernTableExample> {
  final List<CustomerData> _customers = [
    CustomerData(
      id: '5684236526',
      name: 'Ann Culhane',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula.',
      status: 'Open',
      rate: 70.0,
      balance: -270.0,
      deposit: 500.0,
    ),
    CustomerData(
      id: '5684236527',
      name: 'Ahmad Rosser',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula.',
      status: 'Paid',
      rate: 70.0,
      balance: 270.0,
      deposit: 500.0,
    ),
    CustomerData(
      id: '5684236528',
      name: 'Zain Calzoni',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula.',
      status: 'Open',
      rate: 70.0,
      balance: -20.0,
      deposit: 500.0,
    ),
    CustomerData(
      id: '5684236529',
      name: 'Leo Stanton',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula.',
      status: 'Inactive',
      rate: 70.0,
      balance: 600.0,
      deposit: 500.0,
    ),
    CustomerData(
      id: '5684236530',
      name: 'Kaiya Vetrovs',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula.',
      status: 'Open',
      rate: 70.0,
      balance: -350.0,
      deposit: 500.0,
    ),
    CustomerData(
      id: '5684236531',
      name: 'Ryan Westervelt',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula.',
      status: 'Paid',
      rate: 70.0,
      balance: -270.0,
      deposit: 500.0,
    ),
    CustomerData(
      id: '5684236532',
      name: 'Corey Stanton',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula.',
      status: 'Due',
      rate: 70.0,
      balance: 30.0,
      deposit: 500.0,
    ),
    CustomerData(
      id: '5684236533',
      name: 'Adison Aminoff',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula.',
      status: 'Open',
      rate: 70.0,
      balance: -270.0,
      deposit: 500.0,
    ),
    CustomerData(
      id: '5684236534',
      name: 'Alfredo Aminoff',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula.',
      status: 'Inactive',
      rate: 70.0,
      balance: 460.0,
      deposit: 500.0,
    ),
    CustomerData(
      id: '5684236534',
      name: 'Alfredo Aminoff',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula.',
      status: 'Inactive',
      rate: 70.0,
      balance: 460.0,
      deposit: 500.0,
    ),
    CustomerData(
      id: '5684236534',
      name: 'Alfredo Aminoff',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula.',
      status: 'Inactive',
      rate: 70.0,
      balance: 460.0,
      deposit: 500.0,
    ),
    CustomerData(
      id: '5684236534',
      name: 'Alfredo Aminoff',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula.',
      status: 'Inactive',
      rate: 70.0,
      balance: 460.0,
      deposit: 500.0,
    ),
    CustomerData(
      id: '5684236534',
      name: 'Alfredo Aminoff',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula.',
      status: 'Inactive',
      rate: 70.0,
      balance: 460.0,
      deposit: 500.0,
    ),
  ];

  bool _showCheckboxes = true;
  List<CustomerData> _selectedItems = [];
  bool _showExtraColumns = false; // Biến kiểm soát hiển thị thêm cột
  bool _showScrollbar = true; // Biến mới để kiểm soát hiển thị thanh cuộn

  void _viewCustomer(CustomerData customer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Xem chi tiết: ${customer.name}')),
    );
  }

  void _editCustomer(CustomerData customer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sửa khách hàng: ${customer.name}')),
    );
  }

  void _deleteCustomer(CustomerData customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa khách hàng ${customer.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _customers.remove(customer);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(CustomerData customer, int index) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      splashRadius: 20,
      tooltip: 'Thao tác',
      icon: const Icon(
        Icons.more_vert,
        color: Colors.grey,
        size: 20,
      ),
      // Tùy chỉnh hiển thị popup menu
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      offset: const Offset(0, 40),
      elevation: 4,
      position: PopupMenuPosition.under,
      enableFeedback: true,
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'view',
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.visibility, color: Colors.blue, size: 18),
              const SizedBox(width: 8),
              const Text('Xem chi tiết', style: TextStyle(fontSize: 14))
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'edit',
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit, color: Colors.green, size: 18),
              const SizedBox(width: 8),
              const Text('Sửa', style: TextStyle(fontSize: 14))
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'delete',
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete, color: Colors.red, size: 18),
              const SizedBox(width: 8),
              const Text('Xóa', style: TextStyle(fontSize: 14))
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'view':
            _viewCustomer(customer);
            break;
          case 'edit':
            _editCustomer(customer);
            break;
          case 'delete':
            _deleteCustomer(customer);
            break;
        }
      },
    );
  }

  List<SgTableColumn<CustomerData>> _buildColumns() {
    // Bây giờ sử dụng các builder để tạo các cột phức tạp
    List<SgTableColumn<CustomerData>> allColumns = [
      TableColumnBuilder.createNameWithIdColumn<CustomerData>(
        title: 'CUSTOMER',
        getName: (item) => item.name,
        getId: (item) => item.id,
        width: 180,
        fixedWidth: true,
        searchable: true,
        searchValue: (item) => '${item.name} ${item.id}',
      ),
      TableColumnBuilder.createTextColumn<CustomerData>(
        title: 'DESCRIPTION',
        getValue: (item) => item.description,
        width: 120,
        fixedWidth: true,
      ),
      TableColumnBuilder.createStatusColumn<CustomerData>(
        title: 'STATUS',
        getStatus: (item) => item.status,
        width: 100,
        fixedWidth: true,
      ),
      TableColumnBuilder.createTextColumn<CustomerData>(
        title: 'RATE',
        getValue: (item) => '\$${item.rate.toStringAsFixed(2)}',
        align: TextAlign.right,
        width: 120,
        fixedWidth: true,
      ),
      TableColumnBuilder.createCurrencyColumn<CustomerData>(
        title: 'BALANCE',
        getValue: (item) => item.balance,
        width: 120,
        fixedWidth: true,
        colorByValue: true,
      ),
      TableColumnBuilder.createCurrencyColumn<CustomerData>(
        title: 'DEPOSIT',
        getValue: (item) => item.deposit,
        width: 130,
        fixedWidth: true,
      ),
      TableColumnBuilder.createCurrencyColumn<CustomerData>(
          title: 'BALANCE (EXTRA)',
          getValue: (item) => item.balance,
          width: 120,
          fixedWidth: true,
          colorByValue: true,
        ),
        TableColumnBuilder.createCurrencyColumn<CustomerData>(
          title: 'DEPOSIT (EXTRA)',
          getValue: (item) => item.deposit,
          width: 130,
          fixedWidth: true,
        ),
        TableColumnBuilder.createCurrencyColumn<CustomerData>(
          title: 'BALANCE (EXTRA 2)',
          getValue: (item) => item.balance,
          width: 120,
          fixedWidth: true,
          colorByValue: true,
        ),
        TableColumnBuilder.createCurrencyColumn<CustomerData>(
          title: 'DEPOSIT (EXTRA 2)',
          getValue: (item) => item.deposit,
          width: 130,
          fixedWidth: true,
        ),
        TableColumnBuilder.createCurrencyColumn<CustomerData>(
          title: 'BALANCE (EXTRA)',
          getValue: (item) => item.balance,
          width: 120,
          fixedWidth: true,
          colorByValue: true,
        ),
        TableColumnBuilder.createCurrencyColumn<CustomerData>(
          title: 'DEPOSIT (EXTRA)',
          getValue: (item) => item.deposit,
          width: 130,
          fixedWidth: true,
        ),
        TableColumnBuilder.createCurrencyColumn<CustomerData>(
          title: 'BALANCE (EXTRA 2)',
          getValue: (item) => item.balance,
          width: 120,
          fixedWidth: true,
          colorByValue: true,
        ),
        TableColumnBuilder.createCurrencyColumn<CustomerData>(
          title: 'DEPOSIT (EXTRA 2)',
          getValue: (item) => item.deposit,
          width: 130,
          fixedWidth: true,
        ),
    ];
    
    // Thêm các cột bổ sung khi _showExtraColumns là true
    // if (_showExtraColumns) {
    //   allColumns.addAll([
    //     TableColumnBuilder.createCurrencyColumn<CustomerData>(
    //       title: 'BALANCE (EXTRA)',
    //       getValue: (item) => item.balance,
    //       width: 120,
    //       fixedWidth: true,
    //       colorByValue: true,
    //     ),
    //     TableColumnBuilder.createCurrencyColumn<CustomerData>(
    //       title: 'DEPOSIT (EXTRA)',
    //       getValue: (item) => item.deposit,
    //       width: 130,
    //       fixedWidth: true,
    //     ),
    //     TableColumnBuilder.createCurrencyColumn<CustomerData>(
    //       title: 'BALANCE (EXTRA 2)',
    //       getValue: (item) => item.balance,
    //       width: 120,
    //       fixedWidth: true,
    //       colorByValue: true,
    //     ),
    //     TableColumnBuilder.createCurrencyColumn<CustomerData>(
    //       title: 'DEPOSIT (EXTRA 2)',
    //       getValue: (item) => item.deposit,
    //       width: 130,
    //       fixedWidth: true,
    //     ),
    //   ]);
    // }
    
    return allColumns;
  }
  
  @override
  Widget build(BuildContext context) {
    // Xây dựng danh sách các cột
    final allColumns = _buildColumns();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modern Table Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Switch hiển thị checkbox
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: _showCheckboxes,
                      onChanged: (value) {
                        setState(() {
                          _showCheckboxes = value;
                          if (!value) {
                            _selectedItems = [];
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text('Hiển thị checkbox'),
                  ],
                ),
                
                // Switch hiển thị thêm cột
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: _showExtraColumns,
                      onChanged: (value) {
                        setState(() {
                          _showExtraColumns = value;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text('Hiển thị thêm cột'),
                  ],
                ),
                
                // Switch hiển thị thanh cuộn
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: _showScrollbar,
                      onChanged: (value) {
                        setState(() {
                          _showScrollbar = value;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text('Hiển thị thanh cuộn'),
                  ],
                ),
                
                // Tạo khoảng trống linh hoạt
                const SizedBox(width: 40),
                
                // Thông tin số mục đã chọn
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Đã chọn: ${_selectedItems.length} mục'),
                    if (_selectedItems.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Xác nhận'),
                              content: Text(
                                  'Bạn có chắc muốn xóa ${_selectedItems.length} mục đã chọn?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _customers
                                          .removeWhere((item) => _selectedItems.contains(item));
                                      _selectedItems = [];
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Xóa'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Xóa đã chọn'),
                      ),
                    ]
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SgTable<CustomerData>(
                showCheckboxes: _showCheckboxes,
                useFullWidth: true,
                autoWidth: true, // Tự động điều chỉnh chiều rộng
                showHorizontalScrollbar: _showScrollbar, // Sử dụng biến để kiểm soát thanh cuộn
                scrollbarThickness: 10.0, // Thanh cuộn dày hơn một chút
                scrollbarColor: Colors.blue.shade300, // Màu xanh dương nhạt
                scrollbarAlwaysVisible: true, // Luôn hiển thị thanh cuộn
                onSelectionChanged: (items) {
                  setState(() {
                    _selectedItems = items;
                  });
                },
                data: _customers,
                showColumnAction: true,
                columnAction: _buildActionButtons,
                columnActionTitle: '',
                columnActionWidth: 130,
                columns: allColumns,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 