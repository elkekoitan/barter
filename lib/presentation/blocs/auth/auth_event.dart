import 'package:equatable/equatable.dart';
import '../../../domain/repositories/auth_repository.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final LoginRequest request;

  const LoginRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class RegisterRequested extends AuthEvent {
  final RegisterRequest request;

  const RegisterRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class LogoutRequested extends AuthEvent {}

class SendOTPRequested extends AuthEvent {
  final String identifier;
  final OTPType type;

  const SendOTPRequested(this.identifier, this.type);

  @override
  List<Object?> get props => [identifier, type];
}

class VerifyOTPRequested extends AuthEvent {
  final OTPVerificationRequest request;

  const VerifyOTPRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested(this.email);

  @override
  List<Object?> get props => [email];
}

class ResetPasswordRequested extends AuthEvent {
  final ResetPasswordRequest request;

  const ResetPasswordRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class GetCurrentUserRequested extends AuthEvent {}

class UpdateProfileRequested extends AuthEvent {
  final UpdateProfileRequest request;

  const UpdateProfileRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class UploadAvatarRequested extends AuthEvent {
  final String filePath;

  const UploadAvatarRequested(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class DeleteAccountRequested extends AuthEvent {}

class SocialLoginRequested extends AuthEvent {
  final SocialLoginType type;

  const SocialLoginRequested(this.type);

  @override
  List<Object?> get props => [type];
}

class CheckAuthStatusRequested extends AuthEvent {}

class UpdateFCMTokenRequested extends AuthEvent {
  final String token;

  const UpdateFCMTokenRequested(this.token);

  @override
  List<Object?> get props => [token];
}

enum SocialLoginType {
  google,
  apple,
  facebook,
}
