// lib/providers/cart_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/models.dart';
import '../core/constants/app_constants.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  CouponModel? _appliedCoupon;
  bool _isLoading = false;
  String? _error;

  List<CartItem> get items => List.unmodifiable(_items);
  CouponModel? get appliedCoupon => _appliedCoupon;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);
  double get mrpTotal => _items.fold(0, (sum, item) => sum + item.totalMrp);
  double get productDiscount => mrpTotal - subtotal;

  double get couponDiscount {
    if (_appliedCoupon == null) return 0;
    return _appliedCoupon!.calculateDiscount(subtotal);
  }

  double get deliveryCharge {
    if (subtotal >= AppConstants.freeDeliveryThreshold) return 0;
    if (_appliedCoupon?.type == CouponType.freeDelivery) return 0;
    return AppConstants.deliveryCharges;
  }

  double get totalSavings => productDiscount + couponDiscount + (subtotal >= AppConstants.freeDeliveryThreshold ? AppConstants.deliveryCharges : 0);

  double get finalTotal => subtotal - couponDiscount + deliveryCharge;

  double get amountToFreeDelivery => AppConstants.freeDeliveryThreshold - subtotal;

  // Initialize cart from local storage
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(AppConstants.kCartBox);
      if (cartJson != null) {
        final List<dynamic> decoded = jsonDecode(cartJson);
        _items.clear();
        _items.addAll(decoded.map((e) => CartItem.fromJson(e)));
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.kCartBox,
        jsonEncode(_items.map((e) => e.toJson()).toList()),
      );
    } catch (_) {}
  }

  bool containsProduct(String productId, String variantId) {
    return _items.any((i) => i.productId == productId && i.variantId == variantId);
  }

  int quantityOf(String productId, String variantId) {
    final item = _items.cast<CartItem?>().firstWhere(
      (i) => i?.productId == productId && i?.variantId == variantId,
      orElse: () => null,
    );
    return item?.quantity ?? 0;
  }

  Future<void> addItem(CartItem item) async {
    final index = _items.indexWhere(
      (i) => i.productId == item.productId && i.variantId == item.variantId,
    );
    if (index >= 0) {
      if (_items[index].quantity < AppConstants.maxCartQuantity) {
        _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
      }
    } else {
      _items.add(item);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> removeItem(String productId, String variantId) async {
    _items.removeWhere((i) => i.productId == productId && i.variantId == variantId);
    notifyListeners();
    await _persist();
  }

  Future<void> updateQuantity(String productId, String variantId, int quantity) async {
    if (quantity <= 0) {
      await removeItem(productId, variantId);
      return;
    }
    final index = _items.indexWhere(
      (i) => i.productId == productId && i.variantId == variantId,
    );
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: quantity.clamp(1, AppConstants.maxCartQuantity),
      );
      notifyListeners();
      await _persist();
    }
  }

  Future<void> increment(String productId, String variantId) async {
    final current = quantityOf(productId, variantId);
    await updateQuantity(productId, variantId, current + 1);
  }

  Future<void> decrement(String productId, String variantId) async {
    final current = quantityOf(productId, variantId);
    await updateQuantity(productId, variantId, current - 1);
  }

  Future<bool> applyCoupon(String code) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock coupons
    final mockCoupons = {
      'SAVE10': CouponModel(
        id: '1', code: 'SAVE10', title: '10% Off',
        description: '10% off on orders above ₹500',
        type: CouponType.percentage, value: 10, maxDiscount: 100,
        minOrderValue: 500, validTill: DateTime.now().add(const Duration(days: 30)),
      ),
      'WELCOME20': CouponModel(
        id: '2', code: 'WELCOME20', title: '20% Off',
        description: '20% off for new users, max ₹100',
        type: CouponType.percentage, value: 20, maxDiscount: 100,
        minOrderValue: 0, validTill: DateTime.now().add(const Duration(days: 60)),
      ),
      'FREESHIP': CouponModel(
        id: '3', code: 'FREESHIP', title: 'Free Delivery',
        description: 'Free delivery on this order',
        type: CouponType.freeDelivery, value: 49,
        minOrderValue: 199, validTill: DateTime.now().add(const Duration(days: 15)),
      ),
      'DIWALI30': CouponModel(
        id: '4', code: 'DIWALI30', title: '30% Off',
        description: 'Diwali special! 30% off on gift packs',
        type: CouponType.percentage, value: 30, maxDiscount: 200,
        minOrderValue: 599, validTill: DateTime.now().add(const Duration(days: 7)),
      ),
    };

    _isLoading = false;
    final coupon = mockCoupons[code.toUpperCase()];
    if (coupon != null) {
      if (subtotal < coupon.minOrderValue) {
        _error = 'Minimum order of ₹${coupon.minOrderValue.toInt()} required';
        notifyListeners();
        return false;
      }
      _appliedCoupon = coupon;
      notifyListeners();
      return true;
    } else {
      _error = 'Invalid or expired coupon code';
      notifyListeners();
      return false;
    }
  }

  void removeCoupon() {
    _appliedCoupon = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> clear() async {
    _items.clear();
    _appliedCoupon = null;
    notifyListeners();
    await _persist();
  }
}
