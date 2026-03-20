// lib/core/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/auth/splash_screen.dart';
import '../../presentation/screens/auth/welcome_screen.dart';
import '../../presentation/screens/auth/phone_auth_screen.dart';
import '../../presentation/screens/auth/otp_screen.dart';
import '../../presentation/screens/auth/profile_setup_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/product/product_detail_screen.dart';
import '../../presentation/screens/product/category_screen.dart';
import '../../presentation/screens/cart/cart_screen.dart';
import '../../presentation/screens/checkout/checkout_screen.dart';
import '../../presentation/screens/checkout/order_success_screen.dart';
import '../../presentation/screens/orders/order_list_screen.dart';
import '../../presentation/screens/orders/order_detail_screen.dart';
import '../../presentation/screens/orders/order_tracking_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/profile/edit_profile_screen.dart';
import '../../presentation/screens/profile/address_screen.dart';
import '../../presentation/screens/wishlist/wishlist_screen.dart';
import '../../presentation/screens/offers/offers_screen.dart';
import '../../presentation/screens/home/search_screen.dart';
import '../../presentation/screens/home/main_shell.dart';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String phoneAuth = '/auth/phone';
  static const String otp = '/auth/otp';
  static const String profileSetup = '/auth/profile-setup';
  static const String home = '/home';
  static const String search = '/search';
  static const String category = '/category/:id';
  static const String productDetail = '/product/:id';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success/:orderId';
  static const String orders = '/orders';
  static const String orderDetail = '/orders/:orderId';
  static const String orderTracking = '/orders/:orderId/tracking';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String addresses = '/profile/addresses';
  static const String wishlist = '/wishlist';
  static const String offers = '/offers';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.welcome,
      pageBuilder: (context, state) => buildPageWithFade(
        context, state, const WelcomeScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.phoneAuth,
      pageBuilder: (context, state) => buildPageWithSlide(
        context, state, const PhoneAuthScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.otp,
      pageBuilder: (context, state) => buildPageWithSlide(
        context, state, OtpScreen(phone: state.extra as String? ?? ''),
      ),
    ),
    GoRoute(
      path: AppRoutes.profileSetup,
      pageBuilder: (context, state) => buildPageWithSlide(
        context, state, const ProfileSetupScreen(),
      ),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) => NoTransitionPage(
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/categories',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const CategoryListShell(),
          ),
        ),
        GoRoute(
          path: AppRoutes.cart,
          pageBuilder: (context, state) => NoTransitionPage(
            child: const CartScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.orders,
          pageBuilder: (context, state) => NoTransitionPage(
            child: const OrderListScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.profile,
          pageBuilder: (context, state) => NoTransitionPage(
            child: const ProfileScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.search,
      pageBuilder: (context, state) => buildPageWithSlide(
        context, state, const SearchScreen(),
      ),
    ),
    GoRoute(
      path: '/category/:id',
      pageBuilder: (context, state) => buildPageWithSlide(
        context, state, CategoryScreen(categoryId: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/product/:id',
      pageBuilder: (context, state) => buildPageWithSlide(
        context, state, ProductDetailScreen(productId: state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: AppRoutes.checkout,
      pageBuilder: (context, state) => buildPageWithSlide(
        context, state, const CheckoutScreen(),
      ),
    ),
    GoRoute(
      path: '/order-success/:orderId',
      pageBuilder: (context, state) => buildPageWithFade(
        context, state,
        OrderSuccessScreen(orderId: state.pathParameters['orderId']!),
      ),
    ),
    GoRoute(
      path: '/orders/:orderId',
      pageBuilder: (context, state) => buildPageWithSlide(
        context, state,
        OrderDetailScreen(orderId: state.pathParameters['orderId']!),
      ),
    ),
    GoRoute(
      path: '/orders/:orderId/tracking',
      pageBuilder: (context, state) => buildPageWithSlide(
        context, state,
        OrderTrackingScreen(orderId: state.pathParameters['orderId']!),
      ),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      pageBuilder: (context, state) => buildPageWithSlide(
        context, state, const EditProfileScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.addresses,
      pageBuilder: (context, state) => buildPageWithSlide(
        context, state, const AddressScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.wishlist,
      pageBuilder: (context, state) => buildPageWithSlide(
        context, state, const WishlistScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.offers,
      pageBuilder: (context, state) => buildPageWithSlide(
        context, state, const OffersScreen(),
      ),
    ),
  ],
);

CustomTransitionPage buildPageWithFade(
    BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (ctx, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
    transitionDuration: const Duration(milliseconds: 350),
  );
}

CustomTransitionPage buildPageWithSlide(
    BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
    transitionDuration: const Duration(milliseconds: 350),
  );
}

class CategoryListShell extends StatelessWidget {
  const CategoryListShell({super.key});
  @override
  Widget build(BuildContext context) => const CategoryScreen(categoryId: 'all');
}
