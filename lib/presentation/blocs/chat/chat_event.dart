import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat.dart';
import '../../../domain/repositories/chat_repository.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

// Chat Management Events
class GetChatsRequested extends ChatEvent {
  final ChatFilter? filter;
  final int page;
  final int limit;

  const GetChatsRequested({
    this.filter,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [filter, page, limit];
}

class GetChatByIdRequested extends ChatEvent {
  final String chatId;

  const GetChatByIdRequested(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class CreateChatRequested extends ChatEvent {
  final CreateChatRequest request;

  const CreateChatRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateChatRequested extends ChatEvent {
  final String chatId;
  final UpdateChatRequest request;

  const UpdateChatRequested(this.chatId, this.request);

  @override
  List<Object?> get props => [chatId, request];
}

class DeleteChatRequested extends ChatEvent {
  final String chatId;

  const DeleteChatRequested(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ArchiveChatRequested extends ChatEvent {
  final String chatId;

  const ArchiveChatRequested(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class UnarchiveChatRequested extends ChatEvent {
  final String chatId;

  const UnarchiveChatRequested(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class BlockChatRequested extends ChatEvent {
  final String chatId;

  const BlockChatRequested(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class UnblockChatRequested extends ChatEvent {
  final String chatId;

  const UnblockChatRequested(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class MuteChatRequested extends ChatEvent {
  final String chatId;

  const MuteChatRequested(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class UnmuteChatRequested extends ChatEvent {
  final String chatId;

  const UnmuteChatRequested(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

// Message Events
class GetMessagesRequested extends ChatEvent {
  final String chatId;
  final int page;
  final int limit;
  final MessageFilter? filter;

  const GetMessagesRequested({
    required this.chatId,
    this.page = 1,
    this.limit = 50,
    this.filter,
  });

  @override
  List<Object?> get props => [chatId, page, limit, filter];
}

class SendMessageRequested extends ChatEvent {
  final SendMessageRequest request;

  const SendMessageRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class EditMessageRequested extends ChatEvent {
  final String messageId;
  final String newContent;

  const EditMessageRequested(this.messageId, this.newContent);

  @override
  List<Object?> get props => [messageId, newContent];
}

class DeleteMessageRequested extends ChatEvent {
  final String messageId;

  const DeleteMessageRequested(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class MarkMessageAsReadRequested extends ChatEvent {
  final String messageId;

  const MarkMessageAsReadRequested(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class MarkMessagesAsReadRequested extends ChatEvent {
  final List<String> messageIds;

  const MarkMessagesAsReadRequested(this.messageIds);

  @override
  List<Object?> get props => [messageIds];
}

class ReactToMessageRequested extends ChatEvent {
  final String messageId;
  final String emoji;

  const ReactToMessageRequested(this.messageId, this.emoji);

  @override
  List<Object?> get props => [messageId, emoji];
}

class RemoveReactionRequested extends ChatEvent {
  final String messageId;
  final String emoji;

  const RemoveReactionRequested(this.messageId, this.emoji);

  @override
  List<Object?> get props => [messageId, emoji];
}

class ReplyToMessageRequested extends ChatEvent {
  final ReplyToMessageRequest request;

  const ReplyToMessageRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class ForwardMessageRequested extends ChatEvent {
  final ForwardMessageRequest request;

  const ForwardMessageRequested(this.request);

  @override
  List<Object?> get props => [request];
}

// Search Events
class SearchMessagesRequested extends ChatEvent {
  final SearchMessagesRequest request;

  const SearchMessagesRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class SearchChatsRequested extends ChatEvent {
  final SearchChatsRequest request;

  const SearchChatsRequested(this.request);

  @override
  List<Object?> get props => [request];
}

// File Management Events
class UploadFileRequested extends ChatEvent {
  final UploadFileRequest request;

  const UploadFileRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class DeleteFileRequested extends ChatEvent {
  final String fileId;

  const DeleteFileRequested(this.fileId);

  @override
  List<Object?> get props => [fileId];
}

// Typing Events
class SendTypingIndicatorRequested extends ChatEvent {
  final String chatId;
  final bool isTyping;

  const SendTypingIndicatorRequested(this.chatId, this.isTyping);

  @override
  List<Object?> get props => [chatId, isTyping];
}

// Chat Room Events
class CreateChatRoomRequested extends ChatEvent {
  final CreateChatRoomRequest request;

  const CreateChatRoomRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class GetChatRoomRequested extends ChatEvent {
  final String roomId;

  const GetChatRoomRequested(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class GetUserChatRoomsRequested extends ChatEvent {}

class JoinChatRoomRequested extends ChatEvent {
  final String roomId;

  const JoinChatRoomRequested(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class LeaveChatRoomRequested extends ChatEvent {
  final String roomId;

  const LeaveChatRoomRequested(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class AddParticipantToRoomRequested extends ChatEvent {
  final String roomId;
  final String userId;

  const AddParticipantToRoomRequested(this.roomId, this.userId);

  @override
  List<Object?> get props => [roomId, userId];
}

class RemoveParticipantFromRoomRequested extends ChatEvent {
  final String roomId;
  final String userId;

  const RemoveParticipantFromRoomRequested(this.roomId, this.userId);

  @override
  List<Object?> get props => [roomId, userId];
}

class UpdateRoomSettingsRequested extends ChatEvent {
  final String roomId;
  final ChatRoomSettings settings;

  const UpdateRoomSettingsRequested(this.roomId, this.settings);

  @override
  List<Object?> get props => [roomId, settings];
}

// Analytics Events
class GetChatStatsRequested extends ChatEvent {}

// Bulk Operations Events
class MarkAllMessagesAsReadRequested extends ChatEvent {
  final String chatId;

  const MarkAllMessagesAsReadRequested(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class DeleteMultipleMessagesRequested extends ChatEvent {
  final List<String> messageIds;

  const DeleteMultipleMessagesRequested(this.messageIds);

  @override
  List<Object?> get props => [messageIds];
}

class ClearChatHistoryRequested extends ChatEvent {
  final String chatId;

  const ClearChatHistoryRequested(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

// Cache Events
class CacheMessagesRequested extends ChatEvent {
  final String chatId;
  final List<MessageEntity> messages;

  const CacheMessagesRequested(this.chatId, this.messages);

  @override
  List<Object?> get props => [chatId, messages];
}

class GetCachedMessagesRequested extends ChatEvent {
  final String chatId;

  const GetCachedMessagesRequested(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ClearMessageCacheRequested extends ChatEvent {
  final String chatId;

  const ClearMessageCacheRequested(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

// UI Events
class RefreshChatsRequested extends ChatEvent {}

class LoadMoreChatsRequested extends ChatEvent {
  final ChatFilter? filter;

  const LoadMoreChatsRequested({this.filter});

  @override
  List<Object?> get props => [filter];
}

class LoadMoreMessagesRequested extends ChatEvent {
  final String chatId;
  final MessageFilter? filter;

  const LoadMoreMessagesRequested(this.chatId, {this.filter});

  @override
  List<Object?> get props => [chatId, filter];
}

class ClearChatCacheRequested extends ChatEvent {}

// Real-time Events
class ChatUpdated extends ChatEvent {
  final ChatEntity chat;

  const ChatUpdated(this.chat);

  @override
  List<Object?> get props => [chat];
}

class MessageReceived extends ChatEvent {
  final MessageEntity message;

  const MessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageUpdated extends ChatEvent {
  final MessageEntity message;

  const MessageUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class TypingIndicatorReceived extends ChatEvent {
  final TypingIndicator indicator;

  const TypingIndicatorReceived(this.indicator);

  @override
  List<Object?> get props => [indicator];
}

class ChatParticipantJoined extends ChatEvent {
  final String chatId;
  final ChatParticipant participant;

  const ChatParticipantJoined(this.chatId, this.participant);

  @override
  List<Object?> get props => [chatId, participant];
}

class ChatParticipantLeft extends ChatEvent {
  final String chatId;
  final String participantId;

  const ChatParticipantLeft(this.chatId, this.participantId);

  @override
  List<Object?> get props => [chatId, participantId];
}
