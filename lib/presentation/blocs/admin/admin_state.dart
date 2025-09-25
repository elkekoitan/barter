import 'package:equatable/equatable.dart';
import '../../../domain/entities/admin.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminUsersLoading extends AdminState {
  final bool isLoadMore;

  const AdminUsersLoading({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

class UsersLoading extends AdminState {
  final bool isLoadMore;

  const UsersLoading({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

class ListingsLoading extends AdminState {
  final bool isLoadMore;

  const ListingsLoading({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

class TransactionsLoading extends AdminState {
  final bool isLoadMore;

  const TransactionsLoading({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

class ModerationLoading extends AdminState {
  final bool isLoadMore;

  const ModerationLoading({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

class ActivitiesLoading extends AdminState {
  final bool isLoadMore;

  const ActivitiesLoading({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

// Success States
class AdminUsersLoaded extends AdminState {
  final List<AdminUserEntity> adminUsers;
  final bool hasMore;
  final int currentPage;
  final int totalCount;

  const AdminUsersLoaded({
    required this.adminUsers,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [adminUsers, hasMore, currentPage, totalCount];
}

class AdminUserLoaded extends AdminState {
  final AdminUserEntity adminUser;

  const AdminUserLoaded(this.adminUser);

  @override
  List<Object?> get props => [adminUser];
}

class AdminUserCreated extends AdminState {
  final AdminUserEntity adminUser;

  const AdminUserCreated(this.adminUser);

  @override
  List<Object?> get props => [adminUser];
}

class AdminUserUpdated extends AdminState {
  final AdminUserEntity adminUser;

  const AdminUserUpdated(this.adminUser);

  @override
  List<Object?> get props => [adminUser];
}

class AdminUserDeleted extends AdminState {
  final String adminId;

  const AdminUserDeleted(this.adminId);

  @override
  List<Object?> get props => [adminId];
}

class AdminUserActivated extends AdminState {
  final String adminId;

  const AdminUserActivated(this.adminId);

  @override
  List<Object?> get props => [adminId];
}

class AdminUserDeactivated extends AdminState {
  final String adminId;

  const AdminUserDeactivated(this.adminId);

  @override
  List<Object?> get props => [adminId];
}

class AdminPermissionsUpdated extends AdminState {
  final String adminId;
  final AdminPermissions permissions;

  const AdminPermissionsUpdated(this.adminId, this.permissions);

  @override
  List<Object?> get props => [adminId, permissions];
}

class CurrentAdminUserLoaded extends AdminState {
  final AdminUserEntity adminUser;

  const CurrentAdminUserLoaded(this.adminUser);

  @override
  List<Object?> get props => [adminUser];
}

class AdminStatsLoaded extends AdminState {
  final AdminStatsEntity stats;

  const AdminStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class SystemStatsLoaded extends AdminState {
  final SystemStats stats;

  const SystemStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class UserStatsLoaded extends AdminState {
  final UserStats stats;

  const UserStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class ListingStatsLoaded extends AdminState {
  final ListingStats stats;

  const ListingStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class TransactionStatsLoaded extends AdminState {
  final TransactionStats stats;

  const TransactionStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class RevenueStatsLoaded extends AdminState {
  final RevenueStats stats;

  const RevenueStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class ModerationStatsLoaded extends AdminState {
  final ModerationStats stats;

  const ModerationStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class PerformanceStatsLoaded extends AdminState {
  final PerformanceStats stats;

  const PerformanceStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class ModerationQueueLoaded extends AdminState {
  final List<ModerationEntity> moderations;
  final bool hasMore;
  final int currentPage;
  final int totalCount;

  const ModerationQueueLoaded({
    required this.moderations,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [moderations, hasMore, currentPage, totalCount];
}

class ModerationLoaded extends AdminState {
  final ModerationEntity moderation;

  const ModerationLoaded(this.moderation);

  @override
  List<Object?> get props => [moderation];
}

class ModerationApproved extends AdminState {
  final ModerationEntity moderation;

  const ModerationApproved(this.moderation);

  @override
  List<Object?> get props => [moderation];
}

class ModerationRejected extends AdminState {
  final ModerationEntity moderation;

  const ModerationRejected(this.moderation);

  @override
  List<Object?> get props => [moderation];
}

class ModerationEscalated extends AdminState {
  final ModerationEntity moderation;

  const ModerationEscalated(this.moderation);

  @override
  List<Object?> get props => [moderation];
}

class UserModerationHistoryLoaded extends AdminState {
  final List<ModerationEntity> history;

  const UserModerationHistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class AllUsersLoaded extends AdminState {
  final List<UserEntity> users;
  final bool hasMore;
  final int currentPage;
  final int totalCount;

  const AllUsersLoaded({
    required this.users,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [users, hasMore, currentPage, totalCount];
}

class UserLoaded extends AdminState {
  final UserEntity user;

  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserBlocked extends AdminState {
  final String userId;

  const UserBlocked(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UserUnblocked extends AdminState {
  final String userId;

  const UserUnblocked(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UserVerified extends AdminState {
  final String userId;

  const UserVerified(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UserSuspended extends AdminState {
  final String userId;

  const UserSuspended(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UserDeleted extends AdminState {
  final String userId;

  const UserDeleted(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UserWarned extends AdminState {
  final String userId;

  const UserWarned(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UserActionsLoaded extends AdminState {
  final List<UserAction> actions;

  const UserActionsLoaded(this.actions);

  @override
  List<Object?> get props => [actions];
}

class PendingListingsLoaded extends AdminState {
  final List<ListingEntity> listings;
  final bool hasMore;
  final int currentPage;
  final int totalCount;

  const PendingListingsLoaded({
    required this.listings,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [listings, hasMore, currentPage, totalCount];
}

class ListingApproved extends AdminState {
  final ListingEntity listing;

  const ListingApproved(this.listing);

  @override
  List<Object?> get props => [listing];
}

class ListingRejected extends AdminState {
  final ListingEntity listing;

  const ListingRejected(this.listing);

  @override
  List<Object?> get props => [listing];
}

class ListingDeleted extends AdminState {
  final String listingId;

  const ListingDeleted(this.listingId);

  @override
  List<Object?> get props => [listingId];
}

class ListingFeatured extends AdminState {
  final String listingId;

  const ListingFeatured(this.listingId);

  @override
  List<Object?> get props => [listingId];
}

class ListingBoosted extends AdminState {
  final String listingId;

  const ListingBoosted(this.listingId);

  @override
  List<Object?> get props => [listingId];
}

class PendingTransactionsLoaded extends AdminState {
  final List<TransactionEntity> transactions;
  final bool hasMore;
  final int currentPage;
  final int totalCount;

  const PendingTransactionsLoaded({
    required this.transactions,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [transactions, hasMore, currentPage, totalCount];
}

class TransactionLoaded extends AdminState {
  final TransactionEntity transaction;

  const TransactionLoaded(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionRefundProcessed extends AdminState {
  final String transactionId;

  const TransactionRefundProcessed(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

class TransactionHeld extends AdminState {
  final String transactionId;

  const TransactionHeld(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

class TransactionReleased extends AdminState {
  final String transactionId;

  const TransactionReleased(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

class AdminSettingsLoaded extends AdminState {
  final AdminSettingsEntity settings;

  const AdminSettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class AdminSettingsUpdated extends AdminState {
  final AdminSettingsEntity settings;

  const AdminSettingsUpdated(this.settings);

  @override
  List<Object?> get props => [settings];
}

class MaintenanceModeEnabled extends AdminState {}

class MaintenanceModeDisabled extends AdminState {}

class CacheCleared extends AdminState {
  final String cacheType;

  const CacheCleared(this.cacheType);

  @override
  List<Object?> get props => [cacheType];
}

class DataExported extends AdminState {
  final String exportId;

  const DataExported(this.exportId);

  @override
  List<Object?> get props => [exportId];
}

class SystemAnnouncementSent extends AdminState {
  final String announcementId;

  const SystemAnnouncementSent(this.announcementId);

  @override
  List<Object?> get props => [announcementId];
}

class AnalyticsDataLoaded extends AdminState {
  final List<AnalyticsData> data;

  const AnalyticsDataLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ReportGenerated extends AdminState {
  final ReportData report;

  const ReportGenerated(this.report);

  @override
  List<Object?> get props => [report];
}

class AdminActivitiesLoaded extends AdminState {
  final List<AdminActivity> activities;
  final bool hasMore;
  final int currentPage;
  final int totalCount;

  const AdminActivitiesLoaded({
    required this.activities,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [activities, hasMore, currentPage, totalCount];
}

class AdminActivityLogged extends AdminState {
  final AdminActivity activity;

  const AdminActivityLogged(this.activity);

  @override
  List<Object?> get props => [activity];
}

// Real-time States
class SystemStatsUpdatedInRealTime extends AdminState {
  final SystemStats stats;

  const SystemStatsUpdatedInRealTime(this.stats);

  @override
  List<Object?> get props => [stats];
}

class ModerationQueueUpdatedInRealTime extends AdminState {
  final List<ModerationEntity> moderations;

  const ModerationQueueUpdatedInRealTime(this.moderations);

  @override
  List<Object?> get props => [moderations];
}

class AdminActivityReceivedInRealTime extends AdminState {
  final AdminActivity activity;

  const AdminActivityReceivedInRealTime(this.activity);

  @override
  List<Object?> get props => [activity];
}

class SystemAlertReceivedInRealTime extends AdminState {
  final SystemAlert alert;

  const SystemAlertReceivedInRealTime(this.alert);

  @override
  List<Object?> get props => [alert];
}

// Error State
class AdminError extends AdminState {
  final String message;
  final String? code;
  final AdminErrorType? errorType;

  const AdminError(this.message, {this.code, this.errorType});

  @override
  List<Object?> get props => [message, code, errorType];
}

enum AdminErrorType {
  network('network', 'Ağ Hatası'),
  permission('permission', 'İzin Hatası'),
  validation('validation', 'Doğrulama Hatası'),
  notFound('not_found', 'Bulunamadı'),
  forbidden('forbidden', 'Yasak'),
  server('server', 'Sunucu Hatası'),
  unknown('unknown', 'Bilinmeyen Hata');

  const AdminErrorType(this.value, this.displayName);
  final String value;
  final String displayName;
}
