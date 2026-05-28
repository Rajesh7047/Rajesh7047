import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gradient_container.dart';

class _MeditationSession {
  final String title;
  final String description;
  final int minutes;
  final String emoji;
  final Color color;
  final String category;

  const _MeditationSession({
    required this.title,
    required this.description,
    required this.minutes,
    required this.emoji,
    required this.color,
    required this.category,
  });
}

final _sessions = [
  _MeditationSession(
    title: 'Morning Mindfulness',
    description: 'Start your day with clarity and calm. Guided breathing and body scan.',
    minutes: 10,
    emoji: '🌅',
    color: AppColors.accent,
    category: 'Mindfulness',
  ),
  _MeditationSession(
    title: 'Stress Relief',
    description: 'Release tension and anxiety with this powerful breathing technique.',
    minutes: 15,
    emoji: '😮‍💨',
    color: AppColors.secondary,
    category: 'Stress Relief',
  ),
  _MeditationSession(
    title: 'Deep Sleep',
    description: 'Calm your mind and prepare for a restful night\'s sleep.',
    minutes: 20,
    emoji: '🌙',
    color: const Color(0xFF5C6BC0),
    category: 'Sleep',
  ),
  _MeditationSession(
    title: 'Focus & Clarity',
    description: 'Sharpen your concentration and boost productivity.',
    minutes: 12,
    emoji: '🎯',
    color: AppColors.primary,
    category: 'Focus',
  ),
  _MeditationSession(
    title: 'Anxiety Relief',
    description: 'Ground yourself with this powerful anxiety-relieving meditation.',
    minutes: 18,
    emoji: '🌊',
    color: const Color(0xFF0097A7),
    category: 'Anxiety',
  ),
  _MeditationSession(
    title: 'Gratitude Practice',
    description: 'Cultivate positivity and thankfulness in your daily life.',
    minutes: 8,
    emoji: '🙏',
    color: const Color(0xFFE91E63),
    category: 'Mindfulness',
  ),
];

class MeditationScreen extends ConsumerStatefulWidget {
  const MeditationScreen({super.key});

  @override
  ConsumerState<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends ConsumerState<MeditationScreen> {
  _MeditationSession? _activeSession;
  bool _isPlaying = false;
  int _secondsRemaining = 0;
  Timer? _timer;

  void _startSession(_MeditationSession session) {
    setState(() {
      _activeSession = session;
      _secondsRemaining = session.minutes * 60;
      _isPlaying = true;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining <= 0) {
        t.cancel();
        setState(() => _isPlaying = false);
        _showCompletionDialog();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (!_isPlaying) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_secondsRemaining <= 0) {
          t.cancel();
          setState(() => _isPlaying = false);
        } else {
          setState(() => _secondsRemaining--);
        }
      });
    }
  }

  void _stopSession() {
    _timer?.cancel();
    setState(() {
      _activeSession = null;
      _isPlaying = false;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'Session Complete!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Great job! You\'ve completed your meditation.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _stopSession();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String get _formattedTime {
    final min = _secondsRemaining ~/ 60;
    final sec = _secondsRemaining % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Meditation')),
      body: _activeSession != null
          ? _buildActiveSession(theme)
          : _buildSessionList(theme),
    );
  }

  Widget _buildActiveSession(ThemeData theme) {
    final session = _activeSession!;
    final progress = 1 - (_secondsRemaining / (session.minutes * 60));

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _stopSession,
                    icon: const Icon(Icons.close_rounded),
                  ),
                  const Spacer(),
                  Text(session.title, style: theme.textTheme.titleLarge),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
              const Spacer(),
              // Timer circle
              SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 12,
                        backgroundColor: session.color.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(session.color),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(session.emoji, style: const TextStyle(fontSize: 48)),
                        const SizedBox(height: 8),
                        Text(
                          _formattedTime,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: session.color,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          'remaining',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Text(
                '"Take a deep breath and let it go..."',
                style: theme.textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CircleButton(
                    icon: Icons.restart_alt_rounded,
                    onTap: () => _startSession(session),
                    color: Colors.grey,
                    size: 48,
                  ),
                  const SizedBox(width: 24),
                  _CircleButton(
                    icon: _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    onTap: _togglePlay,
                    color: session.color,
                    size: 72,
                  ),
                  const SizedBox(width: 24),
                  _CircleButton(
                    icon: Icons.stop_rounded,
                    onTap: _stopSession,
                    color: Colors.red,
                    size: 48,
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionList(ThemeData theme) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: GradientContainer(
              gradient: const LinearGradient(
                colors: [Color(0xFF5C6BC0), Color(0xFF7E57C2)],
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Find Your Peace', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                        SizedBox(height: 4),
                        Text('12 sessions • All levels', style: TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'Poppins')),
                      ],
                    ),
                  ),
                  const Text('😌', style: TextStyle(fontSize: 48)),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) => _SessionCard(
                session: _sessions[i],
                onTap: () => _startSession(_sessions[i]),
              ),
              childCount: _sessions.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  final _MeditationSession session;
  final VoidCallback onTap;

  const _SessionCard({required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: session.color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: session.color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(session.emoji, style: const TextStyle(fontSize: 32)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: session.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${session.minutes}m',
                    style: TextStyle(
                      color: session.color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              session.title,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              maxLines: 2,
            ),
            const SizedBox(height: 4),
            Text(
              session.category,
              style: TextStyle(
                color: session.color,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: session.color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'Start',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final double size;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(icon, color: color, size: size * 0.4),
      ),
    );
  }
}
