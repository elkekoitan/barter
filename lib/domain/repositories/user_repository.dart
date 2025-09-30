import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUserById(String userId);
  Future<Either<Failure, UserEntity>> updateUser(String userId, Map<String, dynamic> data);
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query);
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, void>> cacheUser(UserEntity user);
  Future<Either<Failure, void>> clearUserCache();
}
