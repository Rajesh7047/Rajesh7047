enum MediaType { yoga, meditation, recipe }

class WellnessMedia {
  const WellnessMedia({
    required this.title,
    required this.url,
    required this.type,
    this.isPremium = false,
  });

  final String title;
  final String url;
  final MediaType type;
  final bool isPremium;
}
