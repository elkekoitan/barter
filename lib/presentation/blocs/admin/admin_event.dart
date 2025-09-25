import 'package:equatable/equatable.dart';
import '../../../domain/repositories/admin_repository.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

// Admin User Management Events
class GetAdminUsersRequested extends AdminEvent {
  final AdminRole? role;
  final bool? isActive;
  final int page;
  final int limit;

  const GetAdminUsersRequested({
    this.role,
    this.isActive,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [role, isActive, page, limit];
}

class GetAdminUserByIdRequested extends AdminEvent {
  final String adminId;

  const GetAdminUserByIdRequested(this.adminId);

  @override
  List<Object?> get props => [adminId];
}

class CreateAdminUserRequested extends AdminEvent {
  final CreateAdminUserRequest request;

  const CreateAdminUserRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateAdminUserRequested extends AdminEvent {
  final String adminId;
  final UpdateAdminUserRequest request;

  const UpdateAdminUserRequested(this.adminId, this.request);

  @override
  List<Object?> get props => [adminId, request];
}

class DeleteAdminUserRequested extends AdminEvent {
  final String adminId;

  const DeleteAdminUserRequested(this.adminId);

  @override
  List<Object?> get props => [adminId];
}

class ActivateAdminUserRequested extends AdminEvent {
  final String adminId;

  const ActivateAdminUserRequested(this.adminId);

  @override
  List<Object?> get props => [adminId];
}

class DeactivateAdminUserRequested extends AdminEvent {
  final String adminId;

  const DeactivateAdminUserRequested(this.adminId);

  @override
  List<Object?> get props => [adminId];
}

class UpdateAdminPermissionsRequested extends AdminEvent {
  final String adminId;
  final AdminPermissions permissions;

  const UpdateAdminPermissionsRequested(this.adminId, this.permissions);

  @override
  List<Object?> get props => [adminId, permissions];
}

class GetCurrentAdminUserRequested extends AdminEvent {}

// Statistics Events
class GetAdminStatsRequested extends AdminEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const GetAdminStatsRequested({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class GetSystemStatsRequested extends AdminEvent {}

class GetUserStatsRequested extends AdminEvent {}

class GetListingStatsRequested extends AdminEvent {}

class GetTransactionStatsRequested extends AdminEvent {}

class GetRevenueStatsRequested extends AdminEvent {}

class GetModerationStatsRequested extends AdminEvent {}

class GetPerformanceStatsRequested extends AdminEvent {}

// Moderation Events
class GetModerationQueueRequested extends AdminEvent {
  final ModerationType? type;
  final ModerationStatus? status;
  final String? moderatorId;
  final int page;
  final int limit;

  const GetModerationQueueRequested({
    this.type,
    this.status,
    this.moderatorId,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [type, status, moderatorId, page, limit];
}

class GetModerationByIdRequested extends AdminEvent {
  final String moderationId;

  const GetModerationByIdRequested(this.moderationId);

  @override
  List<Object?> get props => [moderationId];
}

class ApproveModerationRequested extends AdminEvent {
  final String moderationId;
  final String notes;

  const ApproveModerationRequested(this.moderationId, this.notes);

  @override
  List<Object?> get props => [moderationId, notes];
}

class RejectModerationRequested extends AdminEvent {
  final String moderationId;
  final String reason;
  final String notes;

  const RejectModerationRequested(this.moderationId, this.reason, this.notes);

  @override
  List<Object?> get props => [moderationId, reason, notes];
}

class EscalateModerationRequested extends AdminEvent {
  final String moderationId;
  final String notes;

  const EscalateModerationRequested(this.moderationId, this.notes);

  @override
  List<Object?> get props => [moderationId, notes];
}

class GetUserModerationHistoryRequested extends AdminEvent {
  final String userId;

  const GetUserModerationHistoryRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

// User Management Events
class GetAllUsersRequested extends AdminEvent {
  final String? searchQuery;
  final bool? isVerified;
  final bool? isBlocked;
  final int page;
  final int limit;

  const GetAllUsersRequested({
    this.searchQuery,
    this.isVerified,
    this.isBlocked,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [searchQuery, isVerified, isBlocked, page, limit];
}

class GetUserByIdRequested extends AdminEvent {
  final String userId;

  const GetUserByIdRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class BlockUserRequested extends AdminEvent {
  final String userId;
  final String reason;

  const BlockUserRequested(this.userId, this.reason);

  @override
  List<Object?> get props => [userId, reason];
}

class UnblockUserRequested extends AdminEvent {
  final String userId;

  const UnblockUserRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class VerifyUserRequested extends AdminEvent {
  final String userId;

  const VerifyUserRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SuspendUserRequested extends AdminEvent {
  final String userId;
  final String reason;
  final DateTime? until;

  const SuspendUserRequested(this.userId, this.reason, {this.until});

  @override
  List<Object?> get props => [userId, reason, until];
}

class DeleteUserRequested extends AdminEvent {
  final String userId;
  final String reason;

  const DeleteUserRequested(this.userId, this.reason);

  @override
  List<Object?> get props => [userId, reason];
}

class WarnUserRequested extends AdminEvent {
  final String userId;
  final String warning;

  const WarnUserRequested(this.userId, this.warning);

  @override
  List<Object?> get props => [userId, warning];
}

class GetUserActionsRequested extends AdminEvent {
  final String userId;

  const GetUserActionsRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

// Content Management Events
class GetPendingListingsRequested extends AdminEvent {
  final String? category;
  final DateTime? createdAfter;
  final int page;
  final int limit;

  const GetPendingListingsRequested({
    this.category,
    this.createdAfter,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [category, createdAfter, page, limit];
}

class ApproveListingRequested extends AdminEvent {
  final String listingId;
  final String notes;

  const ApproveListingRequested(this.listingId, this.notes);

  @override
  List<Object?> get props => [listingId, notes];
}

class RejectListingRequested extends AdminEvent {
  final String listingId;
  final String reason;
  final String notes;

  const RejectListingRequested(this.listingId, this.reason, this.notes);

  @override
  List<Object?> get props => [listingId, reason, notes];
}

class DeleteListingRequested extends AdminEvent {
  final String listingId;
  final String reason;

  const DeleteListingRequested(this.listingId, this.reason);

  @override
  List<Object?> get props => [listingId, reason];
}

class FeatureListingRequested extends AdminEvent {
  final String listingId;
  final int days;

  const FeatureListingRequested(this.listingId, this.days);

  @override
  List<Object?> get props => [listingId, days];
}

class BoostListingRequested extends AdminEvent {
  final String listingId;
  final int days;

  const BoostListingRequested(this.listingId, this.days);

  @override
  List<Object?> get props => [listingId, days];
}

// Transaction Management Events
class GetPendingTransactionsRequested extends AdminEvent {
  final DateTime? createdAfter;
  final int page;
  final int limit;

  const GetPendingTransactionsRequested({
    this.createdAfter,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [createdAfter, page, limit];
}

class GetTransactionByIdRequested extends AdminEvent {
  final String transactionId;

  const GetTransactionByIdRequested(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

class ProcessTransactionRefundRequested extends AdminEvent {
  final String transactionId;
  final String reason;

  const ProcessTransactionRefundRequested(this.transactionId, this.reason);

  @override
  List<Object?> get props => [transactionId, reason];
}

class HoldTransactionRequested extends AdminEvent {
  final String transactionId;
  final String reason;

  const HoldTransactionRequested(this.transactionId, this.reason);

  @override
  List<Object?> get props => [transactionId, reason];
}

class ReleaseTransactionRequested extends AdminEvent {
  final String transactionId;

  const ReleaseTransactionRequested(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

// System Management Events
class GetAdminSettingsRequested extends AdminEvent {}

class UpdateAdminSettingsRequested extends AdminEvent {
  final UpdateAdminSettingsRequest request;

  const UpdateAdminSettingsRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class EnableMaintenanceModeRequested extends AdminEvent {}

class DisableMaintenanceModeRequested extends AdminEvent {}

class ClearCacheRequested extends AdminEvent {
  final String cacheType;

  const ClearCacheRequested(this.cacheType);

  @override
  List<Object?> get props => [cacheType];
}

class ExportDataRequested extends AdminEvent {
  final ExportDataRequest request;

  const ExportDataRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class SendSystemAnnouncementRequested extends AdminEvent {
  final SendAnnouncementRequest request;

  const SendSystemAnnouncementRequested(this.request);

  @override
  List<Object?> get props => [request];
}

// Analytics Events
class GetAnalyticsDataRequested extends AdminEvent {
  final AnalyticsRequest request;

  const GetAnalyticsDataRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class GenerateReportRequested extends AdminEvent {
  final ReportRequest request;

  const GenerateReportRequested(this.request);

  @override
  List<Object?> get props => [request];
}

// Activity Logging Events
class GetAdminActivitiesRequested extends AdminEvent {
  final String? adminId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int page;
  final int limit;

  const GetAdminActivitiesRequested({
    this.adminId,
    this.startDate,
    this.endDate,
    this.page = 1,
    this.limit = 50,
  });

  @override
  List<Object?> get props => [adminId, startDate, endDate, page, limit];
}

class LogAdminActivityRequested extends AdminEvent {
  final AdminActivity activity;

  const LogAdminActivityRequested(this.activity);

  @override
  List<Object?> get props => [activity];
}

// UI Events
class RefreshDashboardRequested extends AdminEvent {}

class LoadMoreDataRequested extends AdminEvent {
  final String dataType;

  const LoadMoreDataRequested(this.dataType);

  @override
  List<Object?> get props => [dataType];
}

class ChangeDashboardPeriodRequested extends AdminEvent {
  final DashboardPeriod period;

  const ChangeDashboardPeriodRequested(this.period);

  @override
  List<Object?> get props => [period];
}

class SwitchAdminTabRequested extends AdminEvent {
  final AdminTabType tabType;

  const SwitchAdminTabRequested(this.tabType);

  @override
  List<Object?> get props => [tabType];
}

// Real-time Events
class SystemStatsUpdated extends AdminEvent {
  final SystemStats stats;

  const SystemStatsUpdated(this.stats);

  @override
  List<Object?> get props => [stats];
}

class ModerationQueueUpdated extends AdminEvent {
  final List<ModerationEntity> moderations;

  const ModerationQueueUpdated(this.moderations);

  @override
  List<Object?> get props => [moderations];
}

class AdminActivityReceived extends AdminEvent {
  final AdminActivity activity;

  const AdminActivityReceived(this.activity);

  @override
  List<Object?> get props => [activity];
}

class SystemAlertReceived extends AdminEvent {
  final SystemAlert alert;

  const SystemAlertReceived(this.alert);

  @override
  List<Object?> get props => [alert];
}

enum DashboardPeriod {
  today('today', 'Bugün'),
  week('week', 'Bu Hafta'),
  month('month', 'Bu Ay'),
  quarter('quarter', 'Bu Çeyrek'),
  year('year', 'Bu Yıl'),
  custom('custom', 'Özel');

  const DashboardPeriod(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum AdminTabType {
  dashboard('dashboard', 'Dashboard'),
  users('users', 'Kullanıcılar'),
  listings('listings', 'İlanlar'),
  transactions('transactions', 'İşlemler'),
  moderation('moderation', 'Moderatörlük'),
  analytics('analytics', 'Analitik'),
  settings('settings', 'Ayarlar'),
  reports('reports', 'Raporlar');

  const AdminTabType(this.value, this.displayName);
  final String value;
  final String displayName;
}
