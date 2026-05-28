import 'package:fitmitra/features/recommendations/application/recommendation_engine.dart';
import 'package:fitmitra/shared/models/health_goal.dart';
import 'package:flutter/material.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  final _engine = RecommendationEngine();
  HealthGoal _goal = HealthGoal.weightLoss;

  @override
  Widget build(BuildContext context) {
    final items = _engine.forGoal(_goal);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SegmentedButton<HealthGoal>(
          segments: HealthGoal.values
              .map((goal) => ButtonSegment(value: goal, label: Text(goal.label)))
              .toList(),
          selected: {_goal},
          onSelectionChanged: (value) => setState(() => _goal = value.first),
        ),
        const SizedBox(height: 16),
        ...items.map(
          (item) => Card(
            child: ListTile(
              title: Text(item.name),
              subtitle: Text(item.reason),
              trailing: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ),
      ],
    );
  }
}
