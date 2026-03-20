// lib/presentation/screens/wishlist/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/models.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/wishlist_provider.dart';
import '../home/home_screen.dart' show _mockProducts;

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    // Use mock products for demo if wishlist is empty
    final items = wishlist.isEmpty ? _mockProducts : wishlist.items;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: Text('❤️ My Wishlist (${items.length})')),
      body: items.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('🤍', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text('No wishlisted items', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 8),
              Text('Tap the heart icon on any product', style: AppTextStyles.bodySmall),
            ]))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final product = items[i];
                return _WishCard(
                  product: product,
                  onRemove: () => wishlist.remove(product.id),
                  onAddToCart: () {
                    context.read<CartProvider>().addItem(CartItem(
                      productId: product.id, variantId: product.defaultVariant.id,
                      name: product.name, image: product.images.first,
                      price: product.defaultVariant.sellingPrice,
                      mrp: product.defaultVariant.mrp,
                      weight: product.defaultVariant.weight,
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${product.name} added to cart!'),
                      backgroundColor: AppColors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ));
                  },
                ).animate().fadeIn(delay: (i * 60).ms).scale(begin: const Offset(0.95, 0.95));
              },
            ),
    );
  }
}

class _WishCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onRemove, onAddToCart;
  static const _emojis = ['🥐', '🌾', '🪢', '🫓', '🍬'];
  static const _colors = [Color(0xFFFFF3CD), Color(0xFFD4EDFF), Color(0xFFD4F5C4), Color(0xFFFFE0D0), Color(0xFFF3E8FF)];

  const _WishCard({required this.product, required this.onRemove, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final idx = product.id.hashCode % 5;
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppColors.cardShadow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            Container(
              height: 110, width: double.infinity,
              decoration: BoxDecoration(color: _colors[idx.abs() % 5], borderRadius: const BorderRadius.vertical(top: Radius.circular(14))),
              child: Center(child: Text(_emojis[idx.abs() % 5], style: const TextStyle(fontSize: 52))),
            ),
            Positioned(top: 8, right: 8, child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 30, height: 30,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: AppColors.cardShadow),
                child: const Center(child: Text('❤️', style: TextStyle(fontSize: 14))),
              ),
            )),
          ]),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product.name, style: AppTextStyles.labelSmall.copyWith(fontSize: 12, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text('₹${product.defaultVariant.sellingPrice.toInt()}', style: AppTextStyles.priceMedium.copyWith(color: AppColors.primary)),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAddToCart,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(0, 34), padding: EdgeInsets.zero, textStyle: const TextStyle(fontSize: 11)),
                  child: const Text('Add to Cart'),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─── Offers Screen ─────────────────────────────────────────────────────────
class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  static const _coupons = [
    {'code': 'WELCOME20', 'title': '20% Off', 'desc': 'Get 20% off on your first order. Max discount ₹100.', 'valid': '31 Dec 2026', 'emoji': '🎊', 'color': 0xFF0083BC},
    {'code': 'FREESHIP', 'title': 'Free Delivery', 'desc': 'Free delivery on all orders above ₹199.', 'valid': '15 Nov 2026', 'emoji': '🚚', 'color': 0xFF52B52A},
    {'code': 'DIWALI30', 'title': '30% Off', 'desc': 'Flat 30% off on festive gift packs & hampers!', 'valid': '1 Nov 2026', 'emoji': '🪔', 'color': 0xFFD4AF37},
    {'code': 'SAVE10', 'title': '10% Off', 'desc': '10% off on orders above ₹500. Valid on all categories.', 'valid': '30 Nov 2026', 'emoji': '💰', 'color': 0xFF0083BC},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('🏷️ Offers & Coupons')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Festive banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.festiveGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppColors.primaryShadow,
            ),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Diwali Special 🪔',
                    style: TextStyle(fontFamily: 'PlayfairDisplay', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Upto 30% off on Gift Hampers', style: TextStyle(fontFamily: 'DMSans', color: Colors.white.withOpacity(0.85), fontSize: 12)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, foregroundColor: const Color(0xFFE8891A),
                    minimumSize: const Size(120, 36),
                    textStyle: const TextStyle(fontFamily: 'DMSans', fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  child: const Text('Shop Now'),
                ),
              ])),
              const Text('🎁', style: TextStyle(fontSize: 52)),
            ]),
          ).animate().fadeIn().slideY(begin: -0.1),

          const SizedBox(height: 20),
          Text('Available Coupons (${_coupons.length})', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),

          ..._coupons.asMap().entries.map((e) {
            final c = e.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: AppColors.cardShadow,
                border: Border(left: BorderSide(color: Color(c['color'] as int), width: 5)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c['emoji'] as String, style: const TextStyle(fontSize: 30)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(c['code'] as String, style: AppTextStyles.labelLarge.copyWith(fontSize: 16, letterSpacing: 1)),
                    const SizedBox(height: 2),
                    Text(c['desc'] as String, style: AppTextStyles.bodySmall, maxLines: 2),
                    const SizedBox(height: 4),
                    Text('Valid till: ${c['valid']}', style: AppTextStyles.caption),
                  ])),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Coupon ${c['code']} copied!'),
                        backgroundColor: AppColors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 2),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        border: Border.all(color: AppColors.primary, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Copy', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary, fontSize: 12)),
                    ),
                  ),
                ]),
              ),
            ).animate().fadeIn(delay: (e.key * 80).ms).slideX(begin: 0.1);
          }),
        ],
      ),
    );
  }
}

