import 'package:dartz/dartz.dart';
import '../entities/payment.dart';
import '../../core/errors/failures.dart';

abstract class PaymentRepository {
  // Payment operations
  Future<Either<Failure, PaymentEntity>> processPayment(PaymentRequest request);
  Future<Either<Failure, PaymentEntity>> getPaymentById(String paymentId);
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByUserId(String userId);
  Future<Either<Failure, PaymentEntity>> updatePaymentStatus(String paymentId, String status);

  // Escrow operations
  Future<Either<Failure, EscrowEntity>> createEscrow(EscrowRequest request);
  Future<Either<Failure, EscrowEntity>> getEscrowById(String escrowId);
  Future<Either<Failure, EscrowEntity>> releaseEscrow(String escrowId);
  Future<Either<Failure, EscrowEntity>> disputeEscrow(String escrowId);

  // Refund operations
  Future<Either<Failure, PaymentEntity>> refundPayment(String paymentId, double amount);

  // Webhook verification
  Future<Either<Failure, bool>> verifyWebhook(String provider, Map<String, dynamic> payload);
}

class PaymentRequest {
  final String referenceId;
  final String userId;
  final double amount;
  final String currency;
  final String provider;
  final String description;
  final String callbackUrl;
  final Map<String, dynamic>? metadata;

  const PaymentRequest({
    required this.referenceId,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.provider,
    required this.description,
    required this.callbackUrl,
    this.metadata,
  });
}

class EscrowRequest {
  final String barterId;
  final String userId;
  final double amount;
  final String currency;
  final DateTime? releaseDate;

  const EscrowRequest({
    required this.barterId,
    required this.userId,
    required this.amount,
    required this.currency,
    this.releaseDate,
  });
}
