import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitmitra/src/core/providers/core_providers.dart';
import 'package:fitmitra/src/features/media/domain/models/media_content.dart';
import 'package:fitmitra/src/shared/data/seed_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  return MediaRepository(ref.watch(storageProvider));
});

final mediaLibraryProvider = FutureProvider<List<MediaContent>>((ref) {
  return ref.watch(mediaRepositoryProvider).getLibrary();
});

class MediaRepository {
  const MediaRepository(this._storage);

  final FirebaseStorage? _storage;

  Future<List<MediaContent>> getLibrary() async {
    final content = SeedData.mediaLibrary;
    if (_storage == null) {
      return content;
    }

    final resolved = <MediaContent>[];
    for (final item in content) {
      if (item.storageThumbnailPath == null) {
        resolved.add(item);
        continue;
      }

      try {
        final url = await _storage!
            .ref(item.storageThumbnailPath)
            .getDownloadURL();
        resolved.add(item.copyWith(imageUrl: url));
      } catch (_) {
        resolved.add(item);
      }
    }
    return resolved;
  }
}
