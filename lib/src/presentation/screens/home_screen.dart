import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/models.dart';
import '../../state/app_providers.dart';
import '../widgets/fitmitra_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(selectedGoalProvider);
    final plan = ref.watch(dietPlanProvider);
    final tracker = ref.watch(dailyTrackerProvider);
    final products = ref.watch(productRecommendationsProvider).valueOrNull ?? const <ProductRecommendation>[];
    final sessions = ref.watch(mentorSessionsProvider).valueOrNull ?? const <MentorSession>[];

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          title: const Text('FitMitra'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Chip(
                avatar: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: Text(ref.watch(activeMembershipProvider).label),
              ),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList.list(
            children: <Widget>[
              GradientCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Your personalized wellness cockpit',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'AI chat, diet plans, yoga, meditation, recipes, live mentors, and daily tracking in one app.',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 18),
                    GoalSelector(
                      selectedGoal: goal,
                      onSelected: (next) => ref.read(selectedGoalProvider.notifier).state = next,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > 760;
                  final cards = <Widget>[
                    MetricRing(
                      progress: tracker.calorieProgress,
                      label: 'Calories today',
                      value: '${tracker.caloriesConsumed} / ${tracker.calorieTarget} kcal',
                      icon: Icons.local_fire_department_rounded,
                    ),
                    MetricRing(
                      progress: tracker.waterProgress,
                      label: 'Water intake',
                      value: '${tracker.waterConsumedMl} / ${tracker.waterTargetMl} ml',
                      icon: Icons.water_drop_rounded,
                    ),
                  ];
                  return wide
                      ? Row(children: cards.map((card) => Expanded(child: Padding(padding: const EdgeInsets.all(6), child: card))).toList())
                      : Column(children: cards.map((card) => Padding(padding: const EdgeInsets.only(bottom: 12), child: card)).toList());
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => ref.read(dailyTrackerProvider.notifier).addWater(250),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add 250 ml'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => ref.read(dailyTrackerProvider.notifier).addCalories(150),
                      icon: const Icon(Icons.restaurant_rounded),
                      label: const Text('Add snack'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SectionHeader(title: plan.name),
              const SizedBox(height: 12),
              Text(plan.summary),
              const SizedBox(height: 12),
              ...plan.meals.map((meal) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.restaurant_menu_rounded),
                      title: Text(meal.title),
                      subtitle: Text(meal.description),
                      trailing: Text('${meal.calories} kcal\n${meal.proteinGrams}g P', textAlign: TextAlign.end),
                    ),
                  )),
              const SizedBox(height: 28),
              const SectionHeader(title: 'Live Zoom mentor sessions'),
              const SizedBox(height: 12),
              ...sessions.map((session) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.video_call_rounded),
                      title: Text(session.title),
                      subtitle: Text('${session.mentorName} • ${DateFormat('EEE, MMM d • h:mm a').format(session.startsAt)}'),
                      trailing: session.isPremium ? const PremiumBadge() : const Icon(Icons.arrow_outward_rounded),
                      onTap: () => _launch(session.zoomUrl),
                    ),
                  )),
              const SizedBox(height: 28),
              const SectionHeader(title: 'Recommended for your goal'),
              const SizedBox(height: 12),
              ...products.map((product) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.shopping_bag_rounded),
                      title: Text(product.name),
                      subtitle: Text(product.reason),
                      trailing: Text('INR ${product.priceInr}'),
                      onTap: () => _launch(product.productUrl),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
