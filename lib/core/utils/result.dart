import 'package:fitmitra/core/errors/failures.dart';

/// Lightweight Result type for clean architecture layers.
sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) error,
  }) {
    return switch (this) {
      Success(:final data) => success(data),
      Error(:final failure) => error(failure),
    };
  }
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Error<T> extends Result<T> {
  const Error(this.failure);
  final Failure failure;
}
