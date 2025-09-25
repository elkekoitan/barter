import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/admin.dart';

abstract class AdminRepository {
  // Admin User Management
  Future<Either<Failure, List<AdminUserEntity>>> getAdminUsers({
    AdminRole? role,
    bool? isActive,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, AdminUserEntity>> getAdminUserById(String adminId);

  Future<Either<Failure, AdminUserEntity>> createAdminUser(CreateAdminUserRequest request);

  Future<Either<Failure, AdminUserEntity>> updateAdminUser(String adminId, UpdateAdminUserRequest request);

  Future<Either<Failure, void>> deleteAdminUser(String adminId);

  Future<Either<Failure, void>> activateAdminUser(String adminId);

  Future<Either<Failure, void>> deactivateAdminUser(String adminId);

  Future<Either<Failure, void>> updateAdminPermissions(String adminId, AdminPermissions permissions);

  Future<Either<Failure, AdminUserEntity>> getCurrentAdminUser();

  // Statistics
  Future<Either<Failure, AdminStatsEntity>> getAdminStats({
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<Failure, SystemStats>> getSystemStats();

  Future<Either<Failure, UserStats>> getUserStats();

  Future<Either<Failure, ListingStats>> getListingStats();

  Future<Either<Failure, TransactionStats>> getTransactionStats();

  Future<Either<Failure, RevenueStats>> getRevenueStats();

  Future<Either<Failure, ModerationStats>> getModerationStats();

  Future<Either<Failure, PerformanceStats>> getPerformanceStats();

  // Moderation
  Future<Either<Failure, List<ModerationEntity>>> getModerationQueue({
    ModerationType? type,
    ModerationStatus? status,
    String? moderatorId,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, ModerationEntity>> getModerationById(String moderationId);

  Future<Either<Failure, ModerationEntity>> approveModeration(String moderationId, String notes);

  Future<Either<Failure, ModerationEntity>> rejectModeration(String moderationId, String reason, String notes);

  Future<Either<Failure, ModerationEntity>> escalateModeration(String moderationId, String notes);

  Future<Either<Failure, List<ModerationEntity>>> getUserModerationHistory(String userId);

  // User Management
  Future<Either<Failure, List<UserEntity>>> getAllUsers({
    String? searchQuery,
    bool? isVerified,
    bool? isBlocked,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, UserEntity>> getUserById(String userId);

  Future<Either<Failure, void>> blockUser(String userId, String reason);

  Future<Either<Failure, void>> unblockUser(String userId);

  Future<Either<Failure, void>> verifyUser(String userId);

  Future<Either<Failure, void>> suspendUser(String userId, String reason, DateTime? until);

  Future<Either<Failure, void>> deleteUser(String userId, String reason);

  Future<Either<Failure, void>> warnUser(String userId, String warning);

  Future<Either<Failure, List<UserAction>> getUserActions(String userId);

  // Content Management
  Future<Either<Failure, List<ListingEntity>>> getPendingListings({
    String? category,
    DateTime? createdAfter,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, ListingEntity>> approveListing(String listingId, String notes);

  Future<Either<Failure, ListingEntity>> rejectListing(String listingId, String reason, String notes);

  Future<Either<Failure, void>> deleteListing(String listingId, String reason);

  Future<Either<Failure, void>> featureListing(String listingId, int days);

  Future<Either<Failure, void>> boostListing(String listingId, int days);

  // Transaction Management
  Future<Either<Failure, List<TransactionEntity>>> getPendingTransactions({
    DateTime? createdAfter,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, TransactionEntity>> getTransactionById(String transactionId);

  Future<Either<Failure, void>> processTransactionRefund(String transactionId, String reason);

  Future<Either<Failure, void>> holdTransaction(String transactionId, String reason);

  Future<Either<Failure, void>> releaseTransaction(String transactionId);

  // System Management
  Future<Either<Failure, AdminSettingsEntity>> getAdminSettings();

  Future<Either<Failure, AdminSettingsEntity>> updateAdminSettings(UpdateAdminSettingsRequest request);

  Future<Either<Failure, void>> enableMaintenanceMode();

  Future<Either<Failure, void>> disableMaintenanceMode();

  Future<Either<Failure, void>> clearCache(String cacheType);

  Future<Either<Failure, void>> exportData(ExportDataRequest request);

  Future<Either<Failure, void>> sendSystemAnnouncement(SendAnnouncementRequest request);

  // Analytics
  Future<Either<Failure, List<AnalyticsData>> getAnalyticsData(AnalyticsRequest request);

  Future<Either<Failure, List<ReportData>> generateReport(ReportRequest request);

  // Activity Logging
  Future<Either<Failure, List<AdminActivity>> getAdminActivities({
    String? adminId,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 50,
  });

  Future<Either<Failure, void>> logAdminActivity(AdminActivity activity);

  // Real-time Updates
  Stream<Either<Failure, SystemStats>> subscribeToSystemStats();

  Stream<Either<Failure, List<ModerationEntity>>> subscribeToModerationQueue();

  Stream<Either<Failure, List<AdminActivity>>> subscribeToAdminActivities();

  Stream<Either<Failure, List<SystemAlert>>> subscribeToSystemAlerts();
}

// Request/Response Models
class CreateAdminUserRequest {
  final String email;
  final String displayName;
  final String password;
  final AdminRole role;
  final AdminPermissions permissions;
  final List<String>? managedCategories;

  const CreateAdminUserRequest({
    required this.email,
    required this.displayName,
    required this.password,
    required this.role,
    this.permissions = const AdminPermissions(),
    this.managedCategories,
  });
}

class UpdateAdminUserRequest {
  final String? displayName;
  final String? avatarUrl;
  final AdminPermissions? permissions;
  final List<String>? managedCategories;
  final bool? isActive;

  const UpdateAdminUserRequest({
    this.displayName,
    this.avatarUrl,
    this.permissions,
    this.managedCategories,
    this.isActive,
  });
}

class UpdateAdminSettingsRequest {
  final SystemSettings? systemSettings;
  final ModerationSettings? moderationSettings;
  final PaymentSettings? paymentSettings;
  final FeatureSettings? featureSettings;
  final NotificationSettings? notificationSettings;
  final SecuritySettings? securitySettings;

  const UpdateAdminSettingsRequest({
    this.systemSettings,
    this.moderationSettings,
    this.paymentSettings,
    this.featureSettings,
    this.notificationSettings,
    this.securitySettings,
  });
}

class ExportDataRequest {
  final String dataType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String format;
  final Map<String, dynamic>? filters;

  const ExportDataRequest({
    required this.dataType,
    this.startDate,
    this.endDate,
    this.format = 'csv',
    this.filters,
  });
}

class SendAnnouncementRequest {
  final String title;
  final String message;
  final AnnouncementType type;
  final AnnouncementPriority priority;
  final List<String>? targetUserIds;
  final bool sendEmail;
  final bool sendSMS;
  final DateTime? scheduledAt;

  const SendAnnouncementRequest({
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    this.targetUserIds,
    this.sendEmail = true,
    this.sendSMS = false,
    this.scheduledAt,
  });
}

class AnalyticsRequest {
  final AnalyticsType type;
  final DateTime startDate;
  final DateTime endDate;
  final String? category;
  final Map<String, dynamic>? filters;

  const AnalyticsRequest({
    required this.type,
    required this.startDate,
    required this.endDate,
    this.category,
    this.filters,
  });
}

class ReportRequest {
  final ReportType type;
  final DateTime startDate;
  final DateTime endDate;
  final String format;
  final Map<String, dynamic>? parameters;

  const ReportRequest({
    required this.type,
    required this.startDate,
    required this.endDate,
    this.format = 'pdf',
    this.parameters,
  });
}

enum AnnouncementType {
  system('system', 'Sistem'),
  maintenance('maintenance', 'Bakım'),
  feature('feature', 'Özellik'),
  security('security', 'Güvenlik');

  const AnnouncementType(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum AnnouncementPriority {
  low('low', 'Düşük'),
  normal('normal', 'Normal'),
  high('high', 'Yüksek'),
  urgent('urgent', 'Acil');

  const AnnouncementPriority(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum AnalyticsType {
  users('users', 'Kullanıcılar'),
  listings('listings', 'İlanlar'),
  transactions('transactions', 'İşlemler'),
  revenue('revenue', 'Gelir'),
  moderation('moderation', 'Moderatörlük'),
  performance('performance', 'Performans');

  const AnalyticsType(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum ReportType {
  daily('daily', 'Günlük'),
  weekly('weekly', 'Haftalık'),
  monthly('monthly', 'Aylık'),
  custom('custom', 'Özel');

  const ReportType(this.value, this.displayName);
  final String value;
  final String displayName;
}

class AnalyticsData extends Equatable {
  final String label;
  final double value;
  final String? category;
  final DateTime date;
  final Map<String, dynamic>? metadata;

  const AnalyticsData({
    required this.label,
    required this.value,
    this.category,
    required this.date,
    this.metadata,
  });

  @override
  List<Object?> get props => [label, value, category, date, metadata];
}

class ReportData extends Equatable {
  final String title;
  final String description;
  final List<AnalyticsData> data;
  final Map<String, dynamic> summary;
  final DateTime generatedAt;

  const ReportData({
    required this.title,
    required this.description,
    required this.data,
    required this.summary,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [title, description, data, summary, generatedAt];
}

class AdminActivity extends Equatable {
  final String id;
  final String adminId;
  final String adminName;
  final ActivityType type;
  final String description;
  final String? targetId;
  final String? targetType;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final String? ipAddress;
  final String? userAgent;

  const AdminActivity({
    required this.id,
    required this.adminId,
    required this.adminName,
    required this.type,
    required this.description,
    this.targetId,
    this.targetType,
    this.metadata,
    required this.createdAt,
    this.ipAddress,
    this.userAgent,
  });

  @override
  List<Object?> get props => [
        id,
        adminId,
        adminName,
        type,
        description,
        targetId,
        targetType,
        metadata,
        createdAt,
        ipAddress,
        userAgent,
      ];
}

enum ActivityType {
  login('login', 'Giriş'),
  logout('logout', 'Çıkış'),
  create('create', 'Oluşturma'),
  update('update', 'Güncelleme'),
  delete('delete', 'Silme'),
  approve('approve', 'Onaylama'),
  reject('reject', 'Reddetme'),
  block('block', 'Engelleme'),
  unblock('unblock', 'Engel Kaldırma'),
  export('export', 'Dışa Aktarma'),
  import('import', 'İçe Aktarma'),
  settings('settings', 'Ayarlar');

  const ActivityType(this.value, this.displayName);
  final String value;
  final String displayName;
}

class UserAction extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final ActionType type;
  final String reason;
  final String performedBy;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const UserAction({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    required this.reason,
    required this.performedBy,
    required this.createdAt,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [id, userId, userName, type, reason, performedBy, createdAt, expiresAt];
}

enum ActionType {
  warning('warning', 'Uyarı'),
  suspension('suspension', 'Askıya Alma'),
  ban('ban', 'Yasaklama'),
  verification('verification', 'Doğrulama');

  const ActionType(this.value, this.displayName);
  final String value;
  final String displayName;
}
