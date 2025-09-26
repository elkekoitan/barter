import 'package:dartz/dartz.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/network_info.dart';

class RegisterUseCase {
  final AuthRepository _repository;
  final NetworkInfo _networkInfo;

  const RegisterUseCase(this._repository, this._networkInfo);

  Future<Either<Failure, AuthTokens>> call(RegisterRequest request) async {
    // Validate registration request
    final validationFailure = _validateRegisterRequest(request);
    if (validationFailure != null) {
      return Left(validationFailure);
    }

    // Check network connectivity
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    // Attempt registration
    return await _repository.register(request);
  }

  Failure? _validateRegisterRequest(RegisterRequest request) {
    // Email validation
    if (request.email.isEmpty) {
      return const ValidationFailure('Email is required');
    }

    if (!_isValidEmail(request.email)) {
      return const ValidationFailure('Invalid email format');
    }

    // Phone validation
    if (request.phone.isEmpty) {
      return const ValidationFailure('Phone number is required');
    }

    if (!_isValidPhone(request.phone)) {
      return const ValidationFailure('Invalid phone number format');
    }

    // Password validation
    if (request.password.isEmpty) {
      return const ValidationFailure('Password is required');
    }

    if (request.password.length < 8) {
      return const ValidationFailure('Password must be at least 8 characters');
    }

    if (!_isStrongPassword(request.password)) {
      return const ValidationFailure('Password must contain at least one uppercase letter, one lowercase letter, one number and one special character');
    }

    // Confirm password validation
    if (request.password != request.confirmPassword) {
      return const ValidationFailure('Passwords do not match');
    }

    // Name validation
    if (request.firstName.isEmpty) {
      return const ValidationFailure('First name is required');
    }

    if (request.firstName.length < 2) {
      return const ValidationFailure('First name must be at least 2 characters');
    }

    if (request.lastName.isEmpty) {
      return const ValidationFailure('Last name is required');
    }

    if (request.lastName.length < 2) {
      return const ValidationFailure('Last name must be at least 2 characters');
    }

    // Check for valid characters in names
    if (!_containsOnlyLetters(request.firstName) || !_containsOnlyLetters(request.lastName)) {
      return const ValidationFailure('Names can only contain letters');
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
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }

  bool _isStrongPassword(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special character
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'\d').hasMatch(password);
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    return hasUpperCase && hasLowerCase && hasNumber && hasSpecialChar;
  }

  bool _containsOnlyLetters(String text) {
    final letterRegex = RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]+$');
    return letterRegex.hasMatch(text);
  }
}
