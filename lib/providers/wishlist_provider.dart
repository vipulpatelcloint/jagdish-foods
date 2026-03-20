// lib/providers/wishlist_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/models.dart';
import '../core/constants/app_constants.dart';

class WishlistProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];

  List<ProductModel> get items => List.unmodifiable(_items);
  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;

  bool isWishlisted(String productId) =>
      _items.any((p) => p.id == productId);

  Future<void> init() async {
    // Load from prefs (simplified - store just IDs, fetch from cache)
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = prefs.getStringList(AppConstants.kWishlistBox) ?? [];
      // In real app: fetch product details from cache/API
      notifyListeners();
    } catch (_) {}
  }

  Future<void> toggle(ProductModel product) async {
    if (isWishlisted(product.id)) {
      _items.removeWhere((p) => p.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> remove(String productId) async {
    _items.removeWhere((p) => p.id == productId);
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        AppConstants.kWishlistBox,
        _items.map((p) => p.id).toList(),
      );
    } catch (_) {}
  }
}
