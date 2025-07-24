import 'package:flutter/material.dart';

class MonthlyReportScreen extends StatelessWidget {
  const MonthlyReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Báo cáo tháng',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                _buildMonthSelector(),
              ],
            ),
            const SizedBox(height: 24),
            _buildMonthSummary(),
            const SizedBox(height: 24),
            _buildMonthlyChart(),
            const SizedBox(height: 24),
            _buildTopPerformers(),
            const SizedBox(height: 24),
            _buildGrowthMetrics(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Tháng 5, 2024',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Icon(Icons.calendar_month, size: 16, color: Colors.grey.shade700),
        ],
      ),
    );
  }

  Widget _buildMonthSummary() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng kết tháng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    '+15.2% so với tháng trước',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('Doanh thu', '240.5M', Colors.purple, Icons.attach_money)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('Đơn hàng', '625', Colors.orange, Icons.shopping_cart)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('Khách hàng mới', '84', Colors.blue, Icons.person_add)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('Đơn hoàn', '23', Colors.red, Icons.assignment_return)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14),
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
        ],
      ),
    );
  }

  Widget _buildMonthlyChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Doanh thu theo tuần trong tháng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('Đây là vùng hiển thị biểu đồ theo tuần'),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ChartLegend(color: Colors.blue, label: 'Tuần 1'),
                _ChartLegend(color: Colors.green, label: 'Tuần 2'),
                _ChartLegend(color: Colors.orange, label: 'Tuần 3'),
                _ChartLegend(color: Colors.purple, label: 'Tuần 4'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTopPerformers() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sản phẩm bán chạy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildProductItem('Áo thun nam cổ tròn', '108 đơn', '32.4M', 1),
            const Divider(),
            _buildProductItem('Quần jean nữ ống suông', '92 đơn', '27.6M', 2),
            const Divider(),
            _buildProductItem('Áo sơ mi trắng', '85 đơn', '21.3M', 3),
            const Divider(),
            _buildProductItem('Đầm suông nữ', '67 đơn', '20.1M', 4),
            const Divider(),
            _buildProductItem('Áo khoác dù', '54 đơn', '16.2M', 5),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(String name, String orders, String revenue, int rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: rank <= 3 ? Colors.amber.shade100 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$rank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: rank <= 3 ? Colors.amber.shade800 : Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(orders, style: TextStyle(color: Colors.grey.shade600)),
              Text(
                revenue,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthMetrics() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chỉ số tăng trưởng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildGrowthItem('Doanh thu', 15.2, 10.5),
            const SizedBox(height: 12),
            _buildGrowthItem('Số lượng đơn hàng', 12.8, 8.3),
            const SizedBox(height: 12),
            _buildGrowthItem('Khách hàng mới', 18.6, 12.4),
            const SizedBox(height: 12),
            _buildGrowthItem('Giá trị đơn trung bình', 5.3, 4.2),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthItem(String title, double currentGrowth, double previousGrowth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tháng này',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  _buildGrowthIndicator(currentGrowth),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tháng trước',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  _buildGrowthIndicator(previousGrowth),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildGrowthIndicator(double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 150 * (percentage / 20), // Scale to max 20%
              height: 8,
              decoration: BoxDecoration(
                color: percentage > 10 ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: 150 * (1 - percentage / 20), // Remaining space
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '+$percentage%',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: percentage > 10 ? Colors.green : Colors.orange,
          ),
        ),
      ],
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
} 