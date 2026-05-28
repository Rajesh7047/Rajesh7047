import 'package:fitmitra/features/media/domain/wellness_media.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MediaLibraryScreen extends StatelessWidget {
  const MediaLibraryScreen({super.key});

  static const content = [
    WellnessMedia(
      title: 'Morning Surya Namaskar Flow',
      url: 'https://www.youtube.com/watch?v=v7AYKMP6rOE',
      type: MediaType.yoga,
      isPremium: false,
    ),
    WellnessMedia(
      title: '10-min Guided Meditation',
      url: 'https://www.youtube.com/watch?v=inpok4MKVLM',
      type: MediaType.meditation,
      isPremium: false,
    ),
    WellnessMedia(
      title: 'High Protein Dinner Recipes',
      url: 'https://www.youtube.com/watch?v=8n6k7Y6x4hQ',
      type: MediaType.recipe,
      isPremium: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: content.length,
      itemBuilder: (context, index) {
        final item = content[index];
        return Card(
          child: ListTile(
            title: Text(item.title),
            subtitle:
                Text('${item.type.name.toUpperCase()} ${item.isPremium ? "• PREMIUM" : "• FREE"}'),
            trailing: const Icon(Icons.play_circle_outline_rounded),
            onTap: () async {
              await launchUrl(Uri.parse(item.url), mode: LaunchMode.externalApplication);
            },
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 8),
    );
  }
}
