import 'package:dartz/dartz.dart';
import '../../repositories/chat_repository.dart';
import '../../../core/errors/failures.dart';

class SendMessageUseCase {
  final ChatRepository _repository;

  const SendMessageUseCase(this._repository);

  Future<Either<Failure, MessageEntity>> call(SendMessageRequest request) async {
    // Validate request
    final validationFailure = _validateRequest(request);
    if (validationFailure != null) {
      return Left(validationFailure);
    }

    // Send message
    return await _repository.sendMessage(request);
  }

  Failure? _validateRequest(SendMessageRequest request) {
    if (request.chatId.isEmpty) {
      return const ValidationFailure('Chat ID is required');
    }

    if (request.content.isEmpty && (request.attachments?.isEmpty ?? true)) {
      return const ValidationFailure('Message content or attachment is required');
    }

    if (request.type == MessageType.text && request.content.length > 1000) {
      return const ValidationFailure('Message content too long (max 1000 characters)');
    }

    return null;
  }
}
