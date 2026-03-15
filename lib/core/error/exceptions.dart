class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error occurred']);
  
  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error occurred']);
  
  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Network connection failed']);
  
  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;
  const ValidationException([this.message = 'Validation failed']);
  
  @override
  String toString() => message;
}

class AuthenticationException implements Exception {
  final String message;
  const AuthenticationException([this.message = 'Authentication failed']);
  
  @override
  String toString() => message;
}

class PermissionException implements Exception {
  final String message;
  const PermissionException([this.message = 'Permission denied']);
  
  @override
  String toString() => message;
}
