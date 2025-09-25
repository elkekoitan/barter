import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/chat.dart';

abstract class ChatRepository {
  // Chat Management
  Future<Either<Failure, List<ChatEntity>>> getChats({
    ChatFilter? filter,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, ChatEntity>> getChatById(String chatId);

  Future<Either<Failure, ChatEntity>> createChat(CreateChatRequest request);

  Future<Either<Failure, ChatEntity>> updateChat(String chatId, UpdateChatRequest request);

  Future<Either<Failure, void>> deleteChat(String chatId);

  Future<Either<Failure, void>> archiveChat(String chatId);

  Future<Either<Failure, void>> unarchiveChat(String chatId);

  Future<Either<Failure, void>> blockChat(String chatId);

  Future<Either<Failure, void>> unblockChat(String chatId);

  Future<Either<Failure, void>> muteChat(String chatId);

  Future<Either<Failure, void>> unmuteChat(String chatId);

  // Message Management
  Future<Either<Failure, List<MessageEntity>>> getMessages(
    String chatId, {
    int page = 1,
    int limit = 50,
    MessageFilter? filter,
  });

  Future<Either<Failure, MessageEntity>> sendMessage(SendMessageRequest request);

  Future<Either<Failure, MessageEntity>> editMessage(String messageId, String newContent);

  Future<Either<Failure, void>> deleteMessage(String messageId);

  Future<Either<Failure, void>> markMessageAsRead(String messageId);

  Future<Either<Failure, List<String>>> markMessagesAsRead(List<String> messageIds);

  Future<Either<Failure, void>> reactToMessage(String messageId, String emoji);

  Future<Either<Failure, void>> removeReaction(String messageId, String emoji);

  Future<Either<Failure, MessageEntity>> replyToMessage(ReplyToMessageRequest request);

  Future<Either<Failure, MessageEntity>> forwardMessage(ForwardMessageRequest request);

  // Real-time subscriptions
  Stream<Either<Failure, List<ChatEntity>>> subscribeToChats();

  Stream<Either<Failure, List<MessageEntity>>> subscribeToMessages(String chatId);

  Stream<Either<Failure, ChatEntity>> subscribeToChatUpdates(String chatId);

  Stream<Either<Failure, MessageEntity>> subscribeToMessageUpdates(String chatId);

  // Search
  Future<Either<Failure, List<MessageEntity>>> searchMessages(SearchMessagesRequest request);

  Future<Either<Failure, List<ChatEntity>>> searchChats(SearchChatsRequest request);

  // File Management
  Future<Either<Failure, MessageAttachment>> uploadFile(UploadFileRequest request);

  Future<Either<Failure, void>> deleteFile(String fileId);

  // Typing indicators
  Future<Either<Failure, void>> sendTypingIndicator(String chatId, bool isTyping);

  Stream<Either<Failure, TypingIndicator>> subscribeToTypingIndicators(String chatId);

  // Chat Rooms (Group chats)
  Future<Either<Failure, ChatRoomEntity>> createChatRoom(CreateChatRoomRequest request);

  Future<Either<Failure, ChatRoomEntity>> getChatRoom(String roomId);

  Future<Either<Failure, List<ChatRoomEntity>>> getUserChatRooms();

  Future<Either<Failure, void>> joinChatRoom(String roomId);

  Future<Either<Failure, void>> leaveChatRoom(String roomId);

  Future<Either<Failure, void>> addParticipantToRoom(String roomId, String userId);

  Future<Either<Failure, void>> removeParticipantFromRoom(String roomId, String userId);

  Future<Either<Failure, void>> updateRoomSettings(String roomId, ChatRoomSettings settings);

  // Analytics
  Future<Either<Failure, ChatStats>> getChatStats();

  // Bulk Operations
  Future<Either<Failure, void>> markAllMessagesAsRead(String chatId);

  Future<Either<Failure, List<String>>> deleteMultipleMessages(List<String> messageIds);

  Future<Either<Failure, void>> clearChatHistory(String chatId);

  // Local caching
  Future<Either<Failure, void>> cacheMessages(String chatId, List<MessageEntity> messages);

  Future<Either<Failure, List<MessageEntity>>> getCachedMessages(String chatId);

  Future<Either<Failure, void>> clearMessageCache(String chatId);
}

// Request/Response Models
class CreateChatRequest {
  final String participantId;
  final ChatType type;
  final String? title;
  final String? description;
  final Map<String, dynamic>? metadata;

  const CreateChatRequest({
    required this.participantId,
    this.type = ChatType.direct,
    this.title,
    this.description,
    this.metadata,
  });
}

class UpdateChatRequest {
  final String? title;
  final String? description;
  final String? avatarUrl;
  final Map<String, dynamic>? metadata;

  const UpdateChatRequest({
    this.title,
    this.description,
    this.avatarUrl,
    this.metadata,
  });
}

class SendMessageRequest {
  final String chatId;
  final MessageType type;
  final String content;
  final List<MessageAttachment>? attachments;
  final String? replyToMessageId;
  final Map<String, dynamic>? metadata;

  const SendMessageRequest({
    required this.chatId,
    required this.type,
    required this.content,
    this.attachments,
    this.replyToMessageId,
    this.metadata,
  });
}

class ReplyToMessageRequest {
  final String chatId;
  final String repliedMessageId;
  final String content;
  final MessageType type;
  final List<MessageAttachment>? attachments;

  const ReplyToMessageRequest({
    required this.chatId,
    required this.repliedMessageId,
    required this.content,
    required this.type,
    this.attachments,
  });
}

class ForwardMessageRequest {
  final String originalMessageId;
  final String targetChatId;
  final String? content;

  const ForwardMessageRequest({
    required this.originalMessageId,
    required this.targetChatId,
    this.content,
  });
}

class SearchMessagesRequest {
  final String chatId;
  final String query;
  final MessageFilter? filter;
  final int page;
  final int limit;
  final MessageSearchSort sortBy;
  final bool sortDescending;

  const SearchMessagesRequest({
    required this.chatId,
    required this.query,
    this.filter,
    this.page = 1,
    this.limit = 50,
    this.sortBy = MessageSearchSort.createdAt,
    this.sortDescending = true,
  });
}

class SearchChatsRequest {
  final String query;
  final ChatFilter? filter;
  final int page;
  final int limit;
  final ChatSearchSort sortBy;
  final bool sortDescending;

  const SearchChatsRequest({
    required this.query,
    this.filter,
    this.page = 1,
    this.limit = 20,
    this.sortBy = ChatSearchSort.lastMessage,
    this.sortDescending = true,
  });
}

class UploadFileRequest {
  final String chatId;
  final String fileName;
  final String filePath;
  final String fileType;
  final int fileSize;
  final String? thumbnailPath;

  const UploadFileRequest({
    required this.chatId,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
    this.thumbnailPath,
  });
}

class CreateChatRoomRequest {
  final String name;
  final String description;
  final List<String> participantIds;
  final List<String> adminIds;
  final ChatRoomSettings? settings;
  final String? avatarUrl;

  const CreateChatRoomRequest({
    required this.name,
    required this.description,
    required this.participantIds,
    this.adminIds = const [],
    this.settings,
    this.avatarUrl,
  });
}

class ChatFilter {
  final ChatType? type;
  final bool? isArchived;
  final bool? isBlocked;
  final bool? isMuted;
  final DateTime? createdAfter;
  final DateTime? createdBefore;
  final String? participantId;
  final List<String>? excludeChatIds;

  const ChatFilter({
    this.type,
    this.isArchived,
    this.isBlocked,
    this.isMuted,
    this.createdAfter,
    this.createdBefore,
    this.participantId,
    this.excludeChatIds,
  });
}

class MessageFilter {
  final MessageType? type;
  final MessageStatus? status;
  final String? senderId;
  final DateTime? sentAfter;
  final DateTime? sentBefore;
  final bool? hasAttachments;
  final bool? hasReactions;

  const MessageFilter({
    this.type,
    this.status,
    this.senderId,
    this.sentAfter,
    this.sentBefore,
    this.hasAttachments,
    this.hasReactions,
  });
}

class TypingIndicator {
  final String userId;
  final String userName;
  final String? userAvatar;
  final bool isTyping;
  final DateTime timestamp;

  const TypingIndicator({
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.isTyping,
    required this.timestamp,
  });
}

enum MessageSearchSort {
  createdAt('created_at', 'Gönderilme Tarihi'),
  sender('sender', 'Gönderici'),
  type('type', 'Tür'),
  relevance('relevance', 'Alaka');

  const MessageSearchSort(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum ChatSearchSort {
  lastMessage('last_message', 'Son Mesaj'),
  createdAt('created_at', 'Oluşturulma Tarihi'),
  participantCount('participant_count', 'Katılımcı Sayısı'),
  name('name', 'İsim'),
  relevance('relevance', 'Alaka');

  const ChatSearchSort(this.value, this.displayName);
  final String value;
  final String displayName;
}
