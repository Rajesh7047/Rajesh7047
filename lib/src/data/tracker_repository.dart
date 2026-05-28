import 'package:cloud_firestore/cloud_firestore.dart';

class TrackerRepository {
  TrackerRepository(this._firestore);

  final FirebaseFirestore? _firestore;

  Future<void> saveDailyMetrics({
    required String uid,
    required DateTime date,
    required int calories,
    required int waterMl,
  }) async {
    if (_firestore == null || uid == 'guest') return;
    final dateKey = '${date.year.toString().padLeft(4, '0')}'
        '-${date.month.toString().padLeft(2, '0')}'
        '-${date.day.toString().padLeft(2, '0')}';
    await _firestore.collection('users').doc(uid).collection('tracker').doc(dateKey).set(
      <String, Object?>{
        'calories': calories,
        'waterMl': waterMl,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}
