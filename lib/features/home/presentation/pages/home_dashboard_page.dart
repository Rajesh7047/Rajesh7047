import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitmitra/core/constants/health_goals.dart';
import 'package:fitmitra/core/providers/auth_state_provider.dart';
import 'package:fitmitra/core/theme/app_colors.dart';
import 'package:fitmitra/shared/extensions/context_extensions.dart';
import 'package:fitmitra/shared/widgets/fit_card.dart';
import 'package:fitmitra/shared/widgets/premium_badge.dart';

class HomeDashboardPage extends ConsumerWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final goal = HealthGoals.byId(user?.healthGoalId);
    final isPremium = user?.hasActivePremium ?? false;

    final features = [
      _FeatureTile('Diet Plans', Icons.restaurant_menu, '/diet', false),
      _FeatureTile('Yoga', Icons.self_improvement, '/yoga', false),
      _FeatureTile('Meditation', Icons.spa, '/meditation', false),
      _FeatureTile('Recipes', Icons.soup_kitchen, '/recipes', false),
      _FeatureTile('Live Zoom', Icons.videocam, '/zoom', true),
      _FeatureTile('Products', Icons.shopping_bag, '/products', false),
      _FeatureTile('Tracking', Icons.water_drop, '/tracking', false),
      _FeatureTile('AI Coach', Icons.chat, '/ai-chat', false),
    ];

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: Text('Hi, ${user?.displayName ?? 'Wellness Hero'}'),
          actions: [
            if (isPremium) const PremiumBadge(),
            if (!isPremium)
              TextButton(
                onPressed: () => context.push('/membership'),
                child: const Text('Go Premium'),
              ),
            const SizedBox(width: 8),
          ],
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: context.isWide ? 48 : 16,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              FitCard(
                gradient: LinearGradient(
                  colors: [
                    context.colors.primary,
                    context.colors.secondary,
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal?.title ?? 'Your Wellness Journey',
                      style: context.text.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      goal?.description ??
                          'Set a goal in profile for personalized recommendations',
                      style: context.text.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: () => context.push('/membership'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.premiumGold,
                        foregroundColor: Colors.brown.shade900,
                      ),
                      child: Text(isPremium ? 'Manage Premium' : 'Upgrade to Premium'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Explore',
                style: context.text.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: context.isWide ? 4 : 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: features.length,
                itemBuilder: (context, index) {
                  final f = features[index];
                  return FitCard(
                    onTap: () {
                      if (f.premiumOnly && !isPremium) {
                        context.push('/membership');
                        return;
                      }
                      context.push(f.route);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(f.icon, size: 36, color: context.colors.primary),
                        const SizedBox(height: 8),
                        Text(
                          f.title,
                          textAlign: TextAlign.center,
                          style: context.text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (f.premiumOnly) ...[
                          const SizedBox(height: 4),
                          const PremiumBadge(compact: true),
                        ],
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ],
    );
  }
}

class _FeatureTile {
  const _FeatureTile(this.title, this.icon, this.route, this.premiumOnly);
  final String title;
  final IconData icon;
  final String route;
  final bool premiumOnly;
}
