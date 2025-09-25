import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';
import '../../../domain/usecases/auth/verify_otp_usecase.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final AuthRepository _authRepository;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        _authRepository = authRepository,
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<SendOTPRequested>(_onSendOTPRequested);
    on<VerifyOTPRequested>(_onVerifyOTPRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<GetCurrentUserRequested>(_onGetCurrentUserRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<UploadAvatarRequested>(_onUploadAvatarRequested);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
    on<SocialLoginRequested>(_onSocialLoginRequested);
    on<CheckAuthStatusRequested>(_onCheckAuthStatusRequested);
    on<UpdateFCMTokenRequested>(_onUpdateFCMTokenRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _loginUseCase.call(event.request);

    result.fold(
      (failure) => emit(AuthError(failure.message, code: failure.toString())),
      (tokens) => emit(Authenticated(tokens.user, tokens)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _registerUseCase.call(event.request);

    result.fold(
      (failure) => emit(AuthError(failure.message, code: failure.toString())),
      (tokens) => emit(Authenticated(tokens.user, tokens)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _logoutUseCase.call();

    result.fold(
      (failure) {
        // Even if logout fails, we should emit Unauthenticated
        // since the main goal is to clear local session
        debugPrint('Logout warning: ${failure.message}');
        emit(Unauthenticated());
      },
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onSendOTPRequested(
    SendOTPRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.sendOTP(event.identifier, event.type);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(OTPSent(event.identifier, event.type)),
    );
  }

  Future<void> _onVerifyOTPRequested(
    VerifyOTPRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _verifyOtpUseCase.call(event.request);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(OTPVerified()),
    );
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.forgotPassword(event.email);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(PasswordResetEmailSent(event.email)),
    );
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.resetPassword(event.request);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(Unauthenticated()), // User should login again after password reset
    );
  }

  Future<void> _onGetCurrentUserRequested(
    GetCurrentUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is Authenticated) {
      return; // Already authenticated, no need to fetch
    }

    emit(AuthLoading());

    final result = await _authRepository.getCurrentUser();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        // User data fetched, but we need tokens for full authentication
        emit(AuthError('Session expired. Please login again.'));
      },
    );
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.updateUserProfile(event.request);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        if (state is Authenticated) {
          final currentAuth = state as Authenticated;
          emit(Authenticated(user, currentAuth.tokens));
        } else {
          emit(ProfileUpdated(user));
        }
      },
    );
  }

  Future<void> _onUploadAvatarRequested(
    UploadAvatarRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.uploadAvatar(event.filePath);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        if (state is Authenticated) {
          final currentAuth = state as Authenticated;
          emit(Authenticated(user, currentAuth.tokens));
        } else {
          emit(AvatarUploaded(user));
        }
      },
    );
  }

  Future<void> _onDeleteAccountRequested(
    DeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authRepository.deleteAccount();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AccountDeleted()),
    );
  }

  Future<void> _onSocialLoginRequested(
    SocialLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _getSocialLoginResult(event.type);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (tokens) => emit(Authenticated(tokens.user, tokens)),
    );
  }

  Future<Either<Failure, AuthTokens>> _getSocialLoginResult(SocialLoginType type) async {
    switch (type) {
      case SocialLoginType.google:
        return await _authRepository.loginWithGoogle();
      case SocialLoginType.apple:
        return await _authRepository.loginWithApple();
      case SocialLoginType.facebook:
        return await _authRepository.loginWithFacebook();
    }
  }

  Future<void> _onCheckAuthStatusRequested(
    CheckAuthStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _authRepository.isLoggedIn();

    result.fold(
      (failure) => emit(Unauthenticated()),
      (isLoggedIn) {
        if (isLoggedIn) {
          // Try to get current user data
          add(const GetCurrentUserRequested());
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onUpdateFCMTokenRequested(
    UpdateFCMTokenRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _authRepository.updateFCMToken(event.token);

    result.fold(
      (failure) {
        // FCM token update failed, but this shouldn't affect auth state
        debugPrint('FCM token update failed: ${failure.message}');
      },
      (_) {
        // FCM token updated successfully
        debugPrint('FCM token updated successfully');
      },
    );
  }
}
