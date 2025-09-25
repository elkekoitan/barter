import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/listing/create_listing_usecase.dart';
import '../../../domain/usecases/listing/get_listings_usecase.dart';
import '../../../domain/usecases/listing/update_listing_usecase.dart';
import '../../../domain/usecases/listing/delete_listing_usecase.dart';
import '../../../domain/repositories/listing_repository.dart';
import 'listing_event.dart';
import 'listing_state.dart';

class ListingBloc extends Bloc<ListingEvent, ListingState> {
  final CreateListingUseCase _createListingUseCase;
  final GetListingsUseCase _getListingsUseCase;
  final UpdateListingUseCase _updateListingUseCase;
  final DeleteListingUseCase _deleteListingUseCase;
  final ListingRepository _listingRepository;

  ListingBloc({
    required CreateListingUseCase createListingUseCase,
    required GetListingsUseCase getListingsUseCase,
    required UpdateListingUseCase updateListingUseCase,
    required DeleteListingUseCase deleteListingUseCase,
    required ListingRepository listingRepository,
  })  : _createListingUseCase = createListingUseCase,
        _getListingsUseCase = getListingsUseCase,
        _updateListingUseCase = updateListingUseCase,
        _deleteListingUseCase = deleteListingUseCase,
        _listingRepository = listingRepository,
        super(ListingInitial()) {
    on<CreateListingRequested>(_onCreateListingRequested);
    on<GetListingByIdRequested>(_onGetListingByIdRequested);
    on<GetListingsRequested>(_onGetListingsRequested);
    on<GetUserListingsRequested>(_onGetUserListingsRequested);
    on<UpdateListingRequested>(_onUpdateListingRequested);
    on<DeleteListingRequested>(_onDeleteListingRequested);
    on<SearchListingsRequested>(_onSearchListingsRequested);
    on<GetListingsByCategoryRequested>(_onGetListingsByCategoryRequested);
    on<AddToFavoritesRequested>(_onAddToFavoritesRequested);
    on<RemoveFromFavoritesRequested>(_onRemoveFromFavoritesRequested);
    on<GetFavoriteListingsRequested>(_onGetFavoriteListingsRequested);
    on<BoostListingRequested>(_onBoostListingRequested);
    on<CancelBoostRequested>(_onCancelBoostRequested);
    on<SubmitForModerationRequested>(_onSubmitForModerationRequested);
    on<GetCategoriesRequested>(_onGetCategoriesRequested);
    on<GetCategoryByIdRequested>(_onGetCategoryByIdRequested);
    on<UploadMediaRequested>(_onUploadMediaRequested);
    on<DeleteMediaRequested>(_onDeleteMediaRequested);
    on<ReorderMediaRequested>(_onReorderMediaRequested);
    on<IncrementViewCountRequested>(_onIncrementViewCountRequested);
    on<GetListingStatsRequested>(_onGetListingStatsRequested);
    on<RefreshListingsRequested>(_onRefreshListingsRequested);
    on<LoadMoreListingsRequested>(_onLoadMoreListingsRequested);
  }

  Future<void> _onCreateListingRequested(
    CreateListingRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());

    final result = await _createListingUseCase.call(event.request);

