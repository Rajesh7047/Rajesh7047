import 'package:fitmitra/features/sessions/application/mentor_sessions_controller.dart';
import 'package:fitmitra/features/sessions/domain/mentor_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MentorSessionsScreen extends ConsumerWidget {
  const MentorSessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsState = ref.watch(mentorSessionsControllerProvider);

    return sessionsState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Unable to load sessions right now.')),
      data: (sessions) => _SessionList(sessions: sessions),
    );
  }
}

class _SessionList extends StatelessWidget {
  const _SessionList({required this.sessions});

  final List<MentorSession> sessions;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final item = sessions[index];
        return Card(
          child: ListTile(
            title: Text(item.title),
            subtitle: Text(DateFormat('EEE, dd MMM • hh:mm a').format(item.startAt)),
            trailing: FilledButton.tonal(
              onPressed: () => launchUrl(Uri.parse(item.zoomLink)),
              child: const Text('Join'),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: sessions.length,
    );
  }
}
