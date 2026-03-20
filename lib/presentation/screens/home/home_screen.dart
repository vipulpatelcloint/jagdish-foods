// lib/presentation/screens/home/home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/models.dart';
import '../../../providers/cart_provider.dart';
import '../../widgets/product/product_card.dart';
import '../../widgets/home/banner_card.dart';
import '../../widgets/home/category_item.dart';
import '../../widgets/home/reorder_card.dart';
import '../../widgets/home/combo_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bannerController = PageController();
  final _scrollController = ScrollController();
  Timer? _bannerTimer;
  int _currentBanner = 0;
  bool _isScrolled = false;

  // Mock data
  final List<BannerData> _banners = [
    BannerData(
      tag: '🪔 Diwali Offers',
      title: 'Festive Gift\nHampers',
      subtitle: 'Up to 30% off · Free delivery',
      emoji: '🎁',
      gradient: const LinearGradient(
        colors: [Color(0xFFF4A300), Color(0xFFE8891A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      ctaColor: Color(0xFF7A4500),
    ),
    BannerData(
      tag: '⭐ Best Seller',
      title: 'Signature\nBhakharwadi',
      subtitle: 'Original recipe · Since 1945',
      emoji: '🥐',
      gradient: AppColors.primaryGradient,
      ctaColor: AppColors.primaryDark,
    ),
    BannerData(
      tag: '🌿 Pure Veg',
      title: 'Premium\nSnack Box',
      subtitle: '5 varieties · ₹499 only',
      emoji: '📦',
      gradient: AppColors.greenGradient,
      ctaColor: AppColors.greenDeep,
    ),
  ];

  final List<Map<String, dynamic>> _recentOrders = [
    {'name': 'Bhakharwadi Classic', 'emoji': '🥐', 'price': 180.0, 'productId': 'p1', 'variantId': 'v1', 'color': 0xFFFFF3CD},
    {'name': 'Mixed Chevdo', 'emoji': '🌾', 'price': 220.0, 'productId': 'p2', 'variantId': 'v2', 'color': 0xFFD4EDFF},
    {'name': 'Gathiya Sev', 'emoji': '🪢', 'price': 160.0, 'productId': 'p3', 'variantId': 'v3', 'color': 0xFFD4F5C4},
    {'name': 'Mohanthal', 'emoji': '🍬', 'price': 280.0, 'productId': 'p4', 'variantId': 'v4', 'color': 0xFFF3E8FF},
  ];

  final List<ProductModel> _bestSellers = _mockProducts;
  final List<ProductModel> _featured = _mockProducts.take(3).toList();

  @override
  void initState() {
    super.initState();
    _startBannerAutoScroll();
    _scrollController.addListener(() {
      final scrolled = _scrollController.offset > 10;
      if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
    });
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(AppConstants.bannerScrollInterval, (_) {
      if (_bannerController.hasClients) {
        _currentBanner = (_currentBanner + 1) % _banners.length;
        _bannerController.animateToPage(
          _currentBanner,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamLight,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildBanners()),
          SliverToBoxAdapter(child: _buildCategories()),
          SliverToBoxAdapter(child: _buildOrderAgain()),
          SliverToBoxAdapter(child: _buildBestSellers()),
          SliverToBoxAdapter(child: _buildCombos()),
          SliverToBoxAdapter(child: _buildFeatured()),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: _isScrolled ? 4 : 0,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.yellow, size: 14),
                const SizedBox(width: 4),
                const Text('Deliver to', style: TextStyle(
                  fontFamily: 'DMSans', color: Colors.white70, fontSize: 11,
                )),
                const SizedBox(width: 2),
                Consumer<CartProvider>(
                  builder: (_, cart, __) => const SizedBox.shrink(),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Alkapuri, Vadodara',
                  style: TextStyle(
                    fontFamily: 'DMSans', color: Colors.white,
                    fontSize: 13, fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
                const Spacer(),
                IconButton(
                  onPressed: () => context.push(AppRoutes.offers),
                  icon: const Icon(Icons.local_offer_rounded, color: Colors.white, size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
                const SizedBox(width: 4),
                Consumer<CartProvider>(
                  builder: (context, cart, _) => GestureDetector(
                    onTap: () => context.go(AppRoutes.cart),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.shopping_cart_rounded, color: Colors.white, size: 20),
                        ),
                        if (cart.itemCount > 0)
                          Positioned(
                            top: -4, right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: AppColors.yellow,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                cart.itemCount.toString(),
                                style: const TextStyle(
                                  fontSize: 9, fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: GestureDetector(
            onTap: () => context.push(AppRoutes.search),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppColors.cardShadow,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  const Icon(Icons.search, color: AppColors.textLight, size: 18),
                  const SizedBox(width: 8),
                  Text('Search snacks, sweets, combos...',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('🔥 Diwali', style: TextStyle(
                      fontFamily: 'DMSans', color: Colors.white,
                      fontSize: 10, fontWeight: FontWeight.w700,
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanners() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: PageView.builder(
              controller: _bannerController,
              onPageChanged: (i) => setState(() => _currentBanner = i),
              itemCount: _banners.length,
              itemBuilder: (context, i) => Padding(
                padding: EdgeInsets.only(
                  left: i == 0 ? 16 : 6,
                  right: i == _banners.length - 1 ? 16 : 6,
                ),
                child: BannerCard(data: _banners[i]),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SmoothPageIndicator(
            controller: _bannerController,
            count: _banners.length,
            effect: const ExpandingDotsEffect(
              activeDotColor: AppColors.primary,
              dotColor: AppColors.border,
              dotHeight: 6,
              dotWidth: 6,
              expansionFactor: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Column(
        children: [
          _SectionHeader(title: 'Categories', onSeeAll: () {}),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: AppConstants.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, i) {
                final cat = AppConstants.categories[i];
                return CategoryItem(
                  name: cat['name'],
                  emoji: cat['emoji'],
                  color: Color(cat['color']),
                  onTap: () => context.push('/category/${cat['id']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderAgain() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Column(
        children: [
          _SectionHeader(title: '🔁 Order Again', onSeeAll: () {}),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _recentOrders.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final order = _recentOrders[i];
                return ReorderCard(
                  name: order['name'],
                  emoji: order['emoji'],
                  price: order['price'],
                  bgColor: Color(order['color']),
                  onAddAgain: () {
                    final cart = context.read<CartProvider>();
                    cart.addItem(CartItem(
                      productId: order['productId'],
                      variantId: order['variantId'],
                      name: order['name'],
                      image: order['emoji'],
                      price: order['price'],
                      mrp: order['price'] * 1.1,
                      weight: '250g',
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${order['name']} added to cart!'),
                        backgroundColor: AppColors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellers() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Column(
        children: [
          _SectionHeader(title: '🏆 Best Sellers', onSeeAll: () {}),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _bestSellers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) => ProductCard(
                product: _bestSellers[i],
                onTap: () => context.push('/product/${_bestSellers[i].id}'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCombos() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Column(
        children: [
          _SectionHeader(title: '🎁 Featured Combos', onSeeAll: () {}),
          const SizedBox(height: 12),
          SizedBox(
            height: 155,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                ComboCard(
                  title: 'Snack Party Box',
                  items: ['🥐', '🌾', '🪢', '🫓'],
                  subtitle: 'Bhakharwadi + Chevdo + Sev + Khakhra',
                  price: 549,
                  mrp: 669,
                  badgeLabel: 'COMBO',
                  badgeColor: AppColors.yellow,
                ),
                SizedBox(width: 12),
                ComboCard(
                  title: 'Sweet Festive Box',
                  items: ['🍬', '🥮', '🍡'],
                  subtitle: 'Mohanthal + Ghughra + Ladoo',
                  price: 799,
                  mrp: 999,
                  badgeLabel: 'FESTIVE',
                  badgeColor: AppColors.gold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatured() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          _SectionHeader(title: '✨ New Arrivals', onSeeAll: () {}),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _featured.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) => ProductCard(
                product: _featured[i],
                onTap: () => context.push('/product/${_featured[i].id}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(title, style: AppTextStyles.headlineMedium),
          const Spacer(),
          GestureDetector(
            onTap: onSeeAll,
            child: Text('View All', style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.primary, fontWeight: FontWeight.w700,
            )),
          ),
        ],
      ),
    );
  }
}

// Mock products for demo
List<ProductModel> get _mockProducts => [
  ProductModel(
    id: 'p1', name: 'Bhakharwadi Classic',
    description: 'Our signature Bhakharwadi crafted from a 75-year-old recipe.',
    categoryId: '1', categoryName: 'Bhakharwadi',
    variants: [
      const ProductVariant(id: 'v1a', weight: '100g', mrp: 90, sellingPrice: 75, stockQuantity: 50),
      const ProductVariant(id: 'v1b', weight: '250g', mrp: 220, sellingPrice: 180, stockQuantity: 100),
      const ProductVariant(id: 'v1c', weight: '500g', mrp: 420, sellingPrice: 350, stockQuantity: 80),
      const ProductVariant(id: 'v1d', weight: '1 kg', mrp: 820, sellingPrice: 680, stockQuantity: 40),
    ],
    images: ['assets/images/bhakharwadi.jpg'],
    rating: 4.7, reviewCount: 2341,
    isVeg: true, isBestSeller: true,
    ingredients: ['Whole wheat flour', 'Spices', 'Refined oil', 'Salt', 'Sesame seeds'],
    shelfLife: '45 days',
    tags: ['Spicy', 'Crunchy', 'Traditional'],
    createdAt: DateTime(2024, 1),
  ),
  ProductModel(
    id: 'p2', name: 'Spicy Chevdo Mix',
    description: 'Premium Gujarati Chevdo with a perfect blend of spices.',
    categoryId: '2', categoryName: 'Chevdo',
    variants: [
      const ProductVariant(id: 'v2a', weight: '200g', mrp: 130, sellingPrice: 110, stockQuantity: 60),
      const ProductVariant(id: 'v2b', weight: '400g', mrp: 250, sellingPrice: 220, stockQuantity: 90),
    ],
    images: ['assets/images/chevdo.jpg'],
    rating: 4.5, reviewCount: 1820,
    isVeg: true, isBestSeller: true,
    createdAt: DateTime(2024, 1),
  ),
  ProductModel(
    id: 'p3', name: 'Masala Khakhra',
    description: 'Thin crispy wheat crackers with aromatic masala seasoning.',
    categoryId: '4', categoryName: 'Khakhra',
    variants: [
      const ProductVariant(id: 'v3a', weight: '200g', mrp: 170, sellingPrice: 145, stockQuantity: 70),
      const ProductVariant(id: 'v3b', weight: '400g', mrp: 330, sellingPrice: 280, stockQuantity: 50),
    ],
    images: ['assets/images/khakhra.jpg'],
    rating: 4.6, reviewCount: 1540,
    isVeg: true, isNew: true,
    createdAt: DateTime(2024, 3),
  ),
  ProductModel(
    id: 'p4', name: 'Mohanthal Premium',
    description: 'Rich gram flour sweet made with pure ghee and saffron.',
    categoryId: '5', categoryName: 'Sweets',
    variants: [
      const ProductVariant(id: 'v4a', weight: '250g', mrp: 300, sellingPrice: 280, stockQuantity: 30),
      const ProductVariant(id: 'v4b', weight: '500g', mrp: 580, sellingPrice: 540, stockQuantity: 20),
    ],
    images: ['assets/images/mohanthal.jpg'],
    rating: 4.8, reviewCount: 980,
    isVeg: true,
    createdAt: DateTime(2024, 2),
  ),
];
