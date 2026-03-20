// lib/core/utils/helpers.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';

// ─── Currency Formatter ───────────────────────────────────────────────────
class CurrencyFormatter {
  static final _formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String format(double amount) => _formatter.format(amount);
  static String formatInt(int amount) => _formatter.format(amount);
}

// ─── Date Formatter ───────────────────────────────────────────────────────
class DateFormatter {
  static String orderDate(DateTime date) =>
      DateFormat('d MMM yyyy, hh:mm a').format(date);

  static String shortDate(DateTime date) =>
      DateFormat('d MMM yyyy').format(date);

  static String timeOnly(DateTime date) =>
      DateFormat('hh:mm a').format(date);

  static String relative(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return shortDate(date);
  }
}

// ─── Validators ───────────────────────────────────────────────────────────
class Validators {
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (value.length != 10) return 'Enter valid 10-digit mobile number';
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
      return 'Enter valid Indian mobile number';
    }
    return null;
  }

  static String? otp(String? value) {
    if (value == null || value.isEmpty) return 'OTP is required';
    if (value.length != 6) return 'Enter 6-digit OTP';
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name too short';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return null; // optional
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter valid email address';
    }
    return null;
  }

  static String? pincode(String? value) {
    if (value == null || value.isEmpty) return 'Pincode is required';
    if (value.length != 6) return 'Enter valid 6-digit pincode';
    return null;
  }

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }
}

// ─── Snackbar Helpers ─────────────────────────────────────────────────────
class AppSnackBar {
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: AppColors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ));
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    ));
  }

  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: AppColors.textDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ));
  }
}

// ─── Extensions ───────────────────────────────────────────────────────────
extension StringExtensions on String {
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String get titleCase => split(' ').map((w) => w.capitalized).join(' ');

  bool get isValidPhone =>
      length == 10 && RegExp(r'^[6-9]\d{9}$').hasMatch(this);

  bool get isValidEmail =>
      RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
}

extension DoubleExtensions on double {
  String get inRupees => '₹${toInt()}';
  String get toCurrency => CurrencyFormatter.format(this);
}

extension IntExtensions on int {
  String get inRupees => '₹$this';
}

extension DateTimeExtensions on DateTime {
  String get toOrderDate => DateFormatter.orderDate(this);
  String get toShortDate => DateFormatter.shortDate(this);
  String get toTime => DateFormatter.timeOnly(this);
  String get toRelative => DateFormatter.relative(this);
}

extension BuildContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  ThemeData get theme => Theme.of(this);
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  void showSuccessSnackBar(String message) =>
      AppSnackBar.showSuccess(this, message);
  void showErrorSnackBar(String message) =>
      AppSnackBar.showError(this, message);
}
