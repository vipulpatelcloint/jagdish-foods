// lib/presentation/screens/cart/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/cart_provider.dart';
import '../../widgets/common/jf_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponController = TextEditingController();
  bool _applyingCoupon = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Future<void> _applyCoupon() async {
    if (_couponController.text.isEmpty) return;
    setState(() => _applyingCoupon = true);
    final cart = context.read<CartProvider>();
    final success = await cart.applyCoupon(_couponController.text);
    setState(() => _applyingCoupon = false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success ? '🎉 Coupon applied! You save ₹${cart.couponDiscount.toInt()}' : cart.error ?? 'Invalid coupon'),
      backgroundColor: success ? AppColors.green : AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        if (cart.isEmpty) return const _EmptyCart();
        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          appBar: AppBar(
            title: const Text('My Cart'),
            actions: [
              TextButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Clear Cart?'),
                    content: const Text('Are you sure you want to remove all items?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () { cart.clear(); Navigator.pop(context); },
                        child: const Text('Clear', style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                ),
                child: Text('Clear All', style: AppTextStyles.labelSmall.copyWith(color: Colors.white70)),
              ),
            ],
          ),
          body: Column(
            children: [
              // Free delivery progress bar
              if (cart.amountToFreeDelivery > 0)
                Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: AppTextStyles.bodySmall,
                          children: [
                            const TextSpan(text: 'Add '),
                            TextSpan(
                              text: '₹${cart.amountToFreeDelivery.toInt()} more ',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary, fontWeight: FontWeight.w700,
                              ),
                            ),
                            const TextSpan(text: 'for FREE delivery 🚚'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (cart.subtotal / 299).clamp(0, 1),
                          backgroundColor: AppColors.border,
                          valueColor: const AlwaysStoppedAnimation(AppColors.green),
                          minHeight: 5,
                        ),
                      ),
                    ],
                  ),
                ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Cart items
                    ...cart.items.map((item) => _CartItemCard(
                      key: ValueKey('${item.productId}_${item.variantId}'),
                      item: item,
                      onIncrement: () => cart.increment(item.productId, item.variantId),
                      onDecrement: () => cart.decrement(item.productId, item.variantId),
                      onRemove: () => cart.removeItem(item.productId, item.variantId),
                    ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1)),

                    const SizedBox(height: 12),

                    // Coupon
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.5),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),
                          const Text('🏷️', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: cart.appliedCoupon != null
                                ? Row(
                                    children: [
                                      Text(cart.appliedCoupon!.code,
                                        style: AppTextStyles.labelLarge.copyWith(color: AppColors.green),
                                      ),
                                      const SizedBox(width: 6),
                                      Text('−₹${cart.couponDiscount.toInt()} saved!',
                                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.greenDeep),
                                      ),
                                    ],
                                  )
                                : TextField(
                                    controller: _couponController,
                                    textCapitalization: TextCapitalization.characters,
                                    style: AppTextStyles.labelMedium,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter coupon code',
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                          ),
                          cart.appliedCoupon != null
                              ? TextButton(
                                  onPressed: cart.removeCoupon,
                                  child: const Text('Remove', style: TextStyle(color: AppColors.error, fontSize: 12)),
                                )
                              : TextButton(
                                  onPressed: _applyingCoupon ? null : _applyCoupon,
                                  child: _applyingCoupon
                                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                      : const Text('Apply', style: TextStyle(fontWeight: FontWeight.w700)),
                                ),
                        ],
                      ),
                    ),

                    // Savings banner
                    if (cart.totalSavings > 0)
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.greenLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.green.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Text('🎉', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text(
                              'You\'re saving ₹${cart.totalSavings.toInt()} on this order!',
                              style: AppTextStyles.labelSmall.copyWith(color: AppColors.greenDeep, fontSize: 12),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 12),

                    // Price breakdown
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price Details', style: AppTextStyles.labelLarge),
                          const SizedBox(height: 14),
                          _PriceRow('MRP Total (${cart.itemCount} items)', '₹${cart.mrpTotal.toInt()}'),
                          _PriceRow('Product Discount', '−₹${cart.productDiscount.toInt()}', isGreen: true),
                          if (cart.couponDiscount > 0)
                            _PriceRow('Coupon (${cart.appliedCoupon!.code})', '−₹${cart.couponDiscount.toInt()}', isGreen: true),
                          _PriceRow(
                            'Delivery',
                            cart.deliveryCharge == 0 ? 'FREE 🎉' : '₹${cart.deliveryCharge.toInt()}',
                            isGreen: cart.deliveryCharge == 0,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(height: 1),
                          ),
                          Row(
                            children: [
                              Text('Total Amount', style: AppTextStyles.labelLarge),
                              const Spacer(),
                              Text('₹${cart.finalTotal.toInt()}',
                                style: AppTextStyles.priceLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),

              // Bottom CTA
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total', style: AppTextStyles.bodySmall),
                        Text('₹${cart.finalTotal.toInt()}', style: AppTextStyles.priceLarge),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.push(AppRoutes.checkout),
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('Proceed to Checkout'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 52),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('dismiss_${item.productId}_${item.variantId}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFFF3CD), Color(0xFFFFE090)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('🥐', style: TextStyle(fontSize: 36))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: AppTextStyles.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(item.weight, style: AppTextStyles.bodySmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('₹${(item.price * item.quantity).toInt()}',
                        style: AppTextStyles.priceMedium.copyWith(color: AppColors.primary),
                      ),
                      const Spacer(),
                      // Qty controls
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _QtyBtn(icon: Icons.remove, onTap: onDecrement),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('${item.quantity}',
                                style: AppTextStyles.labelMedium,
                              ),
                            ),
                            _QtyBtn(icon: Icons.add, onTap: onIncrement),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30, height: 30,
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isGreen;
  const _PriceRow(this.label, this.value, {this.isGreen = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          const Spacer(),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(
            color: isGreen ? AppColors.green : AppColors.textDark,
            fontWeight: FontWeight.w600,
          )),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🛒', style: TextStyle(fontSize: 80))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1000.ms),
            const SizedBox(height: 20),
            Text('Your cart is empty!', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text('Explore our authentic Gujarati snacks',
              style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.home),
                icon: const Icon(Icons.home_rounded),
                label: const Text('Start Shopping'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
