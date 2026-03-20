// lib/presentation/screens/product/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/models.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/wishlist_provider.dart';
import '../home/home_screen.dart' show _mockProducts;

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late ProductModel _product;
  late ProductVariant _selectedVariant;
  final _pageController = PageController();
  late TabController _tabController;
  int _currentImage = 0;
  bool _addingToCart = false;

  final List<String> _tabLabels = ['Description', 'Ingredients', 'Reviews'];

  @override
  void initState() {
    super.initState();
    _product = _mockProducts.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => _mockProducts.first,
    );
    _selectedVariant = _product.defaultVariant;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _addToCart() async {
    setState(() => _addingToCart = true);
    final cart = context.read<CartProvider>();
    await cart.addItem(CartItem(
      productId: _product.id,
      variantId: _selectedVariant.id,
      name: _product.name,
      image: _product.images.first,
      price: _selectedVariant.sellingPrice,
      mrp: _selectedVariant.mrp,
      weight: _selectedVariant.weight,
    ));
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _addingToCart = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${_product.name} added to cart! 🛒'),
      backgroundColor: AppColors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final isWishlisted = wishlist.isWishlisted(_product.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Image sliver
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: Colors.white,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                    onPressed: () => context.pop(),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isWishlisted ? Colors.red : AppColors.textLight,
                      ),
                      onPressed: () => wishlist.toggle(_product),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share_rounded, color: AppColors.textDark),
                      onPressed: () {},
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (i) => setState(() => _currentImage = i),
                        itemCount: 3,
                        itemBuilder: (context, i) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFFFF3CD),
                                const Color(0xFFFFE090),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '🥐',
                              style: const TextStyle(fontSize: 120),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 0, right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: i == _currentImage ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: i == _currentImage ? AppColors.primary : AppColors.border,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          )),
                        ),
                      ),
                      // Best seller badge
                      if (_product.isBestSeller)
                        Positioned(
                          top: kToolbarHeight + 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.yellow,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('⭐ BEST SELLER',
                              style: TextStyle(
                                fontFamily: 'DMSans', fontSize: 10,
                                fontWeight: FontWeight.w800, color: AppColors.textDark,
                              )),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name + veg
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(_product.name, style: AppTextStyles.headlineLarge),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.green, width: 1.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Container(
                              width: 10, height: 10,
                              decoration: const BoxDecoration(
                                color: AppColors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Veg / tags
                      Wrap(
                        spacing: 8,
                        children: [
                          _InfoChip(label: '🌿 Pure Veg', color: AppColors.greenLight, textColor: AppColors.greenDeep),
                          _InfoChip(label: '✅ No Preservatives', color: AppColors.blue_light, textColor: AppColors.primary),
                          _InfoChip(label: '🏆 FSSAI Certified', color: const Color(0xFFFFF8E1), textColor: AppColors.yellow),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('₹${_selectedVariant.sellingPrice.toInt()}',
                            style: AppTextStyles.priceHero,
                          ),
                          const SizedBox(width: 8),
                          if (_selectedVariant.hasDiscount) ...[
                            Text('₹${_selectedVariant.mrp.toInt()}',
                              style: AppTextStyles.priceStrike,
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.greenLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Save ${_selectedVariant.discount.toInt()}%',
                                style: const TextStyle(
                                  fontFamily: 'DMSans', fontSize: 11,
                                  fontWeight: FontWeight.w700, color: AppColors.greenDeep,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Rating
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: _product.rating,
                            itemBuilder: (_, __) => const Icon(Icons.star_rounded, color: AppColors.yellow),
                            itemSize: 18,
                          ),
                          const SizedBox(width: 8),
                          Text('${_product.rating}', style: AppTextStyles.labelMedium),
                          const SizedBox(width: 4),
                          Text('(${_product.reviewCount} reviews)',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Weight selector
                      Text('Select Weight', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textMedium)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: _product.variants.map((v) {
                          final isSelected = v.id == _selectedVariant.id;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedVariant = v),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryLight : Colors.white,
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(v.weight, style: TextStyle(
                                    fontFamily: 'DMSans', fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected ? AppColors.primary : AppColors.textDark,
                                  )),
                                  Text('₹${v.sellingPrice.toInt()}', style: TextStyle(
                                    fontFamily: 'DMSans', fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? AppColors.primary : AppColors.textMedium,
                                  )),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Trust badges
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                        ),
                        child: Row(
                          children: [
                            _TrustBadge(emoji: '🚚', title: 'Free Delivery', subtitle: 'Above ₹299'),
                            _TrustBadge(emoji: '🔄', title: 'Easy Returns', subtitle: '7 day policy'),
                            _TrustBadge(emoji: '🌿', title: 'Pure Veg', subtitle: 'No meat/egg'),
                            _TrustBadge(emoji: '✅', title: 'FSSAI', subtitle: 'Certified'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tab section
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.border)),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          tabs: _tabLabels.map((l) => Tab(text: l)).toList(),
                          labelStyle: AppTextStyles.labelMedium,
                          unselectedLabelStyle: AppTextStyles.bodyMedium,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.textLight,
                          indicatorColor: AppColors.primary,
                          indicatorWeight: 2,
                        ),
                      ),
                      const SizedBox(height: 14),

                      SizedBox(
                        height: 120,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Text(
                              '${_product.description}\n\n🕐 Shelf Life: ${_product.shelfLife}\n🌡️ Store in cool, dry place away from direct sunlight.',
                              style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Ingredients:', style: AppTextStyles.labelMedium),
                                const SizedBox(height: 6),
                                Text(
                                  _product.ingredients.join(', '),
                                  style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                                ),
                              ],
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RatingBarIndicator(
                                    rating: _product.rating,
                                    itemBuilder: (_, __) => const Icon(Icons.star_rounded, color: AppColors.yellow),
                                    itemSize: 24,
                                  ),
                                  const SizedBox(height: 6),
                                  Text('${_product.rating} out of 5',
                                    style: AppTextStyles.labelLarge,
                                  ),
                                  Text('Based on ${_product.reviewCount} reviews',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom CTA
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
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
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _addingToCart ? null : _addToCart,
                      icon: _addingToCart
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.add_shopping_cart_rounded),
                      label: Text(_addingToCart ? 'Adding...' : 'Add to Cart'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 52),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await _addToCart();
                        if (mounted) context.push(AppRoutes.checkout);
                      },
                      icon: const Icon(Icons.bolt_rounded),
                      label: const Text('Buy Now'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 52),
                        backgroundColor: AppColors.primary,
                        shadowColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.5, duration: 400.ms, curve: Curves.easeOut),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  const _InfoChip({required this.label, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(
        fontFamily: 'DMSans', fontSize: 11,
        fontWeight: FontWeight.w600, color: textColor,
      )),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final String emoji, title, subtitle;
  const _TrustBadge({required this.emoji, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontFamily: 'DMSans', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textDark), textAlign: TextAlign.center),
          Text(subtitle, style: const TextStyle(fontFamily: 'DMSans', fontSize: 9, color: AppColors.textLight), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// Extension on AppColors for blue_light
extension AppColorsExt on AppColors {
  static Color get blue_light => const Color(0xFFE6F4FB);
}
