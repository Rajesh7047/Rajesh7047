class MentorSession {
  const MentorSession({
    required this.title,
    required this.startAt,
    required this.zoomLink,
    this.isPremium = true,
  });

  final String title;
  final DateTime startAt;
  final String zoomLink;
  final bool isPremium;

  factory MentorSession.fromJson(Map<String, dynamic> json) {
    return MentorSession(
      title: json['title'] as String? ?? 'Live session',
      startAt: DateTime.tryParse(json['startAt'] as String? ?? '') ?? DateTime.now(),
      zoomLink: json['zoomLink'] as String? ?? '',
      isPremium: json['isPremium'] as bool? ?? true,
    );
  }
}
