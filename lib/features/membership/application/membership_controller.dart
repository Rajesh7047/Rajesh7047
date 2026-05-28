import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmitra/features/membership/domain/membership_tier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final membershipControllerProvider =
    StateNotifierProvider<MembershipController, MembershipTier>((ref) {
  return MembershipController(FirebaseFirestore.instance);
});

class MembershipController extends StateNotifier<MembershipTier> {
  MembershipController(this._firestore) : super(MembershipTier.free);

  final FirebaseFirestore _firestore;

  Future<void> refreshForUser(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    final premium = snapshot.data()?['premium'] as bool? ?? false;
    state = premium ? MembershipTier.premium : MembershipTier.free;
  }

  Future<void> markPremium(String uid) async {
    state = MembershipTier.premium;
    await _firestore.collection('users').doc(uid).set({'premium': true}, SetOptions(merge: true));
  }
}
