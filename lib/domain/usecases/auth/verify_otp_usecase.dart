import 'package:dartz/dartz.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';

class VerifyOtpUseCase {
  final AuthRepository _repository;

  const VerifyOtpUseCase(this._repository);

  Future<Either<Failure, void>> call(OTPVerificationRequest request) async {
    // Validate OTP request
    final validationFailure = _validateOTPRequest(request);
    if (validationFailure != null) {
      return Left(validationFailure);
    }

    // Check network connectivity
    final isConnected = await _repository.isLoggedIn(); // This should be replaced with network check
    if (!isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    // Attempt OTP verification
    return await _repository.verifyOTP(request);
  }

  Failure? _validateOTPRequest(OTPVerificationRequest request) {
    if (request.identifier.isEmpty) {
      return const ValidationFailure('Identifier is required');
    }

    if (request.otp.isEmpty) {
      return const ValidationFailure('OTP code is required');
    }

    if (request.otp.length != 6) {
      return const ValidationFailure('OTP code must be 6 digits');
    }

    // Validate OTP contains only numbers
    if (!RegExp(r'^\d{6}$').hasMatch(request.otp)) {
      return const ValidationFailure('OTP code must contain only numbers');
    }

    // Validate identifier format
    if (request.identifier.contains('@') && !_isValidEmail(request.identifier)) {
      return const ValidationFailure('Invalid email format');
    }

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
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }
}
