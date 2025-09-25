import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String id;
  final String referenceId;
  final String userId;
  final double amount;
  final String currency;
  final String provider;
  final String status;
  final String? transactionId;
  final PaymentMetadata metadata;
  final DateTime createdAt;
  final DateTime? completedAt;

  const PaymentEntity({
    required this.id,
    required this.referenceId,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.provider,
    required this.status,
    this.transactionId,
    required this.metadata,
    required this.createdAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
        id,
        referenceId,
        userId,
        amount,
        currency,
        provider,
        status,
        transactionId,
        metadata,
        createdAt,
        completedAt,
      ];
}

class PaymentMetadata extends Equatable {
  final String description;
  final String? buyerEmail;
  final String? buyerPhone;
  final Map<String, dynamic>? additionalData;

  const PaymentMetadata({
    required this.description,
    this.buyerEmail,
    this.buyerPhone,
    this.additionalData,
  });

  @override
  List<Object?> get props => [description, buyerEmail, buyerPhone, additionalData];
}

class EscrowEntity extends Equatable {
  final String id;
  final String barterId;
  final double amount;
  final String currency;
  final String status;
  final String heldBy;
  final String releasedBy;
  final DateTime createdAt;
  final DateTime? releaseDate;
  final DateTime? releasedAt;

  const EscrowEntity({
    required this.id,
    required this.barterId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.heldBy,
    required this.releasedBy,
    required this.createdAt,
    this.releaseDate,
    this.releasedAt,
  });

  @override
  List<Object?> get props => [
        id,
        barterId,
        amount,
        currency,
        status,
        heldBy,
        releasedBy,
        createdAt,
        releaseDate,
        releasedAt,
      ];
}
