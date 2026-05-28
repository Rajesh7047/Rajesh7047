import 'package:fitmitra/src/core/models/membership_tier.dart';
import 'package:fitmitra/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:fitmitra/src/features/membership/data/services/razorpay_checkout_service.dart';
import 'package:fitmitra/src/features/membership/domain/models/subscription_plan.dart';
import 'package:fitmitra/src/shared/data/seed_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final membershipPlansProvider = Provider<List<SubscriptionPlan>>(
  (ref) => SeedData.membershipPlans,
);

final membershipControllerProvider =
    StateNotifierProvider<MembershipController, MembershipState>((ref) {
      return MembershipController(
        checkoutService: RazorpayCheckoutService(),
        ref: ref,
      );
    });

class MembershipState {
  const MembershipState({required this.isProcessing, this.message});

  const MembershipState.initial() : this(isProcessing: false);

  final bool isProcessing;
  final String? message;

  MembershipState copyWith({
    bool? isProcessing,
    String? message,
    bool clearMessage = false,
  }) {
    return MembershipState(
      isProcessing: isProcessing ?? this.isProcessing,
      message: clearMessage ? null : message ?? this.message,
    );
  }
}

class MembershipController extends StateNotifier<MembershipState> {
  MembershipController({
    required RazorpayCheckoutService checkoutService,
    required Ref ref,
  }) : _checkoutService = checkoutService,
       _ref = ref,
       super(const MembershipState.initial());

  final RazorpayCheckoutService _checkoutService;
  final Ref _ref;

  Future<void> activatePlan(SubscriptionPlan plan) async {
    final user = _ref.read(authControllerProvider).user;
    if (user == null) {
      state = state.copyWith(message: 'Log in before upgrading your plan.');
      return;
    }

    state = state.copyWith(isProcessing: true, clearMessage: true);

    final result = await _checkoutService.openCheckout(plan: plan, user: user);

    if (result.isSuccess) {
      await _ref
          .read(authControllerProvider.notifier)
          .updateMembershipTier(
            plan.tier == MembershipTier.free
                ? MembershipTier.free
                : MembershipTier.premium,
          );
    }

    state = state.copyWith(isProcessing: false, message: result.message);
  }
}
