import 'package:equatable/equatable.dart';
import 'barter_offer.dart';

class BarterTransactionEntity extends Equatable {
  final String id;
  final String offerId;
  final TransactionParties parties;
  final TransactionItems items;
  final TransactionPayment payment;
  final TransactionDelivery delivery;
  final TransactionStatus status;
  final List<TransactionTimeline> timeline;
  final TransactionDispute? dispute;
  final TransactionReviews? reviews;
  final TransactionMetadata metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;

  const BarterTransactionEntity({
    required this.id,
    required this.offerId,
    required this.parties,
    required this.items,
    required this.payment,
    required this.delivery,
    required this.status,
    required this.timeline,
    this.dispute,
    this.reviews,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.cancelledAt,
  });

  bool get isCompleted => status == TransactionStatus.completed;

  bool get isCancelled => status == TransactionStatus.cancelled;

  bool get isDisputed => status == TransactionStatus.disputed;

  bool get canBeCancelled => ![TransactionStatus.completed, TransactionStatus.cancelled, TransactionStatus.disputed].contains(status);

  bool get requiresPayment => status == TransactionStatus.paymentPending;

  bool get requiresShipping => status == TransactionStatus.paymentCompleted;

  bool get requiresDeliveryConfirmation => status == TransactionStatus.delivered;

  double get totalValue => items.fromSeller.fold(0.0, (sum, item) => sum + item.estimatedValue) +
                           items.fromBuyer.fold(0.0, (sum, item) => sum + item.estimatedValue);

  @override
  List<Object?> get props => [
        id,
        offerId,
        parties,
        items,
        payment,
        delivery,
        status,
        timeline,
        dispute,
        reviews,
        metadata,
        createdAt,
        updatedAt,
        completedAt,
        cancelledAt,
      ];
}

class TransactionParties extends Equatable {
  final String sellerId;
  final String buyerId;
  final SellerInfo seller;
  final BuyerInfo buyer;

  const TransactionParties({
    required this.sellerId,
    required this.buyerId,
    required this.seller,
    required this.buyer,
  });

  @override
  List<Object?> get props => [sellerId, buyerId, seller, buyer];
}

class SellerInfo extends Equatable {
  final String userId;
  final String name;
  final String? avatarUrl;
  final String phone;
  final String email;
  final TransactionLocation location;
  final double rating;
  final int completedTransactions;

  const SellerInfo({
    required this.userId,
    required this.name,
    this.avatarUrl,
    required this.phone,
    required this.email,
    required this.location,
    this.rating = 0.0,
    this.completedTransactions = 0,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        avatarUrl,
        phone,
        email,
        location,
        rating,
        completedTransactions,
      ];
}

class BuyerInfo extends Equatable {
  final String userId;
  final String name;
  final String? avatarUrl;
  final String phone;
  final String email;
  final TransactionLocation location;
  final double rating;
  final int completedTransactions;

  const BuyerInfo({
    required this.userId,
    required this.name,
    this.avatarUrl,
    required this.phone,
    required this.email,
    required this.location,
    this.rating = 0.0,
    this.completedTransactions = 0,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        avatarUrl,
        phone,
        email,
        location,
        rating,
        completedTransactions,
      ];
}

class TransactionItems extends Equatable {
  final List<TransactionItem> fromSeller;
  final List<TransactionItem> fromBuyer;

  const TransactionItems({
    required this.fromSeller,
    required this.fromBuyer,
  });

  bool get hasItems => fromSeller.isNotEmpty || fromBuyer.isNotEmpty;

  int get totalItems => fromSeller.length + fromBuyer.length;

  @override
  List<Object?> get props => [fromSeller, fromBuyer];
}

class TransactionItem extends Equatable {
  final String listingId;
  final String title;
  final String? imageUrl;
  final String category;
  final String condition;
  final double estimatedValue;
  final String currency;
  final String? description;
  final bool isDelivered;
  final DateTime? deliveredAt;

  const TransactionItem({
    required this.listingId,
    required this.title,
    this.imageUrl,
    required this.category,
    required this.condition,
    required this.estimatedValue,
    this.currency = 'TRY',
    this.description,
    this.isDelivered = false,
    this.deliveredAt,
  });

  @override
  List<Object?> get props => [
        listingId,
        title,
        imageUrl,
        category,
        condition,
        estimatedValue,
        currency,
        description,
        isDelivered,
        deliveredAt,
      ];
}

class TransactionPayment extends Equatable {
  final double amount;
  final String currency;
  final String method;
  final String? provider;
  final String? transactionId;
  final PaymentStatus status;
  final EscrowInfo? escrow;
  final CommissionInfo commission;

  const TransactionPayment({
    required this.amount,
    this.currency = 'TRY',
    required this.method,
    this.provider,
    this.transactionId,
    required this.status,
    this.escrow,
    required this.commission,
  });

  bool get requiresEscrow => escrow != null;

  bool get isEscrowHeld => escrow?.status == EscrowStatus.held;

  bool get isEscrowReleased => escrow?.status == EscrowStatus.released;

  @override
  List<Object?> get props => [
        amount,
        currency,
        method,
        provider,
        transactionId,
        status,
        escrow,
        commission,
      ];
}

class EscrowInfo extends Equatable {
  final bool enabled;
  final String? escrowId;
  final EscrowStatus status;
  final DateTime? releaseDate;
  final DateTime? heldAt;
  final DateTime? releasedAt;

