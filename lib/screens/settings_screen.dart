import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _orderUpdates = true;
  bool _promotions = false;
  
  String _language = 'Tiếng Việt';
  String _dateFormat = 'DD/MM/YYYY';
  String _currency = 'VND (₫)';
  
  final List<String> _languages = ['Tiếng Việt', 'English', '中文', '日本語'];
  final List<String> _dateFormats = ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD'];
  final List<String> _currencies = ['VND (₫)', 'USD (\$)', 'EUR (€)', 'JPY (¥)'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cài đặt',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGeneralSettings(),
                  const SizedBox(height: 24),
                  _buildNotificationSettings(),
                  const SizedBox(height: 24),
                  _buildSecuritySettings(),
                  const SizedBox(height: 24),
                  _buildAdvancedSettings(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cài đặt chung',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Chế độ tối'),
              subtitle: const Text('Thay đổi giao diện sang màu tối'),
              trailing: Switch(
                value: _darkMode,
                onChanged: (bool value) {
                  setState(() {
                    _darkMode = value;
                  });
                },
              ),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Ngôn ngữ'),
              trailing: DropdownButton<String>(
                value: _language,
                underline: Container(),
                onChanged: (String? newValue) {
                  setState(() {
                    _language = newValue!;
                  });
                },
                items: _languages.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Định dạng ngày'),
              trailing: DropdownButton<String>(
                value: _dateFormat,
                underline: Container(),
                onChanged: (String? newValue) {
                  setState(() {
                    _dateFormat = newValue!;
                  });
                },
                items: _dateFormats.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Tiền tệ'),
              trailing: DropdownButton<String>(
                value: _currency,
                underline: Container(),
                onChanged: (String? newValue) {
                  setState(() {
                    _currency = newValue!;
                  });
                },
                items: _currencies.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông báo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Thông báo email'),
              subtitle: const Text('Nhận thông báo qua email'),
              trailing: Switch(
                value: _emailNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
              ),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Thông báo đẩy'),
              subtitle: const Text('Nhận thông báo trên thiết bị'),
              trailing: Switch(
                value: _pushNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
              ),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Cập nhật đơn hàng'),
              subtitle: const Text('Nhận thông báo về trạng thái đơn hàng'),
              trailing: Switch(
                value: _orderUpdates,
                onChanged: (bool value) {
                  setState(() {
                    _orderUpdates = value;
                  });
                },
              ),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Khuyến mãi & Ưu đãi'),
              subtitle: const Text('Nhận thông báo về các khuyến mãi mới'),
              trailing: Switch(
                value: _promotions,
                onChanged: (bool value) {
                  setState(() {
                    _promotions = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bảo mật',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.lock_outline),
              title: const Text('Đổi mật khẩu'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Show change password dialog
              },
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.fingerprint),
              title: const Text('Xác thực hai yếu tố'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Show 2FA settings
              },
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.devices),
              title: const Text('Quản lý thiết bị đăng nhập'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Show device management
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nâng cao',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.backup),
              title: const Text('Sao lưu dữ liệu'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Show backup settings
              },
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.code),
              title: const Text('API Access'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Show API settings
              },
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.delete_outline),
              title: const Text(
                'Xóa tài khoản',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                _showDeleteAccountDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa tài khoản'),
          content: const Text(
              'Bạn có chắc chắn muốn xóa tài khoản này? Hành động này không thể hoàn tác và tất cả dữ liệu của bạn sẽ bị xóa vĩnh viễn.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Xóa tài khoản',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chức năng này chưa được triển khai'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () {
            // Reset settings
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã khôi phục cài đặt mặc định'),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Khôi phục mặc định'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            // Save settings
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã lưu cài đặt thành công'),
                backgroundColor: Colors.green,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Lưu cài đặt'),
        ),
      ],
    );
  }
} 