import 'package:fitmitra/src/core/widgets/app_card.dart';
import 'package:fitmitra/src/core/widgets/metric_tile.dart';
import 'package:fitmitra/src/features/tracking/presentation/controllers/tracking_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackerPage extends ConsumerWidget {
  const TrackerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracking = ref.watch(trackingControllerProvider);
    final controller = ref.read(trackingControllerProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: MediaQuery.sizeOf(context).width > 920 ? 2 : 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.4,
            children: [
              MetricTile(
                icon: Icons.local_fire_department_rounded,
                label: 'Calories logged',
                value: '${tracking.caloriesConsumed} kcal',
                caption: 'Target ${tracking.calorieTarget} kcal',
                progress: tracking.calorieProgress,
              ),
              MetricTile(
                icon: Icons.water_drop_rounded,
                label: 'Water intake',
                value: '${tracking.waterMl} ml',
                caption: 'Target ${tracking.waterTargetMl} ml',
                progress: tracking.waterProgress,
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick calorie log',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final calories in [120, 250, 420, 650])
                      FilledButton.tonal(
                        onPressed: () => controller.logCalories(calories),
                        child: Text('+ $calories kcal'),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick hydration log',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final amount in [250, 400, 600, 1000])
                      FilledButton.tonal(
                        onPressed: () => controller.addWater(amount),
                        child: Text('+ $amount ml'),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Reset the current day when you start over or want to demo the tracker again.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: controller.resetToday,
                  icon: const Icon(Icons.restart_alt_rounded),
                  label: const Text('Reset today'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
