import 'package:dartz/dartz.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';

class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  Future<Either<Failure, AuthTokens>> call(LoginRequest request) async {
    // Validate login request
    final validationFailure = _validateLoginRequest(request);
    if (validationFailure != null) {
      return Left(validationFailure);
    }

    // Check network connectivity
    final isConnected = await _repository.isLoggedIn(); // This should be replaced with network check
    if (!isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    // Attempt login
    return await _repository.login(request);
  }

  Failure? _validateLoginRequest(LoginRequest request) {
    if (request.identifier.isEmpty) {
      return const ValidationFailure('Email or phone number is required');
    }

    if (request.password.isEmpty) {
      return const ValidationFailure('Password is required');
    }

    if (request.password.length < 6) {
      return const ValidationFailure('Password must be at least 6 characters');
    }

    // Validate email format if identifier contains @
    if (request.identifier.contains('@') && !_isValidEmail(request.identifier)) {
      return const ValidationFailure('Invalid email format');
    }

    // Validate phone format if identifier doesn't contain @
    if (!request.identifier.contains('@') && !_isValidPhone(request.identifier)) {
      return const ValidationFailure('Invalid phone number format');
    }

    return null;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    // Turkish phone number validation
    final phoneRegex = RegExp(r'^(\+90|0)?[5][0-9]{9}$');
    return phoneRegex.hasMatch(phone.replaceAll(' ', ''));
  }
}
