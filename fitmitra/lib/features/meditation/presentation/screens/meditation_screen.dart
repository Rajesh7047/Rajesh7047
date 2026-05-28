import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/section_header.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _breathController;
  bool _isBreathing = false;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  void _toggleBreathing() {
    setState(() => _isBreathing = !_isBreathing);
    if (_isBreathing) {
      _breathController.repeat(reverse: true);
    } else {
      _breathController.stop();
      _breathController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Meditation & Mindfulness'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              animationIndex: 0,
              child: Column(
                children: [
                  const Text('Breathing Exercise', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text('Follow the circle to calm your mind', style: TextStyle(color: Colors.white60, fontSize: 13)),
                  const SizedBox(height: 24),
                  AnimatedBuilder(
                    animation: _breathController,
                    builder: (context, child) {
                      return Container(
                        width: 120 + (_breathController.value * 40),
                        height: 120 + (_breathController.value * 40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15 + (_breathController.value * 0.1)),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                        ),
                        child: Center(
                          child: Text(
                            _isBreathing
                                ? (_breathController.value < 0.5 ? 'Breathe In' : 'Breathe Out')
                                : 'Start',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _toggleBreathing,
                    icon: Icon(_isBreathing ? Icons.stop_rounded : Icons.play_arrow_rounded),
                    label: Text(_isBreathing ? 'Stop' : 'Begin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SectionHeader(title: 'Guided Meditations', icon: Icons.headphones_rounded),
            ...meditationSessions.asMap().entries.map((entry) {
              final session = entry.value;
              return CustomCard(
                animationIndex: entry.key + 1,
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: (session['color'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(session['icon'] as IconData, color: session['color'] as Color, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(session['title'] as String, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(session['desc'] as String, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.timer_outlined, size: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                              const SizedBox(width: 4),
                              Text(session['duration'] as String, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.play_circle_filled_rounded, color: session['color'] as Color, size: 40),
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),

            SectionHeader(title: 'Mood Check', icon: Icons.mood_rounded),
            CustomCard(
              animationIndex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How are you feeling?', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMoodButton('😊', 'Happy'),
                      _buildMoodButton('😌', 'Calm'),
                      _buildMoodButton('😐', 'Neutral'),
                      _buildMoodButton('😟', 'Anxious'),
                      _buildMoodButton('😢', 'Sad'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodButton(String emoji, String label) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You\'re feeling $label. We\'ll suggest suitable content!')),
        );
      },
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  static final List<Map<String, dynamic>> meditationSessions = [
    {'title': 'Morning Calm', 'desc': 'Start your day with inner peace', 'duration': '10 min', 'icon': Icons.wb_twilight_rounded, 'color': const Color(0xFFFF9800)},
    {'title': 'Stress Relief', 'desc': 'Release tension and find balance', 'duration': '15 min', 'icon': Icons.spa_rounded, 'color': const Color(0xFF4CAF50)},
    {'title': 'Better Sleep', 'desc': 'Drift into peaceful slumber', 'duration': '20 min', 'icon': Icons.bedtime_rounded, 'color': const Color(0xFF3F51B5)},
    {'title': 'Focus & Clarity', 'desc': 'Sharpen your mind and concentration', 'duration': '12 min', 'icon': Icons.psychology_rounded, 'color': const Color(0xFF9C27B0)},
    {'title': 'Body Scan', 'desc': 'Full body relaxation technique', 'duration': '18 min', 'icon': Icons.accessibility_new_rounded, 'color': const Color(0xFF00BCD4)},
  ];
}
