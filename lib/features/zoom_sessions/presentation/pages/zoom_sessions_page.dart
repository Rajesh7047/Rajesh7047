import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fitmitra/core/utils/result.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fitmitra/core/providers/auth_state_provider.dart';
import 'package:fitmitra/core/providers/repository_providers.dart';
import 'package:fitmitra/domain/entities/mentor_session.dart';
import 'package:fitmitra/shared/widgets/fit_card.dart';
import 'package:fitmitra/shared/widgets/premium_badge.dart';

final sessionsProvider =
    FutureProvider.autoDispose<List<MentorSession>>((ref) async {
  final result =
      await ref.read(contentRepositoryProvider).getUpcomingSessions();
  return result.when(success: (l) => l, error: (_) => []);
});

class ZoomSessionsPage extends ConsumerWidget {
  const ZoomSessionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(sessionsProvider);
    final isPremium = ref.watch(currentUserProvider)?.hasActivePremium ?? false;

    if (!isPremium) {
      return Scaffold(
        appBar: AppBar(title: const Text('Live Mentor Sessions')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const PremiumBadge(),
                const SizedBox(height: 16),
                const Text(
                  'Join live Zoom sessions with certified wellness mentors.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.push('/membership'),
                  child: const Text('Unlock Premium'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Live Mentor Sessions')),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load sessions')),
        data: (sessions) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FitCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text('with ${session.mentorName}'),
                    Text(
                      DateFormat('EEE, MMM d • h:mm a')
                          .format(session.scheduledAt),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: session.isUpcoming
                          ? () => _joinZoom(session.zoomJoinUrl)
                          : null,
                      icon: const Icon(Icons.videocam),
                      label: const Text('Join on Zoom'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _joinZoom(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
