// Developed by Hamas — Medtrack Project [100% Dart]
// Developed by Hamas — Medtrack Project [100% Dart Implementation]
sealed class Failure {
  final String message;
  final Exception? exception;

  const Failure(this.message, [this.exception]);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.exception]);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, [super.exception]);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message, [super.exception]);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, [super.exception]);
}

// Example usage returning an Either with fpdart
// Future<Either<Failure, Medicine>> getMedicine(String id) async { ... }
