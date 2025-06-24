class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() {
    return 'ServerException: $message';
  }
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);

  @override
  String toString() {
    return 'CacheException: $message';
  }
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);

  @override
  String toString() {
    return 'NotFoundException: $message';
  }
}
