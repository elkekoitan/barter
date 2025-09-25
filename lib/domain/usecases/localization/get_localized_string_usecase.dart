import 'package:dartz/dartz.dart';
import '../../repositories/localization_repository.dart';
import '../../../core/errors/failures.dart';

class GetLocalizedStringUseCase {
  final LocalizationRepository _repository;

  const GetLocalizedStringUseCase(this._repository);

  Future<Either<Failure, String>> call(String key, {List<String>? args}) async {
    if (key.isEmpty) {
      return const Left(ValidationFailure('Translation key cannot be empty'));
    }

    return await _repository.getLocalizedString(key, args: args);
  }
}
