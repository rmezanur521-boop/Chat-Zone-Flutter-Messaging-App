/// Exceptions thrown by the data layer (datasources).
/// These get caught by repositories and converted into Failures.
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException(this.message, {this.statusCode});
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(
      [this.message = 'Session expired. Please login again.']);
}

class NoInternetException implements Exception {
  final String message;
  NoInternetException([this.message = 'No internet connection.']);
}

class ForbiddenException implements Exception {
  final String message;
  ForbiddenException(
      [this.message = 'You do not have permission for this action.']);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = 'Requested resource was not found.']);
}
