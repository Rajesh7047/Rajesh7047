import 'package:fitmitra/features/tracking/application/tracker_controller.dart';
import 'package:fitmitra/shared/widgets/metric_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracking = ref.watch(trackerControllerProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        MetricCard(
          title: 'Calories today',
          value: '${tracking.calories} kcal',
          actionLabel: '+100',
          onActionPressed: () => ref
              .read(trackerControllerProvider.notifier)
              .addCalories(uid: userId, calories: 100),
        ),
        const SizedBox(height: 10),
        MetricCard(
          title: 'Water intake',
          value: '${tracking.waterMl} ml',
          actionLabel: '+250ml',
          onActionPressed: () => ref
              .read(trackerControllerProvider.notifier)
              .addWater(uid: userId, waterMl: 250),
        ),
      ],
    );
  }
}
