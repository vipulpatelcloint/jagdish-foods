// lib/presentation/screens/home/main_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../providers/cart_provider.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home_rounded, label: 'Home', path: '/home'),
    _NavItem(icon: Icons.grid_view_rounded, label: 'Categories', path: '/categories'),
    _NavItem(icon: Icons.shopping_cart_rounded, label: 'Cart', path: '/cart'),
    _NavItem(icon: Icons.receipt_long_rounded, label: 'Orders', path: '/orders'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile', path: '/profile'),
  ];

  int _getIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/categories') || location.startsWith('/category')) return 1;
    if (location.startsWith('/cart')) return 2;
    if (location.startsWith('/orders')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _getIndex(location);
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isActive = index == currentIndex;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => context.go(item.path),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (index == 2) // Cart with badge
                            badges.Badge(
                              showBadge: cartProvider.itemCount > 0,
                              badgeContent: Text(
                                cartProvider.itemCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              badgeStyle: const badges.BadgeStyle(
                                badgeColor: AppColors.yellow,
                                padding: EdgeInsets.all(4),
                              ),
                              child: Icon(
                                item.icon,
                                color: isActive ? AppColors.primary : AppColors.textLight,
                                size: 24,
                              ),
                            )
                          else
                            Icon(
                              item.icon,
                              color: isActive ? AppColors.primary : AppColors.textLight,
                              size: 24,
                            ),
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 10,
                              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                              color: isActive ? AppColors.primary : AppColors.textLight,
                            ),
                          ),
                          if (isActive)
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              width: 18,
                              height: 3,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String path;
  const _NavItem({required this.icon, required this.label, required this.path});
}
