// lib/data/models/product_model.dart
import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final String categoryName;
  final List<ProductVariant> variants;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final bool isVeg;
  final bool isBestSeller;
  final bool isNew;
  final bool isAvailable;
  final List<String> ingredients;
  final String shelfLife;
  final List<String> tags;
  final List<String> allergens;
  final NutritionInfo? nutrition;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.variants,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.isVeg,
    this.isBestSeller = false,
    this.isNew = false,
    this.isAvailable = true,
    this.ingredients = const [],
    this.shelfLife = '45 days',
    this.tags = const [],
    this.allergens = const [],
    this.nutrition,
    required this.createdAt,
  });

  ProductVariant get defaultVariant => variants.first;
  double get minPrice => variants.map((v) => v.sellingPrice).reduce((a, b) => a < b ? a : b);

  @override
  List<Object?> get props => [id];

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    categoryId: json['category_id'],
    categoryName: json['category_name'],
    variants: (json['variants'] as List).map((v) => ProductVariant.fromJson(v)).toList(),
    images: List<String>.from(json['images'] ?? []),
    rating: (json['rating'] ?? 0).toDouble(),
    reviewCount: json['review_count'] ?? 0,
    isVeg: json['is_veg'] ?? true,
    isBestSeller: json['is_best_seller'] ?? false,
    isNew: json['is_new'] ?? false,
    isAvailable: json['is_available'] ?? true,
    ingredients: List<String>.from(json['ingredients'] ?? []),
    shelfLife: json['shelf_life'] ?? '45 days',
    tags: List<String>.from(json['tags'] ?? []),
    createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
  );
}

class ProductVariant extends Equatable {
  final String id;
  final String weight;
  final double mrp;
  final double sellingPrice;
  final int stockQuantity;
  final String? sku;

  const ProductVariant({
    required this.id,
    required this.weight,
    required this.mrp,
    required this.sellingPrice,
    required this.stockQuantity,
    this.sku,
  });

  double get discount => mrp > sellingPrice ? ((mrp - sellingPrice) / mrp) * 100 : 0;
  bool get hasDiscount => discount > 0;
  bool get inStock => stockQuantity > 0;

  @override
  List<Object?> get props => [id];

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
    id: json['id'],
    weight: json['weight'],
    mrp: (json['mrp'] ?? 0).toDouble(),
    sellingPrice: (json['selling_price'] ?? 0).toDouble(),
    stockQuantity: json['stock_quantity'] ?? 0,
    sku: json['sku'],
  );
}

class NutritionInfo {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String servingSize;

  const NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.servingSize,
  });
}

// ─── Cart Item ───────────────────────────────────────────────────────────
class CartItem extends Equatable {
  final String productId;
  final String variantId;
  final String name;
  final String image;
  final double price;
  final double mrp;
  final String weight;
  int quantity;

  CartItem({
    required this.productId,
    required this.variantId,
    required this.name,
    required this.image,
    required this.price,
    required this.mrp,
    required this.weight,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;
  double get totalMrp => mrp * quantity;
  double get totalSaving => totalMrp - totalPrice;

  CartItem copyWith({int? quantity}) => CartItem(
    productId: productId,
    variantId: variantId,
    name: name,
    image: image,
    price: price,
    mrp: mrp,
    weight: weight,
    quantity: quantity ?? this.quantity,
  );

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'variant_id': variantId,
    'name': name,
    'image': image,
    'price': price,
    'mrp': mrp,
    'weight': weight,
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    productId: json['product_id'],
    variantId: json['variant_id'],
    name: json['name'],
    image: json['image'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
    mrp: (json['mrp'] ?? 0).toDouble(),
    weight: json['weight'],
    quantity: json['quantity'] ?? 1,
  );

  @override
  List<Object?> get props => [productId, variantId];
}

// ─── User / Address ───────────────────────────────────────────────────────
class UserModel extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? avatarUrl;
  final List<AddressModel> addresses;
  final String membershipTier; // basic, silver, gold
  final int totalOrders;
  final double totalSaved;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.avatarUrl,
    this.addresses = const [],
    this.membershipTier = 'basic',
    this.totalOrders = 0,
    this.totalSaved = 0,
  });

  @override
  List<Object?> get props => [id];
}

class AddressModel extends Equatable {
  final String id;
  final String label; // Home, Work, Other
  final String recipientName;
  final String phone;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;
  final double? latitude;
  final double? longitude;

  const AddressModel({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.line1,
    this.line2 = '',
    required this.city,
    required this.state,
    required this.pincode,
    this.isDefault = false,
    this.latitude,
    this.longitude,
  });

  String get fullAddress => '$line1${line2.isNotEmpty ? ', $line2' : ''}, $city, $state - $pincode';

  @override
  List<Object?> get props => [id];
}

// ─── Order ────────────────────────────────────────────────────────────────
class OrderModel extends Equatable {
  final String id;
  final String orderNumber;
  final List<CartItem> items;
  final AddressModel address;
  final double subtotal;
  final double discount;
  final double deliveryCharge;
  final double total;
  final String paymentMethod;
  final String paymentStatus;
  final OrderStatus status;
  final List<OrderStatusEvent> timeline;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final String? deliveryPartnerName;
  final String? deliveryPartnerPhone;
  final String? couponCode;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.address,
    required this.subtotal,
    this.discount = 0,
    this.deliveryCharge = 0,
    required this.total,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    this.timeline = const [],
    required this.createdAt,
    this.deliveredAt,
    this.deliveryPartnerName,
    this.deliveryPartnerPhone,
    this.couponCode,
  });

  @override
  List<Object?> get props => [id];
}

enum OrderStatus { placed, confirmed, packing, outForDelivery, delivered, cancelled }

class OrderStatusEvent {
  final OrderStatus status;
  final String label;
  final String? description;
  final DateTime timestamp;
  final bool isCompleted;
  final bool isActive;

  const OrderStatusEvent({
    required this.status,
    required this.label,
    this.description,
    required this.timestamp,
    this.isCompleted = false,
    this.isActive = false,
  });
}

// ─── Coupon ────────────────────────────────────────────────────────────────
class CouponModel extends Equatable {
  final String id;
  final String code;
  final String title;
  final String description;
  final CouponType type;
  final double value; // % for percentage, fixed amount for flat
  final double? maxDiscount;
  final double minOrderValue;
  final DateTime validTill;
  final bool isActive;

  const CouponModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.type,
    required this.value,
    this.maxDiscount,
    this.minOrderValue = 0,
    required this.validTill,
    this.isActive = true,
  });

  double calculateDiscount(double orderAmount) {
    if (orderAmount < minOrderValue) return 0;
    switch (type) {
      case CouponType.percentage:
        final discount = orderAmount * (value / 100);
        return maxDiscount != null ? discount.clamp(0, maxDiscount!) : discount;
      case CouponType.flat:
        return value.clamp(0, orderAmount);
      case CouponType.freeDelivery:
        return 49.0; // delivery charge
    }
  }

  @override
  List<Object?> get props => [id, code];
}

enum CouponType { percentage, flat, freeDelivery }
