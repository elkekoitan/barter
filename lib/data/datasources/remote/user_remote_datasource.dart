import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../domain/entities/user.dart';

abstract class UserRemoteDataSource {
  Future<UserEntity> getUserById(String userId);
  Future<UserEntity> updateUser(String userId, Map<String, dynamic> data);
  Future<List<UserEntity>> searchUsers(String query);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UserEntity> getUserById(String userId) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/users/$userId');
    if (response.statusCode == 200) {
      return _mapToUserEntity(response.data!['data']);
    }
    throw Exception('Failed to get user');
  }

  @override
  Future<UserEntity> updateUser(String userId, Map<String, dynamic> data) async {
    final response = await _apiClient.patch<Map<String, dynamic>>('/users/$userId', data: data);
    if (response.statusCode == 200) {
      return _mapToUserEntity(response.data!['data']);
    }
    throw Exception('Failed to update user');
  }

  @override
  Future<List<UserEntity>> searchUsers(String query) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/users/search', queryParameters: {'q': query});
    if (response.statusCode == 200) {
      final List users = response.data!['data'];
      return users.map((user) => _mapToUserEntity(user)).toList();
    }
    throw Exception('Failed to search users');
  }

  UserEntity _mapToUserEntity(Map<String, dynamic> data) {
    return UserEntity(
      id: data['id'],
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      phone: data['phone'],
      profileImageUrl: data['profileImageUrl'],
      isVerified: data['isVerified'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
    );
  }
}
