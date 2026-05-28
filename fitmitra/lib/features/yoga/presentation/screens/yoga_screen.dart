import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/section_header.dart';
import 'package:url_launcher/url_launcher.dart';

class YogaScreen extends StatelessWidget {
  const YogaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Yoga & Exercise'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6584), Color(0xFFFF8BA7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              animationIndex: 0,
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Daily Yoga', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                        SizedBox(height: 4),
                        Text('Start your day with mindful movement', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.timer_outlined, color: Colors.white70, size: 16),
                            SizedBox(width: 4),
                            Text('15-30 min', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            SizedBox(width: 12),
                            Icon(Icons.local_fire_department, color: Colors.white70, size: 16),
                            SizedBox(width: 4),
                            Text('100-200 kcal', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.self_improvement_rounded, color: Colors.white, size: 64),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SectionHeader(title: 'Categories', icon: Icons.category_rounded),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategory(context, 'Beginner', Icons.star_outline_rounded, const Color(0xFF4CAF50)),
                  _buildCategory(context, 'Weight Loss', Icons.trending_down_rounded, const Color(0xFFFF9800)),
                  _buildCategory(context, 'Flexibility', Icons.accessibility_new_rounded, const Color(0xFF2196F3)),
                  _buildCategory(context, 'Pranayama', Icons.air_rounded, const Color(0xFF9C27B0)),
                  _buildCategory(context, 'Power Yoga', Icons.flash_on_rounded, const Color(0xFFF44336)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SectionHeader(title: 'Popular Sessions', icon: Icons.play_circle_rounded),
            ...yogaVideos.asMap().entries.map((entry) {
              final video = entry.value;
              return CustomCard(
                animationIndex: entry.key + 1,
                onTap: () => _launchUrl(video['url'] as String),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 72,
                      decoration: BoxDecoration(
                        color: (video['color'] as Color).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(video['icon'] as IconData, color: video['color'] as Color, size: 32),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(video['duration'] as String, style: const TextStyle(color: Colors.white, fontSize: 10)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(video['title'] as String, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(video['instructor'] as String, style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.local_fire_department, size: 14, color: AppColors.accent),
                              const SizedBox(width: 2),
                              Text('${video['calories']} kcal', style: TextStyle(fontSize: 12, color: AppColors.accent)),
                              const SizedBox(width: 12),
                              Text(video['level'] as String, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.play_circle_filled_rounded, color: AppColors.primary, size: 36),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: CustomCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        color: color.withOpacity(0.08),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static final List<Map<String, dynamic>> yogaVideos = [
    {'title': 'Surya Namaskar for Beginners', 'instructor': 'FitMitra Instructor', 'duration': '15:00', 'level': 'Beginner', 'calories': 120, 'color': const Color(0xFFFF9800), 'icon': Icons.wb_sunny_rounded, 'url': 'https://youtube.com/watch?v=surya-namaskar'},
    {'title': 'Power Yoga - Fat Burn', 'instructor': 'FitMitra Instructor', 'duration': '25:00', 'level': 'Intermediate', 'calories': 250, 'color': const Color(0xFFF44336), 'icon': Icons.flash_on_rounded, 'url': 'https://youtube.com/watch?v=power-yoga'},
    {'title': 'Pranayama Breathing', 'instructor': 'FitMitra Instructor', 'duration': '10:00', 'level': 'All Levels', 'calories': 50, 'color': const Color(0xFF9C27B0), 'icon': Icons.air_rounded, 'url': 'https://youtube.com/watch?v=pranayama'},
    {'title': 'PCOD/Thyroid Yoga Flow', 'instructor': 'FitMitra Instructor', 'duration': '20:00', 'level': 'Beginner', 'calories': 150, 'color': const Color(0xFF4CAF50), 'icon': Icons.health_and_safety_rounded, 'url': 'https://youtube.com/watch?v=pcod-yoga'},
    {'title': 'Morning Stretch Routine', 'instructor': 'FitMitra Instructor', 'duration': '12:00', 'level': 'Beginner', 'calories': 80, 'color': const Color(0xFF2196F3), 'icon': Icons.accessibility_new_rounded, 'url': 'https://youtube.com/watch?v=morning-stretch'},
  ];
}