  const EscrowInfo({
    this.enabled = false,
    this.escrowId,
    this.status = EscrowStatus.none,
    this.releaseDate,
    this.heldAt,
    this.releasedAt,
  });

  @override
  List<Object?> get props => [
        enabled,
        escrowId,
        status,
        releaseDate,
        heldAt,
        releasedAt,
      ];
}

class CommissionInfo extends Equatable {
  final double percentage;
  final double amount;
  final String currency;
  final bool isPaid;

  const CommissionInfo({
    required this.percentage,
    required this.amount,
    this.currency = 'TRY',
    this.isPaid = false,
  });

  @override
  List<Object?> get props => [percentage, amount, currency, isPaid];
}

class TransactionDelivery extends Equatable {
  final DeliveryMethod method;
  final String? trackingNumber;
  final String? carrier;
  final DeliveryStatus status;
  final String? estimatedDeliveryDate;
  final String? actualDeliveryDate;
  final TransactionLocation? pickupLocation;
  final TransactionLocation? deliveryLocation;
  final String? notes;

  const TransactionDelivery({
    required this.method,
    this.trackingNumber,
    this.carrier,
    this.status = DeliveryStatus.notShipped,
    this.estimatedDeliveryDate,
    this.actualDeliveryDate,
    this.pickupLocation,
    this.deliveryLocation,
    this.notes,
  });

  bool get isInTransit => status == DeliveryStatus.inTransit;

  bool get isDelivered => status == DeliveryStatus.delivered;

  bool get requiresTracking => method == DeliveryMethod.cargo && trackingNumber == null;

  @override
  List<Object?> get props => [
        method,
        trackingNumber,
        carrier,
        status,
        estimatedDeliveryDate,
        actualDeliveryDate,
        pickupLocation,
        deliveryLocation,
        notes,
      ];
}

class TransactionTimeline extends Equatable {
  final String event;
  final String description;
  final DateTime timestamp;
  final String? actor;
  final Map<String, dynamic>? metadata;

  const TransactionTimeline({
    required this.event,
    required this.description,
    required this.timestamp,
    this.actor,
    this.metadata,
  });

  @override
  List<Object?> get props => [event, description, timestamp, actor, metadata];
}

class TransactionDispute extends Equatable {
  final bool isActive;
  final String reason;
  final String openedBy;
  final String? description;
  final DateTime openedAt;
  final String? resolvedBy;
  final String? resolution;
  final DateTime? resolvedAt;

  const TransactionDispute({
    required this.isActive,
    required this.reason,
    required this.openedBy,
    this.description,
    required this.openedAt,
    this.resolvedBy,
    this.resolution,
    this.resolvedAt,
  });

  @override
  List<Object?> get props => [
        isActive,
        reason,
        openedBy,
        description,
        openedAt,
        resolvedBy,
        resolution,
        resolvedAt,
      ];
}

class TransactionReviews extends Equatable {
  final Review? fromSeller;
  final Review? fromBuyer;

  const TransactionReviews({
    this.fromSeller,
    this.fromBuyer,
  });

  bool get hasBothReviews => fromSeller != null && fromBuyer != null;

  bool get hasSellerReview => fromSeller != null;

  bool get hasBuyerReview => fromBuyer != null;

  @override
  List<Object?> get props => [fromSeller, fromBuyer];
}

class Review extends Equatable {
  final String id;
  final String reviewerId;
  final String revieweeId;
  final int rating;
  final String comment;
  final bool isPublic;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    required this.comment,
    this.isPublic = true,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        reviewerId,
        revieweeId,
        rating,
        comment,
        isPublic,
        createdAt,
      ];
}

class TransactionLocation extends Equatable {
  final String city;
  final String district;
  final String? neighborhood;
  final String? address;
  final double? latitude;
  final double? longitude;

  const TransactionLocation({
    required this.city,
    required this.district,
    this.neighborhood,
    this.address,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
        city,
        district,
        neighborhood,
        address,
        latitude,
        longitude,
      ];
}

class TransactionMetadata extends Equatable {
  final String? notes;
  final Map<String, dynamic>? customFields;
  final String? referenceNumber;
  final String? externalId;

  const TransactionMetadata({
    this.notes,
    this.customFields,
    this.referenceNumber,
    this.externalId,
  });

  @override
  List<Object?> get props => [notes, customFields, referenceNumber, externalId];
}

enum DeliveryMethod {
  inPerson('in_person', 'Yüz Yüze'),
  cargo('cargo', 'Kargo'),
  pickup('pickup', 'Alış');

  const DeliveryMethod(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum DeliveryStatus {
  notShipped('not_shipped', 'Gönderilmedi'),
  inTransit('in_transit', 'Yolda'),
  delivered('delivered', 'Teslim Edildi'),
  failedDelivery('failed_delivery', 'Teslimat Başarısız');

  const DeliveryStatus(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum PaymentStatus {
  pending('pending', 'Bekliyor'),
  processing('processing', 'İşleniyor'),
  completed('completed', 'Tamamlandı'),
  failed('failed', 'Başarısız'),
  refunded('refunded', 'İade Edildi'),
  cancelled('cancelled', 'İptal Edildi');

  const PaymentStatus(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum EscrowStatus {
  none('none', 'Yok'),
  held('held', 'Tutuldu'),
  released('released', 'Serbest Bırakıldı'),
  disputed('disputed', 'İtiraz Edildi');

  const EscrowStatus(this.value, this.displayName);
  final String value;
  final String displayName;
}
