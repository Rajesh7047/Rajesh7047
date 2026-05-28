import 'package:fitmitra/core/providers/network_provider.dart';
import 'package:fitmitra/core/services/zoom_service.dart';
import 'package:fitmitra/features/sessions/domain/mentor_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final zoomServiceProvider = Provider<ZoomService>((ref) {
  return ZoomService(ref.read(dioProvider));
});

final mentorSessionsControllerProvider =
    StateNotifierProvider<MentorSessionsController, AsyncValue<List<MentorSession>>>((ref) {
  return MentorSessionsController(ref.read(zoomServiceProvider))..load();
});

class MentorSessionsController extends StateNotifier<AsyncValue<List<MentorSession>>> {
  MentorSessionsController(this._zoomService) : super(const AsyncValue.loading());

  final ZoomService _zoomService;

  Future<void> load() async {
    try {
      final sessions = await _zoomService.fetchMentorSessions();
      if (sessions.isEmpty) {
        state = AsyncValue.data(_fallbackSessions);
        return;
      }
      state = AsyncValue.data(sessions);
    } catch (_) {
      state = AsyncValue.data(_fallbackSessions);
    }
  }
}

final _fallbackSessions = <MentorSession>[
  MentorSession(
    title: 'Fat Loss Q&A with Coach Asha',
    startAt: DateTime.now().add(const Duration(days: 1)),
    zoomLink: 'https://zoom.us/j/1234567890',
  ),
  MentorSession(
    title: 'PCOD Lifestyle Coaching with Dr. Mehta',
    startAt: DateTime.now().add(const Duration(days: 2)),
    zoomLink: 'https://zoom.us/j/2234567890',
  ),
];
