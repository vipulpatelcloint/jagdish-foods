// lib/presentation/widgets/home/banner_card.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class BannerData {
  final String tag, title, subtitle, emoji;
  final LinearGradient gradient;
  final Color ctaColor;
  const BannerData({required this.tag, required this.title, required this.subtitle,
    required this.emoji, required this.gradient, required this.ctaColor});
}

class BannerCard extends StatelessWidget {
  final BannerData data;
  const BannerCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(gradient: data.gradient, borderRadius: BorderRadius.circular(16)),
      child: Stack(children: [
        // Decorative circle
        Positioned(top: -20, right: 30, child: Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), shape: BoxShape.circle),
        )),
        Positioned(
          left: 18, top: 18, bottom: 18,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.22),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(data.tag, style: const TextStyle(fontFamily: 'DMSans', color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 8),
            Text(data.title, style: const TextStyle(fontFamily: 'PlayfairDisplay', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700, height: 1.2)),
            const SizedBox(height: 4),
            Text(data.subtitle, style: TextStyle(fontFamily: 'DMSans', color: Colors.white.withOpacity(0.85), fontSize: 11)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('Shop Now', style: TextStyle(fontFamily: 'DMSans', fontSize: 11, fontWeight: FontWeight.w700, color: data.ctaColor)),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 12, color: data.ctaColor),
              ]),
            ),
          ]),
        ),
        Positioned(bottom: 10, right: 16, child: Text(data.emoji, style: const TextStyle(fontSize: 58))),
      ]),
    );
  }
}

// ─── Category Item ─────────────────────────────────────────────────────────
// lib/presentation/widgets/home/category_item.dart
class CategoryItem extends StatelessWidget {
  final String name, emoji;
  final Color color;
  final VoidCallback onTap;
  const CategoryItem({super.key, required this.name, required this.emoji, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 62, height: 62,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withRed(color.red - 20).withGreen(color.green - 20), width: 1.5),
            boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28))),
        ),
        const SizedBox(height: 6),
        SizedBox(width: 62, child: Text(name, textAlign: TextAlign.center, maxLines: 2,
          style: const TextStyle(fontFamily: 'DMSans', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMedium, height: 1.2))),
      ]),
    );
  }
}

// ─── Reorder Card ──────────────────────────────────────────────────────────
// lib/presentation/widgets/home/reorder_card.dart
class ReorderCard extends StatelessWidget {
  final String name, emoji;
  final double price;
  final Color bgColor;
  final VoidCallback onAddAgain;

  const ReorderCard({super.key, required this.name, required this.emoji,
    required this.price, required this.bgColor, required this.onAddAgain});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border), boxShadow: AppColors.cardShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 88, width: double.infinity,
          decoration: BoxDecoration(color: bgColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(14))),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 44))),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(9, 8, 9, 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontFamily: 'DMSans', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text('₹${price.toInt()}', style: const TextStyle(fontFamily: 'DMSans', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
            const SizedBox(height: 7),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAddAgain,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 30), padding: const EdgeInsets.symmetric(horizontal: 8),
                  textStyle: const TextStyle(fontFamily: 'DMSans', fontSize: 11, fontWeight: FontWeight.w700),
                  backgroundColor: AppColors.primaryLight, foregroundColor: AppColors.primary,
                  shadowColor: Colors.transparent, elevation: 0,
                ),
                child: const Text('+ Add Again'),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ─── Combo Card ────────────────────────────────────────────────────────────
// lib/presentation/widgets/home/combo_card.dart
class ComboCard extends StatelessWidget {
  final String title, subtitle, badgeLabel;
  final List<String> items;
  final double price, mrp;
  final Color badgeColor;

  const ComboCard({super.key, required this.title, required this.items,
    required this.subtitle, required this.price, required this.mrp,
    required this.badgeLabel, required this.badgeColor});

  @override
  Widget build(BuildContext context) {
    final saving = ((mrp - price) / mrp * 100).toInt();
    return Container(
      width: 248,
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border), boxShadow: AppColors.cardShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontFamily: 'DMSans', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              Text('Save $saving% 🎉', style: const TextStyle(fontFamily: 'DMSans', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.green)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(10)),
              child: Text(badgeLabel, style: TextStyle(fontFamily: 'DMSans', fontSize: 9, fontWeight: FontWeight.w800,
                  color: badgeColor == AppColors.yellow ? AppColors.textDark : Colors.white)),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(children: items.map((e) => Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Text(e, style: const TextStyle(fontSize: 26)),
          )).toList()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(subtitle, style: const TextStyle(fontFamily: 'DMSans', fontSize: 10, color: AppColors.textLight)),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
          child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('₹${price.toInt()}', style: const TextStyle(fontFamily: 'DMSans', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
              Text('₹${mrp.toInt()} MRP', style: const TextStyle(fontFamily: 'DMSans', fontSize: 10, color: AppColors.textLight, decoration: TextDecoration.lineThrough)),
            ]),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 34), padding: const EdgeInsets.symmetric(horizontal: 14),
                textStyle: const TextStyle(fontFamily: 'DMSans', fontSize: 11, fontWeight: FontWeight.w700),
              ),
              child: const Text('Add to Cart'),
            ),
          ]),
        ),
      ]),
    );
  }
}
