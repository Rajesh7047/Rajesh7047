import 'package:equatable/equatable.dart';

/// Base failure type for repository / use-case errors.
abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error. Please try again.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error.']);
}

class PaymentFailure extends Failure {
  const PaymentFailure([super.message = 'Payment could not be completed.']);
}

class PremiumRequiredFailure extends Failure {
  const PremiumRequiredFailure([
    super.message = 'Upgrade to Premium to access this feature.',
  ]);
}
