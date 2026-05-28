import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitmitra/core/constants/health_goals.dart';
import 'package:fitmitra/core/providers/auth_state_provider.dart';
import 'package:fitmitra/core/providers/repository_providers.dart';
import 'package:fitmitra/core/utils/result.dart';
import 'package:fitmitra/shared/widgets/goal_chip.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  String? _selectedGoalId;
  bool _loading = false;

  Future<void> _continue() async {
    final user = ref.read(currentUserProvider);
    if (user == null || _selectedGoalId == null) return;

    setState(() => _loading = true);
    final updated = user.copyWith(healthGoalId: _selectedGoalId);
    final result =
        await ref.read(authRepositoryProvider).updateProfile(updated);
    if (!mounted) return;
    setState(() => _loading = false);

    result.when(
      success: (_) => context.go('/home'),
      error: (f) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(f.message)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Wellness Goal')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What is your primary health goal?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'We personalize diet plans, products & AI coaching for you.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: HealthGoals.all.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final goal = HealthGoals.all[index];
                  final selected = _selectedGoalId == goal.id;
                  return Card(
                    color: selected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    child: ListTile(
                      leading: GoalChip(
                        goal: goal,
                        selected: selected,
                        onTap: () =>
                            setState(() => _selectedGoalId = goal.id),
                      ),
                      title: Text(goal.title),
                      subtitle: Text(goal.description),
                      onTap: () => setState(() => _selectedGoalId = goal.id),
                    ),
                  );
                },
              ),
            ),
            FilledButton(
              onPressed:
                  _selectedGoalId == null || _loading ? null : _continue,
              child: _loading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
