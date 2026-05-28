import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitmitra/core/providers/auth_state_provider.dart';
import 'package:fitmitra/core/utils/result.dart';
import 'package:fitmitra/core/providers/repository_providers.dart';
import 'package:fitmitra/domain/entities/wellness_video.dart';
import 'package:fitmitra/shared/widgets/video_list_tile.dart';

final yogaVideosProvider =
    FutureProvider.autoDispose<List<WellnessVideo>>((ref) async {
  final result =
      await ref.read(contentRepositoryProvider).getVideos(VideoCategory.yoga);
  return result.when(success: (l) => l, error: (_) => []);
});

class YogaPage extends ConsumerWidget {
  const YogaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosAsync = ref.watch(yogaVideosProvider);
    final isPremium = ref.watch(currentUserProvider)?.hasActivePremium ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Yoga')),
      body: videosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load videos')),
        data: (videos) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: videos.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final video = videos[index];
            final locked = video.isPremiumOnly && !isPremium;
            return VideoListTile(
              video: video,
              locked: locked,
              onTap: () {
                if (locked) {
                  context.push('/membership');
                  return;
                }
                context.push('/video', extra: video);
              },
            );
          },
        ),
      ),
    );
  }
}
