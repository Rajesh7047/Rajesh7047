import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gradient_container.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final _caloriesConsumedProvider = StateProvider<int>((ref) => 1240);
final _waterMlProvider = StateProvider<int>((ref) => 1800);
final _stepsProvider = StateProvider<int>((ref) => 6540);

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final calories = ref.watch(_caloriesConsumedProvider);
    final waterMl = ref.watch(_waterMlProvider);
    final steps = ref.watch(_stepsProvider);
    final calorieGoal = userAsync.valueOrNull?.dailyCalorieGoal ?? 2000;
    final waterGoalMl = ((userAsync.valueOrNull?.dailyWaterGoalLiters ?? 2.5) * 1000).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Tracking'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Calories'),
            Tab(text: 'Water'),
            Tab(text: 'Steps'),
          ],
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textTertiary,
          labelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CalorieTab(consumed: calories, goal: calorieGoal),
          _WaterTab(currentMl: waterMl, goalMl: waterGoalMl),
          _StepsTab(currentSteps: steps, goalSteps: 10000),
        ],
      ),
    );
  }
}

class _CalorieTab extends ConsumerWidget {
  final int consumed;
  final int goal;

  const _CalorieTab({required this.consumed, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remaining = goal - consumed;
    final burned = 320;
    final net = consumed - burned;
    final progress = (consumed / goal).clamp(0.0, 1.0);
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main calorie circle
          Center(
            child: SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 16,
                      backgroundColor: AppColors.primaryContainer,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        remaining < 0 ? AppColors.error : AppColors.primary,
                      ),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$consumed',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          color: remaining < 0 ? AppColors.error : AppColors.primary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const Text('kcal eaten', style: TextStyle(fontSize: 13, color: AppColors.textTertiary, fontFamily: 'Poppins')),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: (remaining < 0 ? AppColors.error : AppColors.primary).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${remaining.abs()} kcal ${remaining >= 0 ? "left" : "over"}',
                          style: TextStyle(
                            fontSize: 11,
                            color: remaining < 0 ? AppColors.error : AppColors.primary,
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
          ),
          const SizedBox(height: 24),

          // Stats row
          Row(
            children: [
              Expanded(child: _StatCard(icon: '🎯', label: 'Goal', value: '$goal kcal', color: AppColors.primary)),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(icon: '🔥', label: 'Burned', value: '$burned kcal', color: AppColors.accent)),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(icon: '⚡', label: 'Net', value: '$net kcal', color: AppColors.secondary)),
            ],
          ),
          const SizedBox(height: 24),

          // Quick add
          Text('Quick Add Food', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickAddButton(
                  emoji: '🍳',
                  label: 'Breakfast',
                  calories: 380,
                  onTap: () => ref.read(_caloriesConsumedProvider.notifier).update((s) => s + 380),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickAddButton(
                  emoji: '🥗',
                  label: 'Salad',
                  calories: 150,
                  onTap: () => ref.read(_caloriesConsumedProvider.notifier).update((s) => s + 150),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickAddButton(
                  emoji: '🍌',
                  label: 'Snack',
                  calories: 90,
                  onTap: () => ref.read(_caloriesConsumedProvider.notifier).update((s) => s + 90),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Weekly chart placeholder
          _WeeklyCalorieChart(),
        ],
      ),
    );
  }
}

class _WaterTab extends ConsumerWidget {
  final int currentMl;
  final int goalMl;

  const _WaterTab({required this.currentMl, required this.goalMl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = (currentMl / goalMl).clamp(0.0, 1.0);
    final remaining = goalMl - currentMl;
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientContainer(
            gradient: const LinearGradient(
              colors: [Color(0xFF0288D1), Color(0xFF0097A7)],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('💧 Water Intake', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                    Text('${(currentMl / 1000).toStringAsFixed(1)}L / ${(goalMl / 1000).toStringAsFixed(1)}L',
                        style: const TextStyle(color: Colors.white70, fontFamily: 'Poppins')),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  remaining > 0 ? '${(remaining / 1000).toStringAsFixed(1)}L more to go!' : 'Goal achieved! 🎉',
                  style: const TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text('Add Water', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _WaterButton('☕', '150ml', 150, ref)),
              const SizedBox(width: 10),
              Expanded(child: _WaterButton('🥤', '250ml', 250, ref)),
              const SizedBox(width: 10),
              Expanded(child: _WaterButton('🍶', '500ml', 500, ref)),
              const SizedBox(width: 10),
              Expanded(child: _WaterButton('🫙', '1L', 1000, ref)),
            ],
          ),
          const SizedBox(height: 24),

          Text('Today\'s Log', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          ..._buildWaterLog(theme),
        ],
      ),
    );
  }

