import 'package:equatable/equatable.dart';

class AdminUserEntity extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final AdminRole role;
  final AdminPermissions permissions;
  final bool isActive;
  final bool isSuperAdmin;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final DateTime? lastActivityAt;
  final Map<String, dynamic>? metadata;
  final List<String>? managedCategories;
  final int totalActions;
  final int successfulActions;
  final double performanceScore;

  const AdminUserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.role = AdminRole.moderator,
    this.permissions = const AdminPermissions(),
    this.isActive = true,
    this.isSuperAdmin = false,
    required this.createdAt,
    required this.lastLoginAt,
    this.lastActivityAt,
    this.metadata,
    this.managedCategories,
    this.totalActions = 0,
    this.successfulActions = 0,
    this.performanceScore = 0.0,
  });

  bool get isOnline => lastActivityAt != null &&
    DateTime.now().difference(lastActivityAt!).inMinutes < 5;

  bool get canModerateListings => permissions.canModerateListings || isSuperAdmin;

  bool get canModerateUsers => permissions.canModerateUsers || isSuperAdmin;

  bool get canManagePayments => permissions.canManagePayments || isSuperAdmin;

  bool get canViewAnalytics => permissions.canViewAnalytics || isSuperAdmin;

  bool get canManageSettings => permissions.canManageSettings || isSuperAdmin;

  bool get canManageAdmins => isSuperAdmin;

  String get roleDisplayName {
    switch (role) {
      case AdminRole.superAdmin:
        return 'Süper Admin';
      case AdminRole.admin:
        return 'Admin';
      case AdminRole.moderator:
        return 'Moderatör';
      case AdminRole.support:
        return 'Destek';
    }
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        avatarUrl,
        role,
        permissions,
        isActive,
        isSuperAdmin,
        createdAt,
        lastLoginAt,
        lastActivityAt,
        metadata,
        managedCategories,
        totalActions,
        successfulActions,
        performanceScore,
      ];
}

class AdminPermissions extends Equatable {
  final bool canModerateListings;
  final bool canModerateUsers;
  final bool canManagePayments;
  final bool canViewAnalytics;
  final bool canManageSettings;
  final bool canManageAdmins;
  final bool canDeleteContent;
  final bool canBanUsers;
  final bool canUnbanUsers;
  final bool canVerifyUsers;
  final bool canProcessRefunds;
  final bool canManagePromotions;
  final bool canSendAnnouncements;
  final bool canExportData;
  final bool canImportData;
  final bool canAccessUserData;

  const AdminPermissions({
    this.canModerateListings = false,
    this.canModerateUsers = false,
    this.canManagePayments = false,
    this.canViewAnalytics = false,
    this.canManageSettings = false,
    this.canManageAdmins = false,
    this.canDeleteContent = false,
    this.canBanUsers = false,
    this.canUnbanUsers = false,
    this.canVerifyUsers = false,
    this.canProcessRefunds = false,
    this.canManagePromotions = false,
    this.canSendAnnouncements = false,
    this.canExportData = false,
    this.canImportData = false,
    this.canAccessUserData = false,
  });

  AdminPermissions copyWith({
    bool? canModerateListings,
    bool? canModerateUsers,
    bool? canManagePayments,
    bool? canViewAnalytics,
    bool? canManageSettings,
    bool? canManageAdmins,
    bool? canDeleteContent,
    bool? canBanUsers,
    bool? canUnbanUsers,
    bool? canVerifyUsers,
    bool? canProcessRefunds,
    bool? canManagePromotions,
    bool? canSendAnnouncements,
    bool? canExportData,
    bool? canImportData,
    bool? canAccessUserData,
  }) {
    return AdminPermissions(
      canModerateListings: canModerateListings ?? this.canModerateListings,
      canModerateUsers: canModerateUsers ?? this.canModerateUsers,
      canManagePayments: canManagePayments ?? this.canManagePayments,
      canViewAnalytics: canViewAnalytics ?? this.canViewAnalytics,
      canManageSettings: canManageSettings ?? this.canManageSettings,
      canManageAdmins: canManageAdmins ?? this.canManageAdmins,
      canDeleteContent: canDeleteContent ?? this.canDeleteContent,
      canBanUsers: canBanUsers ?? this.canBanUsers,
      canUnbanUsers: canUnbanUsers ?? this.canUnbanUsers,
      canVerifyUsers: canVerifyUsers ?? this.canVerifyUsers,
      canProcessRefunds: canProcessRefunds ?? this.canProcessRefunds,
      canManagePromotions: canManagePromotions ?? this.canManagePromotions,
      canSendAnnouncements: canSendAnnouncements ?? this.canSendAnnouncements,
      canExportData: canExportData ?? this.canExportData,
      canImportData: canImportData ?? this.canImportData,
      canAccessUserData: canAccessUserData ?? this.canAccessUserData,
    );
  }

