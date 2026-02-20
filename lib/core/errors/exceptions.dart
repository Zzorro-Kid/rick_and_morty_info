class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException(this.message, [this.statusCode]);

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);

  @override
  String toString() => 'NotFoundException: $message';
}

class UnexpectedException implements Exception {
  final int errorCode;
  final String? message;

  UnexpectedException({required this.errorCode, this.message});

  @override
  String toString() => 'UnexpectedException: Code $errorCode';
}
