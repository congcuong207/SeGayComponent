import 'package:se_gay_components/common/table/model/sg_table_controller.dart';

/// Quản lý các tham chiếu tới SgTableController toàn cục
class SgTableRegistry {
  // Singleton instance
  static final SgTableRegistry _instance = SgTableRegistry._internal();
  factory SgTableRegistry() => _instance;
  SgTableRegistry._internal();
  
  // Ánh xạ từ key đến controller
  final Map<String, dynamic> _controllers = {};
  
  /// Đăng ký controller với một key xác định
  void register<T>(String key, SgTableController<T> controller) {
    _controllers[key] = controller;
  }
  
  /// Lấy controller theo key
  SgTableController<T>? getController<T>(String key) {
    final controller = _controllers[key];
    if (controller is SgTableController<T>) {
      return controller;
    }
    return null;
  }
  
  /// Hủy đăng ký controller
  void unregister(String key) {
    _controllers.remove(key);
  }
  
  /// Cập nhật dữ liệu cho một bảng cụ thể
  bool updateData<T>(String key, List<T> newData) {
    final controller = getController<T>(key);
    if (controller != null) {
      controller.updateData(newData);
      return true;
    }
    return false;
  }
} 