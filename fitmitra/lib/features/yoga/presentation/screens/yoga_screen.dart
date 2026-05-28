import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gradient_container.dart';
import 'video_player_screen.dart';

class _YogaVideo {
  final String id;
  final String title;
  final String instructor;
  final String duration;
  final String level;
  final String emoji;
  final String category;
  final Color color;
  final int calories;
  final String description;

  const _YogaVideo({
    required this.id,
    required this.title,
    required this.instructor,
    required this.duration,
    required this.level,
    required this.emoji,
    required this.category,
    required this.color,
    required this.calories,
    required this.description,
  });
}

final _yogaVideos = [
  _YogaVideo(
    id: 'dQw4w9WgXcQ',
    title: 'Morning Surya Namaskar',
    instructor: 'Ananya Singh',
    duration: '20 min',
    level: 'Beginner',
    emoji: '☀️',
    category: 'Morning Yoga',
    color: AppColors.accent,
    calories: 180,
    description: 'Start your day with the ancient practice of Sun Salutation. Perfect for all levels.',
  ),
  _YogaVideo(
    id: 'dQw4w9WgXcQ',
    title: 'Weight Loss Flow',
    instructor: 'Dr. Priya Sharma',
    duration: '35 min',
    level: 'Intermediate',
    emoji: '💪',
    category: 'Weight Loss',
    color: AppColors.weightLoss,
    calories: 320,
    description: 'Dynamic yoga flow specifically designed to boost metabolism and burn fat.',
  ),
  _YogaVideo(
    id: 'dQw4w9WgXcQ',
    title: 'PCOD Relief Yoga',
    instructor: 'Sunita Patel',
    duration: '25 min',
    level: 'Beginner',
    emoji: '💗',
    category: 'PCOD/Thyroid',
    color: AppColors.pcodThyroid,
    calories: 140,
    description: 'Gentle poses to help manage PCOD symptoms, hormone balance, and stress relief.',
  ),
  _YogaVideo(
    id: 'dQw4w9WgXcQ',
    title: 'Power Yoga for Strength',
    instructor: 'Rahul Gupta',
    duration: '40 min',
    level: 'Advanced',
    emoji: '🔥',
    category: 'Strength',
    color: AppColors.secondary,
    calories: 400,
    description: 'Build strength and flexibility with this power-packed advanced yoga session.',
  ),
  _YogaVideo(
    id: 'dQw4w9WgXcQ',
    title: 'Relaxation & Flexibility',
    instructor: 'Meera Iyer',
    duration: '30 min',
    level: 'Beginner',
    emoji: '🌿',
    category: 'Relaxation',
    color: AppColors.primary,
    calories: 120,
    description: 'Gentle stretches and poses to improve flexibility and reduce muscle tension.',
  ),
  _YogaVideo(
    id: 'dQw4w9WgXcQ',
    title: 'Thyroid Yoga Flow',
    instructor: 'Dr. Anjali Mehta',
    duration: '28 min',
    level: 'Intermediate',
    emoji: '🦋',
    category: 'PCOD/Thyroid',
    color: AppColors.pcodThyroid,
    calories: 160,
    description: 'Poses targeting the thyroid gland to support hormonal health and energy levels.',
  ),
];

final _categories = ['All', 'Morning Yoga', 'Weight Loss', 'PCOD/Thyroid', 'Strength', 'Relaxation'];

class YogaScreen extends ConsumerStatefulWidget {
  const YogaScreen({super.key});

  @override
  ConsumerState<YogaScreen> createState() => _YogaScreenState();
}

class _YogaScreenState extends ConsumerState<YogaScreen> {
  String _selectedCategory = 'All';
  final String _selectedLevel = 'All';

  List<_YogaVideo> get _filteredVideos => _yogaVideos.where((v) {
        final categoryMatch = _selectedCategory == 'All' || v.category == _selectedCategory;
        final levelMatch = _selectedLevel == 'All' || v.level == _selectedLevel;
        return categoryMatch && levelMatch;
      }).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoga & Fitness'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GradientContainer(
                gradient: AppColors.secondaryGradient,
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Daily\nYoga Challenge 🧘',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Day 7 of 30 • Keep it up!',
                            style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: 7 / 30,
                                strokeWidth: 5,
                                backgroundColor: Colors.white.withValues(alpha: 0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                              const Text(
                                '7/30',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Category filter
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final cat = _categories[i];
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.secondary : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.secondary : theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Videos list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _VideoCard(video: _filteredVideos[i]),
                childCount: _filteredVideos.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final _YogaVideo video;

  const _VideoCard({required this.video});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VideoPlayerScreen(videoId: video.id)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [video.color.withValues(alpha: 0.7), video.color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(child: Text(video.emoji, style: const TextStyle(fontSize: 64))),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(Icons.play_arrow_rounded, color: video.color, size: 22),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        video.level,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(video.description, style: theme.textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(video.instructor, style: theme.textTheme.labelSmall),
                      const SizedBox(width: 16),
                      const Icon(Icons.timer_outlined, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(video.duration, style: theme.textTheme.labelSmall),
                      const SizedBox(width: 16),
                      const Icon(Icons.local_fire_department_outlined, size: 14, color: AppColors.accent),
                      const SizedBox(width: 4),
                      Text('${video.calories} kcal', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.accent)),
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
}
