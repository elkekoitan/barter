import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../domain/entities/barter_offer.dart';
import '../../../domain/entities/barter_transaction.dart';
import '../../../domain/repositories/barter_repository.dart';

abstract class BarterRemoteDataSource {
  Future<BarterOfferEntity> createOffer(BarterOfferEntity offer);
  Future<BarterOfferEntity> createOfferFromRequest(CreateOfferRequest request);
  Future<BarterTransactionEntity> createTransactionFromRequest(CreateTransactionRequest request);
  Future<BarterOfferEntity> getOfferById(String offerId);
  Future<List<BarterOfferEntity>> getOffersByListingId(String listingId);
  Future<List<BarterOfferEntity>> getOffersByUserId(String userId);
  Future<List<BarterOfferEntity>> getOffersByListing(String listingId);
  Future<List<BarterOfferEntity>> getOffersByUser(String userId, {OfferFilter? filter});
  Future<BarterOfferEntity> updateOfferStatus(String offerId, String status);
  Future<BarterOfferEntity> updateOffer(String offerId, UpdateOfferRequest request);
  Future<void> deleteOffer(String offerId);
  Future<BarterOfferEntity> counterOffer(String offerId, CounterOfferRequest request);
  Future<BarterTransactionEntity> createTransaction(BarterTransactionEntity transaction);
  Future<BarterTransactionEntity> getTransactionById(String transactionId);
  Future<List<BarterTransactionEntity>> getTransactionsByUserId(String userId);
  Future<List<BarterTransactionEntity>> getTransactionsByUser(String userId, {TransactionFilter? filter});
  Future<BarterTransactionEntity> updateTransaction(String transactionId, UpdateTransactionRequest request);
  Future<BarterTransactionEntity> updateTransactionStatus(String transactionId, String status);
  Future<BarterTransactionEntity> confirmDelivery(String transactionId, DeliveryConfirmationRequest request);
  Future<BarterTransactionEntity> confirmReceipt(String transactionId, ReceiptConfirmationRequest request);
  Future<BarterTransactionEntity> completeTransaction(String transactionId);
  Future<BarterTransactionEntity> cancelTransaction(String transactionId, String reason);
  Future<BarterTransactionEntity> openDispute(String transactionId, DisputeRequest request);
  Future<BarterTransactionEntity> resolveDispute(String transactionId, DisputeResolutionRequest request);
  Future<void> submitReview(String transactionId, ReviewRequest request);
  Future<Review> getReview(String reviewId);
  Future<List<BarterOfferEntity>> searchOffers(SearchOffersRequest request);
  Future<BarterStats> getBarterStats(String userId);
  Future<TransactionStats> getTransactionStats(String userId);
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
  Future<BarterOfferEntity> createOfferFromRequest(CreateOfferRequest request) async {
    // Convert CreateOfferRequest to BarterOfferEntity
    final offer = BarterOfferEntity(
      id: '', // Will be set by backend
      listingId: request.listingId,
      buyerId: request.buyerId,
      sellerId: '', // Will be determined from listing
      type: request.type,
      offer: OfferDetails(
        items: request.offer.items.map((item) => OfferItem(
          listingId: item.listingId,
          title: 'Item', // Placeholder
          imageUrl: '', // Placeholder
          estimatedValue: item.estimatedValue,
          currency: 'TRY', // Placeholder
          condition: 'good', // Placeholder
          description: '', // Placeholder
        )).toList(),
        totalValue: request.offer.items.fold(0.0, (sum, item) => sum + item.estimatedValue),
      ),
      status: OfferStatus.pending,
      message: request.message,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return createOffer(offer);
  }

  @override
  Future<BarterTransactionEntity> createTransactionFromRequest(CreateTransactionRequest request) async {
    // First, get the offer to retrieve buyer and seller IDs
    final offer = await getOfferById(request.offerId);
    
    // Convert CreateTransactionRequest to BarterTransactionEntity
    final transaction = BarterTransactionEntity(
      id: '', // Will be set by backend
      offerId: request.offerId,
      parties: TransactionParties(
        buyerId: offer.buyerId,
        sellerId: offer.sellerId,
        seller: SellerInfo(
          userId: offer.sellerId,
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
          userId: offer.buyerId,
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
      delivery: request.deliveryInfo ?? TransactionDelivery(
        method: DeliveryMethod.inPerson,
        status: DeliveryStatus.notShipped,
      ),
      status: TransactionStatus.initiated,
      timeline: [
        TransactionTimeline(
          event: 'created',
          timestamp: DateTime.now(),
          description: 'Transaction created',
        ),
      ],
      metadata: TransactionMetadata(
        notes: '',
        customFields: {},
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      completedAt: null,
    );

    return createTransaction(transaction);
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
  Future<List<BarterOfferEntity>> getOffersByListing(String listingId) async {
    return getOffersByListingId(listingId);
  }

  @override
  Future<List<BarterOfferEntity>> getOffersByUser(String userId, {OfferFilter? filter}) async {
    final queryParams = {'userId': userId};
    if (filter?.status != null) {
      queryParams['status'] = filter!.status!.value;
    }
    final response = await _apiClient.get<Map<String, dynamic>>('/barter/offers', queryParameters: queryParams);
    if (response.statusCode == 200) {
      final List offers = response.data!['data'];
      return offers.map((offer) => _mapOfferToEntity(offer)).toList();
    }
    throw Exception('Failed to get offers');
  }

  @override
  Future<BarterOfferEntity> updateOffer(String offerId, UpdateOfferRequest request) async {
    final response = await _apiClient.patch<Map<String, dynamic>>('/barter/offers/$offerId', data: {
      if (request.message != null) 'message': request.message,
      if (request.isActive != null) 'isActive': request.isActive,
    });
    if (response.statusCode == 200) {
      return _mapOfferToEntity(response.data!['data']);
    }
    throw Exception('Failed to update offer');
  }

  @override
  Future<void> deleteOffer(String offerId) async {
    final response = await _apiClient.delete('/barter/offers/$offerId');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete offer');
    }
  }

  @override
  Future<BarterOfferEntity> counterOffer(String offerId, CounterOfferRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>('/barter/offers/$offerId/counter', data: {
      'message': request.message,
      'offer': {
        'items': request.offer.items.map((item) => {
          'listingId': item.listingId,
          'estimatedValue': item.estimatedValue,
        }).toList(),
        'cashAmount': request.offer.cashAmount,
        'currency': request.offer.currency,
      },
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      return _mapOfferToEntity(response.data!['data']);
    }
    throw Exception('Failed to create counter offer');
  }

  @override
  Future<List<BarterTransactionEntity>> getTransactionsByUser(String userId, {TransactionFilter? filter}) async {
    final queryParams = {'userId': userId};
    if (filter?.status != null) {
      queryParams['status'] = filter!.status!.value;
    }
    final response = await _apiClient.get<Map<String, dynamic>>('/barter/transactions', queryParameters: queryParams);
    if (response.statusCode == 200) {
      final List transactions = response.data!['data'];
      return transactions.map((transaction) => _mapTransactionToEntity(transaction)).toList();
    }
    throw Exception('Failed to get transactions');
  }

  @override
  Future<BarterTransactionEntity> updateTransaction(String transactionId, UpdateTransactionRequest request) async {
    final response = await _apiClient.patch<Map<String, dynamic>>('/barter/transactions/$transactionId', data: {
      if (request.delivery != null) 'delivery': {},
      if (request.metadata != null) 'metadata': {'notes': request.metadata!.notes},
    });
    if (response.statusCode == 200) {
      return _mapTransactionToEntity(response.data!['data']);
    }
    throw Exception('Failed to update transaction');
  }

  @override
  Future<BarterTransactionEntity> updateTransactionStatus(String transactionId, String status) async {
    final response = await _apiClient.patch<Map<String, dynamic>>('/barter/transactions/$transactionId/status', data: {'status': status});
    if (response.statusCode == 200) {
      return _mapTransactionToEntity(response.data!['data']);
    }
    throw Exception('Failed to update transaction status');
  }

  @override
  Future<BarterTransactionEntity> confirmDelivery(String transactionId, DeliveryConfirmationRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>('/barter/transactions/$transactionId/confirm-delivery', data: {
      if (request.trackingNumber != null) 'trackingNumber': request.trackingNumber,
      if (request.carrier != null) 'carrier': request.carrier,
      if (request.notes != null) 'notes': request.notes,
    });
    if (response.statusCode == 200) {
      return _mapTransactionToEntity(response.data!['data']);
    }
    throw Exception('Failed to confirm delivery');
  }

  @override
  Future<BarterTransactionEntity> confirmReceipt(String transactionId, ReceiptConfirmationRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>('/barter/transactions/$transactionId/confirm-receipt', data: {
      if (request.notes != null) 'notes': request.notes,
      if (request.conditionSatisfied != null) 'conditionSatisfied': request.conditionSatisfied,
    });
    if (response.statusCode == 200) {
      return _mapTransactionToEntity(response.data!['data']);
    }
    throw Exception('Failed to confirm receipt');
  }

  @override
  Future<BarterTransactionEntity> completeTransaction(String transactionId) async {
    return updateTransactionStatus(transactionId, 'completed');
  }

  @override
  Future<BarterTransactionEntity> cancelTransaction(String transactionId, String reason) async {
    final response = await _apiClient.post<Map<String, dynamic>>('/barter/transactions/$transactionId/cancel', data: {'reason': reason});
    if (response.statusCode == 200) {
      return _mapTransactionToEntity(response.data!['data']);
    }
    throw Exception('Failed to cancel transaction');
  }

  @override
  Future<BarterTransactionEntity> openDispute(String transactionId, DisputeRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>('/barter/transactions/$transactionId/dispute', data: {
      'reason': request.reason,
      'description': request.description,
      'openedBy': request.openedBy,
    });
    if (response.statusCode == 200) {
      return _mapTransactionToEntity(response.data!['data']);
    }
    throw Exception('Failed to open dispute');
  }

  @override
  Future<BarterTransactionEntity> resolveDispute(String transactionId, DisputeResolutionRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>('/barter/transactions/$transactionId/dispute/resolve', data: {
      'resolution': request.resolution,
      'resolvedBy': request.resolvedBy,
    });
    if (response.statusCode == 200) {
      return _mapTransactionToEntity(response.data!['data']);
    }
    throw Exception('Failed to resolve dispute');
  }

  @override
  Future<void> submitReview(String transactionId, ReviewRequest request) async {
    final response = await _apiClient.post('/barter/reviews', data: {
      'transactionId': transactionId,
      'reviewerId': request.reviewerId,
      'revieweeId': request.revieweeId,
      'rating': request.rating,
      'comment': request.comment,
      'isPublic': request.isPublic,
    });
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to submit review');
    }
  }

  @override
  Future<Review> getReview(String reviewId) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/barter/reviews/$reviewId');
    if (response.statusCode == 200) {
      final data = response.data!['data'];
      return Review(
        id: data['id'],
        reviewerId: data['reviewerId'],
        revieweeId: data['revieweeId'],
        rating: data['rating'],
        comment: data['comment'],
        isPublic: data['isPublic'] ?? true,
        createdAt: DateTime.parse(data['createdAt']),
      );
    }
    throw Exception('Failed to get review');
  }

  @override
  Future<List<BarterOfferEntity>> searchOffers(SearchOffersRequest request) async {
    final queryParams = {
      'query': request.query,
      'page': request.page.toString(),
      'limit': request.limit.toString(),
    };
    if (request.categoryId != null) queryParams['categoryId'] = request.categoryId!;
    
    final response = await _apiClient.get<Map<String, dynamic>>('/barter/offers/search', queryParameters: queryParams);
    if (response.statusCode == 200) {
      final List offers = response.data!['data'];
      return offers.map((offer) => _mapOfferToEntity(offer)).toList();
    }
    throw Exception('Failed to search offers');
  }

  @override
  Future<BarterStats> getBarterStats(String userId) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/barter/stats/$userId');
    if (response.statusCode == 200) {
      final data = response.data!['data'];
      return BarterStats(
        totalOffers: data['totalOffers'] ?? 0,
        acceptedOffers: data['acceptedOffers'] ?? 0,
        rejectedOffers: data['rejectedOffers'] ?? 0,
        completedTransactions: data['completedTransactions'] ?? 0,
        averageResponseTime: (data['averageResponseTime'] ?? 0).toDouble(),
        successRate: (data['successRate'] ?? 0).toDouble(),
      );
    }
    throw Exception('Failed to get barter stats');
  }

  @override
  Future<TransactionStats> getTransactionStats(String userId) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/barter/transaction-stats/$userId');
    if (response.statusCode == 200) {
      final data = response.data!['data'];
      return TransactionStats(
        totalTransactions: data['totalTransactions'] ?? 0,
        completedTransactions: data['completedTransactions'] ?? 0,
        cancelledTransactions: data['cancelledTransactions'] ?? 0,
        disputedTransactions: data['disputedTransactions'] ?? 0,
        averageCompletionTime: (data['averageCompletionTime'] ?? 0).toDouble(),
        disputeRate: (data['disputeRate'] ?? 0.0).toDouble(),
      );
    }
    throw Exception('Failed to get transaction stats');
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