import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/error_handler.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/escrow.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../core/constants/payment_constants.dart';
import '../datasources/remote/payment_remote_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final ApiClient _apiClient;
  final PaymentRemoteDataSource _paymentRemoteDataSource;

  PaymentRepositoryImpl(this._apiClient, this._paymentRemoteDataSource);

  @override
  Future<Either<Failure, PaymentEntity>> processPayment(PaymentRequest request) async {
    try {
      // First create a payment record in our system
      final createPaymentResponse = await _apiClient.post<Map<String, dynamic>>(
        '/payments/process',
        data: {
          'referenceId': request.referenceId,
          'userId': request.userId,
          'amount': request.amount,
          'currency': request.currency,
          'provider': request.provider,
          'description': request.description,
          'callbackUrl': request.callbackUrl,
          'metadata': request.metadata,
        },
      );

      if (createPaymentResponse.statusCode == 200 || createPaymentResponse.statusCode == 201) {
        final paymentData = createPaymentResponse.data!['data'];

        return Right(PaymentEntity(
          id: paymentData['id'],
          referenceId: paymentData['referenceId'],
          userId: paymentData['userId'],
          amount: paymentData['amount'],
          currency: paymentData['currency'],
          provider: paymentData['provider'],
          status: paymentData['status'],
          transactionId: paymentData['transactionId'],
          metadata: PaymentMetadata(
            description: paymentData['description'],
            buyerEmail: paymentData['buyerEmail'],
            buyerPhone: paymentData['buyerPhone'],
            additionalData: paymentData['metadata'],
          ),
          createdAt: DateTime.parse(paymentData['createdAt']),
          completedAt: paymentData['completedAt'] != null
              ? DateTime.parse(paymentData['completedAt'])
              : null,
        ));
      } else {
        return Left(ServerFailure('Failed to create payment record'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> getPaymentById(String paymentId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('/payments/$paymentId');

      if (response.statusCode == 200) {
        final paymentData = response.data!['data'];
        return Right(_mapPaymentDataToEntity(paymentData));
      } else {
        return Left(ServerFailure('Failed to get payment'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<PaymentEntity>>> getPaymentsByUserId(String userId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/payments',
        queryParameters: {'userId': userId},
      );

      if (response.statusCode == 200) {
        final paymentsData = response.data!['data'] as List;
        final payments = paymentsData
            .map((paymentData) => _mapPaymentDataToEntity(paymentData))
            .toList();

        return Right(payments);
      } else {
        return Left(ServerFailure('Failed to get payments'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> updatePaymentStatus(String paymentId, String status) async {
    try {
      final response = await _apiClient.patch<Map<String, dynamic>>(
        '/payments/$paymentId/status',
        data: {'status': status},
      );

      if (response.statusCode == 200) {
        final paymentData = response.data!['data'];
        return Right(_mapPaymentDataToEntity(paymentData));
      } else {
        return Left(ServerFailure('Failed to update payment status'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, EscrowEntity>> createEscrow(EscrowRequest request) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/escrow',
        data: {
          'barterId': request.barterId,
          'userId': request.userId,
          'amount': request.amount,
          'currency': request.currency,
          'releaseDate': request.releaseDate?.toIso8601String(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final escrowData = response.data!['data'];
        return Right(_mapEscrowDataToEntity(escrowData));
      } else {
        return Left(ServerFailure('Failed to create escrow'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, EscrowEntity>> getEscrowById(String escrowId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('/escrow/$escrowId');

      if (response.statusCode == 200) {
        final escrowData = response.data!['data'];
        return Right(_mapEscrowDataToEntity(escrowData));
      } else {
        return Left(ServerFailure('Failed to get escrow'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, EscrowEntity>> releaseEscrow(String escrowId) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/escrow/$escrowId/release',
      );

      if (response.statusCode == 200) {
        final escrowData = response.data!['data'];
        return Right(_mapEscrowDataToEntity(escrowData));
      } else {
        return Left(ServerFailure('Failed to release escrow'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, EscrowEntity>> disputeEscrow(String escrowId) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/escrow/$escrowId/dispute',
      );

      if (response.statusCode == 200) {
        final escrowData = response.data!['data'];
        return Right(_mapEscrowDataToEntity(escrowData));
      } else {
        return Left(ServerFailure('Failed to dispute escrow'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, PaymentEntity>> refundPayment(String paymentId, double amount) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/payments/$paymentId/refund',
        data: {'amount': amount},
      );

      if (response.statusCode == 200) {
        final paymentData = response.data!['data'];
        return Right(_mapPaymentDataToEntity(paymentData));
      } else {
        return Left(ServerFailure('Failed to refund payment'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyWebhook(String provider, Map<String, dynamic> payload) async {
    try {
      final response = await _apiClient.post<bool>(
        '/payments/webhooks/$provider/verify',
        data: payload,
      );

      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return const Right(false);
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  // Helper methods
  PaymentEntity _mapPaymentDataToEntity(Map<String, dynamic> data) {
    return PaymentEntity(
      id: data['id'],
      referenceId: data['referenceId'],
      userId: data['userId'],
      amount: data['amount'].toDouble(),
      currency: data['currency'],
      provider: data['provider'],
      status: data['status'],
      transactionId: data['transactionId'],
      metadata: PaymentMetadata(
        description: data['description'] ?? '',
        buyerEmail: data['buyerEmail'],
        buyerPhone: data['buyerPhone'],
        additionalData: data['metadata'],
      ),
      createdAt: DateTime.parse(data['createdAt']),
      completedAt: data['completedAt'] != null
          ? DateTime.parse(data['completedAt'])
          : null,
    );
  }

  EscrowEntity _mapEscrowDataToEntity(Map<String, dynamic> data) {
    return EscrowEntity(
      id: data['id'],
      barterId: data['barterId'],
      amount: data['amount'].toDouble(),
      currency: data['currency'],
      status: data['status'],
      heldBy: data['heldBy'],
      releasedBy: data['releasedBy'],
      createdAt: DateTime.parse(data['createdAt']),
      releaseDate: data['releaseDate'] != null
          ? DateTime.parse(data['releaseDate'])
          : null,
      releasedAt: data['releasedAt'] != null
          ? DateTime.parse(data['releasedAt'])
          : null,
    );
  }
}