  @override
  List<Object?> get props => [
        canModerateListings,
        canModerateUsers,
        canManagePayments,
        canViewAnalytics,
        canManageSettings,
        canManageAdmins,
        canDeleteContent,
        canBanUsers,
        canUnbanUsers,
        canVerifyUsers,
        canProcessRefunds,
        canManagePromotions,
        canSendAnnouncements,
        canExportData,
        canImportData,
        canAccessUserData,
      ];
}

enum AdminRole {
  superAdmin('super_admin', 'Süper Admin'),
  admin('admin', 'Admin'),
  moderator('moderator', 'Moderatör'),
  support('support', 'Destek');

  const AdminRole(this.value, this.displayName);
  final String value;
  final String displayName;

  static AdminRole fromString(String value) {
    return AdminRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => AdminRole.moderator,
    );
  }
}

class AdminStatsEntity extends Equatable {
  final SystemStats systemStats;
  final UserStats userStats;
  final ListingStats listingStats;
  final TransactionStats transactionStats;
  final RevenueStats revenueStats;
  final ModerationStats moderationStats;
  final PerformanceStats performanceStats;
  final DateTime generatedAt;

  const AdminStatsEntity({
    required this.systemStats,
    required this.userStats,
    required this.listingStats,
    required this.transactionStats,
    required this.revenueStats,
    required this.moderationStats,
    required this.performanceStats,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [
        systemStats,
        userStats,
        listingStats,
        transactionStats,
        revenueStats,
        moderationStats,
        performanceStats,
        generatedAt,
      ];
}

class SystemStats extends Equatable {
  final int totalUsers;
  final int activeUsers;
  final int totalListings;
  final int activeListings;
  final int totalTransactions;
  final int pendingTransactions;
  final double systemUptime;
  final int serverResponseTime;
  final int databaseConnections;
  final int activeConnections;
  final DateTime lastUpdated;

  const SystemStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.totalListings,
    required this.activeListings,
    required this.totalTransactions,
    required this.pendingTransactions,
    this.systemUptime = 99.9,
    this.serverResponseTime = 150,
    this.databaseConnections = 100,
    this.activeConnections = 25,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        totalUsers,
        activeUsers,
        totalListings,
        activeListings,
        totalTransactions,
        pendingTransactions,
        systemUptime,
        serverResponseTime,
        databaseConnections,
        activeConnections,
        lastUpdated,
      ];
}

class UserStats extends Equatable {
  final int newUsersToday;
  final int newUsersThisWeek;
  final int newUsersThisMonth;
  final int verifiedUsers;
  final int blockedUsers;
  final int premiumUsers;
  final double averageSessionTime;
  final Map<String, int> usersByCountry;
  final Map<String, int> usersByCity;
  final List<UserActivity> userActivity;

  const UserStats({
    required this.newUsersToday,
    required this.newUsersThisWeek,
    required this.newUsersThisMonth,
    required this.verifiedUsers,
    required this.blockedUsers,
    required this.premiumUsers,
    this.averageSessionTime = 0.0,
    this.usersByCountry = const {},
    this.usersByCity = const {},
    this.userActivity = const [],
  });

  @override
  List<Object?> get props => [
        newUsersToday,
        newUsersThisWeek,
        newUsersThisMonth,
        verifiedUsers,
        blockedUsers,
        premiumUsers,
        averageSessionTime,
        usersByCountry,
        usersByCity,
        userActivity,
      ];
}

class ListingStats extends Equatable {
  final int totalListings;
  final int activeListings;
  final int pendingListings;
  final int rejectedListings;
  final int featuredListings;
  final int boostedListings;
  final Map<String, int> listingsByCategory;
  final Map<String, int> listingsByCondition;
  final Map<String, int> listingsByPriceRange;
  final List<ListingActivity> listingActivity;

  const ListingStats({
    required this.totalListings,
    required this.activeListings,
    required this.pendingListings,
    required this.rejectedListings,
    required this.featuredListings,
    required this.boostedListings,
    this.listingsByCategory = const {},
    this.listingsByCondition = const {},
    this.listingsByPriceRange = const {},
    this.listingActivity = const [],
  });

