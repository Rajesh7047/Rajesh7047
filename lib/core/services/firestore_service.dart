import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> usersCollection() => _firestore.collection('users');

  Future<void> upsertUserProfile(String uid, Map<String, dynamic> data) {
    return usersCollection().doc(uid).set(data, SetOptions(merge: true));
  }

  Future<void> upsertDailyTracking({
    required String uid,
    required String dateKey,
    required Map<String, dynamic> payload,
  }) {
    return usersCollection()
        .doc(uid)
        .collection('tracking')
        .doc(dateKey)
        .set(payload, SetOptions(merge: true));
  }
}
