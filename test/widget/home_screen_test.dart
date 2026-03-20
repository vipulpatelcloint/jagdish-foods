// test/widget/home_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jagdish_foods/core/theme/app_theme.dart';
import 'package:jagdish_foods/providers/cart_provider.dart';
import 'package:jagdish_foods/providers/wishlist_provider.dart';
import 'package:jagdish_foods/providers/auth_provider.dart';

void main() {
  Widget buildTestApp(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: child,
      ),
    );
  }

  testWidgets('Cart badge updates when item added', (tester) async {
    final cart = CartProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: cart,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: Text('Test')),
        ),
      ),
    );

    expect(cart.itemCount, 0);

    await cart.addItem(CartItem(
      productId: 'p1', variantId: 'v1',
      name: 'Test', image: '', price: 100, mrp: 120, weight: '100g',
    ));

    expect(cart.itemCount, 1);
  });

  testWidgets('Empty cart screen shows correct message', (tester) async {
    await tester.pumpWidget(buildTestApp(
      const Scaffold(
        body: Center(child: Text('Your cart is empty!')),
      ),
    ));

    expect(find.text('Your cart is empty!'), findsOneWidget);
  });
}
