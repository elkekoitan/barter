import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  final AuthTokens tokens;

  const Authenticated(this.user, this.tokens);

  @override
  List<Object?> get props => [user, tokens];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final String? code;

  const AuthError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

class OTPRequired extends AuthState {
  final String identifier;
  final OTPType type;

  const OTPRequired(this.identifier, this.type);

  @override
  List<Object?> get props => [identifier, type];
}

class OTPSent extends AuthState {
  final String identifier;
  final OTPType type;

  const OTPSent(this.identifier, this.type);

  @override
  List<Object?> get props => [identifier, type];
}

class OTPVerified extends AuthState {}

class PasswordResetEmailSent extends AuthState {
  final String email;

  const PasswordResetEmailSent(this.email);

  @override
  List<Object?> get props => [email];
}

class ProfileUpdated extends AuthState {
  final UserEntity user;

  const ProfileUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class AvatarUploaded extends AuthState {
  final UserEntity user;

  const AvatarUploaded(this.user);

  @override
  List<Object?> get props => [user];
}

class AccountDeleted extends AuthState {}
