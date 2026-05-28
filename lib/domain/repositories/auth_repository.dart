import 'package:fitmitra/core/utils/result.dart';
import 'package:fitmitra/domain/entities/user_profile.dart';

abstract class AuthRepository {
  Stream<UserProfile?> watchCurrentUser();
  Future<Result<String>> sendOtp(String phoneNumber);
  Future<Result<UserProfile>> verifyOtp({
    required String verificationId,
    required String smsCode,
  });
  Future<Result<void>> signOut();
  Future<Result<UserProfile>> updateProfile(UserProfile profile);
}
