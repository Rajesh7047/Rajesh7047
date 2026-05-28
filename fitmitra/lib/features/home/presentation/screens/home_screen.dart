import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/gradient_container.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: ErrorStateWidget(message: e.toString())),
      data: (user) {
        final greeting = DateTime.now().greeting;
        final name = user?.name?.split(' ').first ?? 'Friend';

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context, greeting, name, user?.isPremium ?? false),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 20),
                    _DailySummaryCard(
                      caloriesConsumed: 1240,
                      calorieGoal: user?.dailyCalorieGoal ?? 2000,
                      waterLiters: 1.8,
                      waterGoal: user?.dailyWaterGoalLiters ?? 2.5,
                      steps: 6540,
                    ),
                    const SizedBox(height: 20),
                    _BmiStreakRow(
                      bmi: user?.bmi,
                      streakDays: 7,
                    ),
                    const SizedBox(height: 24),
                    _QuickActionsGrid(goal: user?.healthGoal ?? 'Weight Loss'),
                    const SizedBox(height: 24),
                    _FeaturedPlanBanner(goal: user?.healthGoal ?? 'Weight Loss'),
                    const SizedBox(height: 24),
                    _SectionTitle(title: 'Today\'s Recommendations', onSeeAll: () {}),
                    const SizedBox(height: 12),
                    _RecommendationsRow(goal: user?.healthGoal ?? 'Weight Loss'),
                    const SizedBox(height: 24),
                    _SectionTitle(title: 'Live Mentor Sessions', onSeeAll: () => context.go('/main/mentor')),
                    const SizedBox(height: 12),
                    _UpcomingSessionsRow(),
                    const SizedBox(height: 24),
                    _SectionTitle(title: 'Trending Recipes', onSeeAll: () => context.go('/main/recipes')),
                    const SizedBox(height: 12),
                    _TrendingRecipesRow(),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, String greeting, String name, bool isPremium) {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 80,
      floating: true,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 1,
      automaticallyImplyLeading: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        title: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting, $name! 👋',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Let\'s stay healthy today',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textTertiary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, size: 24),
                  onPressed: () {},
                  color: AppColors.textPrimary,
                ),
                GestureDetector(
                  onTap: () => context.go('/main/profile'),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'FM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DailySummaryCard extends StatelessWidget {
  final int caloriesConsumed;
  final int calorieGoal;
  final double waterLiters;
  final double waterGoal;
  final int steps;

  const _DailySummaryCard({
    required this.caloriesConsumed,
    required this.calorieGoal,
    required this.waterLiters,
    required this.waterGoal,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      gradient: AppColors.primaryGradient,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Summary",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  DateTime.now().formattedDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.local_fire_department_rounded,
                  value: caloriesConsumed.toString(),
                  unit: 'kcal',
                  label: 'Calories',
                  progress: caloriesConsumed / calorieGoal,
                ),
              ),
              Container(width: 1, height: 50, color: Colors.white.withValues(alpha: 0.3)),
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.water_drop_outlined,
                  value: waterLiters.toStringAsFixed(1),
                  unit: 'L',
                  label: 'Water',
                  progress: waterLiters / waterGoal,
                ),
              ),
              Container(width: 1, height: 50, color: Colors.white.withValues(alpha: 0.3)),
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.directions_walk_rounded,
                  value: (steps / 1000).toStringAsFixed(1),
                  unit: 'K',
                  label: 'Steps',
                  progress: steps / 10000,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  final String label;
  final double progress;

  const _SummaryMetric({
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2, left: 2),
              child: Text(
                unit,
                style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 60,
          height: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

class _BmiStreakRow extends StatelessWidget {
  final double? bmi;
  final int streakDays;

  const _BmiStreakRow({this.bmi, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bmiValue = bmi ?? 22.4;
    String bmiCategory;
    Color bmiColor;
    if (bmiValue < 18.5) {
      bmiCategory = 'Underweight';
      bmiColor = AppColors.info;
    } else if (bmiValue < 25) {
      bmiCategory = 'Normal';
      bmiColor = AppColors.success;
    } else if (bmiValue < 30) {
      bmiCategory = 'Overweight';
      bmiColor = AppColors.warning;
    } else {
      bmiCategory = 'Obese';
      bmiColor = AppColors.error;
    }

    return Row(
      children: [
        Expanded(
          child: AppCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: bmiColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      bmiValue.toStringAsFixed(1),
                      style: TextStyle(
                        color: bmiColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BMI Index', style: theme.textTheme.labelMedium),
                    Text(
                      bmiCategory,
                      style: TextStyle(
                        color: bmiColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '🔥',
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Streak', style: theme.textTheme.labelMedium),
                    Text(
                      '$streakDays Days',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final String goal;

  const _QuickActionsGrid({required this.goal});

  @override
  Widget build(BuildContext context) {
    final actions = _getActions(goal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Quick Actions', onSeeAll: null),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: actions.length,
          itemBuilder: (context, i) {
            final action = actions[i];
            return _QuickActionItem(
              emoji: action.$1,
              label: action.$2,
              color: action.$3,
              onTap: () => context.go(action.$4),
            );
          },
        ),
      ],
    );
  }

  List<(String, String, Color, String)> _getActions(String goal) {
    return [
      ('🥗', 'Diet Plan', AppColors.primary, '/main/diet'),
      ('🧘', 'Yoga', AppColors.secondary, '/main/yoga'),
      ('😌', 'Meditate', AppColors.accent, '/main/meditation'),
      ('🍳', 'Recipes', const Color(0xFF2196F3), '/main/recipes'),
      ('📊', 'Tracking', const Color(0xFF4CAF50), '/main/tracking'),
      ('🛒', 'Products', const Color(0xFFFF6B35), '/main/products'),
      ('👨‍⚕️', 'Mentor', const Color(0xFF9C27B0), '/main/mentor'),
      ('👑', 'Premium', const Color(0xFFFFAB00), '/main/membership'),
    ];
  }
}

class _QuickActionItem extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.emoji,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _FeaturedPlanBanner extends StatelessWidget {
  final String goal;

  const _FeaturedPlanBanner({required this.goal});

  @override
  Widget build(BuildContext context) {
    final isWeightLoss = goal.contains('Weight Loss');

    return GestureDetector(
      onTap: () => context.go('/main/diet'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isWeightLoss
              ? const LinearGradient(colors: [Color(0xFFFF5252), Color(0xFFFF8A65)])
              : AppColors.secondaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (isWeightLoss ? AppColors.weightLoss : AppColors.secondary).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Your Plan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    goal,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'View personalized meals →',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const Text('🥗', style: TextStyle(fontSize: 60)),
          ],
        ),
      ),
    );
  }
}

class _RecommendationsRow extends StatelessWidget {
  final String goal;

  const _RecommendationsRow({required this.goal});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('🥦', 'Broccoli Detox', '45 kcal', AppColors.primary),
      ('🍎', 'Apple Smoothie', '120 kcal', AppColors.accent),
      ('🥚', 'Egg White Bowl', '180 kcal', const Color(0xFFFF9800)),
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final item = items[i];
          return Container(
            width: 130,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: item.$4.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: item.$4.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.$1, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 6),
                Text(
                  item.$2,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.$3,
                  style: TextStyle(
                    fontSize: 11,
                    color: item.$4,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UpcomingSessionsRow extends StatelessWidget {
  const _UpcomingSessionsRow();

  @override
  Widget build(BuildContext context) {
    final sessions = [
      ('👩‍⚕️', 'Dr. Priya Sharma', 'Nutrition Expert', 'Today 6:00 PM', true),
      ('🧘‍♀️', 'Ananya Singh', 'Yoga Instructor', 'Tomorrow 7:00 AM', false),
    ];

    return Column(
      children: sessions.map((s) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: AppCard(
          onTap: () => context.go('/main/mentor'),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text(s.$1, style: const TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(s.$2, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, fontFamily: 'Poppins')),
                        if (s.$5) ...[const SizedBox(width: 6), const LiveChip()],
                      ],
                    ),
                    Text(s.$3, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary, fontFamily: 'Poppins')),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(s.$4, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary, fontFamily: 'Poppins')),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: s.$5 ? AppColors.primary : AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      s.$5 ? 'Join' : 'Book',
                      style: TextStyle(
                        color: s.$5 ? Colors.white : AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }
}

class _TrendingRecipesRow extends StatelessWidget {
  const _TrendingRecipesRow();

  @override
  Widget build(BuildContext context) {
    final recipes = [
      ('🥗', 'Greek Salad', '15 min', '220 kcal'),
      ('🍲', 'Dal Khichdi', '25 min', '310 kcal'),
      ('🥤', 'Mango Smoothie', '5 min', '165 kcal'),
    ];

    return SizedBox(
      height: 155,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final r = recipes[i];
          return GestureDetector(
            onTap: () => context.go('/main/recipes'),
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Center(child: Text(r.$1, style: const TextStyle(fontSize: 44))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.$2, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, fontFamily: 'Poppins'), maxLines: 1),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 12, color: AppColors.textTertiary),
                            const SizedBox(width: 3),
                            Text(r.$3, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary, fontFamily: 'Poppins')),
                            const SizedBox(width: 8),
                            const Icon(Icons.local_fire_department_outlined, size: 12, color: AppColors.accent),
                            const SizedBox(width: 3),
                            Text(r.$4, style: const TextStyle(fontSize: 11, color: AppColors.accent, fontFamily: 'Poppins')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionTitle({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text('See All'),
          ),
      ],
    );
  }
}
