sealed class Failure {
  const Failure(this.message, [this.exception]);

  final String message;
  final Exception? exception;
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
