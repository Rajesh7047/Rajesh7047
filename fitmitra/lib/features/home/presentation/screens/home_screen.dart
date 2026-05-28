import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/premium_badge.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../ai_chat/presentation/screens/ai_chat_screen.dart';
import '../../../diet_plan/presentation/screens/diet_plan_screen.dart';
import '../../../yoga/presentation/screens/yoga_screen.dart';
import '../../../meditation/presentation/screens/meditation_screen.dart';
import '../../../recipes/presentation/screens/recipes_screen.dart';
import '../../../products/presentation/screens/products_screen.dart';
import '../../../tracking/presentation/screens/tracking_screen.dart';
import '../../../mentor/presentation/screens/mentor_screen.dart';
import '../../../membership/presentation/screens/membership_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error loading profile')),
          data: (user) {
            final greeting = _getGreeting();
            return RefreshIndicator(
              onRefresh: () async {
                if (user != null) {
                  await ref.read(userProvider.notifier).loadUser(user.uid);
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                greeting,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    ),
                              ),
                              Text(
                                user?.name ?? 'User',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ),
                        if (user?.isPremium == true) const PremiumBadge(showLabel: true),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Text(
                            user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 20),

                    // Daily Progress Card
                    CustomCard(
                      gradient: AppColors.primaryGradient,
                      animationIndex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Today's Progress",
                                  style: TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Keep going! 💪',
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    _buildMiniStat(Icons.local_fire_department_rounded, '1,200', 'kcal'),
                                    const SizedBox(width: 16),
                                    _buildMiniStat(Icons.water_drop_rounded, '1,500', 'ml'),
                                    const SizedBox(width: 16),
                                    _buildMiniStat(Icons.self_improvement_rounded, '20', 'min'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          CircularPercentIndicator(
                            radius: 40,
                            lineWidth: 6,
                            percent: 0.65,
                            center: const Text('65%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                            progressColor: Colors.white,
                            backgroundColor: Colors.white24,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    SectionHeader(title: 'Quick Actions', icon: Icons.flash_on_rounded),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                      children: [
                        _buildQuickAction(context, Icons.chat_bubble_rounded, 'AI Chat', AppColors.primary, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const AIChatScreen()));
                        }),
                        _buildQuickAction(context, Icons.restaurant_menu_rounded, 'Diet Plan', AppColors.success, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const DietPlanScreen()));
                        }),
                        _buildQuickAction(context, Icons.self_improvement_rounded, 'Yoga', AppColors.accent, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const YogaScreen()));
                        }),
                        _buildQuickAction(context, Icons.spa_rounded, 'Meditate', AppColors.secondary, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const MeditationScreen()));
                        }),
                        _buildQuickAction(context, Icons.monitor_weight_rounded, 'Tracking', const Color(0xFFFF6B6B), () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const TrackingScreen()));
                        }),
                        _buildQuickAction(context, Icons.videocam_rounded, 'Recipes', const Color(0xFF45B7D1), () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const RecipesScreen()));
                        }),
                        _buildQuickAction(context, Icons.shopping_bag_rounded, 'Products', const Color(0xFFFF9F43), () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductsScreen()));
                        }),
                        _buildQuickAction(context, Icons.groups_rounded, 'Mentor', const Color(0xFF6C5CE7), () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const MentorScreen()));
                        }),
                      ],
                    ),
                    const SizedBox(height: 20),

                    if (user?.isPremium != true) ...[
                      CustomCard(
                        gradient: AppColors.premiumGradient,
                        animationIndex: 3,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MembershipScreen())),
                        child: Row(
                          children: [
                            const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 40),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Go Premium', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                                  const Text('Unlock AI chat, diet plans & more', style: TextStyle(color: Colors.white70, fontSize: 13)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('₹299/mo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    SectionHeader(title: 'Your Goal', icon: Icons.track_changes_rounded),
                    CustomCard(
                      animationIndex: 4,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getGoalIcon(user?.goal ?? ''),
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user?.goal ?? 'Not set', style: Theme.of(context).textTheme.titleLarge),
                                Text(
                                  _getGoalDescription(user?.goal ?? ''),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.edit_rounded, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    SectionHeader(title: 'Health Tips', icon: Icons.tips_and_updates_rounded),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _healthTips.length,
                        itemBuilder: (context, index) {
                          final tip = _healthTips[index];
                          return Container(
                            width: 280,
                            margin: EdgeInsets.only(right: 12),
                            child: CustomCard(
                              animationIndex: 5 + index,
                              margin: EdgeInsets.zero,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(tip['icon'] as IconData, color: AppColors.primary, size: 20),
                                      const SizedBox(width: 8),
                                      Text(tip['category'] as String, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(tip['title'] as String, style: Theme.of(context).textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text(tip['desc'] as String, style: Theme.of(context).textTheme.bodySmall, maxLines: 3, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildMiniStat(IconData icon, String value, String unit) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(width: 2),
        Text(unit, style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  IconData _getGoalIcon(String goal) {
    switch (goal) {
      case 'Weight Loss': return Icons.trending_down_rounded;
      case 'Weight Gain': return Icons.trending_up_rounded;
      case 'PCOD/Thyroid Management': return Icons.health_and_safety_rounded;
      case 'Muscle Building': return Icons.fitness_center_rounded;
      case 'Stress Relief': return Icons.spa_rounded;
      default: return Icons.flag_rounded;
    }
  }

  String _getGoalDescription(String goal) {
    switch (goal) {
      case 'Weight Loss': return 'Personalized plans to help you lose weight healthily';
      case 'Weight Gain': return 'Structured nutrition for healthy weight gain';
      case 'PCOD/Thyroid Management': return 'Specialized plans for hormonal balance';
      case 'Muscle Building': return 'High-protein plans for lean muscle growth';
      case 'Stress Relief': return 'Mindfulness & nutrition for stress management';
      default: return 'Set a goal to get personalized recommendations';
    }
  }

  static final List<Map<String, dynamic>> _healthTips = [
    {'icon': Icons.water_drop_rounded, 'category': 'Hydration', 'title': 'Drink Water First Thing', 'desc': 'Start your day with 2 glasses of warm water to boost metabolism and flush toxins.'},
    {'icon': Icons.bedtime_rounded, 'category': 'Sleep', 'title': '7-8 Hours of Sleep', 'desc': 'Quality sleep is essential for recovery, hormone balance, and weight management.'},
    {'icon': Icons.restaurant_rounded, 'category': 'Nutrition', 'title': 'Eat Mindfully', 'desc': 'Chew your food 32 times. Mindful eating helps in better digestion and portion control.'},
    {'icon': Icons.directions_walk_rounded, 'category': 'Activity', 'title': '10,000 Steps Daily', 'desc': 'Walking is the simplest exercise. Aim for 10,000 steps to stay active throughout the day.'},
  ];
}
