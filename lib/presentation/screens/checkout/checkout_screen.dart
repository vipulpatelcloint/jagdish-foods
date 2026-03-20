// lib/presentation/screens/checkout/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/models.dart';
import '../../../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedAddressIndex = 0;
  int _selectedDelivery = 0; // 0=express, 1=standard
  int _selectedPayment = 0; // 0=UPI, 1=Card, 2=COD
  bool _placing = false;

  final List<AddressModel> _addresses = const [
    AddressModel(id: 'a1', label: 'Home', recipientName: 'Rajesh Patel',
      phone: '+91 98765 43210', line1: '12, Shyamal Society, Alkapuri',
      city: 'Vadodara', state: 'Gujarat', pincode: '390007', isDefault: true),
    AddressModel(id: 'a2', label: 'Work', recipientName: 'Rajesh Patel',
      phone: '+91 98765 43210', line1: 'Plot 45, GIDC, Makarpura',
      city: 'Vadodara', state: 'Gujarat', pincode: '390010'),
  ];

  final List<Map<String, dynamic>> _deliveryOptions = [
    {'label': 'Express Delivery', 'subtitle': 'Delivered in 2–4 hours', 'price': '₹49', 'icon': Icons.bolt_rounded},
    {'label': 'Standard Delivery', 'subtitle': 'Tomorrow by 7 PM', 'price': 'FREE', 'icon': Icons.schedule_rounded},
  ];

  final List<Map<String, dynamic>> _paymentOptions = [
    {'label': 'UPI Payment', 'subtitle': 'GPay, PhonePe, Paytm', 'emoji': '📱', 'color': 0xFFE6F4FB},
    {'label': 'Credit / Debit Card', 'subtitle': 'Visa, Mastercard, RuPay', 'emoji': '💳', 'color': 0xFFFCE4EC},
    {'label': 'Cash on Delivery', 'subtitle': 'Pay when delivered', 'emoji': '💵', 'color': 0xFFFFF8E1},
  ];

  Future<void> _placeOrder() async {
    setState(() => _placing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final cart = context.read<CartProvider>();
    await cart.clear();
    context.go('/order-success/JF2024-8834');
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Checkout'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _CheckoutSteps(currentStep: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Address section
                _SectionCard(
                  title: '📍 Delivery Address',
                  action: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 14),
                    label: const Text('Add New'),
                  ),
                  child: Column(
                    children: List.generate(_addresses.length, (i) {
                      final addr = _addresses[i];
                      final isSelected = i == _selectedAddressIndex;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedAddressIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(bottom: i < _addresses.length - 1 ? 8 : 0),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryLight : AppColors.creamLight,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 18, height: 18,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: isSelected ? AppColors.primary : AppColors.textLight, width: 2),
                                ),
                                child: isSelected
                                    ? Center(child: Container(width: 8, height: 8,
                                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)))
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isSelected ? AppColors.primary : AppColors.textLight,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(addr.label.toUpperCase(),
                                        style: const TextStyle(fontFamily: 'DMSans', fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(addr.recipientName, style: AppTextStyles.labelMedium),
                                    Text(addr.fullAddress, style: AppTextStyles.bodySmall, maxLines: 2),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 12),

                // Delivery option
                _SectionCard(
                  title: '🚚 Delivery Option',
                  child: Column(
                    children: List.generate(_deliveryOptions.length, (i) {
                      final opt = _deliveryOptions[i];
                      final isSelected = i == _selectedDelivery;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDelivery = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(bottom: i < _deliveryOptions.length - 1 ? 8 : 0),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryLight : Colors.white,
                            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 2 : 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                                child: Icon(opt['icon'] as IconData, color: AppColors.primary, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(opt['label'], style: AppTextStyles.labelMedium),
                                    Text(opt['subtitle'], style: AppTextStyles.bodySmall),
                                  ],
                                ),
                              ),
                              Text(opt['price'], style: AppTextStyles.labelMedium.copyWith(
                                color: opt['price'] == 'FREE' ? AppColors.green : AppColors.textDark,
                              )),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 12),

                // Payment
                _SectionCard(
                  title: '💳 Payment Method',
                  child: Column(
                    children: List.generate(_paymentOptions.length, (i) {
                      final opt = _paymentOptions[i];
                      final isSelected = i == _selectedPayment;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedPayment = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(bottom: i < _paymentOptions.length - 1 ? 8 : 0),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryLight : Colors.white,
                            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 2 : 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(color: Color(opt['color']), borderRadius: BorderRadius.circular(10)),
                                child: Center(child: Text(opt['emoji'], style: const TextStyle(fontSize: 18))),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(opt['label'], style: AppTextStyles.labelMedium),
                                    Text(opt['subtitle'], style: AppTextStyles.bodySmall),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  width: 18, height: 18,
                                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                                )
                              else
                                Container(
                                  width: 18, height: 18,
                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.border, width: 2)),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 12),

                // Order summary card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order Total', style: AppTextStyles.labelMedium),
                          Text('${cart.itemCount} items · Incl. all taxes', style: AppTextStyles.bodySmall),
                        ],
                      ),
                      const Spacer(),
                      Text('₹${cart.finalTotal.toInt()}', style: AppTextStyles.priceHero),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Place order
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))],
            ),
            child: ElevatedButton.icon(
              onPressed: _placing ? null : _placeOrder,
              icon: _placing
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.lock_rounded),
              label: Text(_placing ? 'Placing Order...' : 'Place Order · ₹${cart.finalTotal.toInt()}'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutSteps extends StatelessWidget {
  final int currentStep;
  const _CheckoutSteps({required this.currentStep});

  static const List<String> steps = ['Cart', 'Address', 'Payment', 'Done'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Expanded(
              child: Container(height: 2,
                color: i ~/ 2 < currentStep ? Colors.white : Colors.white30,
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final isDone = stepIndex < currentStep;
          final isActive = stepIndex == currentStep;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: isDone ? const Color(0xFF52B52A) : isActive ? Colors.white : Colors.white30,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : Text('${stepIndex + 1}', style: TextStyle(
                          fontFamily: 'DMSans', fontSize: 12, fontWeight: FontWeight.w700,
                          color: isActive ? AppColors.primary : Colors.white,
                        )),
                ),
              ),
              const SizedBox(height: 3),
              Text(steps[stepIndex], style: TextStyle(
                fontFamily: 'DMSans', fontSize: 9, fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.white60,
              )),
            ],
          );
        }),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? action;
  const _SectionCard({required this.title, required this.child, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text(title, style: AppTextStyles.labelLarge),
              const Spacer(),
              if (action != null) action!,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ─── Order Success Screen ─────────────────────────────────────────────────
class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(top: -40, right: -40, child: Container(width: 200, height: 200,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle))),
              Positioned(bottom: -60, left: -60, child: Container(width: 250, height: 250,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), shape: BoxShape.circle))),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success animation
                    Container(
                      width: 110, height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                      ),
                      child: const Center(child: Text('🎉', style: TextStyle(fontSize: 50))),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 1500.ms),

                    const SizedBox(height: 24),

                    const Text('Order Placed!',
                      style: TextStyle(fontFamily: 'PlayfairDisplay', color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),

                    const SizedBox(height: 8),
                    Text(
                      'Your Jagdish snacks are being packed\nwith love and care 🥐',
                      style: TextStyle(fontFamily: 'DMSans', color: Colors.white.withOpacity(0.8), fontSize: 14),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 400.ms),

                    const SizedBox(height: 32),

                    // Order details card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _SuccessRow('Order ID', '#$orderId', isHighlight: true),
                          _SuccessRow('Total Paid', '₹647 (UPI)', isHighlight: true),
                          _SuccessRow('Items', '3 items · 4 packs'),
                          _SuccessRow('Delivery To', 'Alkapuri, Vadodara'),
                          _SuccessRow('ETA', 'Today, 2:00 – 4:00 PM'),
                        ],
                      ),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),

                    const SizedBox(height: 24),

                    OutlinedButton.icon(
                      onPressed: () => context.go('/orders/JF2024-8834/tracking'),
                      icon: const Icon(Icons.location_on_rounded, color: Colors.white),
                      label: const Text('Track My Order', style: TextStyle(color: Colors.white)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white54, width: 2),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ).animate().fadeIn(delay: 700.ms),

                    const SizedBox(height: 12),

                    ElevatedButton.icon(
                      onPressed: () => context.go(AppRoutes.home),
                      icon: const Icon(Icons.storefront_rounded),
                      label: const Text('Continue Shopping'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ).animate().fadeIn(delay: 800.ms),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;
  const _SuccessRow(this.label, this.value, {this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          const Spacer(),
          Text(value, style: AppTextStyles.labelSmall.copyWith(
            color: isHighlight ? AppColors.primary : AppColors.textDark,
            fontSize: 12,
          )),
        ],
      ),
    );
  }
}
