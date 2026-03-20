// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Jagdish Foods';
  static const String appTagline = "Vadodara's Taste Since 1945";
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'https://api.jagdishfoods.com/v1';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage Keys
  static const String kAuthToken = 'auth_token';
  static const String kRefreshToken = 'refresh_token';
  static const String kUserId = 'user_id';
  static const String kOnboarded = 'is_onboarded';
  static const String kCartBox = 'cart_box';
  static const String kWishlistBox = 'wishlist_box';
  static const String kRecentlyViewed = 'recently_viewed';
  static const String kSelectedAddress = 'selected_address';

  // OTP
  static const int otpLength = 6;
  static const int otpResendSeconds = 30;

  // Pagination
  static const int defaultPageSize = 20;

  // Cart
  static const int maxCartQuantity = 10;
  static const double freeDeliveryThreshold = 299.0;
  static const double deliveryCharges = 49.0;

  // Dimensions
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 32.0;

  // Banner auto-scroll interval
  static const Duration bannerScrollInterval = Duration(seconds: 4);

  // Razorpay
  static const String razorpayKey = 'rzp_live_XXXXXXXXXX'; // Replace with actual key

  // Categories
  static const List<Map<String, dynamic>> categories = [
    {'id': '1', 'name': 'Bhakharwadi', 'emoji': '🥐', 'color': 0xFFFFF3CD},
    {'id': '2', 'name': 'Chevdo', 'emoji': '🌾', 'color': 0xFFD4EDFF},
    {'id': '3', 'name': 'Sev', 'emoji': '🪢', 'color': 0xFFD4F5C4},
    {'id': '4', 'name': 'Khakhra', 'emoji': '🫓', 'color': 0xFFFFE0D0},
    {'id': '5', 'name': 'Sweets', 'emoji': '🍬', 'color': 0xFFF3E8FF},
    {'id': '6', 'name': 'Gift Packs', 'emoji': '🎁', 'color': 0xFFFFF3CD},
  ];
}
