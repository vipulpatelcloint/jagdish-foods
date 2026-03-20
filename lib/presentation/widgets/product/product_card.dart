// lib/presentation/widgets/product/product_card.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/models.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _added = false;

  static const _emojis = {'1': '🥐', '2': '🌾', '3': '🪢', '4': '🫓', '5': '🍬', '6': '🎁'};
  static const _bgColors = {
    '1': Color(0xFFFFF3CD), '2': Color(0xFFD4EDFF),
    '3': Color(0xFFD4F5C4), '4': Color(0xFFFFE0D0),
    '5': Color(0xFFF3E8FF), '6': Color(0xFFFFF3CD),
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 1, end: 0.92).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleAddToCart() async {
    _controller.forward().then((_) => _controller.reverse());
    final cart = context.read<CartProvider>();
    await cart.addItem(CartItem(
      productId: widget.product.id,
      variantId: widget.product.defaultVariant.id,
      name: widget.product.name,
      image: '',
      price: widget.product.defaultVariant.sellingPrice,
      mrp: widget.product.defaultVariant.mrp,
      weight: widget.product.defaultVariant.weight,
    ));
    setState(() => _added = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _added = false);
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.product.defaultVariant;
    final emoji = _emojis[widget.product.categoryId] ?? '🥐';
    final bg = _bgColors[widget.product.categoryId] ?? const Color(0xFFFFF3CD);

    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 155,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: AppColors.cardShadow,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area
              Stack(
                children: [
                  Container(
                    height: 106,
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                    child: Center(child: Text(emoji, style: const TextStyle(fontSize: 52))),
                  ),
                  if (widget.product.isBestSeller)
                    Positioned(top: 8, left: 8, child: _Badge(label: '⭐ BEST', color: AppColors.yellow, textColor: AppColors.textDark)),
                  if (widget.product.isNew)
                    Positioned(top: 8, left: 8, child: _Badge(label: '✨ NEW', color: AppColors.green, textColor: Colors.white)),
                ],
              ),
              // Info area
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.product.name,
                        style: AppTextStyles.labelSmall.copyWith(fontSize: 12, color: AppColors.textDark),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(v.weight, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('₹${v.sellingPrice.toInt()}',
                                style: AppTextStyles.priceMedium),
                            if (v.hasDiscount)
                              Text('₹${v.mrp.toInt()}',
                                  style: AppTextStyles.priceStrike),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _handleAddToCart,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              color: _added ? AppColors.green : AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _added ? Icons.check : Icons.add,
                              color: Colors.white, size: 16,
                            ),
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
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color, textColor;
  const _Badge({required this.label, required this.color, required this.textColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(fontFamily: 'DMSans', fontSize: 8, fontWeight: FontWeight.w800, color: textColor)),
    );
  }
}
