import 'package:fitmitra/src/core/widgets/app_card.dart';
import 'package:fitmitra/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:fitmitra/src/shared/data/seed_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class MentorSessionsPage extends ConsumerWidget {
  const MentorSessionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium =
        ref.watch(authControllerProvider).user?.isPremium ?? false;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        AppCard(
          child: Text(
            isPremium
                ? 'Join your live Zoom mentor sessions and ask deeper wellness questions in real time.'
                : 'Mentor sessions are a premium feature. Upgrade to unlock live group coaching and Q&A over Zoom.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 16),
        for (final session in SeedData.mentorSessions)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          session.title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      if (session.isPremium) const Chip(label: Text('Premium')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Coach: ${session.coachName}'),
                  Text('When: ${session.timeLabel}'),
                  const SizedBox(height: 8),
                  Text(session.focus),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: session.isPremium && !isPremium
                            ? null
                            : () => launchUrl(Uri.parse(session.zoomUrl)),
                        icon: const Icon(Icons.video_camera_front_rounded),
                        label: const Text('Join on Zoom'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.push('/membership'),
                        icon: const Icon(Icons.workspace_premium_rounded),
                        label: Text(
                          isPremium ? 'Manage premium' : 'Unlock premium',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