  @override
  List<Object?> get props => [
        totalListings,
        activeListings,
        pendingListings,
        rejectedListings,
        featuredListings,
        boostedListings,
        listingsByCategory,
        listingsByCondition,
        listingsByPriceRange,
        listingActivity,
      ];
}

class TransactionStats extends Equatable {
  final int totalTransactions;
  final int completedTransactions;
  final int pendingTransactions;
  final int cancelledTransactions;
  final int disputedTransactions;
  final double averageTransactionValue;
  final Map<String, int> transactionsByType;
  final Map<String, int> transactionsByStatus;
  final List<TransactionActivity> transactionActivity;

  const TransactionStats({
    required this.totalTransactions,
    required this.completedTransactions,
    required this.pendingTransactions,
    required this.cancelledTransactions,
    required this.disputedTransactions,
    this.averageTransactionValue = 0.0,
    this.transactionsByType = const {},
    this.transactionsByStatus = const {},
    this.transactionActivity = const [],
  });

  @override
  List<Object?> get props => [
        totalTransactions,
        completedTransactions,
        pendingTransactions,
        cancelledTransactions,
        disputedTransactions,
        averageTransactionValue,
        transactionsByType,
        transactionsByStatus,
        transactionActivity,
      ];
}

class RevenueStats extends Equatable {
  final double totalRevenue;
  final double monthlyRevenue;
  final double commissionRevenue;
  final double feeRevenue;
  final double premiumRevenue;
  final Map<String, double> revenueBySource;
  final List<RevenueActivity> revenueActivity;
  final double averageCommissionRate;
  final int totalPaidCommissions;

  const RevenueStats({
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.commissionRevenue,
    required this.feeRevenue,
    required this.premiumRevenue,
    this.revenueBySource = const {},
    this.revenueActivity = const [],
    this.averageCommissionRate = 0.0,
    this.totalPaidCommissions = 0,
  });

  @override
  List<Object?> get props => [
        totalRevenue,
        monthlyRevenue,
        commissionRevenue,
        feeRevenue,
        premiumRevenue,
        revenueBySource,
        revenueActivity,
        averageCommissionRate,
        totalPaidCommissions,
      ];
}

class ModerationStats extends Equatable {
  final int pendingModerations;
  final int approvedContent;
  final int rejectedContent;
  final int blockedUsers;
  final int unblockedUsers;
  final Map<String, int> moderationByType;
  final Map<String, int> moderationByAction;
  final List<ModerationActivity> moderationActivity;
  final double averageModerationTime;

  const ModerationStats({
    required this.pendingModerations,
    required this.approvedContent,
    required this.rejectedContent,
    required this.blockedUsers,
    required this.unblockedUsers,
    this.moderationByType = const {},
    this.moderationByAction = const {},
    this.moderationActivity = const [],
    this.averageModerationTime = 0.0,
  });

  @override
  List<Object?> get props => [
        pendingModerations,
        approvedContent,
        rejectedContent,
        blockedUsers,
        unblockedUsers,
        moderationByType,
        moderationByAction,
        moderationActivity,
        averageModerationTime,
      ];
}

class PerformanceStats extends Equatable {
  final double systemLoad;
  final double memoryUsage;
  final double cpuUsage;
  final int activeConnections;
  final int errorRate;
  final double responseTime;
  final Map<String, double> apiPerformance;
  final List<SystemAlert> systemAlerts;

  const PerformanceStats({
    this.systemLoad = 0.0,
    this.memoryUsage = 0.0,
    this.cpuUsage = 0.0,
    this.activeConnections = 0,
    this.errorRate = 0,
    this.responseTime = 0.0,
    this.apiPerformance = const {},
    this.systemAlerts = const [],
  });

  @override
  List<Object?> get props => [
        systemLoad,
        memoryUsage,
        cpuUsage,
        activeConnections,
        errorRate,
        responseTime,
        apiPerformance,
        systemAlerts,
      ];
}

class UserActivity extends Equatable {
  final DateTime date;
  final int newUsers;
  final int activeUsers;
  final int sessions;

  const UserActivity({
    required this.date,
    required this.newUsers,
    required this.activeUsers,
    required this.sessions,
  });

  @override
  List<Object?> get props => [date, newUsers, activeUsers, sessions];
}

class ListingActivity extends Equatable {
  final DateTime date;
  final int newListings;
  final int views;
  final int favorites;

  const ListingActivity({
    required this.date,
    required this.newListings,
    required this.views,
    required this.favorites,
  });

  @override
  List<Object?> get props => [date, newListings, views, favorites];
}

class TransactionActivity extends Equatable {
  final DateTime date;
  final int newTransactions;
  final int completedTransactions;
  final double totalValue;

  const TransactionActivity({
    required this.date,
    required this.newTransactions,
    required this.completedTransactions,
    required this.totalValue,
  });

