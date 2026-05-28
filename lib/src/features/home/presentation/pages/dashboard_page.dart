import 'package:fitmitra/src/core/models/membership_tier.dart';
import 'package:fitmitra/src/core/models/wellness_goal.dart';
import 'package:fitmitra/src/core/utils/responsive.dart';
import 'package:fitmitra/src/core/widgets/app_card.dart';
import 'package:fitmitra/src/core/widgets/metric_tile.dart';
import 'package:fitmitra/src/core/widgets/section_header.dart';
import 'package:fitmitra/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:fitmitra/src/features/tracking/presentation/controllers/tracking_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final tracking = ref.watch(trackingControllerProvider);
    final theme = Theme.of(context);
    final columns = Responsive.columns(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 4,
    );

    if (user == null) {
      return const SizedBox.shrink();
    }

    final goalCards = WellnessGoal.values
        .map(
          (goal) => AppCard(
            onTap: () =>
                ref.read(authControllerProvider.notifier).updateGoal(goal),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: goal.accentColor.withValues(alpha: 0.16),
                  child: Icon(goal.icon, color: goal.accentColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(goal.coachPrompt),
                    ],
                  ),
                ),
                if (user.goal == goal)
                  Icon(
                    Icons.check_circle_rounded,
                    color: theme.colorScheme.primary,
                  ),
              ],
            ),
          ),
        )
        .toList();

    final quickActions = const [
      _QuickAction('AI chat', Icons.auto_awesome_rounded, '/chat'),
      _QuickAction('Diet plan', Icons.restaurant_menu_rounded, '/diet'),
      _QuickAction('Yoga & media', Icons.ondemand_video_rounded, '/media'),
      _QuickAction('Tracker', Icons.monitor_heart_rounded, '/tracker'),
      _QuickAction('Mentor sessions', Icons.groups_rounded, '/mentors'),
      _QuickAction('Recommended shop', Icons.shopping_bag_rounded, '/shop'),
      _QuickAction(
        'Premium plans',
        Icons.workspace_premium_rounded,
        '/membership',
      ),
      _QuickAction('Profile', Icons.person_rounded, '/profile'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Responsive.contentWidth(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                gradient: LinearGradient(
                  colors: [user.goal.accentColor, theme.colorScheme.secondary],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back, ${user.displayName}',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Today\'s focus: ${user.goal.shortLabel}. Track your habits, ask the AI coach, and stay consistent.',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.92),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            child: Text(
                              user.membershipTier.label,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: user.goal.accentColor,
                          ),
                          onPressed: () => context.go('/chat'),
                          icon: const Icon(Icons.auto_awesome_rounded),
                          label: const Text('Ask FitMitra AI'),
                        ),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white54),
                          ),
                          onPressed: () => context.push('/membership'),
                          icon: const Icon(Icons.workspace_premium_rounded),
                          label: const Text('Upgrade membership'),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  MetricTile(
                    icon: Icons.local_fire_department_rounded,
                    label: 'Calories',
                    value:
                        '${tracking.caloriesConsumed}/${tracking.calorieTarget}',
                    caption: 'Daily target tracking',
                    progress: tracking.calorieProgress,
                  ),
                  MetricTile(
                    icon: Icons.water_drop_rounded,
                    label: 'Hydration',
                    value: '${tracking.waterMl} ml',
                    caption: 'Goal ${tracking.waterTargetMl} ml',
                    progress: tracking.waterProgress,
                  ),
                  MetricTile(
                    icon: Icons.bolt_rounded,
                    label: 'Current goal',
                    value: user.goal.shortLabel,
                    caption: 'Adaptive coaching mode',
                  ),
                  MetricTile(
                    icon: Icons.emoji_events_rounded,
                    label: 'Streak',
                    value: '${user.streak} days',
                    caption: 'Consistency beats intensity',
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const SectionHeader(
                title: 'Choose your wellness mode',
                subtitle:
                    'Switch goals at any time to update meal plans, suggestions, media picks, and product recommendations.',
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: Responsive.columns(
                  context,
                  mobile: 1,
                  tablet: 1,
                  desktop: 1,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                childAspectRatio: Responsive.isDesktop(context) ? 4.8 : 2.2,
                children: goalCards,
              ),
              const SizedBox(height: 28),
              const SectionHeader(
                title: 'Move faster with premium',
                subtitle:
                    'Premium unlocks mentor sessions, deeper AI guidance, and richer diet personalizations.',
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.isPremium
                          ? 'Your premium access is active.'
                          : 'You are on the free plan.',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.isPremium
                          ? 'Book live Zoom calls, unlock premium videos, and get deeper AI meal swaps.'
                          : 'Upgrade to premium for live mentor sessions, advanced recipes, and a more personalized transformation journey.',
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: () => context.push('/membership'),
                      icon: const Icon(Icons.workspace_premium_rounded),
                      label: Text(
                        user.isPremium ? 'Manage plan' : 'View premium plans',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const SectionHeader(
                title: 'Your personalized action hub',
                subtitle:
                    'Everything FitMitra offers, from AI guidance to mentor support.',
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: Responsive.columns(
                  context,
                  mobile: 2,
                  tablet: 4,
                  desktop: 4,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.25,
                children: [
                  for (final action in quickActions)
                    AppCard(
                      onTap: () => action.route.startsWith('/')
                          ? (action.route == '/membership'
                                ? context.push(action.route)
                                : context.go(action.route))
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(radius: 22, child: Icon(action.icon)),
                          Text(
                            action.label,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction {
  const _QuickAction(this.label, this.icon, this.route);

  final String label;
  final IconData icon;
  final String route;
}
