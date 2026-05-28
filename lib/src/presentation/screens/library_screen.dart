import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../domain/models.dart';
import '../../state/app_providers.dart';
import '../widgets/fitmitra_widgets.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  ContentType? _type;

  @override
  Widget build(BuildContext context) {
    final contentAsync = ref.watch(wellnessContentProvider(_type));
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(pinned: true, title: const Text('Yoga, meditation, recipes')),
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList.list(
            children: <Widget>[
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  ChoiceChip(label: const Text('All'), selected: _type == null, onSelected: (_) => setState(() => _type = null)),
                  ...ContentType.values.map((type) => ChoiceChip(
                        label: Text(type.label),
                        selected: _type == type,
                        onSelected: (_) => setState(() => _type = type),
                      )),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        contentAsync.when(
          loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
          error: (error, stackTrace) => SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(24), child: Text('$error'))),
          data: (items) => SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            sliver: SliverGrid.builder(
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.sizeOf(context).width > 900 ? 3 : (MediaQuery.sizeOf(context).width > 620 ? 2 : 1),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (context, index) => ContentCard(
                content: items[index],
                onTap: () => showModalBottomSheet<void>(
                  context: context,
                  useSafeArea: true,
                  isScrollControlled: true,
                  builder: (_) => _VideoPreviewSheet(content: items[index]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VideoPreviewSheet extends StatefulWidget {
  const _VideoPreviewSheet({required this.content});

  final WellnessContent content;

  @override
  State<_VideoPreviewSheet> createState() => _VideoPreviewSheetState();
}

class _VideoPreviewSheetState extends State<_VideoPreviewSheet> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    final uri = Uri.tryParse(widget.content.videoUrl);
    if (uri != null && uri.hasScheme) {
      _controller = VideoPlayerController.networkUrl(uri)
        ..initialize().then((_) {
          if (mounted) setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.content.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: controller?.value.isInitialized == true
                  ? VideoPlayer(controller!)
                  : const ColoredBox(color: Colors.black12, child: Center(child: CircularProgressIndicator())),
            ),
          ),
          const SizedBox(height: 14),
          Text(widget.content.description),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: controller == null
                ? null
                : () {
                    setState(() {
                      controller.value.isPlaying ? controller.pause() : controller.play();
                    });
                  },
            icon: Icon(controller?.value.isPlaying == true ? Icons.pause_rounded : Icons.play_arrow_rounded),
            label: Text(controller?.value.isPlaying == true ? 'Pause' : 'Play'),
          ),
        ],
      ),
    );
  }
}
