import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/barter/create_offer_usecase.dart';
import '../../../domain/usecases/barter/accept_offer_usecase.dart';
import '../../../domain/usecases/barter/get_offers_usecase.dart';
import '../../../domain/usecases/barter/create_transaction_usecase.dart';
import '../../../domain/repositories/barter_repository.dart';
import 'barter_event.dart';
import 'barter_state.dart';

class BarterBloc extends Bloc<BarterEvent, BarterState> {
  final CreateOfferUseCase _createOfferUseCase;
  final AcceptOfferUseCase _acceptOfferUseCase;
  final GetOffersUseCase _getOffersUseCase;
  final CreateTransactionUseCase _createTransactionUseCase;
  final BarterRepository _barterRepository;

  BarterBloc({
    required CreateOfferUseCase createOfferUseCase,
    required AcceptOfferUseCase acceptOfferUseCase,
    required GetOffersUseCase getOffersUseCase,
    required CreateTransactionUseCase createTransactionUseCase,
    required BarterRepository barterRepository,
  })  : _createOfferUseCase = createOfferUseCase,
        _acceptOfferUseCase = acceptOfferUseCase,
        _getOffersUseCase = getOffersUseCase,
        _createTransactionUseCase = createTransactionUseCase,
        _barterRepository = barterRepository,
        super(BarterInitial()) {
    on<CreateOfferRequested>(_onCreateOfferRequested);
    on<GetOfferByIdRequested>(_onGetOfferByIdRequested);
    on<GetOffersByListingRequested>(_onGetOffersByListingRequested);
    on<GetOffersByUserRequested>(_onGetOffersByUserRequested);
    on<UpdateOfferRequested>(_onUpdateOfferRequested);
    on<DeleteOfferRequested>(_onDeleteOfferRequested);
    on<AcceptOfferRequested>(_onAcceptOfferRequested);
    on<RejectOfferRequested>(_onRejectOfferRequested);
    on<CounterOfferRequested>(_onCounterOfferRequested);
    on<CancelOfferRequested>(_onCancelOfferRequested);
    on<CreateTransactionRequested>(_onCreateTransactionRequested);
    on<GetTransactionByIdRequested>(_onGetTransactionByIdRequested);
    on<GetTransactionsByUserRequested>(_onGetTransactionsByUserRequested);
    on<UpdateTransactionRequested>(_onUpdateTransactionRequested);
    on<ConfirmDeliveryRequested>(_onConfirmDeliveryRequested);
    on<ConfirmReceiptRequested>(_onConfirmReceiptRequested);
    on<CompleteTransactionRequested>(_onCompleteTransactionRequested);
    on<CancelTransactionRequested>(_onCancelTransactionRequested);
    on<OpenDisputeRequested>(_onOpenDisputeRequested);
    on<ResolveDisputeRequested>(_onResolveDisputeRequested);
    on<SubmitReviewRequested>(_onSubmitReviewRequested);
    on<GetReviewRequested>(_onGetReviewRequested);
    on<SearchOffersRequested>(_onSearchOffersRequested);
    on<GetBarterStatsRequested>(_onGetBarterStatsRequested);
    on<GetTransactionStatsRequested>(_onGetTransactionStatsRequested);
    on<RefreshOffersRequested>(_onRefreshOffersRequested);
    on<LoadMoreOffersRequested>(_onLoadMoreOffersRequested);
  }

