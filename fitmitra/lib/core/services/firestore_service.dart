import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseService.firestore;

  Future<void> setDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    await _db.collection(collection).doc(docId).set(data, SetOptions(merge: merge));
  }

  Future<DocumentSnapshot> getDocument({
    required String collection,
    required String docId,
  }) async {
    return await _db.collection(collection).doc(docId).get();
  }

  Future<QuerySnapshot> getCollection({
    required String collection,
    String? orderBy,
    bool descending = false,
    int? limit,
    List<QueryFilter>? filters,
  }) async {
    Query query = _db.collection(collection);
    if (filters != null) {
      for (final filter in filters) {
        query = query.where(filter.field, isEqualTo: filter.isEqualTo, isGreaterThan: filter.isGreaterThan, isLessThan: filter.isLessThan, arrayContains: filter.arrayContains);
      }
    }
    if (orderBy != null) query = query.orderBy(orderBy, descending: descending);
    if (limit != null) query = query.limit(limit);
    return await query.get();
  }

  Future<void> updateDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection(collection).doc(docId).update(data);
  }

  Future<void> deleteDocument({
    required String collection,
    required String docId,
  }) async {
    await _db.collection(collection).doc(docId).delete();
  }

  Stream<DocumentSnapshot> streamDocument({
    required String collection,
    required String docId,
  }) {
    return _db.collection(collection).doc(docId).snapshots();
  }

  Stream<QuerySnapshot> streamCollection({
    required String collection,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query query = _db.collection(collection);
    if (orderBy != null) query = query.orderBy(orderBy, descending: descending);
    if (limit != null) query = query.limit(limit);
    return query.snapshots();
  }
}

class QueryFilter {
  final String field;
  final dynamic isEqualTo;
  final dynamic isGreaterThan;
  final dynamic isLessThan;
  final dynamic arrayContains;

  QueryFilter({
    required this.field,
    this.isEqualTo,
    this.isGreaterThan,
    this.isLessThan,
    this.arrayContains,
  });
}
