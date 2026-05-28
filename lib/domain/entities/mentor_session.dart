import 'package:equatable/equatable.dart';

class MentorSession extends Equatable {
  const MentorSession({
    required this.id,
    required this.title,
    required this.mentorName,
    required this.scheduledAt,
    required this.zoomJoinUrl,
    this.durationMinutes = 60,
    this.isPremiumOnly = true,
  });

  final String id;
  final String title;
  final String mentorName;
  final DateTime scheduledAt;
  final String zoomJoinUrl;
  final int durationMinutes;
  final bool isPremiumOnly;

  bool get isUpcoming => scheduledAt.isAfter(DateTime.now());

  @override
  List<Object?> get props => [id, title, scheduledAt];
}
