import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final NotificationType type;
  final NotificationData data;
  final String title;
  final String message;
  final String? imageUrl;
  final bool isRead;
  final bool isImportant;
  final DateTime createdAt;
  final DateTime? readAt;
  final NotificationPriority priority;
  final NotificationChannel channel;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.data,
    required this.title,
    required this.message,
    this.imageUrl,
    this.isRead = false,
    this.isImportant = false,
    required this.createdAt,
    this.readAt,
    this.priority = NotificationPriority.normal,
    this.channel = NotificationChannel.push,
    this.actionUrl,
    this.metadata,
  });

  bool get isExpired => _isExpired();

  bool get canMarkAsRead => !isRead;

  bool get requiresAction => actionUrl != null && actionUrl!.isNotEmpty;

  String get timeAgo => _calculateTimeAgo();

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        data,
        title,
        message,
        imageUrl,
        isRead,
        isImportant,
        createdAt,
        readAt,
        priority,
        channel,
        actionUrl,
        metadata,
      ];

  bool _isExpired() {
    final now = DateTime.now();
    final expiryDate = createdAt.add(const Duration(days: 30)); // 30 gün sonra expire olur
    return now.isAfter(expiryDate);
  }

  String _calculateTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
}

class NotificationData extends Equatable {
  final String? listingId;
  final String? offerId;
  final String? transactionId;
  final String? messageId;
  final String? userId;
  final String? userName;
  final String? userAvatar;
  final double? amount;
  final String? currency;
  final NotificationAction? action;

  const NotificationData({
    this.listingId,
    this.offerId,
    this.transactionId,
    this.messageId,
    this.userId,
    this.userName,
    this.userAvatar,
    this.amount,
    this.currency,
    this.action,
  });

  @override
  List<Object?> get props => [
        listingId,
        offerId,
        transactionId,
        messageId,
        userId,
        userName,
        userAvatar,
        amount,
        currency,
        action,
      ];

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      listingId: json['listingId'],
      offerId: json['offerId'],
      transactionId: json['transactionId'],
      messageId: json['messageId'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      amount: json['amount']?.toDouble(),
      currency: json['currency'],
      action: json['action'] != null ? NotificationAction.fromString(json['action']) : null,
    );
  }
}

enum NotificationType {
  // General notifications
  system('system', 'Sistem', Icons.info_outline),
  announcement('announcement', 'Duyuru', Icons.campaign_outlined),

  // Listing notifications
  listingCreated('listing_created', 'İlan Oluşturuldu', Icons.add_box_outlined),
  listingApproved('listing_approved', 'İlan Onaylandı', Icons.check_circle_outline),
  listingRejected('listing_rejected', 'İlan Reddedildi', Icons.cancel_outlined),
  listingExpired('listing_expired', 'İlan Süresi Doldu', Icons.schedule_outlined),
  listingFeatured('listing_featured', 'İlan Öne Çıktı', Icons.star_outline),
  listingBoosted('listing_boosted', 'İlan Yükseltildi', Icons.trending_up),

  // Offer notifications
  offerReceived('offer_received', 'Teklif Alındı', Icons.swap_horiz_outlined),
  offerAccepted('offer_accepted', 'Teklif Kabul Edildi', Icons.check_circle_outline),
  offerRejected('offer_rejected', 'Teklif Reddedildi', Icons.cancel_outlined),
  offerCountered('offer_countered', 'Karşı Teklif', Icons.sync_alt_outlined),
  offerExpired('offer_expired', 'Teklif Süresi Doldu', Icons.schedule_outlined),

  // Transaction notifications
  transactionCreated('transaction_created', 'İşlem Başlatıldı', Icons.play_arrow_outlined),
  paymentReceived('payment_received', 'Ödeme Alındı', Icons.payment_outlined),
  paymentSent('payment_sent', 'Ödeme Gönderildi', Icons.send_outlined),
  deliveryConfirmed('delivery_confirmed', 'Teslimat Onaylandı', Icons.local_shipping_outlined),
  itemReceived('item_received', 'Ürün Teslim Alındı', Icons.inventory_2_outlined),
  transactionCompleted('transaction_completed', 'İşlem Tamamlandı', Icons.done_all_outlined),
  escrowHeld('escrow_held', 'Emanet Tutuldu', Icons.account_balance_wallet_outlined),
  escrowReleased('escrow_released', 'Emanet Serbest Bırakıldı', Icons.account_balance_outlined),

  // Message notifications
  messageReceived('message_received', 'Yeni Mesaj', Icons.chat_bubble_outline),
  messageReplied('message_replied', 'Mesaja Yanıt', Icons.reply_outlined),

  // Dispute notifications
  disputeOpened('dispute_opened', 'İtiraz Açıldı', Icons.gavel_outlined),
  disputeResolved('dispute_resolved', 'İtiraz Çözüldü', Icons.verified_outlined),
  disputeUpdated('dispute_updated', 'İtiraz Güncellendi', Icons.update_outlined),

  // Review notifications
  reviewReceived('review_received', 'Değerlendirme Alındı', Icons.star_outline),
  reviewReminder('review_reminder', 'Değerlendirme Hatırlatma', Icons.star_half_outlined),

