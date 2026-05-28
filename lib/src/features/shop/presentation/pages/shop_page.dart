import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitmitra/src/core/models/wellness_goal.dart';
import 'package:fitmitra/src/core/widgets/app_card.dart';
import 'package:fitmitra/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:fitmitra/src/shared/data/seed_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopPage extends ConsumerWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userGoal =
        ref.watch(authControllerProvider).user?.goal ?? WellnessGoal.weightLoss;
    final products = SeedData.products
        .where((product) => product.goal == userGoal)
        .toList();

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.sizeOf(context).width > 980 ? 2 : 1,
        childAspectRatio: 1.18,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        if (product.isPremiumPick)
                          const Chip(label: Text('Premium pick')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(product.description),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final benefit in product.benefits)
                          Chip(label: Text(benefit)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          product.priceLabel,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.star_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(product.rating.toStringAsFixed(1)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    FilledButton.icon(
                      onPressed: () =>
                          launchUrl(Uri.parse(product.purchaseUrl)),
                      icon: const Icon(Icons.open_in_new_rounded),
                      label: const Text('View product'),
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