  @override
  List<Object?> get props => [date, newTransactions, completedTransactions, totalValue];
}

class RevenueActivity extends Equatable {
  final DateTime date;
  final double revenue;
  final String source;

  const RevenueActivity({
    required this.date,
    required this.revenue,
    required this.source,
  });

  @override
  List<Object?> get props => [date, revenue, source];
}

class ModerationActivity extends Equatable {
  final DateTime date;
  final int pendingReviews;
  final int completedReviews;
  final String moderatorName;

  const ModerationActivity({
    required this.date,
    required this.pendingReviews,
    required this.completedReviews,
    required this.moderatorName,
  });

  @override
  List<Object?> get props => [date, pendingReviews, completedReviews, moderatorName];
}

class SystemAlert extends Equatable {
  final String id;
  final String title;
  final String message;
  final AlertSeverity severity;
  final AlertType type;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  const SystemAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.type,
    this.isActive = true,
    required this.createdAt,
    this.resolvedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        message,
        severity,
        type,
        isActive,
        createdAt,
        resolvedAt,
      ];
}

enum AlertSeverity {
  low('low', 'Düşük'),
  medium('medium', 'Orta'),
  high('high', 'Yüksek'),
  critical('critical', 'Kritik');

  const AlertSeverity(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum AlertType {
  system('system', 'Sistem'),
  security('security', 'Güvenlik'),
  performance('performance', 'Performans'),
  maintenance('maintenance', 'Bakım');

  const AlertType(this.value, this.displayName);
  final String value;
  final String displayName;
}

class ModerationEntity extends Equatable {
  final String id;
  final String contentId;
  final ModerationType type;
  final String moderatorId;
  final String moderatorName;
  final ModerationStatus status;
  final String reason;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const ModerationEntity({
    required this.id,
    required this.contentId,
    required this.type,
    required this.moderatorId,
    required this.moderatorName,
    this.status = ModerationStatus.pending,
    required this.reason,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        contentId,
        type,
        moderatorId,
        moderatorName,
        status,
        reason,
        notes,
        createdAt,
        updatedAt,
        metadata,
      ];
}

enum ModerationType {
  listing('listing', 'İlan'),
  message('message', 'Mesaj'),
  review('review', 'Değerlendirme'),
  user('user', 'Kullanıcı'),
  transaction('transaction', 'İşlem');

  const ModerationType(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum ModerationStatus {
  pending('pending', 'Bekliyor'),
  approved('approved', 'Onaylandı'),
  rejected('rejected', 'Reddedildi'),
  escalated('escalated', 'Yükseltildi');

  const ModerationStatus(this.value, this.displayName);
  final String value;
  final String displayName;
}

class AdminSettingsEntity extends Equatable {
  final String id;
  final SystemSettings systemSettings;
  final ModerationSettings moderationSettings;
  final PaymentSettings paymentSettings;
  final FeatureSettings featureSettings;
  final NotificationSettings notificationSettings;
  final SecuritySettings securitySettings;
  final DateTime updatedAt;
  final String updatedBy;

  const AdminSettingsEntity({
    required this.id,
    required this.systemSettings,
    required this.moderationSettings,
    required this.paymentSettings,
    required this.featureSettings,
    required this.notificationSettings,
    required this.securitySettings,
    required this.updatedAt,
    required this.updatedBy,
  });

  @override
  List<Object?> get props => [
        id,
        systemSettings,
        moderationSettings,
        paymentSettings,
        featureSettings,
        notificationSettings,
        securitySettings,
        updatedAt,
        updatedBy,
      ];
}

class SystemSettings extends Equatable {
  final String systemName;
  final String systemDescription;
  final bool maintenanceMode;
  final int maxUsersPerDay;
  final int maxListingsPerUser;
  final int maxImagesPerListing;
  final int sessionTimeoutMinutes;
  final bool allowRegistration;
  final List<String> supportedCountries;
  final Map<String, dynamic> customConfig;

  const SystemSettings({
    this.systemName = 'Boğaziçi Barter',
    this.systemDescription = 'Türkiye\'nin İlk Akıllı Takas Platformu',
    this.maintenanceMode = false,
    this.maxUsersPerDay = 1000,
    this.maxListingsPerUser = 50,
    this.maxImagesPerListing = 10,
    this.sessionTimeoutMinutes = 30,
    this.allowRegistration = true,
    this.supportedCountries = const ['TR'],
    this.customConfig = const {},
  });

  @override
  List<Object?> get props => [
        systemName,
        systemDescription,
        maintenanceMode,
        maxUsersPerDay,
        maxListingsPerUser,
        maxImagesPerListing,
        sessionTimeoutMinutes,
        allowRegistration,
        supportedCountries,
        customConfig,
      ];
}

class ModerationSettings extends Equatable {
  final bool autoApproveListings;
  final bool requireImageModeration;
  final bool enableSpamDetection;
  final int minModeratorLevel;
  final int maxItemsPerModeration;
  final bool allowSelfModeration;
  final Map<String, int> categoryModerationLevels;

  const ModerationSettings({
    this.autoApproveListings = false,
    this.requireImageModeration = true,
    this.enableSpamDetection = true,
    this.minModeratorLevel = 2,
    this.maxItemsPerModeration = 20,
    this.allowSelfModeration = false,
    this.categoryModerationLevels = const {},
  });

  @override
  List<Object?> get props => [
        autoApproveListings,
        requireImageModeration,
        enableSpamDetection,
        minModeratorLevel,
        maxItemsPerModeration,
        allowSelfModeration,
        categoryModerationLevels,
      ];
}

class PaymentSettings extends Equatable {
  final double commissionRate;
  final double minimumTransactionAmount;
  final double maximumTransactionAmount;
  final bool autoProcessPayments;
  final int paymentTimeoutHours;
  final Map<String, double> providerCommissionRates;

  const PaymentSettings({
    this.commissionRate = 0.05, // 5%
    this.minimumTransactionAmount = 10.0,
    this.maximumTransactionAmount = 50000.0,
    this.autoProcessPayments = true,
    this.paymentTimeoutHours = 24,
    this.providerCommissionRates = const {},
  });

  @override
  List<Object?> get props => [
        commissionRate,
        minimumTransactionAmount,
        maximumTransactionAmount,
        autoProcessPayments,
        paymentTimeoutHours,
        providerCommissionRates,
      ];
}

class FeatureSettings extends Equatable {
  final bool enableChat;
  final bool enableNotifications;
  final bool enablePremiumFeatures;
  final bool enableLocationServices;
  final bool enableSocialLogin;
  final bool enableFileUploads;
  final bool enableVideoCalls;
  final bool enableAIRecommendations;
  final Map<String, bool> experimentalFeatures;

  const FeatureSettings({
    this.enableChat = true,
    this.enableNotifications = true,
    this.enablePremiumFeatures = true,
    this.enableLocationServices = true,
    this.enableSocialLogin = true,
    this.enableFileUploads = true,
    this.enableVideoCalls = false,
    this.enableAIRecommendations = false,
    this.experimentalFeatures = const {},
  });

  @override
  List<Object?> get props => [
        enableChat,
        enableNotifications,
        enablePremiumFeatures,
        enableLocationServices,
        enableSocialLogin,
        enableFileUploads,
        enableVideoCalls,
        enableAIRecommendations,
        experimentalFeatures,
      ];
}

class NotificationSettings extends Equatable {
  final bool enableEmailNotifications;
  final bool enableSMSNotifications;
  final bool enablePushNotifications;
  final int notificationRetentionDays;
  final bool sendDailyReports;
  final bool sendWeeklyReports;

  const NotificationSettings({
    this.enableEmailNotifications = true,
    this.enableSMSNotifications = false,
    this.enablePushNotifications = true,
    this.notificationRetentionDays = 30,
    this.sendDailyReports = false,
    this.sendWeeklyReports = true,
  });

  @override
  List<Object?> get props => [
        enableEmailNotifications,
        enableSMSNotifications,
        enablePushNotifications,
        notificationRetentionDays,
        sendDailyReports,
        sendWeeklyReports,
      ];
}

class SecuritySettings extends Equatable {
  final bool enableTwoFactorAuth;
  final bool requirePasswordStrength;
  final int maxLoginAttempts;
  final int lockoutDurationMinutes;
  final bool enableSessionMonitoring;
  final bool enableIPTracking;
  final List<String> allowedIPs;
  final List<String> blockedIPs;

  const SecuritySettings({
    this.enableTwoFactorAuth = false,
    this.requirePasswordStrength = true,
    this.maxLoginAttempts = 5,
    this.lockoutDurationMinutes = 15,
    this.enableSessionMonitoring = true,
    this.enableIPTracking = false,
    this.allowedIPs = const [],
    this.blockedIPs = const [],
  });

  @override
  List<Object?> get props => [
        enableTwoFactorAuth,
        requirePasswordStrength,
        maxLoginAttempts,
        lockoutDurationMinutes,
        enableSessionMonitoring,
        enableIPTracking,
        allowedIPs,
        blockedIPs,
      ];
}