    result.fold(
      (failure) => emit(ListingError(failure.message, code: failure.toString())),
      (listing) => emit(ListingCreated(listing)),
    );
  }

  Future<void> _onGetListingByIdRequested(
    GetListingByIdRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());

    final result = await _listingRepository.getListingById(event.listingId);

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (listing) => emit(ListingLoaded(listing)),
    );
  }

  Future<void> _onGetListingsRequested(
    GetListingsRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingsLoading());

    final result = await _getListingsUseCase.call(
      params: event.params,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (listings) => emit(ListingsLoaded(
        listings: listings,
        currentPage: event.page,
        hasMore: listings.length == event.limit,
      )),
    );
  }

  Future<void> _onGetUserListingsRequested(
    GetUserListingsRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingsLoading());

    final result = await _listingRepository.getUserListings(
      event.userId,
      status: event.status,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (listings) => emit(ListingsLoaded(
        listings: listings,
        currentPage: event.page,
        hasMore: listings.length == event.limit,
      )),
    );
  }

  Future<void> _onUpdateListingRequested(
    UpdateListingRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());

    final result = await _updateListingUseCase.call(event.listingId, event.request);

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (listing) => emit(ListingUpdated(listing)),
    );
  }

  Future<void> _onDeleteListingRequested(
    DeleteListingRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());

    final result = await _deleteListingUseCase.call(event.listingId);

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (_) => emit(ListingDeleted()),
    );
  }

  Future<void> _onSearchListingsRequested(
    SearchListingsRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingsLoading());

    final result = await _listingRepository.searchListings(event.request);

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (listings) => emit(ListingsLoaded(
        listings: listings,
        currentPage: event.request.page,
        hasMore: listings.length == event.request.limit,
      )),
    );
  }

  Future<void> _onGetListingsByCategoryRequested(
    GetListingsByCategoryRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingsLoading());

    final result = await _listingRepository.getListingsByCategory(
      event.categoryId,
      params: event.params,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (listings) => emit(ListingsLoaded(
        listings: listings,
        currentPage: event.page,
        hasMore: listings.length == event.limit,
      )),
    );
  }

  Future<void> _onAddToFavoritesRequested(
    AddToFavoritesRequested event,
    Emitter<ListingState> emit,
  ) async {
    final result = await _listingRepository.addToFavorites(event.listingId);

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (_) => emit(const AddedToFavorites(event.listingId)),
    );
  }

  Future<void> _onRemoveFromFavoritesRequested(
    RemoveFromFavoritesRequested event,
    Emitter<ListingState> emit,
  ) async {
    final result = await _listingRepository.removeFromFavorites(event.listingId);

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (_) => emit(const RemovedFromFavorites(event.listingId)),
    );
  }

  Future<void> _onGetFavoriteListingsRequested(
    GetFavoriteListingsRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingsLoading());

    final result = await _listingRepository.getFavoriteListings(
      event.userId,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (listings) => emit(FavoriteListingsLoaded(
        listings: listings,
        currentPage: event.page,
        hasMore: listings.length == event.limit,
      )),
    );
  }

  Future<void> _onBoostListingRequested(
    BoostListingRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());

    final result = await _listingRepository.boostListing(event.listingId, event.request);

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (listing) => emit(ListingBoosted(listing)),
    );
  }

  Future<void> _onCancelBoostRequested(
    CancelBoostRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());

    final result = await _listingRepository.cancelBoost(event.listingId);

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (listing) => emit(BoostCancelled()),
    );
  }

  Future<void> _onSubmitForModerationRequested(
    SubmitForModerationRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());

    final result = await _listingRepository.submitForModeration(event.listingId);

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (listing) => emit(SubmittedForModeration(listing)),
    );
  }

  Future<void> _onGetCategoriesRequested(
    GetCategoriesRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());

    final result = await _listingRepository.getCategories(parentId: event.parentId);

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }

  Future<void> _onGetCategoryByIdRequested(
    GetCategoryByIdRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());

    final result = await _listingRepository.getCategoryById(event.categoryId);

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (category) => emit(CategoryLoaded(category)),
    );
  }

  Future<void> _onUploadMediaRequested(
    UploadMediaRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());

    final result = await _listingRepository.uploadMedia(event.filePaths);

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (mediaUrls) => emit(MediaUploaded(mediaUrls)),
    );
  }

  Future<void> _onDeleteMediaRequested(
    DeleteMediaRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());

    final result = await _listingRepository.deleteMedia(event.mediaId);

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (_) => emit(MediaDeleted()),
    );
  }

  Future<void> _onReorderMediaRequested(
    ReorderMediaRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());

    final result = await _listingRepository.reorderMedia(event.listingId, event.mediaIds);

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (_) => emit(MediaReordered()),
    );
  }

  Future<void> _onIncrementViewCountRequested(
    IncrementViewCountRequested event,
    Emitter<ListingState> emit,
  ) async {
    final result = await _listingRepository.incrementViewCount(event.listingId);

    result.fold(
      (failure) {
        // View count increment failed, but this shouldn't affect UI
        debugPrint('View count increment failed: ${failure.message}');
      },
      (stats) => emit(ViewCountIncremented(stats.viewCount)),
    );
  }

  Future<void> _onGetListingStatsRequested(
    GetListingStatsRequested event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());

    final result = await _listingRepository.getListingStats(event.listingId);

    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (stats) => emit(ListingStatsLoaded(stats)),
    );
  }

  Future<void> _onRefreshListingsRequested(
    RefreshListingsRequested event,
    Emitter<ListingState> emit,
  ) async {
    // This will refresh the current listings
    // The actual implementation depends on the current state
    emit(ListingInitial());
  }

  Future<void> _onLoadMoreListingsRequested(
    LoadMoreListingsRequested event,
    Emitter<ListingState> emit,
  ) async {
    final currentState = state;
    if (currentState is ListingsLoaded && currentState.hasMore) {
      emit(ListingsLoading(isLoadMore: true));

      final result = await _getListingsUseCase.call(
        params: event.params,
        page: currentState.currentPage + 1,
        limit: 20,
      );

      result.fold(
        (failure) => emit(ListingError(failure.message)),
        (listings) => emit(ListingsLoaded(
          listings: [...currentState.listings, ...listings],
          currentPage: currentState.currentPage + 1,
          hasMore: listings.length == 20,
          isLoadMore: false,
        )),
      );
    }
  }
}
