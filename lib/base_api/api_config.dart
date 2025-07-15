class ApiConfig {
  static String baseURL = '';
  static String bearToken = "";

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
  /// Đặt bearToken cho API.
  /// ///
  /// Sử dụng:
  /// ///
  /// ```dart
  /// ApiConfig.setBearToken('your_bearer_token');
  /// ``` 
  static void setBearToken(String token) {
    bearToken = token;
  }
  /// Lấy bearToken hiện tại cho API.
  ///
  /// Sử dụng:
  ///
  /// ```dart
  /// String token = ApiConfig.getBearToken();
  /// ```
  static String getBearToken() {
    return bearToken;
  }
} 