// ─── Search Screen ─────────────────────────────────────────────────────────
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';

  final _trending = ['Bhakharwadi', 'Chevdo Mix', 'Diwali Gift Pack', 'Sev', 'Khakhra', 'Mohanthal'];

  @override
  Widget build(BuildContext context) {
    final results = _query.isEmpty ? [] : _mockProducts
        .where((p) => p.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextField(
            controller: _ctrl,
            autofocus: true,
            style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Search snacks, sweets...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontFamily: 'DMSans', fontSize: 14),
              border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
              filled: false,
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () { _ctrl.clear(); setState(() => _query = ''); }),
        ],
      ),
      body: _query.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('🔥 Trending', style: AppTextStyles.headlineSmall),
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, children: _trending.map((t) => GestureDetector(
                  onTap: () => setState(() { _ctrl.text = t; _query = t; }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border), boxShadow: AppColors.cardShadow,
                    ),
                    child: Text(t, style: AppTextStyles.labelSmall.copyWith(fontSize: 12, color: AppColors.textMedium)),
                  ),
                )).toList()),
              ]),
            )
          : results.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('🔍', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text('No results for "$_query"', style: AppTextStyles.headlineSmall),
                  Text('Try a different keyword', style: AppTextStyles.bodySmall),
                ]))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final p = results[i];
                    return GestureDetector(
                      onTap: () => context.push('/product/${p.id}'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppColors.cardShadow),
                        child: Row(children: [
                          Container(width: 60, height: 60, decoration: const BoxDecoration(
                            color: Color(0xFFFFF3CD), borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: const Center(child: Text('🥐', style: TextStyle(fontSize: 30)))),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(p.name, style: AppTextStyles.labelMedium),
                            Text(p.categoryName, style: AppTextStyles.bodySmall),
                          ])),
                          Text('₹${p.minPrice.toInt()}', style: AppTextStyles.priceMedium.copyWith(color: AppColors.primary)),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
                        ]),
                      ),
                    );
                  },
                ),
    );
  }
}

// ─── Category Screen ───────────────────────────────────────────────────────
class CategoryScreen extends StatefulWidget {
  final String categoryId;
  const CategoryScreen({super.key, required this.categoryId});
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _sortBy = 'popular';
  int _selectedFilter = 0;
  final _filters = ['All', 'Under ₹200', 'Under ₹500', 'Best Seller', 'New'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('Namkeen & Snacks'), actions: [
        IconButton(icon: const Icon(Icons.tune_rounded, color: Colors.white), onPressed: () {}),
      ]),
      body: Column(children: [
        // Filter chips
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Column(children: [
            // Filters row
            SizedBox(height: 34, child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) => GestureDetector(
                onTap: () => setState(() => _selectedFilter = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: i == _selectedFilter ? AppColors.primary : Colors.white,
                    border: Border.all(color: i == _selectedFilter ? AppColors.primary : AppColors.border),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(_filters[i], style: TextStyle(
                    fontFamily: 'DMSans', fontSize: 12, fontWeight: FontWeight.w600,
                    color: i == _selectedFilter ? Colors.white : AppColors.textMedium,
                  )),
                ),
              ),
            )),
          ]),
        ),

        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.72,
            ),
            itemCount: _mockProducts.length,
            itemBuilder: (context, i) {
              final p = _mockProducts[i];
              return GestureDetector(
                onTap: () => context.push('/product/${p.id}'),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppColors.cardShadow),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Stack(children: [
                      Container(
                        height: 110, width: double.infinity,
                        decoration: BoxDecoration(color: const Color(0xFFFFF3CD), borderRadius: const BorderRadius.vertical(top: Radius.circular(14))),
                        child: const Center(child: Text('🥐', style: TextStyle(fontSize: 52))),
                      ),
                      if (p.isBestSeller)
                        Positioned(top: 8, left: 8, child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(8)),
                          child: const Text('⭐ BEST', style: TextStyle(fontFamily: 'DMSans', fontSize: 8, fontWeight: FontWeight.w800)),
                        )),
                    ]),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(p.name, style: AppTextStyles.labelSmall.copyWith(fontSize: 12, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(p.defaultVariant.weight, style: AppTextStyles.bodySmall),
                        const SizedBox(height: 6),
                        Row(children: [
                          Text('₹${p.defaultVariant.sellingPrice.toInt()}', style: AppTextStyles.priceMedium.copyWith(color: AppColors.primary)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              context.read<CartProvider>().addItem(CartItem(
                                productId: p.id, variantId: p.defaultVariant.id,
                                name: p.name, image: '', price: p.defaultVariant.sellingPrice,
                                mrp: p.defaultVariant.mrp, weight: p.defaultVariant.weight,
                              ));
                            },
                            child: Container(
                              width: 28, height: 28,
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.add, color: Colors.white, size: 16),
                            ),
                          ),
                        ]),
                      ]),
                    ),
                  ]),
                ).animate().fadeIn(delay: (i * 60).ms).scale(begin: const Offset(0.95, 0.95)),
              );
            },
          ),
        ),
      ]),
    );
  }
}

// Use mock products from home screen
const _mockProducts = <ProductModel>[];
