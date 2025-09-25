import 'package:equatable/equatable.dart';
import '../../../domain/repositories/listing_repository.dart';

abstract class ListingEvent extends Equatable {
  const ListingEvent();

  @override
  List<Object?> get props => [];
}

class CreateListingRequested extends ListingEvent {
  final CreateListingRequest request;

  const CreateListingRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class GetListingByIdRequested extends ListingEvent {
  final String listingId;

  const GetListingByIdRequested(this.listingId);

  @override
  List<Object?> get props => [listingId];
}

class GetListingsRequested extends ListingEvent {
  final ListingQueryParams? params;
  final int page;
  final int limit;

  const GetListingsRequested({
    this.params,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [params, page, limit];
}

class GetUserListingsRequested extends ListingEvent {
  final String userId;
  final ListingStatus? status;
  final int page;
  final int limit;

  const GetUserListingsRequested({
    required this.userId,
    this.status,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [userId, status, page, limit];
}

class UpdateListingRequested extends ListingEvent {
  final String listingId;
  final UpdateListingRequest request;

  const UpdateListingRequested(this.listingId, this.request);

  @override
  List<Object?> get props => [listingId, request];
}

class DeleteListingRequested extends ListingEvent {
  final String listingId;

  const DeleteListingRequested(this.listingId);

  @override
  List<Object?> get props => [listingId];
}

class SearchListingsRequested extends ListingEvent {
  final SearchListingsRequest request;

  const SearchListingsRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class GetListingsByCategoryRequested extends ListingEvent {
  final String categoryId;
  final ListingQueryParams? params;
  final int page;
  final int limit;

  const GetListingsByCategoryRequested({
    required this.categoryId,
    this.params,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [categoryId, params, page, limit];
}

class AddToFavoritesRequested extends ListingEvent {
  final String listingId;

  const AddToFavoritesRequested(this.listingId);

  @override
  List<Object?> get props => [listingId];
}

class RemoveFromFavoritesRequested extends ListingEvent {
  final String listingId;

  const RemoveFromFavoritesRequested(this.listingId);

  @override
  List<Object?> get props => [listingId];
}

class GetFavoriteListingsRequested extends ListingEvent {
  final String userId;
  final int page;
  final int limit;

  const GetFavoriteListingsRequested({
    required this.userId,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [userId, page, limit];
}

class BoostListingRequested extends ListingEvent {
  final String listingId;
  final BoostRequest request;

  const BoostListingRequested(this.listingId, this.request);

  @override
  List<Object?> get props => [listingId, request];
}

class CancelBoostRequested extends ListingEvent {
  final String listingId;

  const CancelBoostRequested(this.listingId);

  @override
  List<Object?> get props => [listingId];
}

class SubmitForModerationRequested extends ListingEvent {
  final String listingId;

  const SubmitForModerationRequested(this.listingId);

  @override
  List<Object?> get props => [listingId];
}

class GetCategoriesRequested extends ListingEvent {
  final String? parentId;

  const GetCategoriesRequested({this.parentId});

  @override
  List<Object?> get props => [parentId];
}

class GetCategoryByIdRequested extends ListingEvent {
  final String categoryId;

  const GetCategoryByIdRequested(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class UploadMediaRequested extends ListingEvent {
  final List<String> filePaths;

  const UploadMediaRequested(this.filePaths);

  @override
  List<Object?> get props => [filePaths];
}

class DeleteMediaRequested extends ListingEvent {
  final String mediaId;

  const DeleteMediaRequested(this.mediaId);

  @override
  List<Object?> get props => [mediaId];
}

class ReorderMediaRequested extends ListingEvent {
  final String listingId;
  final List<String> mediaIds;

  const ReorderMediaRequested(this.listingId, this.mediaIds);

  @override
  List<Object?> get props => [listingId, mediaIds];
}

class IncrementViewCountRequested extends ListingEvent {
  final String listingId;

  const IncrementViewCountRequested(this.listingId);

  @override
  List<Object?> get props => [listingId];
}

class GetListingStatsRequested extends ListingEvent {
  final String listingId;

  const GetListingStatsRequested(this.listingId);

  @override
  List<Object?> get props => [listingId];
}

class RefreshListingsRequested extends ListingEvent {}

class LoadMoreListingsRequested extends ListingEvent {
  final ListingQueryParams? params;

  const LoadMoreListingsRequested({this.params});

  @override
  List<Object?> get props => [params];
}
