import 'package:fitmitra/core/utils/result.dart';
import 'package:fitmitra/domain/entities/membership_plan.dart';

abstract class MembershipRepository {
  Future<Result<void>> purchasePlan({
    required String userId,
    required MembershipPlan plan,
  });
}
