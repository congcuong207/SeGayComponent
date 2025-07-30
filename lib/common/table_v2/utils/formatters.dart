import 'package:intl/intl.dart';

/// Utility class for formatting values in the table
class TableFormatters {
  /// Format a currency value
  static String formatCurrency(String value) {
    if (value.isEmpty) return '0';
    
    // Convert to numeric value first
    final cleanValue = value.replaceAll(RegExp(r'[^\d.,]'), '').replaceAll(',', '.');
    final numValue = double.tryParse(cleanValue) ?? 0;
    
    // Format as currency
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(numValue);
  }
  
  /// Format a date value
  static String formatDate(DateTime? date, {String format = 'dd/MM/yyyy'}) {
    if (date == null) return '';
    return DateFormat(format).format(date);
  }
} 