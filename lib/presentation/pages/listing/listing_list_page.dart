import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../blocs/listing/listing_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/listing_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/filter_sheet.dart';

class ListingListPage extends StatefulWidget {
  const ListingListPage({super.key});

  @override
  State<ListingListPage> createState() => _ListingListPageState();
}

class _ListingListPageState extends State<ListingListPage> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Load initial listings
    context.read<ListingBloc>().add(const GetListingsRequested());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreListings();
    }
  }

  void _loadMoreListings() {
    final currentState = context.read<ListingBloc>().state;
    if (currentState is ListingsLoaded && currentState.hasMore && !_isLoading) {
      setState(() => _isLoading = true);
      context.read<ListingBloc>().add(const LoadMoreListingsRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'listings'.tr(),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showFilterSheet,
            icon: Icon(
              Icons.filter_list,
              size: 24.w,
            ),
          ),
          IconButton(
            onPressed: _showSearchBar,
            icon: Icon(
              Icons.search,
              size: 24.w,
            ),
          ),
        ],
      ),
      body: BlocConsumer<ListingBloc, ListingState>(
        listener: (context, state) {
          if (state is ListingsLoading && state.isLoadMore) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }

          if (state is ListingError) {
            _showErrorDialog(state.message);
          }
        },
        builder: (context, state) {
          if (state is ListingLoading && state is! ListingsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ListingsLoaded) {
            if (state.listings.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: _refreshListings,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(AppDimensions.paddingM),
                itemCount: state.listings.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.listings.length) {
                    return _buildLoadingIndicator();
                  }

                  final listing = state.listings[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppDimensions.marginM),
                    child: ListingCard(
                      listing: listing,
                      onTap: () => _navigateToListingDetail(listing.id),
                      onFavoriteToggle: (isFavorite) {
                        if (isFavorite) {
                          context.read<ListingBloc>().add(
                            RemoveFromFavoritesRequested(listing.id),
                          );
                        } else {
                          context.read<ListingBloc>().add(
                            AddToFavoritesRequested(listing.id),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            );
          }

          return _buildEmptyState();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateListing,
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.add,
          size: 24.w,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80.w,
            color: AppColors.textMuted,
          ),
          SizedBox(height: AppDimensions.marginL),
          Text(
            'no_listings_found'.tr(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.marginS),
          Text(
            'be_first_to_create_listing'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDimensions.marginXXL),
          ElevatedButton.icon(
            onPressed: _navigateToCreateListing,
            icon: Icon(Icons.add, size: 20.w),
            label: Text('create_first_listing'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingXL,
                vertical: AppDimensions.paddingL,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      alignment: Alignment.center,
      child: SizedBox(
        width: 24.w,
        height: 24.w,
        child: CircularProgressIndicator(
          strokeWidth: 2.w,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );
  }

  void _showSearchBar() {
    showSearch(
      context: context,
      delegate: ListingSearchDelegate(
        onSearch: (query) {
          setState(() {
            _searchQuery = query;
          });
          _performSearch(query);
        },
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.borderRadiusL),
        ),
      ),
      builder: (context) => FilterSheet(
        onFiltersApplied: (filters) {
          // Apply filters to listings
          context.read<ListingBloc>().add(
            GetListingsRequested(params: filters),
          );
        },
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      context.read<ListingBloc>().add(const GetListingsRequested());
    } else {
      context.read<ListingBloc>().add(
        SearchListingsRequested(
          SearchListingsRequest(
            query: query,
            limit: 20,
          ),
        ),
      );
    }
  }

  Future<void> _refreshListings() async {
    context.read<ListingBloc>().add(const RefreshListingsRequested());
  }

  void _navigateToListingDetail(String listingId) {
    // TODO: Navigate to listing detail page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('navigate_to_listing_detail'.tr(args: [listingId])),
      ),
    );
  }

  void _navigateToCreateListing() {
    Navigator.pushNamed(context, '/create-listing');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('error'.tr()),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ok'.tr()),
          ),
        ],
      ),
    );
  }
}

// Search Delegate for listings
class ListingSearchDelegate extends SearchDelegate<String> {
  final Function(String) onSearch;

  ListingSearchDelegate({required this.onSearch});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          onSearch('');
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, ''),
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  String get searchFieldLabel => 'search_listings'.tr();
}
