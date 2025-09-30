import 'package:equatable/equatable.dart';

class BarterOfferEntity extends Equatable {
  final String id;
  final String listingId;
  final String sellerId;
  final String buyerId;
  final OfferType type;
  final OfferDetails offer;
  final OfferStatus status;
  final CounterOffer? counterOffer;
  final ConversationInfo? conversation;
  final TransactionInfo? transaction;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? expiresAt;
  final String? message;
  final bool isActive;
  final int version;

  const BarterOfferEntity({
    required this.id,
    required this.listingId,
    required this.sellerId,
    required this.buyerId,
    required this.type,
    required this.offer,
    required this.status,
    this.counterOffer,
    this.conversation,
    this.transaction,
    required this.createdAt,
    required this.updatedAt,
    this.expiresAt,
    this.message,
    this.isActive = true,
    this.version = 1,
  });

  bool get isExpired => expiresAt?.isBefore(DateTime.now()) == true;

  bool get canBeAccepted => status == OfferStatus.pending && isActive && !isExpired;

  bool get canBeRejected => status == OfferStatus.pending && isActive;

  bool get canBeCountered => status == OfferStatus.pending && isActive && type != OfferType.barterPool;

  bool get isCompleted => status == OfferStatus.accepted || status == OfferStatus.completed;

  double get totalValue => offer.totalValue;

  String get offeredByUserId => type == OfferType.directSwap ? buyerId : sellerId;

  List<String> get offeredItems => offer.items.map((item) => item.listingId).toList();

  @override
  List<Object?> get props => [
        id,
        listingId,
        sellerId,
        buyerId,
        type,
        offer,
        status,
        counterOffer,
        conversation,
        transaction,
        createdAt,
        updatedAt,
        expiresAt,
        message,
        isActive,
        version,
      ];
}

class OfferDetails extends Equatable {
  final List<OfferItem> items;
  final double cashAmount;
  final String currency;
  final double totalValue;
  final String? additionalInfo;

  const OfferDetails({
    required this.items,
    this.cashAmount = 0.0,
    this.currency = 'TRY',
    required this.totalValue,
    this.additionalInfo,
  });

  bool get hasCash => cashAmount > 0;

  bool get hasItems => items.isNotEmpty;

  bool get isCashOnly => !hasItems && hasCash;

  bool get isItemsOnly => hasItems && !hasCash;

  bool get isMixed => hasItems && hasCash;

  @override
  List<Object?> get props => [items, cashAmount, currency, totalValue, additionalInfo];
}

class OfferItem extends Equatable {
  final String listingId;
  final String title;
  final String? imageUrl;
  final double estimatedValue;
  final String currency;
  final String condition;
  final String? description;

  const OfferItem({
    required this.listingId,
    required this.title,
    this.imageUrl,
    required this.estimatedValue,
    this.currency = 'TRY',
    this.condition = 'good',
    this.description,
  });

  @override
  List<Object?> get props => [
        listingId,
        title,
        imageUrl,
        estimatedValue,
        currency,
        condition,
        description,
      ];
}

class CounterOffer extends Equatable {
  final OfferDetails offer;
  final String message;
  final DateTime createdAt;

  const CounterOffer({
    required this.offer,
    required this.message,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [offer, message, createdAt];
}

class ConversationInfo extends Equatable {
  final String id;
  final String lastMessage;
  final int unreadCount;
  final DateTime lastMessageAt;

  const ConversationInfo({
    required this.id,
    required this.lastMessage,
    this.unreadCount = 0,
    required this.lastMessageAt,
  });

  @override
  List<Object?> get props => [id, lastMessage, unreadCount, lastMessageAt];
}

class TransactionInfo extends Equatable {
  final String id;
  final TransactionStatus status;
  final String? escrowId;
  final DateTime createdAt;
  final DateTime? completedAt;

  const TransactionInfo({
    required this.id,
    required this.status,
    this.escrowId,
    required this.createdAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [id, status, escrowId, createdAt, completedAt];
}

enum OfferType {
  directSwap('direct_swap', 'Direkt Takas'),
  swapWithCash('swap_with_cash', 'Takas + Nakit'),
  barterPool('barter_pool', 'Barter Havuzu');

  const OfferType(this.value, this.displayName);
  final String value;
  final String displayName;

  static OfferType fromString(String value) {
    return OfferType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => OfferType.directSwap,
    );
  }
}

enum OfferStatus {
  pending('pending', 'Bekliyor'),
  accepted('accepted', 'Kabul Edildi'),
  rejected('rejected', 'Reddedildi'),
  countered('countered', 'Karşı Teklif'),
  expired('expired', 'Süresi Doldu'),
  cancelled('cancelled', 'İptal Edildi'),
  completed('completed', 'Tamamlandı');

  const OfferStatus(this.value, this.displayName);
  final String value;
  final String displayName;

  static OfferStatus fromString(String value) {
    return OfferStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => OfferStatus.pending,
    );
  }
}

enum TransactionStatus {
  initiated('initiated', 'Başlatıldı'),
  paymentPending('payment_pending', 'Ödeme Bekliyor'),
  paymentCompleted('payment_completed', 'Ödeme Tamamlandı'),
  shipping('shipping', 'Kargoda'),
  delivered('delivered', 'Teslim Edildi'),
  completed('completed', 'Tamamlandı'),
  disputed('disputed', 'İtiraz Edildi'),
  cancelled('cancelled', 'İptal Edildi'),
  refunded('refunded', 'İade Edildi');

  const TransactionStatus(this.value, this.displayName);
  final String value;
  final String displayName;

  static TransactionStatus fromString(String value) {
    return TransactionStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TransactionStatus.initiated,
    );
  }
}
