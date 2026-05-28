import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmitra/core/providers/repository_providers.dart';
import 'package:fitmitra/domain/entities/user_profile.dart';

final authStateProvider = StreamProvider<UserProfile?>((ref) {
  return ref.watch(authRepositoryProvider).watchCurrentUser();
});

final currentUserProvider = Provider<UserProfile?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});
