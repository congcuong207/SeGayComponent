import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _selectedReport = 'Tổng quan';
  DateTime _selectedStartDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _selectedEndDate = DateTime.now();
  bool _isGenerating = false;

  final List<String> _reportTypes = [
    'Tổng quan',
    'Doanh thu',
    'Sản phẩm',
    'Khách hàng',
    'Kho hàng',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Báo cáo & Thống kê',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildReportControls(),
          const SizedBox(height: 24),
          Expanded(
            child: _buildReportContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildReportControls() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Loại báo cáo',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  _buildReportTypeSelector(),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Khoảng thời gian',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  _buildDateRangeSelector(),
                ],
              ),
            ),
            const SizedBox(width: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isGenerating ? null : _generateReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: _isGenerating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Tạo báo cáo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTypeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedReport,
          icon: const Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
          onChanged: (String? newValue) {
            setState(() {
              _selectedReport = newValue!;
            });
          },
          items: _reportTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedStartDate.day}/${_selectedStartDate.month}/${_selectedStartDate.year}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('đến'),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedEndDate.day}/${_selectedEndDate.month}/${_selectedEndDate.year}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _selectedStartDate : _selectedEndDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
          // Make sure start date isn't after end date
          if (_selectedStartDate.isAfter(_selectedEndDate)) {
            _selectedEndDate = _selectedStartDate;
          }
        } else {
          _selectedEndDate = picked;
          // Make sure end date isn't before start date
          if (_selectedEndDate.isBefore(_selectedStartDate)) {
            _selectedStartDate = _selectedEndDate;
          }
        }
      });
    }
  }

  void _generateReport() {
    setState(() {
      _isGenerating = true;
    });
    
    // Simulate report generation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Báo cáo $_selectedReport đã được tạo thành công'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  Widget _buildReportContent() {
    switch (_selectedReport) {
      case 'Doanh thu':
        return _buildRevenueReport();
      case 'Sản phẩm':
        return _buildProductReport();
      case 'Khách hàng':
        return _buildCustomerReport();
      case 'Kho hàng':
        return _buildInventoryReport();
      case 'Tổng quan':
      default:
        return _buildOverviewReport();
    }
  }

  Widget _buildOverviewReport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tổng quan kinh doanh',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: _buildSummaryCard('Tổng doanh thu', '548.5M', Colors.blue, Icons.trending_up)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSummaryCard('Đơn hàng', '1,245', Colors.orange, Icons.shopping_cart)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSummaryCard('Khách hàng mới', '235', Colors.green, Icons.person_add)),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildChartSection('Doanh thu theo thời gian'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: _buildTopSellersSection(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildChartSection('Phân bổ doanh thu theo danh mục'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildChartSection('Phân bổ khách hàng theo nhóm'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.arrow_upward,
                  color: Colors.green,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  '+12.5% so với trước đó',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(String title) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Biểu đồ $title',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSellersSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sản phẩm bán chạy nhất',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTopSellerItem('Áo thun nam cổ tròn', 108, 32.4),
            const Divider(),
            _buildTopSellerItem('Quần jean nữ ống suông', 92, 27.6),
            const Divider(),
            _buildTopSellerItem('Áo sơ mi trắng', 85, 21.3),
            const Divider(),
            _buildTopSellerItem('Đầm suông nữ', 67, 20.1),
            const Divider(),
            _buildTopSellerItem('Áo khoác dù', 54, 16.2),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSellerItem(String name, int quantity, double revenue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(name, overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: Text(
              '$quantity đơn',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              '${revenue}M',
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueReport() {
    return const Center(
      child: Text('Báo cáo doanh thu chi tiết sẽ hiển thị ở đây'),
    );
  }

  Widget _buildProductReport() {
    return const Center(
      child: Text('Báo cáo sản phẩm chi tiết sẽ hiển thị ở đây'),
    );
  }

  Widget _buildCustomerReport() {
    return const Center(
      child: Text('Báo cáo khách hàng chi tiết sẽ hiển thị ở đây'),
    );
  }

  Widget _buildInventoryReport() {
    return const Center(
      child: Text('Báo cáo kho hàng chi tiết sẽ hiển thị ở đây'),
    );
  }
} 