  List<Widget> _buildWaterLog(ThemeData theme) {
    final log = [
      ('6:30 AM', 250, 'Morning glass'),
      ('8:00 AM', 300, 'With breakfast'),
      ('10:00 AM', 200, 'Mid-morning'),
      ('12:30 PM', 350, 'Before lunch'),
      ('3:00 PM', 200, 'Afternoon'),
      ('5:00 PM', 500, 'Post workout'),
    ];
    return log.take((currentMl / 250).ceil().clamp(0, log.length)).map((entry) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE1F5FE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Text('💧', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.$3, style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Poppins', fontSize: 13)),
                    Text(entry.$1, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Text('+${entry.$2}ml', style: const TextStyle(color: Color(0xFF0288D1), fontWeight: FontWeight.w600, fontFamily: 'Poppins', fontSize: 13)),
            ],
          ),
        )).toList();
  }
}

class _WaterButton extends StatelessWidget {
  final String emoji;
  final String label;
  final int ml;
  final WidgetRef ref;

  const _WaterButton(this.emoji, this.label, this.ml, this.ref);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ref.read(_waterMlProvider.notifier).update((s) => s + ml),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE1F5FE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF0288D1).withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: Color(0xFF0288D1))),
          ],
        ),
      ),
    );
  }
}

class _StepsTab extends StatelessWidget {
  final int currentSteps;
  final int goalSteps;

  const _StepsTab({required this.currentSteps, required this.goalSteps});

  @override
  Widget build(BuildContext context) {
    final progress = (currentSteps / goalSteps).clamp(0.0, 1.0);
    final km = currentSteps * 0.000762;
    final calories = (currentSteps * 0.04).round();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 14,
                      backgroundColor: AppColors.primaryContainer,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('👟', style: TextStyle(fontSize: 32)),
                      Text(
                        '$currentSteps',
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.success, fontFamily: 'Poppins'),
                      ),
                      const Text('of 10,000 steps', style: TextStyle(fontSize: 11, color: AppColors.textTertiary, fontFamily: 'Poppins')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _StatCard(icon: '📏', label: 'Distance', value: '${km.toStringAsFixed(2)} km', color: AppColors.success)),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(icon: '🔥', label: 'Burned', value: '$calories kcal', color: AppColors.accent)),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(icon: '⏱️', label: 'Time', value: '42 min', color: AppColors.secondary)),
            ],
          ),
          const SizedBox(height: 24),
          GradientContainer(
            gradient: const LinearGradient(colors: [Color(0xFF66BB6A), Color(0xFF43A047)]),
            child: Row(
              children: [
                const Text('🏆', style: TextStyle(fontSize: 36)),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('You\'re 65% there!', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                      Text('Keep walking to hit your daily goal', style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Poppins')),
                    ],
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

class _StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color, fontFamily: 'Poppins')),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textTertiary, fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final String emoji;
  final String label;
  final int calories;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.emoji,
    required this.label,
    required this.calories,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: AppColors.primaryDark)),
            Text('+$calories', style: const TextStyle(fontSize: 10, color: AppColors.primary, fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }
}

class _WeeklyCalorieChart extends StatelessWidget {
  const _WeeklyCalorieChart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = [1840, 1960, 1780, 2100, 1890, 2240, 1500];
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final maxVal = data.reduce((a, b) => a > b ? a : b).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('This Week', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) {
              final h = (data[i] / maxVal) * 100;
              final isToday = i == DateTime.now().weekday - 1;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${(data[i] / 1000).toStringAsFixed(1)}k',
                    style: TextStyle(
                      fontSize: 9,
                      color: isToday ? AppColors.primary : AppColors.textTertiary,
                      fontFamily: 'Poppins',
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300 + i * 50),
                    width: 28,
                    height: h,
                    decoration: BoxDecoration(
                      gradient: isToday
                          ? AppColors.primaryGradient
                          : LinearGradient(colors: [
                              AppColors.primary.withValues(alpha: 0.4),
                              AppColors.primary.withValues(alpha: 0.2),
                            ]),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    days[i],
                    style: TextStyle(
                      fontSize: 11,
                      color: isToday ? AppColors.primary : AppColors.textTertiary,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
