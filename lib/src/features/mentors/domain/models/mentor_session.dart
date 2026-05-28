class MentorSession {
  const MentorSession({
    required this.id,
    required this.title,
    required this.coachName,
    required this.timeLabel,
    required this.focus,
    required this.zoomUrl,
    this.isPremium = true,
  });

  final String id;
  final String title;
  final String coachName;
  final String timeLabel;
  final String focus;
  final String zoomUrl;
  final bool isPremium;
}
