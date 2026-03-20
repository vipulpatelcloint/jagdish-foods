// lib/presentation/screens/orders/order_tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Track Order'),
            Text('Order #$orderId',
                style: const TextStyle(fontSize: 11, color: Colors.white70, fontFamily: 'DMSans')),
          ],
        ),
      ),
      body: Column(
        children: [
          // Map placeholder
          Container(
            height: 180,
            color: const Color(0xFFE8F4FD),
            child: Stack(
              children: [
                // Route line
                Center(
                  child: Container(
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 60),
                    decoration: BoxDecoration(
                      gradient: AppColors.greenGradient,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Start dot
                Positioned(
                  left: 60,
                  top: 87,
                  child: Container(
                    width: 14, height: 14,
                    decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)]),
                  ),
                ),
                // End dot
                Positioned(
                  right: 60,
                  top: 87,
                  child: Container(
                    width: 14, height: 14,
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)]),
                  ),
                ),
                // Rider
                Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 20,
                  top: 72,
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: const Center(child: Text('🛵', style: TextStyle(fontSize: 18))),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveX(begin: -20, end: 20, duration: 2000.ms, curve: Curves.easeInOut),
                ),
                // Labels
                const Positioned(
                  left: 44, bottom: 30,
                  child: Text('📦 Warehouse', style: TextStyle(fontFamily: 'DMSans', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
                ),
                const Positioned(
                  right: 20, bottom: 30,
                  child: Text('🏠 Your Home', style: TextStyle(fontFamily: 'DMSans', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ETA card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Estimated Arrival', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                            Text('1:45 PM', style: AppTextStyles.displayMedium.copyWith(color: AppColors.primary, fontFamily: 'DMSans')),
                            Text('Today · Approx 45 min', style: AppTextStyles.bodySmall),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Delivery Partner', style: AppTextStyles.bodySmall),
                            Text('Ramesh D.', style: AppTextStyles.labelLarge),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _ContactBtn(label: '📞 Call', color: AppColors.primary, onTap: () {}),
                                const SizedBox(width: 6),
                                _ContactBtn(label: '💬 Chat', color: AppColors.green, onTap: () {}),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2),

                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Order Timeline', style: AppTextStyles.headlineSmall),
                  ),
                  const SizedBox(height: 16),

                  // Timeline
                  _TimelineItem(
                    emoji: '✅', label: 'Order Placed',
                    subtitle: 'Payment confirmed', time: '12:10 PM',
                    state: _TileState.done,
                  ),
                  _TimelineItem(
                    emoji: '✅', label: 'Order Confirmed',
                    subtitle: 'Jagdish Foods accepted your order', time: '12:12 PM',
                    state: _TileState.done,
                  ),
                  _TimelineItem(
                    emoji: '✅', label: 'Being Packed',
                    subtitle: 'Your snacks are being packed fresh', time: '12:28 PM',
                    state: _TileState.done,
                  ),
                  _TimelineItem(
                    emoji: '🛵', label: 'Out for Delivery',
                    subtitle: 'Ramesh is on the way to your location', time: '12:55 PM · Now',
                    state: _TileState.active,
                  ),
                  _TimelineItem(
                    emoji: '🏠', label: 'Delivered',
                    subtitle: 'Estimated at 1:45 PM', time: '',
                    state: _TileState.pending,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _TileState { done, active, pending }

class _TimelineItem extends StatelessWidget {
  final String emoji, label, subtitle, time;
  final _TileState state;
  final bool isLast;

  const _TimelineItem({
    required this.emoji, required this.label, required this.subtitle,
    required this.time, required this.state, this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 34,
            child: Column(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: state == _TileState.done
                        ? AppColors.green
                        : state == _TileState.active
                            ? AppColors.primary
                            : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: state == _TileState.pending ? AppColors.border : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(emoji,
                        style: TextStyle(fontSize: state == _TileState.pending ? 14 : 14)),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: state == _TileState.done ? AppColors.green : AppColors.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.labelMedium.copyWith(
                    color: state == _TileState.active ? AppColors.primary : AppColors.textDark,
                  )),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                  if (time.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(time, style: AppTextStyles.bodySmall.copyWith(
                      color: state == _TileState.active ? AppColors.primary : AppColors.textLight,
                      fontWeight: FontWeight.w600,
                    )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.1);
  }
}

class _ContactBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ContactBtn({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label, style: const TextStyle(fontFamily: 'DMSans', fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }
}

// ─── Order List Screen ─────────────────────────────────────────────────────
class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  static const _mockOrders = [
    {'id': 'JF2024-8834', 'date': '20 Mar 2026', 'items': 3, 'total': 647, 'status': 'Delivered', 'statusColor': 0xFF52B52A},
    {'id': 'JF2024-8791', 'date': '12 Mar 2026', 'items': 2, 'total': 380, 'status': 'Delivered', 'statusColor': 0xFF52B52A},
    {'id': 'JF2024-8722', 'date': '1 Mar 2026', 'items': 5, 'total': 1120, 'status': 'Delivered', 'statusColor': 0xFF52B52A},
    {'id': 'JF2024-8650', 'date': '18 Feb 2026', 'items': 1, 'total': 220, 'status': 'Cancelled', 'statusColor': 0xFFE53935},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('My Orders')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _mockOrders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final o = _mockOrders[i];
          return GestureDetector(
            onTap: () => context.push('/orders/${o['id']}'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('#${o['id']}', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(o['statusColor'] as int).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(o['status'] as String,
                          style: TextStyle(fontFamily: 'DMSans', fontSize: 11, fontWeight: FontWeight.w700,
                              color: Color(o['statusColor'] as int))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${o['items']} items', style: AppTextStyles.bodyMedium),
                        Text(o['date'] as String, style: AppTextStyles.bodySmall),
                      ]),
                      const Spacer(),
                      Text('₹${o['total']}', style: AppTextStyles.priceLarge),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.push('/orders/${o['id']}/tracking'),
                          style: OutlinedButton.styleFrom(minimumSize: const Size(0, 38), padding: EdgeInsets.zero),
                          child: const Text('Track'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(minimumSize: const Size(0, 38), padding: EdgeInsets.zero),
                          child: const Text('Reorder'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (i * 80).ms).slideY(begin: 0.1),
          );
        },
      ),
    );
  }
}

// ─── Order Detail Screen ───────────────────────────────────────────────────
class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: Text('Order #$orderId')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DetailCard(title: 'Order Status', child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: AppColors.greenLight, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.green, size: 18),
                const SizedBox(width: 6),
                Text('Delivered on 20 Mar 2026', style: AppTextStyles.labelMedium.copyWith(color: AppColors.greenDeep)),
              ],
            ),
          )),
          const SizedBox(height: 12),
          _DetailCard(title: 'Items Ordered', child: Column(
            children: [
              _OrderItemRow('🥐', 'Bhakharwadi Classic 250g', 2, 360),
              _OrderItemRow('🌾', 'Spicy Chevdo Mix 400g', 1, 220),
              _OrderItemRow('🫓', 'Masala Khakhra 200g', 1, 145),
            ],
          )),
          const SizedBox(height: 12),
          _DetailCard(title: 'Delivery Address', child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rajesh Patel', style: AppTextStyles.labelMedium),
              const SizedBox(height: 2),
              Text('12, Shyamal Society, Alkapuri, Vadodara - 390007, Gujarat', style: AppTextStyles.bodySmall),
            ],
          )),
          const SizedBox(height: 12),
          _DetailCard(title: 'Payment Summary', child: Column(
            children: [
              _SummaryRow('Subtotal', '₹725'),
              _SummaryRow('Discount', '−₹40', isGreen: true),
              _SummaryRow('Coupon (SAVE10)', '−₹58', isGreen: true),
              _SummaryRow('Delivery', 'FREE', isGreen: true),
              const Divider(height: 16),
              _SummaryRow('Total Paid', '₹647', isBold: true),
              _SummaryRow('Payment', 'UPI (GPay)'),
            ],
          )),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _DetailCard({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppColors.cardShadow),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppTextStyles.labelLarge),
        const SizedBox(height: 12),
        child,
      ]),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final String emoji, name;
  final int qty;
  final double price;
  const _OrderItemRow(this.emoji, this.name, this.qty, this.price);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: AppTextStyles.labelSmall.copyWith(fontSize: 12, color: AppColors.textDark)),
            Text('Qty: $qty', style: AppTextStyles.bodySmall),
          ])),
          Text('₹${price.toInt()}', style: AppTextStyles.priceMedium.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final bool isGreen, isBold;
  const _SummaryRow(this.label, this.value, {this.isGreen = false, this.isBold = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(fontWeight: isBold ? FontWeight.w700 : FontWeight.w400)),
          const Spacer(),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(
            color: isGreen ? AppColors.green : isBold ? AppColors.primary : AppColors.textDark,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
          )),
        ],
      ),
    );
  }
}
