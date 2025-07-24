import 'package:flutter/material.dart';

class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

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
                'Báo cáo tuần',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              _buildDateSelector(),
            ],
          ),
          const SizedBox(height: 24),
          _buildWeeklyStatsSection(),
          const SizedBox(height: 24),
          _buildWeeklyChartSection(),
          const SizedBox(height: 24),
          _buildComparisonSection(),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
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
            '06/05 - 12/05/2024',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade700),
        ],
      ),
    );
  }

  Widget _buildWeeklyStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tổng kết tuần',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatCard('Tổng doanh thu', '52.3M', Colors.indigo, Icons.attach_money)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('Đơn hàng', '145', Colors.orange, Icons.shopping_cart)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatCard('Khách hàng mới', '28', Colors.green, Icons.person_add)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('Tỷ lệ hoàn đơn', '4.2%', Colors.red, Icons.assignment_return)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
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
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Doanh thu theo ngày trong tuần',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Center(
            child: Text('Đây là vùng hiển thị biểu đồ theo ngày'),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'So sánh với tuần trước',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildComparisonItem('Doanh thu', '52.3M', '48.7M', 7.4),
                const Divider(),
                _buildComparisonItem('Số đơn hàng', '145', '132', 9.8),
                const Divider(),
                _buildComparisonItem('Khách hàng mới', '28', '23', 21.7),
                const Divider(),
                _buildComparisonItem('Tỷ lệ hoàn đơn', '4.2%', '5.1%', -17.6),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonItem(String title, String currentValue, String previousValue, double percentChange) {
    final isPositive = percentChange >= 0;
    final changeText = '${isPositive ? "+" : ""}$percentChange%';
    final changeColor = title == 'Tỷ lệ hoàn đơn' ? 
      (isPositive ? Colors.red : Colors.green) :
      (isPositive ? Colors.green : Colors.red);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text(currentValue, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text(previousValue, style: TextStyle(color: Colors.grey.shade600)),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: changeColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  changeText,
                  style: TextStyle(
                    color: changeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 