  // Security notifications
  loginAlert('login_alert', 'Yeni Giriş', Icons.security_outlined),
  passwordChanged('password_changed', 'Şifre Değiştirildi', Icons.lock_outline),
  accountSuspended('account_suspended', 'Hesap Askıya Alındı', Icons.block_outlined),
  verificationRequired('verification_required', 'Doğrulama Gerekli', Icons.verified_user_outlined),

  // Promotional notifications
  promotion('promotion', 'Promosyon', Icons.local_offer_outlined),
  discount('discount', 'İndirim', Icons.percent_outlined),
  specialOffer('special_offer', 'Özel Teklif', Icons.flash_on_outlined);

  const NotificationType(this.value, this.displayName, this.icon);
  final String value;
  final String displayName;
  final IconData icon;

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationType.system,
    );
  }
}

enum NotificationPriority {
  low('low', 'Düşük'),
  normal('normal', 'Normal'),
  high('high', 'Yüksek'),
  urgent('urgent', 'Acil');

  const NotificationPriority(this.value, this.displayName);
  final String value;
  final String displayName;

  static NotificationPriority fromString(String value) {
    return NotificationPriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => NotificationPriority.normal,
    );
  }
}

enum NotificationChannel {
  push('push', 'Push Bildirimi'),
  email('email', 'E-posta'),
  sms('sms', 'SMS'),
  inApp('in_app', 'Uygulama İçi');

  const NotificationChannel(this.value, this.displayName);
  final String value;
  final String displayName;

  static NotificationChannel fromString(String value) {
    return NotificationChannel.values.firstWhere(
      (channel) => channel.value == value,
      orElse: () => NotificationChannel.push,
    );
  }
}

enum NotificationAction {
  openListing('open_listing', 'İlanı Aç'),
  openOffer('open_offer', 'Teklifi Aç'),
  openTransaction('open_transaction', 'İşlemi Aç'),
  openChat('open_chat', 'Sohbeti Aç'),
  openProfile('open_profile', 'Profili Aç'),
  openDispute('open_dispute', 'İtirazı Aç'),
  verifyAccount('verify_account', 'Hesabı Doğrula'),
  changePassword('change_password', 'Şifreyi Değiştir'),
  viewSettings('view_settings', 'Ayarları Görüntüle');

  const NotificationAction(this.value, this.displayName);
  final String value;
  final String displayName;

  static NotificationAction fromString(String value) {
    return NotificationAction.values.firstWhere(
      (action) => action.value == value,
      orElse: () => NotificationAction.openListing,
    );
  }
}

class NotificationSettings extends Equatable {
  final String userId;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool smsEnabled;
  final bool inAppEnabled;

  // Category-specific settings
  final NotificationCategorySettings categories;

  const NotificationSettings({
    required this.userId,
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.smsEnabled = false,
    this.inAppEnabled = true,
    this.categories = const NotificationCategorySettings(),
  });

  NotificationSettings copyWith({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? smsEnabled,
    bool? inAppEnabled,
    NotificationCategorySettings? categories,
  }) {
    return NotificationSettings(
      userId: userId,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      inAppEnabled: inAppEnabled ?? this.inAppEnabled,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        pushEnabled,
        emailEnabled,
        smsEnabled,
        inAppEnabled,
        categories,
      ];
}

class NotificationCategorySettings extends Equatable {
  final bool listings;
  final bool offers;
  final bool transactions;
  final bool messages;
  final bool disputes;
  final bool reviews;
  final bool security;
  final bool promotions;

  const NotificationCategorySettings({
    this.listings = true,
    this.offers = true,
    this.transactions = true,
    this.messages = true,
    this.disputes = true,
    this.reviews = true,
    this.security = true,
    this.promotions = false,
  });

  NotificationCategorySettings copyWith({
    bool? listings,
    bool? offers,
    bool? transactions,
    bool? messages,
    bool? disputes,
    bool? reviews,
    bool? security,
    bool? promotions,
  }) {
    return NotificationCategorySettings(
      listings: listings ?? this.listings,
      offers: offers ?? this.offers,
      transactions: transactions ?? this.transactions,
      messages: messages ?? this.messages,
      disputes: disputes ?? this.disputes,
      reviews: reviews ?? this.reviews,
      security: security ?? this.security,
      promotions: promotions ?? this.promotions,
    );
  }

  @override
  List<Object?> get props => [
        listings,
        offers,
        transactions,
        messages,
        disputes,
        reviews,
        security,
        promotions,
      ];
}

class NotificationStats extends Equatable {
  final int totalNotifications;
  final int unreadCount;
  final int todayCount;
  final int thisWeekCount;
  final Map<String, int> typeDistribution;
  final Map<String, int> priorityDistribution;

  const NotificationStats({
    required this.totalNotifications,
    required this.unreadCount,
    required this.todayCount,
    required this.thisWeekCount,
    required this.typeDistribution,
    required this.priorityDistribution,
  });

  @override
  List<Object?> get props => [
        totalNotifications,
        unreadCount,
        todayCount,
        thisWeekCount,
        typeDistribution,
        priorityDistribution,
      ];
}
