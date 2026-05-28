import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmitra/core/constants/app_constants.dart';
import 'package:fitmitra/core/errors/failures.dart';
import 'package:fitmitra/core/utils/result.dart';
import 'package:fitmitra/domain/entities/membership_plan.dart';
import 'package:fitmitra/domain/repositories/membership_repository.dart';
import 'package:fitmitra/shared/services/razorpay_service.dart';

class MembershipRepositoryImpl implements MembershipRepository {
  MembershipRepositoryImpl({
    required RazorpayService razorpayService,
    FirebaseFirestore? firestore,
  })  : _razorpay = razorpayService,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final RazorpayService _razorpay;
  final FirebaseFirestore _firestore;

  @override
  Future<Result<void>> purchasePlan({
    required String userId,
    required MembershipPlan plan,
  }) async {
    if (!plan.isPremium || plan.priceInPaise == 0) {
      return const Success(null);
    }

    try {
      final paymentId = await _razorpay.checkout(
        amountInPaise: plan.priceInPaise,
        description: 'FitMitra ${plan.name}',
        userId: userId,
      );

      final expiresAt =
          DateTime.now().add(Duration(days: plan.durationDays));

      await _firestore.collection(AppConstants.usersCollection).doc(userId).set({
        'isPremium': true,
        'premiumExpiresAt': Timestamp.fromDate(expiresAt),
        'membershipPlanId': plan.id,
        'lastPaymentId': paymentId,
      }, SetOptions(merge: true));

      await _firestore.collection(AppConstants.membershipsCollection).add({
        'userId': userId,
        'planId': plan.id,
        'paymentId': paymentId,
        'amountInPaise': plan.priceInPaise,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return const Success(null);
    } on PaymentFailure catch (e) {
      return Error(e);
    } catch (e) {
      return Error(PaymentFailure(e.toString()));
    }
  }
}
