sealed class Failure {
  const Failure();
}

class NetworkFailure extends Failure {
  final String message;
  const NetworkFailure(this.message);

  @override
  String toString() => 'NetworkFailure: $message';
}

class AuthFailure extends Failure {
  final String message;
  const AuthFailure(this.message);

  @override
  String toString() => 'AuthFailure: $message';
}

class ServerFailure extends Failure {
  final int statusCode;
  final String message;
  const ServerFailure(this.statusCode, this.message);

  @override
  String toString() => 'ServerFailure: $statusCode - $message';
}

class CacheFailure extends Failure {
  final String message;
  const CacheFailure(this.message);

  @override
  String toString() => 'CacheFailure: $message';
}

class ValidationFailure extends Failure {
  final String message;
  const ValidationFailure(this.message);

  @override
  String toString() => 'ValidationFailure: $message';
}
