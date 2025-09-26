import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../domain/entities/barter_offer.dart';
import '../../../domain/entities/barter_transaction.dart';

abstract class BarterRemoteDataSource {
  Future<BarterOfferEntity> createOffer(BarterOfferEntity offer);
  Future<BarterOfferEntity> getOfferById(String offerId);
  Future<List<BarterOfferEntity>> getOffersByListingId(String listingId);
  Future<List<BarterOfferEntity>> getOffersByUserId(String userId);
  Future<BarterOfferEntity> updateOfferStatus(String offerId, String status);
  Future<BarterTransactionEntity> createTransaction(BarterTransactionEntity transaction);
  Future<BarterTransactionEntity> getTransactionById(String transactionId);
  Future<List<BarterTransactionEntity>> getTransactionsByUserId(String userId);
  Future<BarterTransactionEntity> updateTransactionStatus(String transactionId, String status);
}

class BarterRemoteDataSourceImpl implements BarterRemoteDataSource {
  final ApiClient _apiClient;

  BarterRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BarterOfferEntity> createOffer(BarterOfferEntity offer) async {
    final response = await _apiClient.post<Map<String, dynamic>>('/barter/offers', data: _mapOfferFromEntity(offer));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return _mapOfferToEntity(response.data!['data']);
    }
    throw Exception('Failed to create offer');
  }

  @override
  Future<BarterOfferEntity> getOfferById(String offerId) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/barter/offers/$offerId');
    if (response.statusCode == 200) {
      return _mapOfferToEntity(response.data!['data']);
    }
    throw Exception('Failed to get offer');
  }

  @override
  Future<List<BarterOfferEntity>> getOffersByListingId(String listingId) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/barter/offers', queryParameters: {'listingId': listingId});
    if (response.statusCode == 200) {
      final List offers = response.data!['data'];
      return offers.map((offer) => _mapOfferToEntity(offer)).toList();
    }
    throw Exception('Failed to get offers');
  }

  @override
  Future<List<BarterOfferEntity>> getOffersByUserId(String userId) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/barter/offers', queryParameters: {'userId': userId});
    if (response.statusCode == 200) {
      final List offers = response.data!['data'];
      return offers.map((offer) => _mapOfferToEntity(offer)).toList();
    }
    throw Exception('Failed to get offers');
  }

  @override
  Future<BarterOfferEntity> updateOfferStatus(String offerId, String status) async {
    final response = await _apiClient.patch<Map<String, dynamic>>('/barter/offers/$offerId/status', data: {'status': status});
    if (response.statusCode == 200) {
      return _mapOfferToEntity(response.data!['data']);
    }
    throw Exception('Failed to update offer status');
  }

  @override
  Future<BarterTransactionEntity> createTransaction(BarterTransactionEntity transaction) async {
    final response = await _apiClient.post<Map<String, dynamic>>('/barter/transactions', data: _mapTransactionFromEntity(transaction));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return _mapTransactionToEntity(response.data!['data']);
    }
    throw Exception('Failed to create transaction');
  }

  @override
  Future<BarterTransactionEntity> getTransactionById(String transactionId) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/barter/transactions/$transactionId');
    if (response.statusCode == 200) {
      return _mapTransactionToEntity(response.data!['data']);
    }
    throw Exception('Failed to get transaction');
  }

  @override
  Future<List<BarterTransactionEntity>> getTransactionsByUserId(String userId) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/barter/transactions', queryParameters: {'userId': userId});
    if (response.statusCode == 200) {
      final List transactions = response.data!['data'];
      return transactions.map((transaction) => _mapTransactionToEntity(transaction)).toList();
    }
    throw Exception('Failed to get transactions');
  }

  @override
  Future<BarterTransactionEntity> updateTransactionStatus(String transactionId, String status) async {
    final response = await _apiClient.patch<Map<String, dynamic>>('/barter/transactions/$transactionId/status', data: {'status': status});
    if (response.statusCode == 200) {
      return _mapTransactionToEntity(response.data!['data']);
    }
    throw Exception('Failed to update transaction status');
  }

  // Private helper methods
  Map<String, dynamic> _mapOfferFromEntity(BarterOfferEntity offer) {
    return {
      'listingId': offer.listingId,
      'buyerId': offer.buyerId,
      'sellerId': offer.sellerId,
      'offer': {
        'items': offer.offer.items.map((item) => {
          'listingId': item.listingId,
          'title': item.title,
          'imageUrl': item.imageUrl,
          'estimatedValue': item.estimatedValue,
          'currency': item.currency,
          'condition': item.condition,
          'description': item.description,
        }).toList(),
        'totalValue': offer.offer.totalValue,
      },
      'type': offer.type.value,
      'status': offer.status.value,
      'message': offer.message,
    };
  }

  BarterOfferEntity _mapOfferToEntity(Map<String, dynamic> data) {
    // Simplified implementation for basic functionality
    return BarterOfferEntity(
      id: data['id'] ?? '',
      listingId: data['listingId'] ?? '',
      buyerId: data['buyerId'] ?? '',
      sellerId: data['sellerId'] ?? '',
      type: OfferType.fromString(data['type'] ?? 'direct'),
      offer: OfferDetails(
        items: [],
        totalValue: 0.0,
      ),
      status: OfferStatus.fromString(data['status'] ?? 'pending'),
      message: data['message'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
    );
  }

  Map<String, dynamic> _mapTransactionFromEntity(BarterTransactionEntity transaction) {
    return {
      'offerId': transaction.offerId,
      'status': transaction.status.value,
      'completedAt': transaction.completedAt?.toIso8601String(),
    };
  }

  BarterTransactionEntity _mapTransactionToEntity(Map<String, dynamic> data) {
    // Simplified implementation for basic functionality
    return BarterTransactionEntity(
      id: data['id'] ?? '',
      offerId: data['offerId'] ?? '',
      parties: TransactionParties(
        buyerId: data['buyerId'] ?? '',
        sellerId: data['sellerId'] ?? '',
        seller: SellerInfo(
          userId: data['sellerId'] ?? '',
          name: 'Seller',
          phone: '',
          email: '',
          location: TransactionLocation(
            city: '',
            district: '',
          ),
          rating: 5.0,
          completedTransactions: 0,
        ),
        buyer: BuyerInfo(
          userId: data['buyerId'] ?? '',
          name: 'Buyer',
          phone: '',
          email: '',
          location: TransactionLocation(
            city: '',
            district: '',
          ),
          rating: 5.0,
          completedTransactions: 0,
        ),
      ),
      items: TransactionItems(
        fromSeller: [],
        fromBuyer: [],
      ),
      payment: TransactionPayment(
        amount: 0.0,
        method: 'cash',
        status: PaymentStatus.pending,
        commission: CommissionInfo(
          percentage: 0.0,
          amount: 0.0,
        ),
      ),
      delivery: TransactionDelivery(
        method: DeliveryMethod.inPerson,
        status: DeliveryStatus.notShipped,
      ),
      status: TransactionStatus.fromString(data['status'] ?? 'pending'),
      timeline: [
        TransactionTimeline(
          event: 'created',
          timestamp: DateTime.parse(data['createdAt']),
          description: 'Transaction created',
        ),
      ],
      metadata: TransactionMetadata(
        notes: data['notes'],
        customFields: {},
      ),
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      completedAt: data['completedAt'] != null ? DateTime.parse(data['completedAt']) : null,
    );
  }
}