import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/security/security_usecases.dart';
import 'security_event.dart';
import 'security_state.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  final GetTwoFactorStatusUseCase _getTwoFactorStatusUseCase;
  final EnableTwoFactorAuthUseCase _enableTwoFactorAuthUseCase;
  final DisableTwoFactorAuthUseCase _disableTwoFactorAuthUseCase;
  final VerifyTwoFactorCodeUseCase _verifyTwoFactorCodeUseCase;
  final SendTwoFactorCodeUseCase _sendTwoFactorCodeUseCase;
  final GenerateBackupCodesUseCase _generateBackupCodesUseCase;
  final VerifyBackupCodeUseCase _verifyBackupCodeUseCase;
  final UpdateTwoFactorSettingsUseCase _updateTwoFactorSettingsUseCase;
  final GetTwoFactorRecoveryOptionsUseCase _getTwoFactorRecoveryOptionsUseCase;
  final SetupTwoFactorRecoveryUseCase _setupTwoFactorRecoveryUseCase;
  final VerifyTwoFactorRecoveryUseCase _verifyTwoFactorRecoveryUseCase;
  final DisableTwoFactorTemporarilyUseCase _disableTwoFactorTemporarilyUseCase;
  final GetTwoFactorStatsUseCase _getTwoFactorStatsUseCase;
  final GetSecurityAlertsUseCase _getSecurityAlertsUseCase;
  final MarkSecurityAlertAsReadUseCase _markSecurityAlertAsReadUseCase;
  final GetTrustedDevicesUseCase _getTrustedDevicesUseCase;
  final TrustCurrentDeviceUseCase _trustCurrentDeviceUseCase;
  final RemoveTrustedDeviceUseCase _removeTrustedDeviceUseCase;
  final GetActiveSessionsUseCase _getActiveSessionsUseCase;
  final TerminateSessionUseCase _terminateSessionUseCase;
  final GetSecuritySettingsUseCase _getSecuritySettingsUseCase;
  final UpdateSecuritySettingsUseCase _updateSecuritySettingsUseCase;
  final GetAuditLogsUseCase _getAuditLogsUseCase;
  final GetSecurityStatsUseCase _getSecurityStatsUseCase;
  final GetPasswordPolicyUseCase _getPasswordPolicyUseCase;
  final UpdatePasswordPolicyUseCase _updatePasswordPolicyUseCase;
  final ValidatePasswordStrengthUseCase _validatePasswordStrengthUseCase;
  final GetPasswordStrengthUseCase _getPasswordStrengthUseCase;
  final CheckPasswordAgainstBreachedUseCase _checkPasswordAgainstBreachedUseCase;
  final IsRateLimitedUseCase _isRateLimitedUseCase;
  final GetBiometricSettingsUseCase _getBiometricSettingsUseCase;
  final UpdateBiometricSettingsUseCase _updateBiometricSettingsUseCase;
  final IsBiometricAvailableUseCase _isBiometricAvailableUseCase;
  final AuthenticateWithBiometricUseCase _authenticateWithBiometricUseCase;
  final EnableBiometricAuthUseCase _enableBiometricAuthUseCase;
  final DisableBiometricAuthUseCase _disableBiometricAuthUseCase;
  final GetSecurityConfigurationUseCase _getSecurityConfigurationUseCase;
  final UpdateSecurityConfigurationUseCase _updateSecurityConfigurationUseCase;
  final PerformSecurityScanUseCase _performSecurityScanUseCase;
  final GetSecurityScoreUseCase _getSecurityScoreUseCase;
  final GetSecurityRecommendationsUseCase _getSecurityRecommendationsUseCase;
  final UpdateSecurityScoreUseCase _updateSecurityScoreUseCase;
  final CheckSuspiciousActivityUseCase _checkSuspiciousActivityUseCase;
  final BlockSuspiciousIPUseCase _blockSuspiciousIPUseCase;
  final GetBlockedIPsUseCase _getBlockedIPsUseCase;
  final IsIPBlockedUseCase _isIPBlockedUseCase;

  SecurityBloc({
    required GetTwoFactorStatusUseCase getTwoFactorStatusUseCase,
    required EnableTwoFactorAuthUseCase enableTwoFactorAuthUseCase,
    required DisableTwoFactorAuthUseCase disableTwoFactorAuthUseCase,
    required VerifyTwoFactorCodeUseCase verifyTwoFactorCodeUseCase,
    required SendTwoFactorCodeUseCase sendTwoFactorCodeUseCase,
    required GenerateBackupCodesUseCase generateBackupCodesUseCase,
    required VerifyBackupCodeUseCase verifyBackupCodeUseCase,
    required UpdateTwoFactorSettingsUseCase updateTwoFactorSettingsUseCase,
    required GetTwoFactorRecoveryOptionsUseCase getTwoFactorRecoveryOptionsUseCase,
    required SetupTwoFactorRecoveryUseCase setupTwoFactorRecoveryUseCase,
    required VerifyTwoFactorRecoveryUseCase verifyTwoFactorRecoveryUseCase,
    required DisableTwoFactorTemporarilyUseCase disableTwoFactorTemporarilyUseCase,
    required GetTwoFactorStatsUseCase getTwoFactorStatsUseCase,
    required GetSecurityAlertsUseCase getSecurityAlertsUseCase,
    required MarkSecurityAlertAsReadUseCase markSecurityAlertAsReadUseCase,
    required GetTrustedDevicesUseCase getTrustedDevicesUseCase,
    required TrustCurrentDeviceUseCase trustCurrentDeviceUseCase,
    required RemoveTrustedDeviceUseCase removeTrustedDeviceUseCase,
    required GetActiveSessionsUseCase getActiveSessionsUseCase,
    required TerminateSessionUseCase terminateSessionUseCase,
    required GetSecuritySettingsUseCase getSecuritySettingsUseCase,
    required UpdateSecuritySettingsUseCase updateSecuritySettingsUseCase,
    required GetAuditLogsUseCase getAuditLogsUseCase,
    required GetSecurityStatsUseCase getSecurityStatsUseCase,
    required GetPasswordPolicyUseCase getPasswordPolicyUseCase,
    required UpdatePasswordPolicyUseCase updatePasswordPolicyUseCase,
    required ValidatePasswordStrengthUseCase validatePasswordStrengthUseCase,
    required GetPasswordStrengthUseCase getPasswordStrengthUseCase,
    required CheckPasswordAgainstBreachedUseCase checkPasswordAgainstBreachedUseCase,
    required IsRateLimitedUseCase isRateLimitedUseCase,
    required GetBiometricSettingsUseCase getBiometricSettingsUseCase,
    required UpdateBiometricSettingsUseCase updateBiometricSettingsUseCase,
    required IsBiometricAvailableUseCase isBiometricAvailableUseCase,
    required AuthenticateWithBiometricUseCase authenticateWithBiometricUseCase,
    required EnableBiometricAuthUseCase enableBiometricAuthUseCase,
    required DisableBiometricAuthUseCase disableBiometricAuthUseCase,
    required GetSecurityConfigurationUseCase getSecurityConfigurationUseCase,
    required UpdateSecurityConfigurationUseCase updateSecurityConfigurationUseCase,
    required PerformSecurityScanUseCase performSecurityScanUseCase,
    required GetSecurityScoreUseCase getSecurityScoreUseCase,
    required GetSecurityRecommendationsUseCase getSecurityRecommendationsUseCase,
    required UpdateSecurityScoreUseCase updateSecurityScoreUseCase,
    required CheckSuspiciousActivityUseCase checkSuspiciousActivityUseCase,
    required BlockSuspiciousIPUseCase blockSuspiciousIPUseCase,
    required GetBlockedIPsUseCase getBlockedIPsUseCase,
    required IsIPBlockedUseCase isIPBlockedUseCase,
  }) : _getTwoFactorStatusUseCase = getTwoFactorStatusUseCase,
       _enableTwoFactorAuthUseCase = enableTwoFactorAuthUseCase,
       _disableTwoFactorAuthUseCase = disableTwoFactorAuthUseCase,
       _verifyTwoFactorCodeUseCase = verifyTwoFactorCodeUseCase,
       _sendTwoFactorCodeUseCase = sendTwoFactorCodeUseCase,
       _generateBackupCodesUseCase = generateBackupCodesUseCase,
       _verifyBackupCodeUseCase = verifyBackupCodeUseCase,
       _updateTwoFactorSettingsUseCase = updateTwoFactorSettingsUseCase,
       _getTwoFactorRecoveryOptionsUseCase = getTwoFactorRecoveryOptionsUseCase,
       _setupTwoFactorRecoveryUseCase = setupTwoFactorRecoveryUseCase,
       _verifyTwoFactorRecoveryUseCase = verifyTwoFactorRecoveryUseCase,
       _disableTwoFactorTemporarilyUseCase = disableTwoFactorTemporarilyUseCase,
       _getTwoFactorStatsUseCase = getTwoFactorStatsUseCase,
       _getSecurityAlertsUseCase = getSecurityAlertsUseCase,
       _markSecurityAlertAsReadUseCase = markSecurityAlertAsReadUseCase,
       _getTrustedDevicesUseCase = getTrustedDevicesUseCase,
       _trustCurrentDeviceUseCase = trustCurrentDeviceUseCase,
       _removeTrustedDeviceUseCase = removeTrustedDeviceUseCase,
       _getActiveSessionsUseCase = getActiveSessionsUseCase,
       _terminateSessionUseCase = terminateSessionUseCase,
       _getSecuritySettingsUseCase = getSecuritySettingsUseCase,
       _updateSecuritySettingsUseCase = updateSecuritySettingsUseCase,
       _getAuditLogsUseCase = getAuditLogsUseCase,
       _getSecurityStatsUseCase = getSecurityStatsUseCase,
       _getPasswordPolicyUseCase = getPasswordPolicyUseCase,
       _updatePasswordPolicyUseCase = updatePasswordPolicyUseCase,
       _validatePasswordStrengthUseCase = validatePasswordStrengthUseCase,
       _getPasswordStrengthUseCase = getPasswordStrengthUseCase,
       _checkPasswordAgainstBreachedUseCase = checkPasswordAgainstBreachedUseCase,
       _isRateLimitedUseCase = isRateLimitedUseCase,
       _getBiometricSettingsUseCase = getBiometricSettingsUseCase,
       _updateBiometricSettingsUseCase = updateBiometricSettingsUseCase,
       _isBiometricAvailableUseCase = isBiometricAvailableUseCase,
       _authenticateWithBiometricUseCase = authenticateWithBiometricUseCase,
       _enableBiometricAuthUseCase = enableBiometricAuthUseCase,
       _disableBiometricAuthUseCase = disableBiometricAuthUseCase,
       _getSecurityConfigurationUseCase = getSecurityConfigurationUseCase,
       _updateSecurityConfigurationUseCase = updateSecurityConfigurationUseCase,
       _performSecurityScanUseCase = performSecurityScanUseCase,
       _getSecurityScoreUseCase = getSecurityScoreUseCase,
       _getSecurityRecommendationsUseCase = getSecurityRecommendationsUseCase,
       _updateSecurityScoreUseCase = updateSecurityScoreUseCase,
       _checkSuspiciousActivityUseCase = checkSuspiciousActivityUseCase,
       _blockSuspiciousIPUseCase = blockSuspiciousIPUseCase,
       _getBlockedIPsUseCase = getBlockedIPsUseCase,
       _isIPBlockedUseCase = isIPBlockedUseCase,
       super(SecurityInitial()) {
    on<EnableTwoFactorAuthRequested>(_onEnableTwoFactorAuthRequested);
    on<DisableTwoFactorAuthRequested>(_onDisableTwoFactorAuthRequested);
    on<VerifyTwoFactorCodeRequested>(_onVerifyTwoFactorCodeRequested);
    on<SendTwoFactorCodeRequested>(_onSendTwoFactorCodeRequested);
    on<GenerateBackupCodesRequested>(_onGenerateBackupCodesRequested);
    on<VerifyBackupCodeRequested>(_onVerifyBackupCodeRequested);
    on<GetTwoFactorStatusRequested>(_onGetTwoFactorStatusRequested);
    on<UpdateTwoFactorSettingsRequested>(_onUpdateTwoFactorSettingsRequested);
    on<GetTwoFactorRecoveryOptionsRequested>(_onGetTwoFactorRecoveryOptionsRequested);
    on<SetupTwoFactorRecoveryRequested>(_onSetupTwoFactorRecoveryRequested);
    on<VerifyTwoFactorRecoveryRequested>(_onVerifyTwoFactorRecoveryRequested);
    on<DisableTwoFactorTemporarilyRequested>(_onDisableTwoFactorTemporarilyRequested);
    on<GetTwoFactorStatsRequested>(_onGetTwoFactorStatsRequested);
    on<GetSecurityAlertsRequested>(_onGetSecurityAlertsRequested);
    on<MarkSecurityAlertAsReadRequested>(_onMarkSecurityAlertAsReadRequested);
    on<GetTrustedDevicesRequested>(_onGetTrustedDevicesRequested);
    on<TrustCurrentDeviceRequested>(_onTrustCurrentDeviceRequested);
    on<RemoveTrustedDeviceRequested>(_onRemoveTrustedDeviceRequested);
    on<GetActiveSessionsRequested>(_onGetActiveSessionsRequested);
    on<TerminateSessionRequested>(_onTerminateSessionRequested);
    on<GetSecuritySettingsRequested>(_onGetSecuritySettingsRequested);
    on<UpdateSecuritySettingsRequested>(_onUpdateSecuritySettingsRequested);
    on<GetAuditLogsRequested>(_onGetAuditLogsRequested);
    on<GetSecurityStatsRequested>(_onGetSecurityStatsRequested);
    on<GetPasswordPolicyRequested>(_onGetPasswordPolicyRequested);
    on<UpdatePasswordPolicyRequested>(_onUpdatePasswordPolicyRequested);
    on<ValidatePasswordStrengthRequested>(_onValidatePasswordStrengthRequested);
    on<GetPasswordStrengthRequested>(_onGetPasswordStrengthRequested);
    on<CheckPasswordAgainstBreachedRequested>(_onCheckPasswordAgainstBreachedRequested);
    on<IsRateLimitedRequested>(_onIsRateLimitedRequested);
    on<GetBiometricSettingsRequested>(_onGetBiometricSettingsRequested);
    on<UpdateBiometricSettingsRequested>(_onUpdateBiometricSettingsRequested);
    on<IsBiometricAvailableRequested>(_onIsBiometricAvailableRequested);
    on<AuthenticateWithBiometricRequested>(_onAuthenticateWithBiometricRequested);
    on<EnableBiometricAuthRequested>(_onEnableBiometricAuthRequested);
    on<DisableBiometricAuthRequested>(_onDisableBiometricAuthRequested);
    on<GetSecurityConfigurationRequested>(_onGetSecurityConfigurationRequested);
    on<UpdateSecurityConfigurationRequested>(_onUpdateSecurityConfigurationRequested);
    on<PerformSecurityScanRequested>(_onPerformSecurityScanRequested);
    on<GetSecurityScoreRequested>(_onGetSecurityScoreRequested);
    on<GetSecurityRecommendationsRequested>(_onGetSecurityRecommendationsRequested);
    on<UpdateSecurityScoreRequested>(_onUpdateSecurityScoreRequested);
    on<CheckSuspiciousActivityRequested>(_onCheckSuspiciousActivityRequested);
    on<BlockSuspiciousIPRequested>(_onBlockSuspiciousIPRequested);
    on<GetBlockedIPsRequested>(_onGetBlockedIPsRequested);
    on<IsIPBlockedRequested>(_onIsIPBlockedRequested);
  }

  Future<void> _onEnableTwoFactorAuthRequested(
    EnableTwoFactorAuthRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _enableTwoFactorAuthUseCase(
      method: event.method,
      phoneNumber: event.phoneNumber,
      email: event.email,
      setAsPrimary: event.setAsPrimary,
    );

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (twoFactorAuth) => TwoFactorAuthEnabled(twoFactorAuth),
    ));
  }

  Future<void> _onDisableTwoFactorAuthRequested(
    DisableTwoFactorAuthRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _disableTwoFactorAuthUseCase(event.password);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (_) => TwoFactorAuthDisabled(),
    ));
  }

  Future<void> _onVerifyTwoFactorCodeRequested(
    VerifyTwoFactorCodeRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _verifyTwoFactorCodeUseCase(
      code: event.code,
      method: event.method,
      verificationId: event.verificationId,
      trustDevice: event.trustDevice,
    );

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (verified) => TwoFactorCodeVerified(trustedDevice: event.trustDevice && verified),
    ));
  }

  Future<void> _onSendTwoFactorCodeRequested(
    SendTwoFactorCodeRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _sendTwoFactorCodeUseCase(
      event.method,
      phoneNumber: event.phoneNumber,
      email: event.email,
    );

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (verificationId) => TwoFactorCodeSent(verificationId),
    ));
  }

  Future<void> _onGenerateBackupCodesRequested(
    GenerateBackupCodesRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _generateBackupCodesUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (backupCodes) => BackupCodesGenerated(backupCodes),
    ));
  }

  Future<void> _onVerifyBackupCodeRequested(
    VerifyBackupCodeRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _verifyBackupCodeUseCase(event.backupCode);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (_) => const BackupCodeVerified(),
    ));
  }

  Future<void> _onGetTwoFactorStatusRequested(
    GetTwoFactorStatusRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _getTwoFactorStatusUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (twoFactorAuth) => SecurityLoaded(twoFactorAuth: twoFactorAuth),
    ));
  }

  Future<void> _onUpdateTwoFactorSettingsRequested(
    UpdateTwoFactorSettingsRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _updateTwoFactorSettingsUseCase(event.settings);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (twoFactorAuth) => TwoFactorSettingsUpdated(twoFactorAuth),
    ));
  }

  Future<void> _onGetTwoFactorRecoveryOptionsRequested(
    GetTwoFactorRecoveryOptionsRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _getTwoFactorRecoveryOptionsUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (options) => TwoFactorRecoveryOptionsLoaded(options),
    ));
  }

  Future<void> _onSetupTwoFactorRecoveryRequested(
    SetupTwoFactorRecoveryRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _setupTwoFactorRecoveryUseCase(
      securityQuestions: event.securityQuestions,
      backupEmail: event.backupEmail,
      backupPhone: event.backupPhone,
    );

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (_) => TwoFactorRecoverySetupCompleted(),
    ));
  }

  Future<void> _onVerifyTwoFactorRecoveryRequested(
    VerifyTwoFactorRecoveryRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _verifyTwoFactorRecoveryUseCase(
      securityAnswers: event.securityAnswers,
      backupCode: event.backupCode,
      recoveryToken: event.recoveryToken,
    );

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (_) => TwoFactorRecoveryVerified(),
    ));
  }

  Future<void> _onDisableTwoFactorTemporarilyRequested(
    DisableTwoFactorTemporarilyRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _disableTwoFactorTemporarilyUseCase(
      reason: event.reason,
      durationMinutes: event.durationMinutes,
    );

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (_) => TwoFactorTemporarilyDisabled(),
    ));
  }

  Future<void> _onGetTwoFactorStatsRequested(
    GetTwoFactorStatsRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _getTwoFactorStatsUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (stats) => TwoFactorStatsLoaded(stats),
    ));
  }

  Future<void> _onGetSecurityAlertsRequested(
    GetSecurityAlertsRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _getSecurityAlertsUseCase(
      type: event.type,
      severity: event.severity,
      unreadOnly: event.unreadOnly,
      page: event.page,
      limit: event.limit,
    );

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (alerts) => SecurityAlertsLoaded(
        alerts: alerts,
        type: event.type,
        severity: event.severity,
        unreadOnly: event.unreadOnly,
      ),
    ));
  }

  Future<void> _onMarkSecurityAlertAsReadRequested(
    MarkSecurityAlertAsReadRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _markSecurityAlertAsReadUseCase(event.alertId);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (_) => SecurityAlertMarkedAsRead(event.alertId),
    ));
  }

  Future<void> _onGetTrustedDevicesRequested(
    GetTrustedDevicesRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _getTrustedDevicesUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (devices) => TrustedDevicesLoaded(devices),
    ));
  }

  Future<void> _onTrustCurrentDeviceRequested(
    TrustCurrentDeviceRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _trustCurrentDeviceUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (_) => CurrentDeviceTrusted(),
    ));
  }

  Future<void> _onRemoveTrustedDeviceRequested(
    RemoveTrustedDeviceRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _removeTrustedDeviceUseCase(event.deviceId);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (_) => TrustedDeviceRemoved(event.deviceId),
    ));
  }

  Future<void> _onGetActiveSessionsRequested(
    GetActiveSessionsRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _getActiveSessionsUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (sessions) => ActiveSessionsLoaded(sessions),
    ));
  }

  Future<void> _onTerminateSessionRequested(
    TerminateSessionRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _terminateSessionUseCase(event.sessionId);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (_) => SessionTerminated(event.sessionId),
    ));
  }

  Future<void> _onGetSecuritySettingsRequested(
    GetSecuritySettingsRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _getSecuritySettingsUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (settings) => SecuritySettingsLoaded(settings),
    ));
  }

  Future<void> _onUpdateSecuritySettingsRequested(
    UpdateSecuritySettingsRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _updateSecuritySettingsUseCase(event.settings);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (settings) => SecuritySettingsUpdated(settings),
    ));
  }

  Future<void> _onGetAuditLogsRequested(
    GetAuditLogsRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _getAuditLogsUseCase(
      action: event.action,
      fromDate: event.fromDate,
      toDate: event.toDate,
      resource: event.resource,
      page: event.page,
      limit: event.limit,
    );

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (logs) => AuditLogsLoaded(logs: logs, action: event.action, resource: event.resource),
    ));
  }

  Future<void> _onGetSecurityStatsRequested(
    GetSecurityStatsRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _getSecurityStatsUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (stats) => SecurityStatsLoaded(stats),
    ));
  }

  Future<void> _onGetPasswordPolicyRequested(
    GetPasswordPolicyRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _getPasswordPolicyUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (policy) => PasswordPolicyLoaded(policy),
    ));
  }

  Future<void> _onUpdatePasswordPolicyRequested(
    UpdatePasswordPolicyRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _updatePasswordPolicyUseCase(event.policy);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (policy) => PasswordPolicyUpdated(policy),
    ));
  }

  Future<void> _onValidatePasswordStrengthRequested(
    ValidatePasswordStrengthRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _validatePasswordStrengthUseCase(event.password);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (valid) => PasswordStrengthValidated(event.password, valid: valid),
    ));
  }

  Future<void> _onGetPasswordStrengthRequested(
    GetPasswordStrengthRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _getPasswordStrengthUseCase(event.password);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (strength) => PasswordStrengthLoaded(event.password, strength),
    ));
  }

  Future<void> _onCheckPasswordAgainstBreachedRequested(
    CheckPasswordAgainstBreachedRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _checkPasswordAgainstBreachedUseCase(event.password);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (breaches) => PasswordBreachedCheckLoaded(event.password, breaches),
    ));
  }

  Future<void> _onIsRateLimitedRequested(
    IsRateLimitedRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _isRateLimitedUseCase(event.identifier, event.type);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (limited) => RateLimitedStatusLoaded(event.identifier, event.type, limited: limited),
    ));
  }

  Future<void> _onGetBiometricSettingsRequested(
    GetBiometricSettingsRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _getBiometricSettingsUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (settings) => BiometricSettingsLoaded(settings),
    ));
  }

  Future<void> _onUpdateBiometricSettingsRequested(
    UpdateBiometricSettingsRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _updateBiometricSettingsUseCase(event.settings);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (settings) => BiometricSettingsUpdated(settings),
    ));
  }

  Future<void> _onIsBiometricAvailableRequested(
    IsBiometricAvailableRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _isBiometricAvailableUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (available) => BiometricAvailableStatusLoaded(available: available),
    ));
  }

  Future<void> _onAuthenticateWithBiometricRequested(
    AuthenticateWithBiometricRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _authenticateWithBiometricUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (_) => const BiometricAuthenticated(),
    ));
  }

  Future<void> _onEnableBiometricAuthRequested(
    EnableBiometricAuthRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _enableBiometricAuthUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (_) => BiometricAuthEnabled(),
    ));
  }

  Future<void> _onDisableBiometricAuthRequested(
    DisableBiometricAuthRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _disableBiometricAuthUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (_) => BiometricAuthDisabled(),
    ));
  }

  Future<void> _onGetSecurityConfigurationRequested(
    GetSecurityConfigurationRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _getSecurityConfigurationUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (config) => SecurityConfigurationLoaded(config),
    ));
  }

  Future<void> _onUpdateSecurityConfigurationRequested(
    UpdateSecurityConfigurationRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _updateSecurityConfigurationUseCase(event.config);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (config) => SecurityConfigurationUpdated(config),
    ));
  }

  Future<void> _onPerformSecurityScanRequested(
    PerformSecurityScanRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _performSecurityScanUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (_) => SecurityScanCompleted(),
    ));
  }

  Future<void> _onGetSecurityScoreRequested(
    GetSecurityScoreRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _getSecurityScoreUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (score) => SecurityScoreLoaded(score),
    ));
  }

  Future<void> _onGetSecurityRecommendationsRequested(
    GetSecurityRecommendationsRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _getSecurityRecommendationsUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (recommendations) => SecurityRecommendationsLoaded(recommendations),
    ));
  }

  Future<void> _onUpdateSecurityScoreRequested(
    UpdateSecurityScoreRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _updateSecurityScoreUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (_) => SecurityScoreUpdated(),
    ));
  }

  Future<void> _onCheckSuspiciousActivityRequested(
    CheckSuspiciousActivityRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _checkSuspiciousActivityUseCase(event.activity);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (suspicious) => SuspiciousActivityChecked(event.activity, suspicious: suspicious),
    ));
  }

  Future<void> _onBlockSuspiciousIPRequested(
    BlockSuspiciousIPRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _blockSuspiciousIPUseCase(event.ipAddress);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (_) => SuspiciousIPBlocked(event.ipAddress),
    ));
  }

  Future<void> _onGetBlockedIPsRequested(
    GetBlockedIPsRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _getBlockedIPsUseCase();

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (ips) => BlockedIPsLoaded(ips),
    ));
  }

  Future<void> _onIsIPBlockedRequested(
    IsIPBlockedRequested event,
    Emitter<SecurityState> emit,
  ) async {
    emit(SecurityLoading());

    final result = await _isIPBlockedUseCase(event.ipAddress);

    emit(result.fold(
      (failure) => SecurityError(failure.toString()),
      (blocked) => IPBlockedStatusLoaded(event.ipAddress, blocked),
    ));
  }
}
