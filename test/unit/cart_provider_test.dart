// test/unit/cart_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:jagdish_foods/data/models/models.dart';
import 'package:jagdish_foods/providers/cart_provider.dart';

void main() {
  group('CartProvider', () {
    late CartProvider cartProvider;

    final testItem = CartItem(
      productId: 'p1',
      variantId: 'v1',
      name: 'Bhakharwadi Classic',
      image: '',
      price: 180.0,
      mrp: 220.0,
      weight: '250g',
    );

    setUp(() {
      cartProvider = CartProvider();
    });

    test('starts empty', () {
      expect(cartProvider.isEmpty, isTrue);
      expect(cartProvider.itemCount, 0);
      expect(cartProvider.subtotal, 0.0);
    });

    test('adds item correctly', () async {
      await cartProvider.addItem(testItem);
      expect(cartProvider.itemCount, 1);
      expect(cartProvider.items.first.name, 'Bhakharwadi Classic');
    });

    test('increments quantity when same item added', () async {
      await cartProvider.addItem(testItem);
      await cartProvider.addItem(testItem);
      expect(cartProvider.itemCount, 2);
      expect(cartProvider.items.length, 1);
    });

    test('removes item', () async {
      await cartProvider.addItem(testItem);
      await cartProvider.removeItem('p1', 'v1');
      expect(cartProvider.isEmpty, isTrue);
    });

    test('updates quantity', () async {
      await cartProvider.addItem(testItem);
      await cartProvider.updateQuantity('p1', 'v1', 3);
      expect(cartProvider.items.first.quantity, 3);
    });

    test('removes item when quantity set to 0', () async {
      await cartProvider.addItem(testItem);
      await cartProvider.updateQuantity('p1', 'v1', 0);
      expect(cartProvider.isEmpty, isTrue);
    });

    test('calculates subtotal correctly', () async {
      await cartProvider.addItem(testItem);
      await cartProvider.updateQuantity('p1', 'v1', 2);
      expect(cartProvider.subtotal, 360.0); // 180 * 2
    });

    test('calculates product discount', () async {
      await cartProvider.addItem(testItem);
      expect(cartProvider.productDiscount, 40.0); // 220 - 180
    });

    test('free delivery when subtotal >= 299', () async {
      final expensiveItem = CartItem(
        productId: 'p2', variantId: 'v2', name: 'Test', image: '',
        price: 300.0, mrp: 350.0, weight: '500g',
      );
      await cartProvider.addItem(expensiveItem);
      expect(cartProvider.deliveryCharge, 0.0);
    });

    test('charges delivery when subtotal < 299', () async {
      await cartProvider.addItem(testItem);
      expect(cartProvider.deliveryCharge, 49.0);
    });

    test('caps quantity at maxCartQuantity', () async {
      await cartProvider.addItem(testItem);
      await cartProvider.updateQuantity('p1', 'v1', 999);
      expect(cartProvider.items.first.quantity, 10); // max = 10
    });

    test('clears cart', () async {
      await cartProvider.addItem(testItem);
      await cartProvider.clear();
      expect(cartProvider.isEmpty, isTrue);
    });

    test('applies valid coupon', () async {
      // Add item above min order value
      final item = CartItem(
        productId: 'p3', variantId: 'v3', name: 'Test', image: '',
        price: 600.0, mrp: 700.0, weight: '1kg',
      );
      await cartProvider.addItem(item);
      final success = await cartProvider.applyCoupon('SAVE10');
      expect(success, isTrue);
      expect(cartProvider.appliedCoupon, isNotNull);
      expect(cartProvider.couponDiscount, greaterThan(0));
    });

    test('rejects invalid coupon', () async {
      await cartProvider.addItem(testItem);
      final success = await cartProvider.applyCoupon('INVALID123');
      expect(success, isFalse);
      expect(cartProvider.appliedCoupon, isNull);
      expect(cartProvider.error, isNotNull);
    });

    test('removes coupon', () async {
      final item = CartItem(
        productId: 'p4', variantId: 'v4', name: 'Test', image: '',
        price: 600.0, mrp: 700.0, weight: '1kg',
      );
      await cartProvider.addItem(item);
      await cartProvider.applyCoupon('SAVE10');
      cartProvider.removeCoupon();
      expect(cartProvider.appliedCoupon, isNull);
    });
  });
}
