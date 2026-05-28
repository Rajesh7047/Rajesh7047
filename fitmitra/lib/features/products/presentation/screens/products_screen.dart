import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../data/models/product_model.dart';

final selectedProductGoalProvider = StateProvider<String>((ref) => 'All');

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGoal = ref.watch(selectedProductGoalProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = selectedGoal == 'All'
        ? products
        : products.where((p) => p.goals.contains(selectedGoal)).toList();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Recommended Products'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Products based on your goals', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)).animate().fadeIn(),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Weight Loss', 'Weight Gain', 'PCOD/Thyroid', 'General'].map((goal) {
                  final isSelected = selectedGoal == goal;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(goal),
                      selected: isSelected,
                      onSelected: (_) => ref.read(selectedProductGoalProvider.notifier).state = goal,
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      labelStyle: TextStyle(color: isSelected ? AppColors.primary : null, fontWeight: isSelected ? FontWeight.w600 : null),
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final product = filtered[index];
                return CustomCard(
                  animationIndex: index,
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(12),
                  onTap: () => _showProductDetail(context, product),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Center(child: Icon(Icons.shopping_bag_rounded, color: AppColors.primary.withOpacity(0.3), size: 48)),
                              if (product.discountPercent > 0)
                                Positioned(
                                  top: 6,
                                  left: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(6)),
                                    child: Text('${product.discountPercent}% OFF', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(product.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                      Text(product.brand, style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('₹${product.price.toStringAsFixed(0)}', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 15)),
                          if (product.originalPrice != null) ...[
                            const SizedBox(width: 4),
                            Text('₹${product.originalPrice!.toStringAsFixed(0)}', style: const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 11, color: AppColors.textSecondaryLight)),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB800)),
                          const SizedBox(width: 2),
                          Text('${product.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          Text(' (${product.reviews})', style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetail(BuildContext context, ProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.06), borderRadius: BorderRadius.circular(16)),
              child: Icon(Icons.shopping_bag_rounded, color: AppColors.primary.withOpacity(0.3), size: 72),
            ),
            const SizedBox(height: 16),
            Text(product.name, style: Theme.of(context).textTheme.headlineMedium),
            Text(product.brand, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Text(product.description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('₹${product.price.toStringAsFixed(0)}', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 24)),
                if (product.originalPrice != null) ...[
                  const SizedBox(width: 8),
                  Text('₹${product.originalPrice!.toStringAsFixed(0)}', style: const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 16, color: AppColors.textSecondaryLight)),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: product.goals.map((g) => Chip(label: Text(g, style: const TextStyle(fontSize: 11)), padding: EdgeInsets.zero, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap)).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(onPressed: () {}, child: const Text('Buy Now')),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  static final List<ProductModel> products = [
    ProductModel(id: '1', name: 'Whey Protein Isolate', description: 'Premium whey protein for muscle recovery', price: 1899, originalPrice: 2499, imageUrl: '', rating: 4.5, reviews: 1250, goals: ['Weight Loss', 'Weight Gain', 'General'], category: 'Supplements', brand: 'MuscleBlaze'),
    ProductModel(id: '2', name: 'Apple Cider Vinegar', description: 'Raw, unfiltered ACV with mother', price: 349, originalPrice: 499, imageUrl: '', rating: 4.3, reviews: 890, goals: ['Weight Loss', 'PCOD/Thyroid', 'General'], category: 'Health Drinks', brand: 'WOW'),
    ProductModel(id: '3', name: 'Organic Flax Seeds', description: 'Rich in omega-3 and fiber', price: 199, originalPrice: 299, imageUrl: '', rating: 4.6, reviews: 560, goals: ['PCOD/Thyroid', 'Weight Loss', 'General'], category: 'Superfoods', brand: 'True Elements'),
    ProductModel(id: '4', name: 'Mass Gainer XXL', description: 'High-calorie mass gainer for weight gain', price: 2299, originalPrice: 2999, imageUrl: '', rating: 4.2, reviews: 780, goals: ['Weight Gain'], category: 'Supplements', brand: 'GNC'),
    ProductModel(id: '5', name: 'Yoga Mat - Premium', description: '6mm anti-slip eco-friendly yoga mat', price: 699, originalPrice: 999, imageUrl: '', rating: 4.7, reviews: 2100, goals: ['Weight Loss', 'PCOD/Thyroid', 'General'], category: 'Fitness Gear', brand: 'Boldfit'),
    ProductModel(id: '6', name: 'Resistance Bands Set', description: '5-level resistance bands for home workout', price: 449, originalPrice: 699, imageUrl: '', rating: 4.4, reviews: 1560, goals: ['Weight Loss', 'Weight Gain', 'General'], category: 'Fitness Gear', brand: 'Boldfit'),
  ];
}
