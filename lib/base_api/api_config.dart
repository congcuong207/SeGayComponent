class ApiConfig {
  static String baseURL = '';
  static final ApiConfig instance = ApiConfig();

  /// Đặt lại baseURL cho API.
  /// 
  /// Sử dụng:
  /// 
  /// ```dart
  /// ApiConfig.setBaseURL('https://api.mysite.com');
  /// ```
  static void setBaseURL(String url) {
    baseURL = url;
  }
  /// Lấy baseURL hiện tại cho API.
  /// 
  /// Sử dụng:
  /// 
  /// ```dart
  /// String url = ApiConfig.getBaseURL();
  /// ```
  static String getBaseURL() {
    return baseURL;
  }
} 