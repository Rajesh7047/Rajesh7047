import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_environment.dart';
import '../../state/app_providers.dart';
import '../widgets/fitmitra_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final themeMode = ref.watch(themeModeProvider);
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(pinned: true, title: const Text('Profile')),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList.list(
            children: <Widget>[
              GradientCard(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white,
                      child: Text(_initialFor(user?.displayName), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(user?.displayName ?? 'Guest member', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                          Text(user?.phoneNumber ?? 'Demo mode', style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Card(
                child: Column(
                  children: <Widget>[
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.system,
                      groupValue: themeMode,
                      onChanged: (mode) => ref.read(themeModeProvider.notifier).setThemeMode(mode!),
                      title: const Text('System theme'),
                    ),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.light,
                      groupValue: themeMode,
                      onChanged: (mode) => ref.read(themeModeProvider.notifier).setThemeMode(mode!),
                      title: const Text('Light theme'),
                    ),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.dark,
                      groupValue: themeMode,
                      onChanged: (mode) => ref.read(themeModeProvider.notifier).setThemeMode(mode!),
                      title: const Text('Dark theme'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.support_agent_rounded),
                      title: const Text('Call support'),
                      subtitle: Text(AppEnvironment.supportPhone),
                      onTap: () => launchUrl(Uri.parse('tel:${AppEnvironment.supportPhone}')),
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout_rounded),
                      title: Text(user == null ? 'Go to login' : 'Sign out'),
                      onTap: () async {
                        if (user != null) await ref.read(authRepositoryProvider).signOut();
                        if (context.mounted) context.go('/login');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  String _initialFor(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return 'G';
    return trimmed.characters.first.toUpperCase();
  }

}
