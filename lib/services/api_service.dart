// lib/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../core/constants/app_constants.dart';
import '../data/models/models.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;

  void init({String? authToken}) {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      },
    ));

    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: false,
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Token expired — trigger re-auth
          // authProvider.logout();
        }
        handler.next(e);
      },
    ));
  }

  // ─── Auth ─────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> sendOtp(String phone) async {
    final res = await _dio.post('/auth/send-otp', data: {'phone': phone});
    return res.data;
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final res = await _dio.post('/auth/verify-otp', data: {'phone': phone, 'otp': otp});
    return res.data; // { token, refresh_token, user }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final res = await _dio.post('/auth/refresh', data: {'refresh_token': refreshToken});
    return res.data;
  }

  // ─── Products ─────────────────────────────────────────────────────────
  Future<List<ProductModel>> getProducts({
    String? categoryId,
    String? search,
    String sortBy = 'popular',
    int page = 1,
    int limit = AppConstants.defaultPageSize,
  }) async {
    final res = await _dio.get('/products', queryParameters: {
      if (categoryId != null) 'category_id': categoryId,
      if (search != null) 'search': search,
      'sort_by': sortBy,
      'page': page,
      'limit': limit,
    });
    return (res.data['data'] as List)
        .map((p) => ProductModel.fromJson(p))
        .toList();
  }

  Future<ProductModel> getProductById(String id) async {
    final res = await _dio.get('/products/$id');
    return ProductModel.fromJson(res.data['data']);
  }

  Future<List<ProductModel>> getBestSellers({int limit = 10}) async {
    final res = await _dio.get('/products/best-sellers', queryParameters: {'limit': limit});
    return (res.data['data'] as List)
        .map((p) => ProductModel.fromJson(p))
        .toList();
  }

  Future<List<ProductModel>> getNewArrivals({int limit = 10}) async {
    final res = await _dio.get('/products/new-arrivals', queryParameters: {'limit': limit});
    return (res.data['data'] as List)
        .map((p) => ProductModel.fromJson(p))
        .toList();
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final res = await _dio.get('/products/search', queryParameters: {'q': query});
    return (res.data['data'] as List)
        .map((p) => ProductModel.fromJson(p))
        .toList();
  }

  // ─── Coupons ──────────────────────────────────────────────────────────
  Future<CouponModel?> validateCoupon(String code, double orderAmount) async {
    try {
      final res = await _dio.post('/coupons/validate', data: {
        'code': code,
        'order_amount': orderAmount,
      });
      return CouponModel(
        id: res.data['data']['id'],
        code: res.data['data']['code'],
        title: res.data['data']['title'],
        description: res.data['data']['description'],
        type: CouponType.values.firstWhere(
            (t) => t.name == res.data['data']['type']),
        value: (res.data['data']['value'] as num).toDouble(),
        maxDiscount: res.data['data']['max_discount']?.toDouble(),
        minOrderValue: (res.data['data']['min_order_value'] as num).toDouble(),
        validTill: DateTime.parse(res.data['data']['valid_till']),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) return null;
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableCoupons() async {
    final res = await _dio.get('/coupons');
    return List<Map<String, dynamic>>.from(res.data['data']);
  }

  // ─── Orders ──────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> placeOrder({
    required List<CartItem> items,
    required String addressId,
    required String paymentMethod,
    String? couponCode,
    String? paymentId,
  }) async {
    final res = await _dio.post('/orders', data: {
      'items': items.map((i) => {
        'product_id': i.productId,
        'variant_id': i.variantId,
        'quantity': i.quantity,
        'price': i.price,
      }).toList(),
      'address_id': addressId,
      'payment_method': paymentMethod,
      if (couponCode != null) 'coupon_code': couponCode,
      if (paymentId != null) 'payment_id': paymentId,
    });
    return res.data['data'];
  }

  Future<List<Map<String, dynamic>>> getOrders({int page = 1}) async {
    final res = await _dio.get('/orders', queryParameters: {'page': page});
    return List<Map<String, dynamic>>.from(res.data['data']);
  }

  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    final res = await _dio.get('/orders/$orderId');
    return res.data['data'];
  }

  Future<Map<String, dynamic>> getOrderTracking(String orderId) async {
    final res = await _dio.get('/orders/$orderId/tracking');
    return res.data['data'];
  }

  // ─── User & Addresses ────────────────────────────────────────────────
  Future<Map<String, dynamic>> getUserProfile() async {
    final res = await _dio.get('/user/profile');
    return res.data['data'];
  }

  Future<Map<String, dynamic>> updateUserProfile({
    required String name,
    String? email,
  }) async {
    final res = await _dio.put('/user/profile', data: {
      'name': name,
      if (email != null) 'email': email,
    });
    return res.data['data'];
  }

  Future<List<Map<String, dynamic>>> getAddresses() async {
    final res = await _dio.get('/user/addresses');
    return List<Map<String, dynamic>>.from(res.data['data']);
  }

  Future<Map<String, dynamic>> addAddress(AddressModel address) async {
    final res = await _dio.post('/user/addresses', data: {
      'label': address.label,
      'recipient_name': address.recipientName,
      'phone': address.phone,
      'line1': address.line1,
      'line2': address.line2,
      'city': address.city,
      'state': address.state,
      'pincode': address.pincode,
      'is_default': address.isDefault,
    });
    return res.data['data'];
  }

  Future<void> deleteAddress(String addressId) async {
    await _dio.delete('/user/addresses/$addressId');
  }

  // ─── Wishlist ────────────────────────────────────────────────────────
  Future<void> addToWishlist(String productId) async {
    await _dio.post('/user/wishlist', data: {'product_id': productId});
  }

  Future<void> removeFromWishlist(String productId) async {
    await _dio.delete('/user/wishlist/$productId');
  }

  Future<List<String>> getWishlistIds() async {
    final res = await _dio.get('/user/wishlist');
    return List<String>.from(res.data['data'].map((p) => p['id']));
  }

  // ─── Banners ─────────────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getBanners() async {
    final res = await _dio.get('/banners');
    return List<Map<String, dynamic>>.from(res.data['data']);
  }

  // ─── Notifications ───────────────────────────────────────────────────
  Future<void> registerFcmToken(String token) async {
    await _dio.post('/user/fcm-token', data: {'token': token});
  }
}
