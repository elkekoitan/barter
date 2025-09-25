import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/barter_offer.dart';
import '../entities/barter_transaction.dart';

abstract class BarterRepository {
  // Offer Operations
  Future<Either<Failure, BarterOfferEntity>> createOffer(CreateOfferRequest request);
  Future<Either<Failure, BarterOfferEntity>> getOfferById(String offerId);
  Future<Either<Failure, List<BarterOfferEntity>>> getOffersByListing(String listingId);
  Future<Either<Failure, List<BarterOfferEntity>>> getOffersByUser(String userId, {OfferFilter? filter});
  Future<Either<Failure, BarterOfferEntity>> updateOffer(String offerId, UpdateOfferRequest request);
  Future<Either<Failure, void>> deleteOffer(String offerId);

  // Offer Actions
  Future<Either<Failure, BarterOfferEntity>> acceptOffer(String offerId);
  Future<Either<Failure, BarterOfferEntity>> rejectOffer(String offerId, String reason);
  Future<Either<Failure, BarterOfferEntity>> counterOffer(String offerId, CounterOfferRequest request);
  Future<Either<Failure, BarterOfferEntity>> cancelOffer(String offerId);

  // Transaction Operations
  Future<Either<Failure, BarterTransactionEntity>> createTransaction(CreateTransactionRequest request);
  Future<Either<Failure, BarterTransactionEntity>> getTransactionById(String transactionId);
  Future<Either<Failure, List<BarterTransactionEntity>>> getTransactionsByUser(String userId, {TransactionFilter? filter});
  Future<Either<Failure, BarterTransactionEntity>> updateTransaction(String transactionId, UpdateTransactionRequest request);

  // Transaction Actions
  Future<Either<Failure, BarterTransactionEntity>> confirmDelivery(String transactionId, DeliveryConfirmationRequest request);
  Future<Either<Failure, BarterTransactionEntity>> confirmReceipt(String transactionId, ReceiptConfirmationRequest request);
  Future<Either<Failure, BarterTransactionEntity>> completeTransaction(String transactionId);
  Future<Either<Failure, BarterTransactionEntity>> cancelTransaction(String transactionId, String reason);

  // Dispute Operations
  Future<Either<Failure, BarterTransactionEntity>> openDispute(String transactionId, DisputeRequest request);
  Future<Either<Failure, BarterTransactionEntity>> resolveDispute(String transactionId, DisputeResolutionRequest request);

  // Reviews
  Future<Either<Failure, void>> submitReview(String transactionId, ReviewRequest request);
  Future<Either<Failure, Review>> getReview(String reviewId);

  // Search & Filter
  Future<Either<Failure, List<BarterOfferEntity>>> searchOffers(SearchOffersRequest request);

  // Analytics
  Future<Either<Failure, BarterStats>> getBarterStats(String userId);
  Future<Either<Failure, TransactionStats>> getTransactionStats(String userId);
}

// Request/Response Models
class CreateOfferRequest {
  final String listingId;
  final String buyerId;
  final OfferType type;
  final CreateOfferDetails offer;
  final String? message;

  const CreateOfferRequest({
    required this.listingId,
    required this.buyerId,
    required this.type,
    required this.offer,
    this.message,
  });
}

class CreateOfferDetails {
  final List<CreateOfferItem> items;
  final double cashAmount;
  final String currency;

  const CreateOfferDetails({
    required this.items,
    this.cashAmount = 0.0,
    this.currency = 'TRY',
  });
}

class CreateOfferItem {
  final String listingId;
  final double estimatedValue;

  const CreateOfferItem({
    required this.listingId,
    required this.estimatedValue,
  });
}

class UpdateOfferRequest {
  final String? message;
  final bool? isActive;

  const UpdateOfferRequest({
    this.message,
    this.isActive,
  });
}

class CounterOfferRequest {
  final CreateOfferDetails offer;
  final String message;

  const CounterOfferRequest({
    required this.offer,
    required this.message,
  });
}

class CreateTransactionRequest {
  final String offerId;
  final TransactionDelivery? deliveryInfo;

  const CreateTransactionRequest({
    required this.offerId,
    this.deliveryInfo,
  });
}

class UpdateTransactionRequest {
  final TransactionDelivery? delivery;
  final TransactionMetadata? metadata;

  const UpdateTransactionRequest({
    this.delivery,
    this.metadata,
  });
}

class DeliveryConfirmationRequest {
  final String? trackingNumber;
  final String? carrier;
  final String? notes;

  const DeliveryConfirmationRequest({
    this.trackingNumber,
    this.carrier,
    this.notes,
  });
}

class ReceiptConfirmationRequest {
  final String? notes;
  final bool? conditionSatisfied;

  const ReceiptConfirmationRequest({
    this.notes,
    this.conditionSatisfied,
  });
}

class DisputeRequest {
  final String reason;
  final String description;
  final String openedBy;

  const DisputeRequest({
    required this.reason,
    required this.description,
    required this.openedBy,
  });
}

class DisputeResolutionRequest {
  final String resolution;
  final String resolvedBy;

  const DisputeResolutionRequest({
    required this.resolution,
    required this.resolvedBy,
  });
}

class ReviewRequest {
  final String reviewerId;
  final String revieweeId;
  final int rating;
  final String comment;
  final bool isPublic;

  const ReviewRequest({
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    required this.comment,
    this.isPublic = true,
  });
}

class OfferFilter {
  final OfferStatus? status;
  final OfferType? type;
  final DateTime? createdAfter;
  final DateTime? createdBefore;
  final double? minValue;
  final double? maxValue;

  const OfferFilter({
    this.status,
    this.type,
    this.createdAfter,
    this.createdBefore,
    this.minValue,
    this.maxValue,
  });
}

class TransactionFilter {
  final TransactionStatus? status;
  final DateTime? createdAfter;
  final DateTime? createdBefore;
  final String? listingId;

  const TransactionFilter({
    this.status,
    this.createdAfter,
    this.createdBefore,
    this.listingId,
  });
}

class SearchOffersRequest {
  final String query;
  final String? categoryId;
  final OfferFilter? filter;
  final int page;
  final int limit;

  const SearchOffersRequest({
    required this.query,
    this.categoryId,
    this.filter,
    this.page = 1,
    this.limit = 20,
  });
}

class BarterStats {
  final int totalOffers;
  final int acceptedOffers;
  final int rejectedOffers;
  final int completedTransactions;
  final double averageResponseTime;
  final double successRate;

  const BarterStats({
    required this.totalOffers,
    required this.acceptedOffers,
    required this.rejectedOffers,
    required this.completedTransactions,
    required this.averageResponseTime,
    required this.successRate,
  });
}

class TransactionStats {
  final int totalTransactions;
  final int completedTransactions;
  final int disputedTransactions;
  final int cancelledTransactions;
  final double averageCompletionTime;
  final double disputeRate;

  const TransactionStats({
    required this.totalTransactions,
    required this.completedTransactions,
    required this.disputedTransactions,
    required this.cancelledTransactions,
    required this.averageCompletionTime,
    required this.disputeRate,
  });
}
