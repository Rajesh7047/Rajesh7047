import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/premium_badge.dart';
import 'package:url_launcher/url_launcher.dart';

class MentorScreen extends StatelessWidget {
  const MentorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Live Mentor Sessions'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              animationIndex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Live Expert Sessions', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                            SizedBox(height: 4),
                            Text('Connect with certified health mentors via Zoom', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.videocam_rounded, color: Colors.white, size: 32),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const PremiumBadge(showLabel: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text('Our Mentors', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            ...mentors.asMap().entries.map((entry) {
              final mentor = entry.value;
              return CustomCard(
                animationIndex: entry.key + 1,
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: (mentor['color'] as Color).withOpacity(0.15),
                          child: Text(mentor['initials'] as String, style: TextStyle(color: mentor['color'] as Color, fontWeight: FontWeight.w700, fontSize: 18)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mentor['name'] as String, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                              Text(mentor['specialty'] as String, style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB800)),
                                  const SizedBox(width: 2),
                                  Text('${mentor['rating']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  Text(' • ${mentor['experience']}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(mentor['bio'] as String, style: Theme.of(context).textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Next: ${mentor['nextSession']}',
                            style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                        CustomButton(
                          text: 'Book Session',
                          onPressed: () => _bookSession(context, mentor),
                          height: 38,
                          width: 130,
                          borderRadius: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),
            Text('Upcoming Group Sessions', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            ...groupSessions.asMap().entries.map((entry) {
              final session = entry.value;
              return CustomCard(
                animationIndex: entry.key + 5,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (session['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(session['icon'] as IconData, color: session['color'] as Color, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(session['title'] as String, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          Text(session['date'] as String, style: Theme.of(context).textTheme.bodySmall),
                          Text('${session['spots']} spots left', style: TextStyle(color: AppColors.warning, fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Join'),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _bookSession(BuildContext context, Map<String, dynamic> mentor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Book with ${mentor['name']}'),
        content: Text('Schedule a live Zoom session with ${mentor['name']} (${mentor['specialty']}).\n\nPremium membership required for booking.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Book Now')),
        ],
      ),
    );
  }

  static final List<Map<String, dynamic>> mentors = [
    {'name': 'Dr. Priya Sharma', 'initials': 'PS', 'specialty': 'Nutritionist & Dietitian', 'rating': 4.9, 'experience': '12 yrs exp', 'bio': 'Certified clinical nutritionist specializing in weight management and PCOD/thyroid diet therapy.', 'nextSession': 'Mon, 10:00 AM', 'color': const Color(0xFF6C5CE7)},
    {'name': 'Yogi Ravi Kumar', 'initials': 'RK', 'specialty': 'Yoga & Meditation Expert', 'rating': 4.8, 'experience': '15 yrs exp', 'bio': 'International yoga instructor with expertise in therapeutic yoga for chronic conditions.', 'nextSession': 'Tue, 7:00 AM', 'color': const Color(0xFF4CAF50)},
    {'name': 'Dr. Anita Patel', 'initials': 'AP', 'specialty': 'Ayurveda & Wellness', 'rating': 4.7, 'experience': '10 yrs exp', 'bio': 'BAMS doctor combining Ayurvedic wisdom with modern nutrition science for holistic health.', 'nextSession': 'Wed, 11:00 AM', 'color': const Color(0xFFFF9800)},
  ];

  static final List<Map<String, dynamic>> groupSessions = [
    {'title': 'PCOD Diet Workshop', 'date': 'Sat, June 1 • 10:00 AM', 'spots': 12, 'icon': Icons.health_and_safety_rounded, 'color': const Color(0xFFF44336)},
    {'title': 'Morning Yoga Flow', 'date': 'Sun, June 2 • 7:00 AM', 'spots': 20, 'icon': Icons.self_improvement_rounded, 'color': const Color(0xFF4CAF50)},
    {'title': 'Stress Management', 'date': 'Mon, June 3 • 6:00 PM', 'spots': 8, 'icon': Icons.spa_rounded, 'color': const Color(0xFF9C27B0)},
  ];
}
