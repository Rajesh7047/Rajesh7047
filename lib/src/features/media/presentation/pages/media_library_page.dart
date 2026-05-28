import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitmitra/src/core/widgets/app_card.dart';
import 'package:fitmitra/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:fitmitra/src/features/media/data/repositories/media_repository.dart';
import 'package:fitmitra/src/features/media/domain/models/media_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MediaLibraryPage extends ConsumerWidget {
  const MediaLibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryAsync = ref.watch(mediaLibraryProvider);
    final isPremium =
        ref.watch(authControllerProvider).user?.isPremium ?? false;

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: TabBar(
              tabs: [
                Tab(text: 'Yoga'),
                Tab(text: 'Meditation'),
                Tab(text: 'Recipes'),
              ],
            ),
          ),
          Expanded(
            child: libraryAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text(error.toString())),
              data: (items) {
                final tabs = [
                  MediaCategory.yoga,
                  MediaCategory.meditation,
                  MediaCategory.recipes,
                ];
                return TabBarView(
                  children: [
                    for (final category in tabs)
                      GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.sizeOf(context).width > 1040 ? 3 : 1,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.12,
                        ),
                        itemCount: items
                            .where((item) => item.category == category)
                            .length,
                        itemBuilder: (context, index) {
                          final filtered = items
                              .where((item) => item.category == category)
                              .toList();
                          final item = filtered[index];
                          final locked = item.isPremium && !isPremium;

                          return AppCard(
                            onTap: locked
                                ? null
                                : () => showDialog<void>(
                                    context: context,
                                    builder: (_) => _VideoDialog(item: item),
                                  ),
                            padding: EdgeInsets.zero,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(28),
                                            ),
                                        child: CachedNetworkImage(
                                          imageUrl: item.imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 12,
                                        right: 12,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(
                                              alpha: 0.55,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            child: Text(
                                              locked
                                                  ? 'Premium'
                                                  : item.durationLabel,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(item.description),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Icon(
                                            locked
                                                ? Icons.lock_rounded
                                                : Icons
                                                      .play_circle_fill_rounded,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(item.level),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoDialog extends StatefulWidget {
  const _VideoDialog({required this.item});

  final MediaContent item;

  @override
  State<_VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<_VideoDialog> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.item.youtubeVideoId,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.item.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: YoutubePlayer(controller: _controller),
              ),
              const SizedBox(height: 12),
              Text(widget.item.description),
            ],
          ),
        ),
      ),
    );
  }
}
