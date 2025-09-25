import 'package:equatable/equatable.dart';
import '../../../domain/repositories/barter_repository.dart';

abstract class BarterEvent extends Equatable {
  const BarterEvent();

  @override
  List<Object?> get props => [];
}

// Offer Events
class CreateOfferRequested extends BarterEvent {
  final CreateOfferRequest request;

  const CreateOfferRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class GetOfferByIdRequested extends BarterEvent {
  final String offerId;

  const GetOfferByIdRequested(this.offerId);

  @override
  List<Object?> get props => [offerId];
}

class GetOffersByListingRequested extends BarterEvent {
  final String listingId;

  const GetOffersByListingRequested(this.listingId);

  @override
  List<Object?> get props => [listingId];
}

class GetOffersByUserRequested extends BarterEvent {
  final String userId;
  final OfferFilter? filter;

  const GetOffersByUserRequested(this.userId, {this.filter});

  @override
  List<Object?> get props => [userId, filter];
}

class UpdateOfferRequested extends BarterEvent {
  final String offerId;
  final UpdateOfferRequest request;

  const UpdateOfferRequested(this.offerId, this.request);

  @override
  List<Object?> get props => [offerId, request];
}

class DeleteOfferRequested extends BarterEvent {
  final String offerId;

  const DeleteOfferRequested(this.offerId);

  @override
  List<Object?> get props => [offerId];
}

class AcceptOfferRequested extends BarterEvent {
  final String offerId;

  const AcceptOfferRequested(this.offerId);

  @override
  List<Object?> get props => [offerId];
}

class RejectOfferRequested extends BarterEvent {
  final String offerId;
  final String reason;

  const RejectOfferRequested(this.offerId, this.reason);

  @override
  List<Object?> get props => [offerId, reason];
}

class CounterOfferRequested extends BarterEvent {
  final String offerId;
  final CounterOfferRequest request;

  const CounterOfferRequested(this.offerId, this.request);

  @override
  List<Object?> get props => [offerId, request];
}

class CancelOfferRequested extends BarterEvent {
  final String offerId;

  const CancelOfferRequested(this.offerId);

  @override
  List<Object?> get props => [offerId];
}

// Transaction Events
class CreateTransactionRequested extends BarterEvent {
  final CreateTransactionRequest request;

  const CreateTransactionRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class GetTransactionByIdRequested extends BarterEvent {
  final String transactionId;

  const GetTransactionByIdRequested(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

class GetTransactionsByUserRequested extends BarterEvent {
  final String userId;
  final TransactionFilter? filter;

  const GetTransactionsByUserRequested(this.userId, {this.filter});

  @override
  List<Object?> get props => [userId, filter];
}

class UpdateTransactionRequested extends BarterEvent {
  final String transactionId;
  final UpdateTransactionRequest request;

  const UpdateTransactionRequested(this.transactionId, this.request);

  @override
  List<Object?> get props => [transactionId, request];
}

class ConfirmDeliveryRequested extends BarterEvent {
  final String transactionId;
  final DeliveryConfirmationRequest request;

  const ConfirmDeliveryRequested(this.transactionId, this.request);

  @override
  List<Object?> get props => [transactionId, request];
}

class ConfirmReceiptRequested extends BarterEvent {
  final String transactionId;
  final ReceiptConfirmationRequest request;

  const ConfirmReceiptRequested(this.transactionId, this.request);

  @override
  List<Object?> get props => [transactionId, request];
}

class CompleteTransactionRequested extends BarterEvent {
  final String transactionId;

  const CompleteTransactionRequested(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

class CancelTransactionRequested extends BarterEvent {
  final String transactionId;
  final String reason;

  const CancelTransactionRequested(this.transactionId, this.reason);

  @override
  List<Object?> get props => [transactionId, reason];
}

// Dispute Events
class OpenDisputeRequested extends BarterEvent {
  final String transactionId;
  final DisputeRequest request;

  const OpenDisputeRequested(this.transactionId, this.request);

  @override
  List<Object?> get props => [transactionId, request];
}

class ResolveDisputeRequested extends BarterEvent {
  final String transactionId;
  final DisputeResolutionRequest request;

  const ResolveDisputeRequested(this.transactionId, this.request);

  @override
  List<Object?> get props => [transactionId, request];
}

// Review Events
class SubmitReviewRequested extends BarterEvent {
  final String transactionId;
  final ReviewRequest request;

  const SubmitReviewRequested(this.transactionId, this.request);

  @override
  List<Object?> get props => [transactionId, request];
}

class GetReviewRequested extends BarterEvent {
  final String reviewId;

  const GetReviewRequested(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

// Search Events
class SearchOffersRequested extends BarterEvent {
  final SearchOffersRequest request;

  const SearchOffersRequested(this.request);

  @override
  List<Object?> get props => [request];
}

// Analytics Events
class GetBarterStatsRequested extends BarterEvent {
  final String userId;

  const GetBarterStatsRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetTransactionStatsRequested extends BarterEvent {
  final String userId;

  const GetTransactionStatsRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

// UI Events
class RefreshOffersRequested extends BarterEvent {}

class LoadMoreOffersRequested extends BarterEvent {
  final String? listingId;
  final String? userId;
  final OfferFilter? filter;

  const LoadMoreOffersRequested({
    this.listingId,
    this.userId,
    this.filter,
  });

  @override
  List<Object?> get props => [listingId, userId, filter];
}
