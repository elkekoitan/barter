abstract class Failure {
  final String message;
  final int? code;
  final String? details;

  const Failure(this.message, {this.code, this.details});

  @override
  String toString() => 'Failure(message: $message, code: $code, details: $details)';
}

class ServerFailure extends Failure {
  const ServerFailure(String message, {int? code, String? details})
      : super(message, code: code, details: details);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message, {String? details})
      : super(message, details: details);
}

class CacheFailure extends Failure {
  const CacheFailure(String message, {String? details})
      : super(message, details: details);
}

class AuthFailure extends Failure {
  const AuthFailure(String message, {String? details})
      : super(message, details: details);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message, {String? details})
      : super(message, details: details);
}

class PaymentFailure extends Failure {
  const PaymentFailure(String message, {int? code, String? details})
      : super(message, code: code, details: details);
}

class PermissionFailure extends Failure {
  const PermissionFailure(String message, {String? details})
      : super(message, details: details);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(String message, {String? details})
      : super(message, details: details);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(String message, {String? details})
      : super(message, details: details);
}

class UnknownFailure extends Failure {
  const UnknownFailure(String message, {String? details})
      : super(message, details: details);
}
