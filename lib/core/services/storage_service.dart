import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  StorageService(this._storage);

  final FirebaseStorage _storage;

  Future<String> uploadProfileImage(String uid, String localPath) async {
    final ref = _storage.ref('profile/$uid/avatar.jpg');
    await ref.putFile(File(localPath));
    return ref.getDownloadURL();
  }
}
