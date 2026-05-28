import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmitra/data/repositories/auth_repository_impl.dart';
import 'package:fitmitra/data/repositories/chat_repository_impl.dart';
import 'package:fitmitra/data/repositories/content_repository_impl.dart';
import 'package:fitmitra/data/repositories/membership_repository_impl.dart';
import 'package:fitmitra/data/repositories/tracking_repository_impl.dart';
import 'package:fitmitra/domain/repositories/auth_repository.dart';
import 'package:fitmitra/domain/repositories/chat_repository.dart';
import 'package:fitmitra/domain/repositories/content_repository.dart';
import 'package:fitmitra/domain/repositories/membership_repository.dart';
import 'package:fitmitra/domain/repositories/tracking_repository.dart';
import 'package:fitmitra/shared/services/razorpay_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepositoryImpl();
});

final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  return TrackingRepositoryImpl();
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(
    openAiApiKey: dotenv.maybeGet('OPENAI_API_KEY'),
  );
});

final razorpayServiceProvider = Provider<RazorpayService>((ref) {
  return RazorpayService(
    keyId: dotenv.maybeGet('RAZORPAY_KEY_ID') ?? 'rzp_test_placeholder',
  );
});

final membershipRepositoryProvider = Provider<MembershipRepository>((ref) {
  return MembershipRepositoryImpl(
    razorpayService: ref.watch(razorpayServiceProvider),
  );
});
