import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/premium_badge.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/services/theme_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../membership/presentation/screens/membership_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      body: SafeArea(
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (user) {
            if (user == null) return const SizedBox();
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ).animate().scale(duration: 400.ms),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(user.name, style: Theme.of(context).textTheme.headlineMedium),
                      if (user.isPremium) ...[
                        const SizedBox(width: 8),
                        const PremiumBadge(size: 22),
                      ],
                    ],
                  ),
                  Text(
                    '+91 ${user.phone}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  if (user.bmi != null)
                    CustomCard(
                      gradient: AppColors.cardGradient,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('BMI', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                Text(
                                  user.bmi!.toStringAsFixed(1),
                                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
                                ),
                                Text(user.bmiCategory, style: const TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                          _buildStatColumn('Weight', '${user.weight?.toStringAsFixed(0) ?? "-"} kg'),
                          const SizedBox(width: 16),
                          _buildStatColumn('Height', '${user.height?.toStringAsFixed(0) ?? "-"} cm'),
                          const SizedBox(width: 16),
                          _buildStatColumn('Age', '${user.age ?? "-"}'),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (!user.isPremium)
                    CustomCard(
                      gradient: AppColors.premiumGradient,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MembershipScreen()),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 36),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Upgrade to Premium', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                                const Text('Unlock all features', style: TextStyle(color: Colors.white70, fontSize: 13)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  SectionHeader(title: 'Settings', icon: Icons.settings_outlined),
                  _buildSettingTile(
                    context,
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: themeMode == ThemeMode.dark,
                      onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
                      activeColor: AppColors.primary,
                    ),
                  ),
                  _buildSettingTile(context, icon: Icons.person_outline_rounded, title: 'Edit Profile'),
                  _buildSettingTile(context, icon: Icons.notifications_outlined, title: 'Notifications'),
                  _buildSettingTile(context, icon: Icons.help_outline_rounded, title: 'Help & Support'),
                  _buildSettingTile(context, icon: Icons.privacy_tip_outlined, title: 'Privacy Policy'),
                  _buildSettingTile(context, icon: Icons.description_outlined, title: 'Terms of Service'),
                  const SizedBox(height: 16),
                  CustomCard(
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text('Logout', style: TextStyle(color: AppColors.error)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        ref.read(userProvider.notifier).signOut();
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded, color: AppColors.error),
                        const SizedBox(width: 12),
                        Text('Logout', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildSettingTile(BuildContext context, {required IconData icon, required String title, Widget? trailing}) {
    return CustomCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
          trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        ],
      ),
    );
  }
}
