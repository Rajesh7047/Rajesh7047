import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitmitra/core/constants/health_goals.dart';
import 'package:fitmitra/core/providers/auth_state_provider.dart';
import 'package:fitmitra/core/providers/repository_providers.dart';
import 'package:fitmitra/core/providers/theme_mode_provider.dart';
import 'package:fitmitra/core/utils/result.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final themeMode = ref.watch(themeModeProvider);
    final goal = HealthGoals.byId(user?.healthGoalId);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text(
                (user?.displayName ?? 'F').substring(0, 1).toUpperCase(),
              ),
            ),
            title: Text(user?.displayName ?? 'FitMitra User'),
            subtitle: Text(user?.phoneNumber ?? ''),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Health Goal'),
            subtitle: Text(goal?.title ?? 'Not set'),
            onTap: () => context.go('/onboarding'),
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text('Membership'),
            subtitle: Text(
              user?.hasActivePremium == true ? 'Premium active' : 'Free plan',
            ),
            onTap: () => context.push('/membership'),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Theme'),
            subtitle: Text(themeMode.name),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              underline: const SizedBox.shrink(),
              items: ThemeMode.values
                  .map(
                    (m) => DropdownMenuItem(
                      value: m,
                      child: Text(m.name),
                    ),
                  )
                  .toList(),
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeModeProvider.notifier).setMode(mode);
                }
              },
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed: () async {
              final result =
                  await ref.read(authRepositoryProvider).signOut();
              result.when(
                success: (_) {
                  if (context.mounted) context.go('/login');
                },
                error: (f) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(f.message)),
                  );
                },
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