  Future<void> _onCreateOfferRequested(
    CreateOfferRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _createOfferUseCase.call(event.request);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (offer) => emit(OfferCreated(offer)),
    );
  }

  Future<void> _onGetOfferByIdRequested(
    GetOfferByIdRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.getOfferById(event.offerId);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (offer) => emit(OfferLoaded(offer)),
    );
  }

  Future<void> _onGetOffersByListingRequested(
    GetOffersByListingRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(OffersLoading());

    final result = await _barterRepository.getOffersByListing(event.listingId);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (offers) => emit(OffersLoaded(offers: offers)),
    );
  }

  Future<void> _onGetOffersByUserRequested(
    GetOffersByUserRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(OffersLoading());

    final result = await _barterRepository.getOffersByUser(
      event.userId,
      filter: event.filter,
    );

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (offers) => emit(OffersLoaded(offers: offers)),
    );
  }

  Future<void> _onUpdateOfferRequested(
    UpdateOfferRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.updateOffer(event.offerId, event.request);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (offer) => emit(OfferUpdated(offer)),
    );
  }

  Future<void> _onDeleteOfferRequested(
    DeleteOfferRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.deleteOffer(event.offerId);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (_) => emit(OfferDeleted()),
    );
  }

  Future<void> _onAcceptOfferRequested(
    AcceptOfferRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _acceptOfferUseCase.call(event.offerId);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (offer) => emit(OfferAccepted(offer)),
    );
  }

  Future<void> _onRejectOfferRequested(
    RejectOfferRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.rejectOffer(event.offerId, event.reason);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (offer) => emit(OfferRejected(offer)),
    );
  }

  Future<void> _onCounterOfferRequested(
    CounterOfferRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.counterOffer(event.offerId, event.request);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (offer) => emit(OfferCountered(offer)),
    );
  }

  Future<void> _onCancelOfferRequested(
    CancelOfferRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.cancelOffer(event.offerId);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (offer) => emit(OfferCancelled()),
    );
  }

  Future<void> _onCreateTransactionRequested(
    CreateTransactionRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _createTransactionUseCase.call(event.request);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (transaction) => emit(TransactionCreated(transaction)),
    );
  }

  Future<void> _onGetTransactionByIdRequested(
    GetTransactionByIdRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.getTransactionById(event.transactionId);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (transaction) => emit(TransactionLoaded(transaction)),
    );
  }

  Future<void> _onGetTransactionsByUserRequested(
    GetTransactionsByUserRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(TransactionsLoading());

    final result = await _barterRepository.getTransactionsByUser(
      event.userId,
      filter: event.filter,
    );

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (transactions) => emit(TransactionsLoaded(transactions: transactions)),
    );
  }

  Future<void> _onUpdateTransactionRequested(
    UpdateTransactionRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.updateTransaction(event.transactionId, event.request);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (transaction) => emit(TransactionUpdated(transaction)),
    );
  }

  Future<void> _onConfirmDeliveryRequested(
    ConfirmDeliveryRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.confirmDelivery(event.transactionId, event.request);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (transaction) => emit(DeliveryConfirmed(transaction)),
    );
  }

  Future<void> _onConfirmReceiptRequested(
    ConfirmReceiptRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.confirmReceipt(event.transactionId, event.request);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (transaction) => emit(ReceiptConfirmed(transaction)),
    );
  }

  Future<void> _onCompleteTransactionRequested(
    CompleteTransactionRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.completeTransaction(event.transactionId);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (transaction) => emit(TransactionCompleted(transaction)),
    );
  }

  Future<void> _onCancelTransactionRequested(
    CancelTransactionRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.cancelTransaction(event.transactionId, event.reason);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (transaction) => emit(TransactionCancelled()),
    );
  }

  Future<void> _onOpenDisputeRequested(
    OpenDisputeRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.openDispute(event.transactionId, event.request);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (transaction) => emit(DisputeOpened(transaction)),
    );
  }

  Future<void> _onResolveDisputeRequested(
    ResolveDisputeRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.resolveDispute(event.transactionId, event.request);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (transaction) => emit(DisputeResolved(transaction)),
    );
  }

  Future<void> _onSubmitReviewRequested(
    SubmitReviewRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.submitReview(event.transactionId, event.request);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (_) => emit(ReviewSubmitted()),
    );
  }

  Future<void> _onGetReviewRequested(
    GetReviewRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.getReview(event.reviewId);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (review) => emit(ReviewLoaded(review)),
    );
  }

  Future<void> _onSearchOffersRequested(
    SearchOffersRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(OffersLoading());

    final result = await _barterRepository.searchOffers(event.request);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (offers) => emit(OffersSearched(offers, event.request.query)),
    );
  }

  Future<void> _onGetBarterStatsRequested(
    GetBarterStatsRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.getBarterStats(event.userId);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (stats) => emit(BarterStatsLoaded(stats)),
    );
  }

  Future<void> _onGetTransactionStatsRequested(
    GetTransactionStatsRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterLoading());

    final result = await _barterRepository.getTransactionStats(event.userId);

    result.fold(
      (failure) => emit(BarterError(failure.message)),
      (stats) => emit(TransactionStatsLoaded(stats)),
    );
  }

  Future<void> _onRefreshOffersRequested(
    RefreshOffersRequested event,
    Emitter<BarterState> emit,
  ) async {
    emit(BarterInitial());
  }

  Future<void> _onLoadMoreOffersRequested(
    LoadMoreOffersRequested event,
    Emitter<BarterState> emit,
  ) async {
    final currentState = state;
    if (currentState is OffersLoaded && currentState.hasMore) {
      emit(OffersLoading(isLoadMore: true));

      final result = await _getOffersUseCase.call(
        listingId: event.listingId,
        userId: event.userId,
        filter: event.filter,
        page: currentState.currentPage + 1,
        limit: 20,
      );

      result.fold(
        (failure) => emit(BarterError(failure.message)),
        (offers) => emit(OffersLoaded(
          offers: [...currentState.offers, ...offers],
          currentPage: currentState.currentPage + 1,
          hasMore: offers.length == 20,
        )),
      );
    }
  }
}
