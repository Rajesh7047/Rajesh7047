import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gradient_container.dart';

class _Mentor {
  final String name;
  final String specialization;
  final String emoji;
  final double rating;
  final int sessions;
  final String bio;
  final List<String> expertise;
  final int sessionPriceINR;
  final bool isAvailableNow;
  final String nextSlot;
  final String zoomLink;

  const _Mentor({
    required this.name,
    required this.specialization,
    required this.emoji,
    required this.rating,
    required this.sessions,
    required this.bio,
    required this.expertise,
    required this.sessionPriceINR,
    required this.isAvailableNow,
    required this.nextSlot,
    required this.zoomLink,
  });
}

final _mentors = [
  _Mentor(
    name: 'Dr. Priya Sharma',
    specialization: 'Clinical Nutritionist',
    emoji: '👩‍⚕️',
    rating: 4.9,
    sessions: 1240,
    bio: 'PhD in Nutrition Science with 12+ years experience. Specializes in hormonal health, PCOD management, and therapeutic diets.',
    expertise: ['Weight Loss', 'PCOD/PCOS', 'Thyroid', 'Diabetes'],
    sessionPriceINR: 999,
    isAvailableNow: true,
    nextSlot: 'Today 6:00 PM',
    zoomLink: 'https://zoom.us/j/sample',
  ),
  _Mentor(
    name: 'Ananya Singh',
    specialization: 'Certified Yoga Instructor',
    emoji: '🧘‍♀️',
    rating: 4.8,
    sessions: 890,
    bio: 'RYT-500 certified yoga teacher with specialization in therapeutic yoga, Ayurvedic principles, and stress management.',
    expertise: ['Yoga', 'Meditation', 'Stress Relief', 'Flexibility'],
    sessionPriceINR: 799,
    isAvailableNow: false,
    nextSlot: 'Tomorrow 7:00 AM',
    zoomLink: 'https://zoom.us/j/sample',
  ),
  _Mentor(
    name: 'Dr. Rahul Mehta',
    specialization: 'Sports & Fitness Coach',
    emoji: '🏃‍♂️',
    rating: 4.7,
    sessions: 675,
    bio: 'NSCA certified strength coach and sports medicine specialist. Expert in body recomposition and athletic performance.',
    expertise: ['Weight Gain', 'Muscle Building', 'Fitness', 'Cardio'],
    sessionPriceINR: 1199,
    isAvailableNow: true,
    nextSlot: 'Today 8:00 PM',
    zoomLink: 'https://zoom.us/j/sample',
  ),
  _Mentor(
    name: 'Dr. Sunita Patel',
    specialization: 'Ayurvedic Practitioner',
    emoji: '🌿',
    rating: 4.9,
    sessions: 1100,
    bio: 'BAMS with 15 years experience in Ayurvedic medicine. Expert in herbal remedies, Panchakarma, and holistic healing.',
    expertise: ['Ayurveda', 'Thyroid', 'PCOD/PCOS', 'Gut Health'],
    sessionPriceINR: 899,
    isAvailableNow: false,
    nextSlot: 'Today 9:00 PM',
    zoomLink: 'https://zoom.us/j/sample',
  ),
];

class MentorScreen extends ConsumerStatefulWidget {
  const MentorScreen({super.key});

  @override
  ConsumerState<MentorScreen> createState() => _MentorScreenState();
}

class _MentorScreenState extends ConsumerState<MentorScreen> {
  String _filter = 'All';

  final _filters = ['All', 'Available Now', 'Nutrition', 'Yoga', 'Fitness', 'Ayurveda'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filtered = _mentors.where((m) {
      if (_filter == 'All') return true;
      if (_filter == 'Available Now') return m.isAvailableNow;
      return m.expertise.any((e) => e.contains(_filter)) || m.specialization.contains(_filter);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Mentors'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () {},
            tooltip: 'My Bookings',
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
                          Text('Expert 1:1 Sessions', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                          SizedBox(height: 4),
                          Text('Book a personalized session via Zoom', style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Poppins')),
                          SizedBox(height: 12),
                          Row(children: [
                            _Badge('🎥 Live Video', Colors.white24),
                            SizedBox(width: 8),
                            _Badge('🔒 Secure', Colors.white24),
                          ]),
                        ],
                      ),
                    ),
                    const Text('👨‍⚕️', style: TextStyle(fontSize: 56)),
                  ],
                ),
              ),
            ),
          ),

          // Live now indicator
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${_mentors.where((m) => m.isAvailableNow).length} mentors available now',
                    style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w600, fontSize: 13, fontFamily: 'Poppins'),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Filter chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final f = _filters[i];
                  final isSelected = _filter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.secondary : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? AppColors.secondary : theme.colorScheme.outlineVariant),
                      ),
                      child: Center(
                        child: Text(
                          f,
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

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _MentorCard(mentor: filtered[i]),
                childCount: filtered.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Poppins')),
    );
  }
}

class _MentorCard extends StatelessWidget {
  final _Mentor mentor;

  const _MentorCard({required this.mentor});

  void _bookSession(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 20),
            Text('Book Session', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text('with ${mentor.name}', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Text(mentor.emoji, style: const TextStyle(fontSize: 36)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mentor.name, style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                      Text(mentor.specialization, style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text('Next: ${mentor.nextSlot}', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Session Fee:', style: TextStyle(fontSize: 14, fontFamily: 'Poppins')),
                Text('₹${mentor.sessionPriceINR}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary, fontFamily: 'Poppins')),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _launchZoom(mentor.zoomLink);
              },
              icon: const Icon(Icons.video_call_rounded),
              label: const Text('Book & Join via Zoom'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchZoom(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: mentor.isAvailableNow ? AppColors.success : theme.colorScheme.outlineVariant,
          width: mentor.isAvailableNow ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: mentor.isAvailableNow ? AppColors.primaryGradient : const LinearGradient(colors: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)]),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(child: Text(mentor.emoji, style: const TextStyle(fontSize: 30))),
                    ),
                    if (mentor.isAvailableNow)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mentor.name, style: theme.textTheme.titleMedium),
                      Text(mentor.specialization, style: theme.textTheme.bodySmall),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFFFAB00), size: 14),
                          const SizedBox(width: 3),
                          Text('${mentor.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                          Text(' • ${mentor.sessions}+ sessions', style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (mentor.isAvailableNow)
                      const LiveChip()
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(mentor.nextSlot, style: theme.textTheme.labelSmall),
                      ),
                    const SizedBox(height: 6),
                    Text('₹${mentor.sessionPriceINR}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 15, fontFamily: 'Poppins')),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
            child: Text(mentor.bio, style: theme.textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: mentor.expertise.take(3).map((e) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(e, style: const TextStyle(fontSize: 11, color: AppColors.secondaryDark, fontWeight: FontWeight.w500, fontFamily: 'Poppins')),
                  )).toList(),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                    label: const Text('Message'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.secondary),
                      foregroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size(0, 40),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _bookSession(context),
                    icon: const Icon(Icons.video_call_rounded, size: 16),
                    label: const Text('Book Session'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mentor.isAvailableNow ? AppColors.primary : AppColors.secondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size(0, 40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
