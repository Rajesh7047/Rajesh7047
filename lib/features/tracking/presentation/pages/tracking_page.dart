import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmitra/core/providers/auth_state_provider.dart';
import 'package:fitmitra/core/utils/result.dart';
import 'package:fitmitra/core/providers/repository_providers.dart';
import 'package:fitmitra/domain/entities/daily_tracking.dart';
import 'package:fitmitra/shared/widgets/fit_card.dart';

final trackingProvider = FutureProvider.autoDispose<DailyTracking>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return const DailyTracking(
      dateKey: '',
      caloriesConsumed: 0,
      waterMl: 0,
    );
  }
  final result =
      await ref.read(trackingRepositoryProvider).getTodayTracking(user.uid);
  return result.when(
    success: (d) => d,
    error: (_) => const DailyTracking(
      dateKey: '',
      caloriesConsumed: 0,
      waterMl: 0,
    ),
  );
});

class TrackingPage extends ConsumerWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackingAsync = ref.watch(trackingProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Tracking')),
      body: trackingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Unable to load tracking')),
        data: (tracking) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FitCard(
              child: Column(
                children: [
                  Text(
                    'Calories',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: tracking.caloriesConsumed,
                            color: Theme.of(context).colorScheme.primary,
                            title: '${tracking.caloriesConsumed.toInt()}',
                            radius: 50,
                          ),
                          PieChartSectionData(
                            value: (tracking.calorieGoal -
                                    tracking.caloriesConsumed)
                                .clamp(0, double.infinity),
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            title: '',
                            radius: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text('Goal: ${tracking.calorieGoal.toInt()} kcal'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [200, 400, 600]
                        .map(
                          (c) => ActionChip(
                            label: Text('+$c'),
                            onPressed: user == null
                                ? null
                                : () => _addCalories(ref, user.uid, c.toDouble()),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FitCard(
              child: Column(
                children: [
                  Text(
                    'Water Intake',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: tracking.waterProgress,
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${tracking.waterMl.toInt()} / ${tracking.waterGoalMl.toInt()} ml',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [250, 500]
                        .map(
                          (ml) => ActionChip(
                            label: Text('+$ml ml'),
                            onPressed: user == null
                                ? null
                                : () => _addWater(ref, user.uid, ml.toDouble()),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addCalories(WidgetRef ref, String uid, double amount) async {
    await ref.read(trackingRepositoryProvider).addCalories(uid, amount);
    ref.invalidate(trackingProvider);
  }

  Future<void> _addWater(WidgetRef ref, String uid, double ml) async {
    await ref.read(trackingRepositoryProvider).addWater(uid, ml);
    ref.invalidate(trackingProvider);
  }
}
