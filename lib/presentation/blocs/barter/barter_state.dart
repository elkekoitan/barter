import 'package:equatable/equatable.dart';
import '../../../domain/entities/barter_offer.dart';
import '../../../domain/entities/barter_transaction.dart';

abstract class BarterState extends Equatable {
  const BarterState();

  @override
  List<Object?> get props => [];
}

class BarterInitial extends BarterState {}

class BarterLoading extends BarterState {}

class OffersLoading extends BarterState {
  final bool isLoadMore;

  const OffersLoading({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

class TransactionsLoading extends BarterState {
  final bool isLoadMore;

  const TransactionsLoading({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

// Offer States
class OfferCreated extends BarterState {
  final BarterOfferEntity offer;

  const OfferCreated(this.offer);

  @override
  List<Object?> get props => [offer];
}

class OfferLoaded extends BarterState {
  final BarterOfferEntity offer;

  const OfferLoaded(this.offer);

  @override
  List<Object?> get props => [offer];
}

class OffersLoaded extends BarterState {
  final List<BarterOfferEntity> offers;
  final bool hasMore;
  final int currentPage;

  const OffersLoaded({
    required this.offers,
    this.hasMore = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [offers, hasMore, currentPage];
}

class OfferUpdated extends BarterState {
  final BarterOfferEntity offer;

  const OfferUpdated(this.offer);

  @override
  List<Object?> get props => [offer];
}

class OfferDeleted extends BarterState {}

class OfferAccepted extends BarterState {
  final BarterOfferEntity offer;

  const OfferAccepted(this.offer);

  @override
  List<Object?> get props => [offer];
}

class OfferRejected extends BarterState {
  final BarterOfferEntity offer;

  const OfferRejected(this.offer);

  @override
  List<Object?> get props => [offer];
}

class OfferCountered extends BarterState {
  final BarterOfferEntity offer;

  const OfferCountered(this.offer);

  @override
  List<Object?> get props => [offer];
}

class OfferCancelled extends BarterState {}

// Transaction States
class TransactionCreated extends BarterState {
  final BarterTransactionEntity transaction;

  const TransactionCreated(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionLoaded extends BarterState {
  final BarterTransactionEntity transaction;

  const TransactionLoaded(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionsLoaded extends BarterState {
  final List<BarterTransactionEntity> transactions;
  final bool hasMore;
  final int currentPage;

  const TransactionsLoaded({
    required this.transactions,
    this.hasMore = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [transactions, hasMore, currentPage];
}

class TransactionUpdated extends BarterState {
  final BarterTransactionEntity transaction;

  const TransactionUpdated(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class DeliveryConfirmed extends BarterState {
  final BarterTransactionEntity transaction;

  const DeliveryConfirmed(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class ReceiptConfirmed extends BarterState {
  final BarterTransactionEntity transaction;

  const ReceiptConfirmed(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionCompleted extends BarterState {
  final BarterTransactionEntity transaction;

  const TransactionCompleted(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionCancelled extends BarterState {}

// Dispute States
class DisputeOpened extends BarterState {
  final BarterTransactionEntity transaction;

  const DisputeOpened(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class DisputeResolved extends BarterState {
  final BarterTransactionEntity transaction;

  const DisputeResolved(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

// Review States
class ReviewSubmitted extends BarterState {}

class ReviewLoaded extends BarterState {
  final Review review;

  const ReviewLoaded(this.review);

  @override
  List<Object?> get props => [review];
}

// Search States
class OffersSearched extends BarterState {
  final List<BarterOfferEntity> offers;
  final String query;

  const OffersSearched(this.offers, this.query);

  @override
  List<Object?> get props => [offers, query];
}

// Analytics States
class BarterStatsLoaded extends BarterState {
  final BarterStats stats;

  const BarterStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class TransactionStatsLoaded extends BarterState {
  final TransactionStats stats;

  const TransactionStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

// Error State
class BarterError extends BarterState {
  final String message;
  final String? code;

  const BarterError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}
