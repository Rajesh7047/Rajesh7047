import 'package:equatable/equatable.dart';

enum VideoCategory { yoga, meditation, recipe }

class WellnessVideo extends Equatable {
  const WellnessVideo({
    required this.id,
    required this.title,
    required this.category,
    required this.thumbnailUrl,
    required this.videoUrl,
    this.durationMinutes = 10,
    this.isPremiumOnly = false,
    this.instructor,
  });

  final String id;
  final String title;
  final VideoCategory category;
  final String thumbnailUrl;
  final String videoUrl;
  final int durationMinutes;
  final bool isPremiumOnly;
  final String? instructor;

  @override
  List<Object?> get props => [id, title, category];
}
