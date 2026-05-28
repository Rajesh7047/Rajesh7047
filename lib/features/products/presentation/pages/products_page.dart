import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmitra/core/providers/auth_state_provider.dart';
import 'package:fitmitra/core/providers/repository_providers.dart';
import 'package:fitmitra/core/utils/result.dart';
import 'package:fitmitra/domain/entities/product.dart';
import 'package:fitmitra/shared/extensions/context_extensions.dart';
import 'package:fitmitra/shared/widgets/fit_card.dart';

final productsProvider =
    FutureProvider.autoDispose<List<WellnessProduct>>((ref) async {
  final user = ref.watch(currentUserProvider);
  final result = await ref
      .read(contentRepositoryProvider)
      .getProducts(goalId: user?.healthGoalId);
  return result.when(success: (l) => l, error: (_) => []);
});

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Products'),
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load products')),
        data: (products) {
          if (products.isEmpty) {
            return const Center(
              child: Text('No products for your goal yet.'),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.isWide ? 3 : 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return FitCard(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: p.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (p.tag != null)
                            Chip(
                              label: Text(p.tag!),
                              visualDensity: VisualDensity.compact,
                            ),
                          Text(
                            p.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(p.priceDisplay),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
