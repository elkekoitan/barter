import 'package:dartz/dartz.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    try {
      // Check if user is actually logged in
      final isLoggedIn = await _repository.isLoggedIn();
      if (!isLoggedIn) {
        return const Left(AuthFailure('User is not logged in'));
      }

      // Attempt logout
      return await _repository.logout();
    } catch (e) {
      // Even if logout fails, we should return success
      // since the main goal is to clear local session
      return const Right(null);
    }
  }
}
