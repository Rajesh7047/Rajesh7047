import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gradient_container.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final themeMode = ref.watch(themeModeProvider);
    final user = userAsync.valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () => context.go('/main/profile'),
                child: GradientContainer(
                  gradient: AppColors.primaryGradient,
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            user?.initials ?? 'FM',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'FitMitra User',
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                            ),
                            Text(
                              user?.phoneNumber ?? '',
                              style: const TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Poppins'),
                            ),
                            if (user?.isPremium == true) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 12),
                                    SizedBox(width: 4),
                                    Text('Premium', style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Poppins')),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 16),
                    ],
                  ),
                ),
              ),
            ),

            // Settings sections
            _SettingsSection(title: 'Appearance', items: [
              _SettingsItem(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                trailing: Switch.adaptive(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (v) => ref.read(themeModeProvider.notifier)
                      .setTheme(v ? ThemeMode.dark : ThemeMode.light),
                  activeColor: AppColors.primary,
                ),
              ),
            ]),

            _SettingsSection(title: 'Health & Goals', items: [
              _SettingsItem(
                icon: Icons.person_outline_rounded,
                title: 'Edit Profile',
                subtitle: 'Update your health details',
                onTap: () => context.go('/main/profile'),
              ),
              _SettingsItem(
                icon: Icons.flag_outlined,
                title: 'Health Goal',
                subtitle: user?.healthGoal ?? 'Not set',
                onTap: () => context.go('/main/profile'),
              ),
              _SettingsItem(
                icon: Icons.local_fire_department_outlined,
                title: 'Calorie Goal',
                subtitle: '${user?.dailyCalorieGoal ?? 2000} kcal/day',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.water_drop_outlined,
                title: 'Water Goal',
                subtitle: '${user?.dailyWaterGoalLiters?.toStringAsFixed(1) ?? "2.5"} L/day',
                onTap: () {},
              ),
            ]),

            _SettingsSection(title: 'Membership', items: [
              _SettingsItem(
                icon: Icons.workspace_premium_outlined,
                title: user?.isPremium == true ? 'Premium Member' : 'Upgrade to Premium',
                subtitle: user?.isPremium == true ? 'Active subscription' : 'Unlock all features',
                trailing: user?.isPremium != true
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: AppColors.premiumGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('Upgrade', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                      )
                    : null,
                onTap: () => context.go('/main/membership'),
              ),
            ]),

            _SettingsSection(title: 'Notifications', items: [
              _SettingsItem(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                subtitle: 'Meal reminders, workout alerts',
                trailing: Switch.adaptive(
                  value: user?.notificationsEnabled ?? true,
                  onChanged: (v) {},
                  activeColor: AppColors.primary,
                ),
              ),
              _SettingsItem(
                icon: Icons.water_drop_outlined,
                title: 'Water Reminders',
                subtitle: 'Every 2 hours',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.restaurant_outlined,
                title: 'Meal Reminders',
                subtitle: 'Breakfast, lunch & dinner',
                onTap: () {},
              ),
            ]),

            _SettingsSection(title: 'Support', items: [
              _SettingsItem(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.star_outline_rounded,
                title: 'Rate Us',
                subtitle: 'Enjoying FitMitra? Leave a review!',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.info_outline_rounded,
                title: 'App Version',
                subtitle: 'v1.0.0',
              ),
            ]),

            _SettingsSection(title: 'Account', items: [
              _SettingsItem(
                icon: Icons.logout_rounded,
                title: 'Logout',
                titleColor: AppColors.error,
                onTap: () => _confirmLogout(context, ref),
              ),
              _SettingsItem(
                icon: Icons.delete_forever_outlined,
                title: 'Delete Account',
                titleColor: AppColors.error,
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout from FitMitra?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) context.go(AppRoutes.phoneLogin);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  _SettingsTile(item: item),
                  if (i < items.length - 1)
                    Divider(
                      height: 1,
                      indent: 56,
                      endIndent: 16,
                      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  });
}

class _SettingsTile extends StatelessWidget {
  final _SettingsItem item;

  const _SettingsTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: (item.titleColor ?? AppColors.primary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          item.icon,
          size: 18,
          color: item.titleColor ?? AppColors.primary,
        ),
      ),
      title: Text(
        item.title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: item.titleColor,
        ),
      ),
      subtitle: item.subtitle != null
          ? Text(
              item.subtitle!,
              style: Theme.of(context).textTheme.bodySmall,
            )
          : null,
      trailing: item.trailing ??
          (item.onTap != null
              ? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textTertiary)
              : null),
      onTap: item.onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}
