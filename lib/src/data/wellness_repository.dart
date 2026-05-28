import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../domain/models.dart';
import 'demo_seed_data.dart';

class WellnessRepository {
  WellnessRepository(this._firestore, this._storage);

  final FirebaseFirestore? _firestore;
  final FirebaseStorage? _storage;

  Stream<List<WellnessContent>> watchContent({ContentType? type}) {
    if (_firestore == null) {
      final filtered = DemoSeedData.content
          .where((item) => type == null || item.type == type)
          .toList();
      return Stream<List<WellnessContent>>.value(filtered);
    }

    Query<Map<String, dynamic>> query = _firestore
        .collection('content')
        .where('status', isEqualTo: 'published')
        .orderBy('createdAt', descending: true);
    if (type != null) {
      query = query.where('type', isEqualTo: type.firestoreKey);
    }
    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => WellnessContent.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Stream<List<ProductRecommendation>> watchProducts(HealthGoal goal) {
    if (_firestore == null) {
      return Stream<List<ProductRecommendation>>.value(DemoSeedData.products(goal));
    }
    return _firestore
        .collection('products')
        .where('goals', arrayContains: goal.firestoreKey)
        .orderBy('priority', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return ProductRecommendation(
                id: doc.id,
                name: data['name'] as String? ?? 'Recommended product',
                goal: goal,
                reason: data['reason'] as String? ?? '',
                imageUrl: data['imageUrl'] as String? ?? '',
                priceInr: (data['priceInr'] as num?)?.toInt() ?? 0,
                productUrl: data['productUrl'] as String? ?? '',
              );
            }).toList());
  }

  Stream<List<MentorSession>> watchMentorSessions() {
    if (_firestore == null) {
      return Stream<List<MentorSession>>.value(DemoSeedData.sessions);
    }
    return _firestore
        .collection('sessions')
        .where('isLive', isEqualTo: true)
        .orderBy('startsAt')
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              final startsAt = data['startsAt'];
              return MentorSession(
                id: doc.id,
                title: data['title'] as String? ?? 'Live mentor session',
                mentorName: data['mentorName'] as String? ?? 'FitMitra mentor',
                startsAt: startsAt is Timestamp ? startsAt.toDate() : DateTime.now(),
                zoomUrl: data['zoomUrl'] as String? ?? '',
                isPremium: data['isPremium'] as bool? ?? false,
              );
            }).toList());
  }

  Future<String?> publicDownloadUrl(String storagePath) async {
    if (_storage == null || storagePath.trim().isEmpty) return null;
    return _storage.ref(storagePath).getDownloadURL();
  }
}
