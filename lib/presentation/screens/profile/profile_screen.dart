// lib/presentation/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.heroGradient),
                child: Stack(children: [
                  Positioned(top: -30, right: -30, child: Container(width: 160, height: 160,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle))),
                  SafeArea(child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 64, height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                              ),
                              child: const Center(child: Text('👤', style: TextStyle(fontSize: 28))),
                            ),
                            const SizedBox(width: 14),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user?.name ?? 'Guest User',
                                    style: const TextStyle(fontFamily: 'PlayfairDisplay', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                                Text(user?.phone ?? '',
                                    style: TextStyle(fontFamily: 'DMSans', color: Colors.white.withOpacity(0.8), fontSize: 12)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(10)),
                                  child: const Text('⭐ Gold Member', style: TextStyle(fontFamily: 'DMSans', fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                                ),
                              ],
                            )),
                            IconButton(
                              onPressed: () => context.push(AppRoutes.editProfile),
                              icon: const Icon(Icons.edit_rounded, color: Colors.white70, size: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Stats
                        Container(
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
                          child: Row(children: [
                            _StatItem('${user?.totalOrders ?? 0}', 'Orders'),
                            Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
                            _StatItem('4.8', 'Avg Rating'),
                            Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
                            _StatItem('₹${user?.totalSaved.toInt() ?? 0}', 'Saved'),
                          ]),
                        ),
                      ],
                    ),
                  )),
                ]),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                _MenuGroup(title: 'MY ACCOUNT', items: [
                  _MenuItem(icon: '✏️', label: 'Edit Profile', color: AppColors.primaryLight, onTap: () => context.push(AppRoutes.editProfile)),
                  _MenuItem(icon: '📍', label: 'Saved Addresses', color: AppColors.primaryLight, onTap: () => context.push(AppRoutes.addresses)),
                  _MenuItem(icon: '❤️', label: 'My Wishlist', color: const Color(0xFFFCE4EC), badge: '12', onTap: () => context.push(AppRoutes.wishlist)),
                ]),
                const SizedBox(height: 12),
                _MenuGroup(title: 'ORDERS & OFFERS', items: [
                  _MenuItem(icon: '📦', label: 'My Orders', color: AppColors.primaryLight, onTap: () => context.go(AppRoutes.orders)),
                  _MenuItem(icon: '🏷️', label: 'Offers & Coupons', color: AppColors.yellowLight, badge: '3 Active', onTap: () => context.push(AppRoutes.offers)),
                  _MenuItem(icon: '🎁', label: 'Festive Gift Packs', color: AppColors.greenLight, onTap: () {}),
                  _MenuItem(icon: '📋', label: 'Bulk Orders', color: AppColors.primaryLight, onTap: () {}),
                ]),
                const SizedBox(height: 12),
                _MenuGroup(title: 'SUPPORT', items: [
                  _MenuItem(icon: '💬', label: 'Help & Support', color: AppColors.primaryLight, onTap: () {}),
                  _MenuItem(icon: '⭐', label: 'Rate the App', color: AppColors.yellowLight, onTap: () {}),
                  _MenuItem(icon: 'ℹ️', label: 'About Jagdish Foods', color: AppColors.primaryLight, onTap: () {}),
                ]),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    showDialog(context: context, builder: (_) => AlertDialog(
                      title: const Text('Logout?'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        TextButton(onPressed: () { auth.logout(); Navigator.pop(context); context.go(AppRoutes.welcome); },
                          child: const Text('Logout', style: TextStyle(color: AppColors.error))),
                      ],
                    ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: const Color(0xFFFCE4EC), borderRadius: BorderRadius.circular(12)),
                    child: Row(children: [
                      Container(width: 36, height: 36,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: const Center(child: Text('🚪', style: TextStyle(fontSize: 18))),
                      ),
                      const SizedBox(width: 12),
                      const Text('Logout', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFC62828))),
                    ]),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Jagdish Foods v1.0.0', style: AppTextStyles.bodySmall),
                Text('Vadodara\'s Taste Since 1945', style: AppTextStyles.caption),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  const _StatItem(this.value, this.label);
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(children: [
        Text(value, style: const TextStyle(fontFamily: 'DMSans', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
        Text(label, style: TextStyle(fontFamily: 'DMSans', color: Colors.white.withOpacity(0.7), fontSize: 10)),
      ]),
    ));
  }
}

class _MenuGroup extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _MenuGroup({required this.title, required this.items});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(title, style: AppTextStyles.captionBold.copyWith(color: AppColors.textLight)),
      ),
      Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppColors.cardShadow),
        child: Column(children: items.asMap().entries.map((e) {
          final isLast = e.key == items.length - 1;
          return Column(children: [
            e.value,
            if (!isLast) const Divider(height: 1, indent: 60),
          ]);
        }).toList()),
      ),
    ]);
  }
}

class _MenuItem extends StatelessWidget {
  final String icon, label;
  final Color color;
  final String? badge;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label, required this.color, this.badge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(children: [
          Container(width: 36, height: 36,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 17)))),
          const SizedBox(width: 12),
          Text(label, style: AppTextStyles.labelMedium),
          const Spacer(),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(10)),
              child: Text(badge!, style: const TextStyle(fontFamily: 'DMSans', fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.textDark)),
            ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
        ]),
      ),
    );
  }
}

// Stub screens
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Edit Profile')), body: const Center(child: Text('Edit Profile')));
}

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('My Addresses')), body: const Center(child: Text('Addresses')));
}
