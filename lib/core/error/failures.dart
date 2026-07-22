import 'package:equatable/equatable.dart';
import 'exceptions.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}

/// Converts a raw exception thrown by the data layer into a typed
/// domain Failure. Repositories should always go through this so
/// notifiers only ever deal with Failure objects.
Failure mapExceptionToFailure(Object error) {
  if (error is UnauthorizedException) return UnauthorizedFailure(error.message);
  if (error is ForbiddenException) return ForbiddenFailure(error.message);
  if (error is NotFoundException) return NotFoundFailure(error.message);
  if (error is NoInternetException) return NetworkFailure(error.message);
  if (error is ServerException) return ServerFailure(error.message);
  return UnexpectedFailure(error.toString());
}
