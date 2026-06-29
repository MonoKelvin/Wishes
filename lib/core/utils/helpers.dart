import 'package:intl/intl.dart';

class Helpers {
  // 格式化价格
  static String formatPrice(double price) {
    return '¥${price.toStringAsFixed(2)}';
  }

  // 格式化日期
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // 格式化日期时间
  static String formatDateTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  // 格式化数字（如：1234 -> 1,234）
  static String formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }

  // 格式化大数字（如：12345 -> 1.2万）
  static String formatLargeNumber(int number) {
    if (number >= 10000) {
      return '${(number / 10000).toStringAsFixed(1)}万';
    }
    return formatNumber(number);
  }

  // 生成UUID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // 验证邮箱格式
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // 验证手机号格式
  static bool isValidPhone(String phone) {
    return RegExp(r'^1[3-9]\d{9}$').hasMatch(phone);
  }

  // 截断文本
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
