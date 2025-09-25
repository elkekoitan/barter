import 'package:equatable/equatable.dart';
import '../../../domain/entities/listing.dart';

abstract class ListingState extends Equatable {
  const ListingState();

  @override
  List<Object?> get props => [];
}

class ListingInitial extends ListingState {}

class ListingLoading extends ListingState {}

class ListingsLoading extends ListingState {
  final bool isLoadMore;

  const ListingsLoading({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

class ListingLoaded extends ListingState {
  final ListingEntity listing;

  const ListingLoaded(this.listing);

  @override
  List<Object?> get props => [listing];
}

class ListingsLoaded extends ListingState {
  final List<ListingEntity> listings;
  final bool hasMore;
  final int currentPage;
  final bool isLoadMore;

  const ListingsLoaded({
    required this.listings,
    this.hasMore = true,
    this.currentPage = 1,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [listings, hasMore, currentPage, isLoadMore];
}

class ListingCreated extends ListingState {
  final ListingEntity listing;

  const ListingCreated(this.listing);

  @override
  List<Object?> get props => [listing];
}

class ListingUpdated extends ListingState {
  final ListingEntity listing;

  const ListingUpdated(this.listing);

  @override
  List<Object?> get props => [listing];
}

class ListingDeleted extends ListingState {}

class ListingError extends ListingState {
  final String message;
  final String? code;

  const ListingError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

class CategoriesLoaded extends ListingState {
  final List<CategoryEntity> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoryLoaded extends ListingState {
  final CategoryEntity category;

  const CategoryLoaded(this.category);

  @override
  List<Object?> get props => [category];
}

class MediaUploaded extends ListingState {
  final List<String> mediaUrls;

  const MediaUploaded(this.mediaUrls);

  @override
  List<Object?> get props => [mediaUrls];
}

class MediaDeleted extends ListingState {}

class MediaReordered extends ListingState {}

class AddedToFavorites extends ListingState {
  final String listingId;

  const AddedToFavorites(this.listingId);

  @override
  List<Object?> get props => [listingId];
}

class RemovedFromFavorites extends ListingState {
  final String listingId;

  const RemovedFromFavorites(this.listingId);

  @override
  List<Object?> get props => [listingId];
}

class FavoriteListingsLoaded extends ListingState {
  final List<ListingEntity> listings;
  final bool hasMore;
  final int currentPage;

  const FavoriteListingsLoaded({
    required this.listings,
    this.hasMore = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [listings, hasMore, currentPage];
}

class ListingBoosted extends ListingState {
  final ListingEntity listing;

  const ListingBoosted(this.listing);

  @override
  List<Object?> get props => [listing];
}

class BoostCancelled extends ListingState {}

class SubmittedForModeration extends ListingState {
  final ListingEntity listing;

  const SubmittedForModeration(this.listing);

  @override
  List<Object?> get props => [listing];
}

class ListingStatsLoaded extends ListingState {
  final ListingStatsResponse stats;

  const ListingStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class ViewCountIncremented extends ListingState {
  final int newCount;

  const ViewCountIncremented(this.newCount);

  @override
  List<Object?> get props => [newCount];
}
