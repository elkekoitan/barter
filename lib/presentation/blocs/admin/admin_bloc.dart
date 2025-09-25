import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/admin_repository.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository _adminRepository;

  AdminBloc({required AdminRepository adminRepository})
      : _adminRepository = adminRepository,
        super(AdminInitial()) {
    on<GetAdminUsersRequested>(_onGetAdminUsersRequested);
    on<GetAdminUserByIdRequested>(_onGetAdminUserByIdRequested);
    on<CreateAdminUserRequested>(_onCreateAdminUserRequested);
    on<UpdateAdminUserRequested>(_onUpdateAdminUserRequested);
    on<DeleteAdminUserRequested>(_onDeleteAdminUserRequested);
    on<ActivateAdminUserRequested>(_onActivateAdminUserRequested);
    on<DeactivateAdminUserRequested>(_onDeactivateAdminUserRequested);
    on<UpdateAdminPermissionsRequested>(_onUpdateAdminPermissionsRequested);
    on<GetCurrentAdminUserRequested>(_onGetCurrentAdminUserRequested);
    on<GetAdminStatsRequested>(_onGetAdminStatsRequested);
    on<GetSystemStatsRequested>(_onGetSystemStatsRequested);
    on<GetUserStatsRequested>(_onGetUserStatsRequested);
    on<GetListingStatsRequested>(_onGetListingStatsRequested);
    on<GetTransactionStatsRequested>(_onGetTransactionStatsRequested);
    on<GetRevenueStatsRequested>(_onGetRevenueStatsRequested);
    on<GetModerationStatsRequested>(_onGetModerationStatsRequested);
    on<GetPerformanceStatsRequested>(_onGetPerformanceStatsRequested);
    on<GetModerationQueueRequested>(_onGetModerationQueueRequested);
    on<GetModerationByIdRequested>(_onGetModerationByIdRequested);
    on<ApproveModerationRequested>(_onApproveModerationRequested);
    on<RejectModerationRequested>(_onRejectModerationRequested);
    on<EscalateModerationRequested>(_onEscalateModerationRequested);
    on<GetUserModerationHistoryRequested>(_onGetUserModerationHistoryRequested);
    on<GetAllUsersRequested>(_onGetAllUsersRequested);
    on<GetUserByIdRequested>(_onGetUserByIdRequested);
    on<BlockUserRequested>(_onBlockUserRequested);
    on<UnblockUserRequested>(_onUnblockUserRequested);
    on<VerifyUserRequested>(_onVerifyUserRequested);
    on<SuspendUserRequested>(_onSuspendUserRequested);
    on<DeleteUserRequested>(_onDeleteUserRequested);
    on<WarnUserRequested>(_onWarnUserRequested);
    on<GetUserActionsRequested>(_onGetUserActionsRequested);
    on<GetPendingListingsRequested>(_onGetPendingListingsRequested);
    on<ApproveListingRequested>(_onApproveListingRequested);
    on<RejectListingRequested>(_onRejectListingRequested);
    on<DeleteListingRequested>(_onDeleteListingRequested);
    on<FeatureListingRequested>(_onFeatureListingRequested);
    on<BoostListingRequested>(_onBoostListingRequested);
    on<GetPendingTransactionsRequested>(_onGetPendingTransactionsRequested);
    on<GetTransactionByIdRequested>(_onGetTransactionByIdRequested);
    on<ProcessTransactionRefundRequested>(_onProcessTransactionRefundRequested);
    on<HoldTransactionRequested>(_onHoldTransactionRequested);
    on<ReleaseTransactionRequested>(_onReleaseTransactionRequested);
    on<GetAdminSettingsRequested>(_onGetAdminSettingsRequested);
    on<UpdateAdminSettingsRequested>(_onUpdateAdminSettingsRequested);
    on<EnableMaintenanceModeRequested>(_onEnableMaintenanceModeRequested);
    on<DisableMaintenanceModeRequested>(_onDisableMaintenanceModeRequested);
    on<ClearCacheRequested>(_onClearCacheRequested);
    on<ExportDataRequested>(_onExportDataRequested);
    on<SendSystemAnnouncementRequested>(_onSendSystemAnnouncementRequested);
    on<GetAnalyticsDataRequested>(_onGetAnalyticsDataRequested);
    on<GenerateReportRequested>(_onGenerateReportRequested);
    on<GetAdminActivitiesRequested>(_onGetAdminActivitiesRequested);
    on<LogAdminActivityRequested>(_onLogAdminActivityRequested);
    on<RefreshDashboardRequested>(_onRefreshDashboardRequested);
    on<LoadMoreDataRequested>(_onLoadMoreDataRequested);
    on<ChangeDashboardPeriodRequested>(_onChangeDashboardPeriodRequested);
    on<SwitchAdminTabRequested>(_onSwitchAdminTabRequested);
    on<SystemStatsUpdated>(_onSystemStatsUpdated);
    on<ModerationQueueUpdated>(_onModerationQueueUpdated);
    on<AdminActivityReceived>(_onAdminActivityReceived);
    on<SystemAlertReceived>(_onSystemAlertReceived);
  }

  Future<void> _onGetAdminUsersRequested(
    GetAdminUsersRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminUsersLoading());

    final result = await _adminRepository.getAdminUsers(
      role: event.role,
      isActive: event.isActive,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (adminUsers) => emit(AdminUsersLoaded(
        adminUsers: adminUsers,
        currentPage: event.page,
        hasMore: adminUsers.length == event.limit,
        totalCount: adminUsers.length,
      )),
    );
  }

  Future<void> _onGetAdminUserByIdRequested(
    GetAdminUserByIdRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await _adminRepository.getAdminUserById(event.adminId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (adminUser) => emit(AdminUserLoaded(adminUser)),
    );
  }

  Future<void> _onCreateAdminUserRequested(
    CreateAdminUserRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await _adminRepository.createAdminUser(event.request);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (adminUser) => emit(AdminUserCreated(adminUser)),
    );
  }

  Future<void> _onUpdateAdminUserRequested(
    UpdateAdminUserRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.updateAdminUser(event.adminId, event.request);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (adminUser) => emit(AdminUserUpdated(adminUser)),
    );
  }

  Future<void> _onDeleteAdminUserRequested(
    DeleteAdminUserRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.deleteAdminUser(event.adminId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(AdminUserDeleted(event.adminId)),
    );
  }

  Future<void> _onActivateAdminUserRequested(
    ActivateAdminUserRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.activateAdminUser(event.adminId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(AdminUserActivated(event.adminId)),
    );
  }

  Future<void> _onDeactivateAdminUserRequested(
    DeactivateAdminUserRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.deactivateAdminUser(event.adminId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(AdminUserDeactivated(event.adminId)),
    );
  }

  Future<void> _onUpdateAdminPermissionsRequested(
    UpdateAdminPermissionsRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.updateAdminPermissions(event.adminId, event.permissions);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(AdminPermissionsUpdated(event.adminId, event.permissions)),
    );
  }

  Future<void> _onGetCurrentAdminUserRequested(
    GetCurrentAdminUserRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.getCurrentAdminUser();

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (adminUser) => emit(CurrentAdminUserLoaded(adminUser)),
    );
  }

  Future<void> _onGetAdminStatsRequested(
    GetAdminStatsRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await _adminRepository.getAdminStats(
      startDate: event.startDate,
      endDate: event.endDate,
    );

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (stats) => emit(AdminStatsLoaded(stats)),
    );
  }

  Future<void> _onGetSystemStatsRequested(
    GetSystemStatsRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.getSystemStats();

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (stats) => emit(SystemStatsLoaded(stats)),
    );
  }

  Future<void> _onGetUserStatsRequested(
    GetUserStatsRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.getUserStats();

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (stats) => emit(UserStatsLoaded(stats)),
    );
  }

  Future<void> _onGetListingStatsRequested(
    GetListingStatsRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.getListingStats();

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (stats) => emit(ListingStatsLoaded(stats)),
    );
  }

  Future<void> _onGetTransactionStatsRequested(
    GetTransactionStatsRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.getTransactionStats();

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (stats) => emit(TransactionStatsLoaded(stats)),
    );
  }

  Future<void> _onGetRevenueStatsRequested(
    GetRevenueStatsRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.getRevenueStats();

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (stats) => emit(RevenueStatsLoaded(stats)),
    );
  }

  Future<void> _onGetModerationStatsRequested(
    GetModerationStatsRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.getModerationStats();

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (stats) => emit(ModerationStatsLoaded(stats)),
    );
  }

  Future<void> _onGetPerformanceStatsRequested(
    GetPerformanceStatsRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.getPerformanceStats();

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (stats) => emit(PerformanceStatsLoaded(stats)),
    );
  }

  Future<void> _onGetModerationQueueRequested(
    GetModerationQueueRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(ModerationLoading());

    final result = await _adminRepository.getModerationQueue(
      type: event.type,
      status: event.status,
      moderatorId: event.moderatorId,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (moderations) => emit(ModerationQueueLoaded(
        moderations: moderations,
        currentPage: event.page,
        hasMore: moderations.length == event.limit,
        totalCount: moderations.length,
      )),
    );
  }

  Future<void> _onGetModerationByIdRequested(
    GetModerationByIdRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await _adminRepository.getModerationById(event.moderationId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (moderation) => emit(ModerationLoaded(moderation)),
    );
  }

  Future<void> _onApproveModerationRequested(
    ApproveModerationRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.approveModeration(event.moderationId, event.notes);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (moderation) => emit(ModerationApproved(moderation)),
    );
  }

  Future<void> _onRejectModerationRequested(
    RejectModerationRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.rejectModeration(event.moderationId, event.reason, event.notes);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (moderation) => emit(ModerationRejected(moderation)),
    );
  }

  Future<void> _onEscalateModerationRequested(
    EscalateModerationRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.escalateModeration(event.moderationId, event.notes);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (moderation) => emit(ModerationEscalated(moderation)),
    );
  }

  Future<void> _onGetUserModerationHistoryRequested(
    GetUserModerationHistoryRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.getUserModerationHistory(event.userId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (history) => emit(UserModerationHistoryLoaded(history)),
    );
  }

  Future<void> _onGetAllUsersRequested(
    GetAllUsersRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(UsersLoading());

    final result = await _adminRepository.getAllUsers(
      searchQuery: event.searchQuery,
      isVerified: event.isVerified,
      isBlocked: event.isBlocked,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (users) => emit(AllUsersLoaded(
        users: users,
        currentPage: event.page,
        hasMore: users.length == event.limit,
        totalCount: users.length,
      )),
    );
  }

  Future<void> _onGetUserByIdRequested(
    GetUserByIdRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await _adminRepository.getUserById(event.userId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> _onBlockUserRequested(
    BlockUserRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.blockUser(event.userId, event.reason);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(UserBlocked(event.userId)),
    );
  }

  Future<void> _onUnblockUserRequested(
    UnblockUserRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.unblockUser(event.userId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(UserUnblocked(event.userId)),
    );
  }

  Future<void> _onVerifyUserRequested(
    VerifyUserRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.verifyUser(event.userId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(UserVerified(event.userId)),
    );
  }

  Future<void> _onSuspendUserRequested(
    SuspendUserRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.suspendUser(event.userId, event.reason, event.until);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(UserSuspended(event.userId)),
    );
  }

  Future<void> _onDeleteUserRequested(
    DeleteUserRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.deleteUser(event.userId, event.reason);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(UserDeleted(event.userId)),
    );
  }

  Future<void> _onWarnUserRequested(
    WarnUserRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.warnUser(event.userId, event.warning);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(UserWarned(event.userId)),
    );
  }

  Future<void> _onGetUserActionsRequested(
    GetUserActionsRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.getUserActions(event.userId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (actions) => emit(UserActionsLoaded(actions)),
    );
  }

  Future<void> _onGetPendingListingsRequested(
    GetPendingListingsRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(ListingsLoading());

    final result = await _adminRepository.getPendingListings(
      category: event.category,
      createdAfter: event.createdAfter,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (listings) => emit(PendingListingsLoaded(
        listings: listings,
        currentPage: event.page,
        hasMore: listings.length == event.limit,
        totalCount: listings.length,
      )),
    );
  }

  Future<void> _onApproveListingRequested(
    ApproveListingRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.approveListing(event.listingId, event.notes);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (listing) => emit(ListingApproved(listing)),
    );
  }

  Future<void> _onRejectListingRequested(
    RejectListingRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.rejectListing(event.listingId, event.reason, event.notes);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (listing) => emit(ListingRejected(listing)),
    );
  }

  Future<void> _onDeleteListingRequested(
    DeleteListingRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.deleteListing(event.listingId, event.reason);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(ListingDeleted(event.listingId)),
    );
  }

  Future<void> _onFeatureListingRequested(
    FeatureListingRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.featureListing(event.listingId, event.days);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(ListingFeatured(event.listingId)),
    );
  }

  Future<void> _onBoostListingRequested(
    BoostListingRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.boostListing(event.listingId, event.days);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(ListingBoosted(event.listingId)),
    );
  }

  Future<void> _onGetPendingTransactionsRequested(
    GetPendingTransactionsRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(TransactionsLoading());

    final result = await _adminRepository.getPendingTransactions(
      createdAfter: event.createdAfter,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (transactions) => emit(PendingTransactionsLoaded(
        transactions: transactions,
        currentPage: event.page,
        hasMore: transactions.length == event.limit,
        totalCount: transactions.length,
      )),
    );
  }

  Future<void> _onGetTransactionByIdRequested(
    GetTransactionByIdRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await _adminRepository.getTransactionById(event.transactionId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (transaction) => emit(TransactionLoaded(transaction)),
    );
  }

  Future<void> _onProcessTransactionRefundRequested(
    ProcessTransactionRefundRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.processTransactionRefund(event.transactionId, event.reason);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(TransactionRefundProcessed(event.transactionId)),
    );
  }

  Future<void> _onHoldTransactionRequested(
    HoldTransactionRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.holdTransaction(event.transactionId, event.reason);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(TransactionHeld(event.transactionId)),
    );
  }

  Future<void> _onReleaseTransactionRequested(
    ReleaseTransactionRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.releaseTransaction(event.transactionId);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(TransactionReleased(event.transactionId)),
    );
  }

  Future<void> _onGetAdminSettingsRequested(
    GetAdminSettingsRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await _adminRepository.getAdminSettings();

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (settings) => emit(AdminSettingsLoaded(settings)),
    );
  }

  Future<void> _onUpdateAdminSettingsRequested(
    UpdateAdminSettingsRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());

    final result = await _adminRepository.updateAdminSettings(event.request);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (settings) => emit(AdminSettingsUpdated(settings)),
    );
  }

  Future<void> _onEnableMaintenanceModeRequested(
    EnableMaintenanceModeRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.enableMaintenanceMode();

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(MaintenanceModeEnabled()),
    );
  }

  Future<void> _onDisableMaintenanceModeRequested(
    DisableMaintenanceModeRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.disableMaintenanceMode();

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(MaintenanceModeDisabled()),
    );
  }

  Future<void> _onClearCacheRequested(
    ClearCacheRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.clearCache(event.cacheType);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(CacheCleared(event.cacheType)),
    );
  }

  Future<void> _onExportDataRequested(
    ExportDataRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.exportData(event.request);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(DataExported('export_${DateTime.now().millisecondsSinceEpoch}')),
    );
  }

  Future<void> _onSendSystemAnnouncementRequested(
    SendSystemAnnouncementRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.sendSystemAnnouncement(event.request);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(SystemAnnouncementSent('announcement_${DateTime.now().millisecondsSinceEpoch}')),
    );
  }

  Future<void> _onGetAnalyticsDataRequested(
    GetAnalyticsDataRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.getAnalyticsData(event.request);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (data) => emit(AnalyticsDataLoaded(data)),
    );
  }

  Future<void> _onGenerateReportRequested(
    GenerateReportRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.generateReport(event.request);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (report) => emit(ReportGenerated(report)),
    );
  }

  Future<void> _onGetAdminActivitiesRequested(
    GetAdminActivitiesRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(ActivitiesLoading());

    final result = await _adminRepository.getAdminActivities(
      adminId: event.adminId,
      startDate: event.startDate,
      endDate: event.endDate,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (activities) => emit(AdminActivitiesLoaded(
        activities: activities,
        currentPage: event.page,
        hasMore: activities.length == event.limit,
        totalCount: activities.length,
      )),
    );
  }

  Future<void> _onLogAdminActivityRequested(
    LogAdminActivityRequested event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _adminRepository.logAdminActivity(event.activity);

    result.fold(
      (failure) => emit(AdminError(failure.message)),
      (_) => emit(AdminActivityLogged(event.activity)),
    );
  }

  Future<void> _onRefreshDashboardRequested(
    RefreshDashboardRequested event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminInitial());
  }

  Future<void> _onLoadMoreDataRequested(
    LoadMoreDataRequested event,
    Emitter<AdminState> emit,
  ) async {
    // TODO: Implement load more logic based on data type
    debugPrint('Load more data for: ${event.dataType}');
  }

  Future<void> _onChangeDashboardPeriodRequested(
    ChangeDashboardPeriodRequested event,
    Emitter<AdminState> emit,
  ) async {
    // TODO: Refresh data for new period
    debugPrint('Changed dashboard period to: ${event.period.value}');
  }

  Future<void> _onSwitchAdminTabRequested(
    SwitchAdminTabRequested event,
    Emitter<AdminState> emit,
  ) async {
    // TODO: Switch to different admin tab
    debugPrint('Switched to admin tab: ${event.tabType.value}');
  }

  Future<void> _onSystemStatsUpdated(
    SystemStatsUpdated event,
    Emitter<AdminState> emit,
  ) async {
    emit(SystemStatsUpdatedInRealTime(event.stats));
  }

  Future<void> _onModerationQueueUpdated(
    ModerationQueueUpdated event,
    Emitter<AdminState> emit,
  ) async {
    emit(ModerationQueueUpdatedInRealTime(event.moderations));
  }

  Future<void> _onAdminActivityReceived(
    AdminActivityReceived event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminActivityReceivedInRealTime(event.activity));
  }

  Future<void> _onSystemAlertReceived(
    SystemAlertReceived event,
    Emitter<AdminState> emit,
  ) async {
    emit(SystemAlertReceivedInRealTime(event.alert));
  }

  // Helper methods
  void logActivity(ActivityType type, String description, {String? targetId, String? targetType}) {
    // TODO: Get current admin user ID
    const adminId = 'current_admin_id';
    const adminName = 'Admin User';

    final activity = AdminActivity(
      id: 'activity_${DateTime.now().millisecondsSinceEpoch}',
      adminId: adminId,
      adminName: adminName,
      type: type,
      description: description,
      targetId: targetId,
      targetType: targetType,
      createdAt: DateTime.now(),
    );

    add(LogAdminActivityRequested(activity));
  }

  void refreshAllStats() {
    add(const GetAdminStatsRequested());
    add(const GetSystemStatsRequested());
    add(const GetUserStatsRequested());
    add(const GetListingStatsRequested());
    add(const GetTransactionStatsRequested());
    add(const GetRevenueStatsRequested());
    add(const GetModerationStatsRequested());
    add(const GetPerformanceStatsRequested());
  }

  void navigateToTab(AdminTabType tabType) {
    add(SwitchAdminTabRequested(tabType));
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
