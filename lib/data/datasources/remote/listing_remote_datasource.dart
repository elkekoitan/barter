import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../domain/entities/listing.dart';

abstract class ListingRemoteDataSource {
  Future<ListingEntity> createListing(ListingEntity listing);
  Future<ListingEntity> getListingById(String listingId);
  Future<List<ListingEntity>> getListings({String? category, String? location});
  Future<ListingEntity> updateListing(String listingId, ListingEntity listing);
  Future<void> deleteListing(String listingId);
  Future<List<ListingEntity>> searchListings(String query);
}

class ListingRemoteDataSourceImpl implements ListingRemoteDataSource {
  final ApiClient _apiClient;

  ListingRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ListingEntity> createListing(ListingEntity listing) async {
    final response = await _apiClient.post<Map<String, dynamic>>('/listings', data: _mapFromEntity(listing));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return _mapToEntity(response.data!['data']);
    }
    throw Exception('Failed to create listing');
  }

  @override
  Future<ListingEntity> getListingById(String listingId) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/listings/$listingId');
    if (response.statusCode == 200) {
      return _mapToEntity(response.data!['data']);
    }
    throw Exception('Failed to get listing');
  }

  @override
  Future<List<ListingEntity>> getListings({String? category, String? location}) async {
    final queryParams = <String, dynamic>{};
    if (category != null) queryParams['category'] = category;
    if (location != null) queryParams['location'] = location;

    final response = await _apiClient.get<Map<String, dynamic>>('/listings', queryParameters: queryParams);
    if (response.statusCode == 200) {
      final List listings = response.data!['data'];
      return listings.map((listing) => _mapToEntity(listing)).toList();
    }
    throw Exception('Failed to get listings');
  }

  @override
  Future<ListingEntity> updateListing(String listingId, ListingEntity listing) async {
    final response = await _apiClient.patch<Map<String, dynamic>>('/listings/$listingId', data: _mapFromEntity(listing));
    if (response.statusCode == 200) {
      return _mapToEntity(response.data!['data']);
    }
    throw Exception('Failed to update listing');
  }

  @override
  Future<void> deleteListing(String listingId) async {
    final response = await _apiClient.delete('/listings/$listingId');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete listing');
    }
  }

  @override
  Future<List<ListingEntity>> searchListings(String query) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/listings/search', queryParameters: {'q': query});
    if (response.statusCode == 200) {
      final List listings = response.data!['data'];
      return listings.map((listing) => _mapToEntity(listing)).toList();
    }
    throw Exception('Failed to search listings');
  }

  Map<String, dynamic> _mapFromEntity(ListingEntity listing) {
    return {
      'title': listing.title,
      'description': listing.description,
      'price': listing.price,
      'currency': listing.currency,
      'category': listing.category,
      'condition': listing.condition,
      'location': listing.location,
      'images': listing.images,
      'userId': listing.userId,
      'isActive': listing.isActive,
    };
  }

  ListingEntity _mapToEntity(Map<String, dynamic> data) {
    return ListingEntity(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      price: data['price'].toDouble(),
      currency: data['currency'],
      category: data['category'],
      condition: data['condition'],
      location: data['location'],
      images: List<String>.from(data['images'] ?? []),
      userId: data['userId'],
      isActive: data['isActive'] ?? true,
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
    );
  }
}
