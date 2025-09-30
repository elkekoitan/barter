import 'package:dartz/dartz.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/errors/failures.dart';
import '../../entities/chat.dart';

class CreateChatUseCase {
  final ChatRepository _repository;

  const CreateChatUseCase(this._repository);

  Future<Either<Failure, ChatEntity>> call(CreateChatRequest request) async {
    // Validate request
    final validationFailure = _validateRequest(request);
    if (validationFailure != null) {
      return Left(validationFailure);
    }

    // Create chat
    return await _repository.createChat(request);
  }

  Failure? _validateRequest(CreateChatRequest request) {
    if (request.participantId.isEmpty) {
      return const ValidationFailure('Participant ID is required');
    }

    if (request.type == ChatType.direct && request.title != null) {
      return const ValidationFailure('Direct chats should not have a title');
    }

    if (request.type != ChatType.direct && (request.title?.isEmpty ?? true)) {
      return const ValidationFailure('Group chats must have a title');
    }

    return null;
  }
}
