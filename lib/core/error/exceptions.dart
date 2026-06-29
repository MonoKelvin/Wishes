class ServerException implements Exception {
  final int statusCode;
  final String message;

  ServerException(this.statusCode, this.message);

  @override
  String toString() => 'ServerException: $statusCode - $message';
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}
