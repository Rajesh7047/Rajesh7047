enum MediaCategory { yoga, meditation, recipes }

class MediaContent {
  const MediaContent({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.durationLabel,
    required this.level,
    required this.youtubeVideoId,
    required this.imageUrl,
    this.storageThumbnailPath,
    this.isPremium = false,
  });

  final String id;
  final String title;
  final MediaCategory category;
  final String description;
  final String durationLabel;
  final String level;
  final String youtubeVideoId;
  final String imageUrl;
  final String? storageThumbnailPath;
  final bool isPremium;

  MediaContent copyWith({String? imageUrl}) {
    return MediaContent(
      id: id,
      title: title,
      category: category,
      description: description,
      durationLabel: durationLabel,
      level: level,
      youtubeVideoId: youtubeVideoId,
      imageUrl: imageUrl ?? this.imageUrl,
      storageThumbnailPath: storageThumbnailPath,
      isPremium: isPremium,
    );
  }
}
