import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatsLoading extends ChatState {
  final bool isLoadMore;

  const ChatsLoading({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

class MessagesLoading extends ChatState {
  final bool isLoadMore;

  const MessagesLoading({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

class FileUploading extends ChatState {
  final String fileName;
  final double progress;

  const FileUploading(this.fileName, this.progress);

  @override
  List<Object?> get props => [fileName, progress];
}

// Success States
class ChatsLoaded extends ChatState {
  final List<ChatEntity> chats;
  final bool hasMore;
  final int currentPage;
  final int totalCount;

  const ChatsLoaded({
    required this.chats,
    this.hasMore = true,
    this.currentPage = 1,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [chats, hasMore, currentPage, totalCount];
}

class ChatLoaded extends ChatState {
  final ChatEntity chat;

  const ChatLoaded(this.chat);

  @override
  List<Object?> get props => [chat];
}

class ChatCreated extends ChatState {
  final ChatEntity chat;

  const ChatCreated(this.chat);

  @override
  List<Object?> get props => [chat];
}

class ChatUpdated extends ChatState {
  final ChatEntity chat;

  const ChatUpdated(this.chat);

  @override
  List<Object?> get props => [chat];
}

class ChatDeleted extends ChatState {
  final String chatId;

  const ChatDeleted(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ChatArchived extends ChatState {
  final String chatId;

  const ChatArchived(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ChatUnarchived extends ChatState {
  final String chatId;

  const ChatUnarchived(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ChatBlocked extends ChatState {
  final String chatId;

  const ChatBlocked(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ChatUnblocked extends ChatState {
  final String chatId;

  const ChatUnblocked(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ChatMuted extends ChatState {
  final String chatId;

  const ChatMuted(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ChatUnmuted extends ChatState {
  final String chatId;

  const ChatUnmuted(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class MessagesLoaded extends ChatState {
  final String chatId;
  final List<MessageEntity> messages;
  final bool hasMore;
  final int currentPage;

  const MessagesLoaded({
    required this.chatId,
    required this.messages,
    this.hasMore = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [chatId, messages, hasMore, currentPage];
}

class MessageSent extends ChatState {
  final MessageEntity message;

  const MessageSent(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageEdited extends ChatState {
  final MessageEntity message;

  const MessageEdited(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageDeleted extends ChatState {
  final String messageId;

  const MessageDeleted(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class MessageMarkedAsRead extends ChatState {
  final String messageId;

  const MessageMarkedAsRead(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class MessagesMarkedAsRead extends ChatState {
  final List<String> messageIds;

  const MessagesMarkedAsRead(this.messageIds);

  @override
  List<Object?> get props => [messageIds];
}

class MessageReacted extends ChatState {
  final String messageId;
  final MessageReaction reaction;

  const MessageReacted(this.messageId, this.reaction);

  @override
  List<Object?> get props => [messageId, reaction];
}

class ReactionRemoved extends ChatState {
  final String messageId;
  final String emoji;

  const ReactionRemoved(this.messageId, this.emoji);

  @override
  List<Object?> get props => [messageId, emoji];
}

class MessageReplied extends ChatState {
  final MessageEntity reply;

  const MessageReplied(this.reply);

  @override
  List<Object?> get props => [reply];
}

class MessageForwarded extends ChatState {
  final MessageEntity message;
  final String targetChatId;

  const MessageForwarded(this.message, this.targetChatId);

  @override
  List<Object?> get props => [message, targetChatId];
}

class MessagesSearched extends ChatState {
  final List<MessageEntity> messages;
  final String query;

  const MessagesSearched(this.messages, this.query);

  @override
  List<Object?> get props => [messages, query];
}

class ChatsSearched extends ChatState {
  final List<ChatEntity> chats;
  final String query;

  const ChatsSearched(this.chats, this.query);

  @override
  List<Object?> get props => [chats, query];
}

class FileUploaded extends ChatState {
  final MessageAttachment attachment;

  const FileUploaded(this.attachment);

  @override
  List<Object?> get props => [attachment];
}

class FileDeleted extends ChatState {
  final String fileId;

  const FileDeleted(this.fileId);

  @override
  List<Object?> get props => [fileId];
}

class ChatRoomCreated extends ChatState {
  final ChatRoomEntity room;

  const ChatRoomCreated(this.room);

  @override
  List<Object?> get props => [room];
}

class ChatRoomLoaded extends ChatState {
  final ChatRoomEntity room;

  const ChatRoomLoaded(this.room);

  @override
  List<Object?> get props => [room];
}

class UserChatRoomsLoaded extends ChatState {
  final List<ChatRoomEntity> rooms;

  const UserChatRoomsLoaded(this.rooms);

  @override
  List<Object?> get props => [rooms];
}

class ChatRoomJoined extends ChatState {
  final String roomId;

  const ChatRoomJoined(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class ChatRoomLeft extends ChatState {
  final String roomId;

  const ChatRoomLeft(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class ParticipantAddedToRoom extends ChatState {
  final String roomId;
  final ChatParticipant participant;

  const ParticipantAddedToRoom(this.roomId, this.participant);

  @override
  List<Object?> get props => [roomId, participant];
}

class ParticipantRemovedFromRoom extends ChatState {
  final String roomId;
  final String participantId;

  const ParticipantRemovedFromRoom(this.roomId, this.participantId);

  @override
  List<Object?> get props => [roomId, participantId];
}

class RoomSettingsUpdated extends ChatState {
  final String roomId;
  final ChatRoomSettings settings;

  const RoomSettingsUpdated(this.roomId, this.settings);

  @override
  List<Object?> get props => [roomId, settings];
}

class ChatStatsLoaded extends ChatState {
  final ChatStats stats;

  const ChatStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class AllMessagesMarkedAsRead extends ChatState {
  final String chatId;

  const AllMessagesMarkedAsRead(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class MultipleMessagesDeleted extends ChatState {
  final List<String> messageIds;

  const MultipleMessagesDeleted(this.messageIds);

  @override
  List<Object?> get props => [messageIds];
}

class ChatHistoryCleared extends ChatState {
  final String chatId;

  const ChatHistoryCleared(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class MessagesCached extends ChatState {
  final String chatId;
  final List<MessageEntity> messages;

  const MessagesCached(this.chatId, this.messages);

  @override
  List<Object?> get props => [chatId, messages];
}

class CachedMessagesLoaded extends ChatState {
  final String chatId;
  final List<MessageEntity> messages;

  const CachedMessagesLoaded(this.chatId, this.messages);

  @override
  List<Object?> get props => [chatId, messages];
}

class MessageCacheCleared extends ChatState {
  final String chatId;

  const MessageCacheCleared(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ChatCacheCleared extends ChatState {}

// Real-time States
class ChatUpdatedInRealTime extends ChatState {
  final ChatEntity chat;

  const ChatUpdatedInRealTime(this.chat);

  @override
  List<Object?> get props => [chat];
}

class MessageReceivedInRealTime extends ChatState {
  final MessageEntity message;

  const MessageReceivedInRealTime(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageUpdatedInRealTime extends ChatState {
  final MessageEntity message;

  const MessageUpdatedInRealTime(this.message);

  @override
  List<Object?> get props => [message];
}

class TypingIndicatorReceivedInRealTime extends ChatState {
  final TypingIndicator indicator;

  const TypingIndicatorReceivedInRealTime(this.indicator);

  @override
  List<Object?> get props => [indicator];
}

class ParticipantJoinedRoomInRealTime extends ChatState {
  final String roomId;
  final ChatParticipant participant;

  const ParticipantJoinedRoomInRealTime(this.roomId, this.participant);

  @override
  List<Object?> get props => [roomId, participant];
}

class ParticipantLeftRoomInRealTime extends ChatState {
  final String roomId;
  final String participantId;

  const ParticipantLeftRoomInRealTime(this.roomId, this.participantId);

  @override
  List<Object?> get props => [roomId, participantId];
}

// Error State
class ChatError extends ChatState {
  final String message;
  final String? code;
  final ChatErrorType? errorType;

  const ChatError(this.message, {this.code, this.errorType});

  @override
  List<Object?> get props => [message, code, errorType];
}

enum ChatErrorType {
  network('network', 'Ağ Hatası'),
  permission('permission', 'İzin Hatası'),
  validation('validation', 'Doğrulama Hatası'),
  quota('quota', 'Kota Aşımı'),
  fileTooLarge('file_too_large', 'Dosya Çok Büyük'),
  invalidFileType('invalid_file_type', 'Geçersiz Dosya Türü'),
  chatNotFound('chat_not_found', 'Sohbet Bulunamadı'),
  messageNotFound('message_not_found', 'Mesaj Bulunamadı'),
  blockedUser('blocked_user', 'Engellenmiş Kullanıcı'),
  unknown('unknown', 'Bilinmeyen Hata');

  const ChatErrorType(this.value, this.displayName);
  final String value;
  final String displayName;
}
