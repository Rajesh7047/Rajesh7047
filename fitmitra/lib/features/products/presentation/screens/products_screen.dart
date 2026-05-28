import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gradient_container.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class _Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String emoji;
  final String category;
  final List<String> goals;
  final double rating;
  final int reviews;
  final bool isAffiliate;

  const _Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.emoji,
    required this.category,
    required this.goals,
    required this.rating,
    required this.reviews,
    this.isAffiliate = false,
  });
}

final _allProducts = [
  _Product(id: '1', name: 'Whey Protein Isolate', description: 'High quality 90% protein, low carb. Ideal for muscle gain & weight management.', price: 1899, originalPrice: 2499, emoji: '💪', category: 'Supplements', goals: ['Weight Gain', 'Muscle Gain'], rating: 4.5, reviews: 1240),
  _Product(id: '2', name: 'Apple Cider Vinegar', description: 'Raw, unfiltered ACV with mother. Supports weight loss and gut health.', price: 349, originalPrice: 499, emoji: '🍎', category: 'Supplements', goals: ['Weight Loss', 'PCOD/PCOS'], rating: 4.3, reviews: 856),
  _Product(id: '3', name: 'Thyroid Support Complex', description: 'Natural herbs blend for thyroid health — Ashwagandha, Guggul & more.', price: 799, originalPrice: 999, emoji: '🦋', category: 'Supplements', goals: ['Thyroid Management'], rating: 4.4, reviews: 432),
  _Product(id: '4', name: 'Yoga Mat (Premium)', description: 'Anti-slip, eco-friendly yoga mat. Perfect for all yoga and exercise types.', price: 1299, originalPrice: 1799, emoji: '🧘', category: 'Equipment', goals: ['Weight Loss', 'PCOD/PCOS', 'Stress Relief'], rating: 4.7, reviews: 2100),
  _Product(id: '5', name: 'Protein Oats (Flavored)', description: 'Instant oats fortified with protein. Perfect healthy breakfast.', price: 449, originalPrice: 599, emoji: '🥣', category: 'Healthy Snacks', goals: ['Weight Loss', 'Maintenance'], rating: 4.2, reviews: 687),
  _Product(id: '6', name: 'PCOD Balance Capsules', description: 'Clinically formulated with Spearmint, Inositol & Vitamin D for PCOD management.', price: 1199, originalPrice: 1499, emoji: '💗', category: 'Supplements', goals: ['PCOD/PCOS'], rating: 4.6, reviews: 923, isAffiliate: true),
  _Product(id: '7', name: 'Resistance Bands Set', description: 'Set of 5 bands for home workouts. Perfect for all fitness levels.', price: 699, originalPrice: 999, emoji: '🏋️', category: 'Equipment', goals: ['Weight Gain', 'Muscle Gain'], rating: 4.4, reviews: 1456),
  _Product(id: '8', name: 'Green Tea Extract', description: 'High-potency EGCG extract to boost metabolism and fat burning.', price: 549, originalPrice: 749, emoji: '🍵', category: 'Supplements', goals: ['Weight Loss', 'Maintenance'], rating: 4.1, reviews: 534),
];

final _productCategories = ['Recommended', 'Supplements', 'Equipment', 'Healthy Snacks'];

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  String _selectedCategory = 'Recommended';

  List<_Product> _getFilteredProducts(String? userGoal) {
    if (_selectedCategory == 'Recommended' && userGoal != null) {
      final goalProducts = _allProducts.where((p) => p.goals.contains(userGoal)).toList();
      final rest = _allProducts.where((p) => !p.goals.contains(userGoal)).toList();
      return [...goalProducts, ...rest];
    }
    if (_selectedCategory == 'Recommended') return _allProducts;
    return _allProducts.where((p) => p.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final userGoal = userAsync.valueOrNull?.healthGoal;
    final filtered = _getFilteredProducts(userGoal);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Recommended Products')),
      body: CustomScrollView(
        slivers: [
          // Goal-based recommendation banner
          if (userGoal != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: GradientContainer(
                  gradient: AppColors.accentGradient,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Text('🎯', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Curated for Your Goal', style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'Poppins')),
                            Text(
                              userGoal,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Category filter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _productCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final cat = _productCategories[i];
                    final isSelected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.accent : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? AppColors.accent : theme.colorScheme.outlineVariant),
                        ),
                        child: Center(
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Products grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => _ProductCard(
                  product: filtered[i],
                  userGoal: userGoal,
                ),
                childCount: filtered.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final _Product product;
  final String? userGoal;

  const _ProductCard({required this.product, this.userGoal});

  bool get _isRecommended =>
      userGoal != null && product.goals.contains(userGoal);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final discount = product.originalPrice != null
        ? ((1 - product.price / product.originalPrice!) * 100).round()
        : null;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isRecommended ? AppColors.accent : theme.colorScheme.outlineVariant,
          width: _isRecommended ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 110,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Center(child: Text(product.emoji, style: const TextStyle(fontSize: 52))),
              ),
              if (discount != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('-$discount%', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                  ),
                ),
              if (_isRecommended)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('Best Match', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: theme.textTheme.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFFFAB00), size: 12),
                    const SizedBox(width: 2),
                    Text('${product.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, fontFamily: 'Poppins')),
                    Text(' (${product.reviews})', style: theme.textTheme.labelSmall),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary, fontFamily: 'Poppins'),
                    ),
                    if (product.originalPrice != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        '₹${product.originalPrice!.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 11, decoration: TextDecoration.lineThrough, color: AppColors.textTertiary, fontFamily: 'Poppins'),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Buy Now',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
