import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/error_handler.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  UserRepositoryImpl(this._remoteDataSource, this._localDataSource, this._networkInfo);

  @override
  Future<Either<Failure, UserEntity>> getUserById(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.getUserById(userId);
        return Right(user);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(String userId, Map<String, dynamic> data) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.updateUser(userId, data);
        return Right(user);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query) async {
    if (await _networkInfo.isConnected) {
      try {
        final users = await _remoteDataSource.searchUsers(query);
        return Right(users);
      } catch (e) {
        return Left(ErrorHandler.handleError(e));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final currentUser = await _localDataSource.getCurrentUser();
      if (currentUser != null) {
        return Right(currentUser);
      } else {
        return const Left(CacheFailure('No cached user found'));
      }
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> cacheUser(UserEntity user) async {
    try {
      await _localDataSource.cacheUser(user);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> clearUserCache() async {
    try {
      await _localDataSource.clearUserCache();
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }
}
