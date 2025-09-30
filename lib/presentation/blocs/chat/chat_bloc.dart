import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/chat/get_chats_usecase.dart';
import '../../../domain/usecases/chat/send_message_usecase.dart';
import '../../../domain/usecases/chat/create_chat_usecase.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../domain/entities/chat.dart' as domain;
import 'chat_event.dart' as chat_event;
import 'chat_state.dart' as chat_state;

class ChatBloc extends Bloc<chat_event.ChatEvent, chat_state.ChatState> {
  final GetChatsUseCase _getChatsUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final CreateChatUseCase _createChatUseCase;
  final ChatRepository _chatRepository;

  ChatBloc({
    required GetChatsUseCase getChatsUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required CreateChatUseCase createChatUseCase,
    required ChatRepository chatRepository,
  })  : _getChatsUseCase = getChatsUseCase,
        _sendMessageUseCase = sendMessageUseCase,
        _createChatUseCase = createChatUseCase,
        _chatRepository = chatRepository,
        super(chat_state.ChatInitial()) {
    on<chat_event.GetChatsRequested>(_onGetChatsRequested);
    on<chat_event.GetChatByIdRequested>(_onGetChatByIdRequested);
    on<chat_event.CreateChatRequested>(_onCreateChatRequested);
    on<chat_event.UpdateChatRequested>(_onUpdateChatRequested);
    on<chat_event.DeleteChatRequested>(_onDeleteChatRequested);
    on<chat_event.ArchiveChatRequested>(_onArchiveChatRequested);
    on<chat_event.UnarchiveChatRequested>(_onUnarchiveChatRequested);
    on<chat_event.BlockChatRequested>(_onBlockChatRequested);
    on<chat_event.UnblockChatRequested>(_onUnblockChatRequested);
    on<chat_event.MuteChatRequested>(_onMuteChatRequested);
    on<chat_event.UnmuteChatRequested>(_onUnmuteChatRequested);
    on<chat_event.GetMessagesRequested>(_onGetMessagesRequested);
    on<chat_event.SendMessageRequested>(_onSendMessageRequested);
    on<chat_event.EditMessageRequested>(_onEditMessageRequested);
    on<chat_event.DeleteMessageRequested>(_onDeleteMessageRequested);
    on<chat_event.MarkMessageAsReadRequested>(_onMarkMessageAsReadRequested);
    on<chat_event.MarkMessagesAsReadRequested>(_onMarkMessagesAsReadRequested);
    on<chat_event.ReactToMessageRequested>(_onReactToMessageRequested);
    on<chat_event.RemoveReactionRequested>(_onRemoveReactionRequested);
    on<chat_event.ReplyToMessageRequested>(_onReplyToMessageRequested);
    on<chat_event.ForwardMessageRequested>(_onForwardMessageRequested);
    on<chat_event.SearchMessagesRequested>(_onSearchMessagesRequested);
    on<chat_event.SearchChatsRequested>(_onSearchChatsRequested);
    on<chat_event.UploadFileRequested>(_onUploadFileRequested);
    on<chat_event.DeleteFileRequested>(_onDeleteFileRequested);
    on<chat_event.SendTypingIndicatorRequested>(_onSendTypingIndicatorRequested);
    on<chat_event.CreateChatRoomRequested>(_onCreateChatRoomRequested);
    on<chat_event.GetChatRoomRequested>(_onGetChatRoomRequested);
    on<chat_event.GetUserChatRoomsRequested>(_onGetUserChatRoomsRequested);
    on<chat_event.JoinChatRoomRequested>(_onJoinChatRoomRequested);
    on<chat_event.LeaveChatRoomRequested>(_onLeaveChatRoomRequested);
    on<chat_event.AddParticipantToRoomRequested>(_onAddParticipantToRoomRequested);
    on<chat_event.RemoveParticipantFromRoomRequested>(_onRemoveParticipantFromRoomRequested);
    on<chat_event.UpdateRoomSettingsRequested>(_onUpdateRoomSettingsRequested);
    on<chat_event.GetChatStatsRequested>(_onGetChatStatsRequested);
    on<chat_event.MarkAllMessagesAsReadRequested>(_onMarkAllMessagesAsReadRequested);
    on<chat_event.DeleteMultipleMessagesRequested>(_onDeleteMultipleMessagesRequested);
    on<chat_event.ClearChatHistoryRequested>(_onClearChatHistoryRequested);
    on<chat_event.CacheMessagesRequested>(_onCacheMessagesRequested);
    on<chat_event.GetCachedMessagesRequested>(_onGetCachedMessagesRequested);
    on<chat_event.ClearMessageCacheRequested>(_onClearMessageCacheRequested);
    on<chat_event.RefreshChatsRequested>(_onRefreshChatsRequested);
    on<chat_event.LoadMoreChatsRequested>(_onLoadMoreChatsRequested);
    on<chat_event.LoadMoreMessagesRequested>(_onLoadMoreMessagesRequested);
    on<chat_event.ClearChatCacheRequested>(_onClearChatCacheRequested);
    on<chat_event.ChatUpdated>(_onChatUpdated);
    on<chat_event.MessageReceived>(_onMessageReceived);
    on<chat_event.MessageUpdated>(_onMessageUpdated);
    on<chat_event.TypingIndicatorReceived>(_onTypingIndicatorReceived);
    on<chat_event.ChatParticipantJoined>(_onChatParticipantJoined);
    on<chat_event.ChatParticipantLeft>(_onChatParticipantLeft);
  }

  Future<void> _onGetChatsRequested(
    chat_event.GetChatsRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    emit(chat_state.ChatsLoading());

    final result = await _getChatsUseCase.call(
      filter: event.filter,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (chats) => emit(chat_state.ChatsLoaded(
        chats: chats,
        currentPage: event.page,
        hasMore: chats.length == event.limit,
        totalCount: chats.length,
      )),
    );
  }

  Future<void> _onGetChatByIdRequested(
    chat_event.GetChatByIdRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    emit(chat_state.ChatLoading());

    final result = await _chatRepository.getChatById(event.chatId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (chat) => emit(chat_state.ChatLoaded(chat)),
    );
  }

  Future<void> _onCreateChatRequested(
    chat_event.CreateChatRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    emit(chat_state.ChatLoading());

    final result = await _createChatUseCase.call(event.request);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (chat) => emit(chat_state.ChatCreated(chat)),
    );
  }

  Future<void> _onUpdateChatRequested(
    chat_event.UpdateChatRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.updateChat(event.chatId, event.request);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (chat) => emit(chat_state.ChatUpdated(chat)),
    );
  }

  Future<void> _onDeleteChatRequested(
    chat_event.DeleteChatRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.deleteChat(event.chatId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.ChatDeleted(event.chatId)),
    );
  }

  Future<void> _onArchiveChatRequested(
    chat_event.ArchiveChatRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.archiveChat(event.chatId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.ChatArchived(event.chatId)),
    );
  }

  Future<void> _onUnarchiveChatRequested(
    chat_event.UnarchiveChatRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.unarchiveChat(event.chatId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.ChatUnarchived(event.chatId)),
    );
  }

  Future<void> _onBlockChatRequested(
    chat_event.BlockChatRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.blockChat(event.chatId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.ChatBlocked(event.chatId)),
    );
  }

  Future<void> _onUnblockChatRequested(
    chat_event.UnblockChatRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.unblockChat(event.chatId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.ChatUnblocked(event.chatId)),
    );
  }

  Future<void> _onMuteChatRequested(
    chat_event.MuteChatRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.muteChat(event.chatId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.ChatMuted(event.chatId)),
    );
  }

  Future<void> _onUnmuteChatRequested(
    chat_event.UnmuteChatRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.unmuteChat(event.chatId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.ChatUnmuted(event.chatId)),
    );
  }

  Future<void> _onGetMessagesRequested(
    chat_event.GetMessagesRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    emit(chat_state.MessagesLoading());

    final result = await _chatRepository.getMessages(
      event.chatId,
      page: event.page,
      limit: event.limit,
      filter: event.filter,
    );

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (messages) => emit(chat_state.MessagesLoaded(
        chatId: event.chatId,
        messages: messages,
        currentPage: event.page,
        hasMore: messages.length == event.limit,
      )),
    );
  }

  Future<void> _onSendMessageRequested(
    chat_event.SendMessageRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _sendMessageUseCase.call(event.request);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (message) => emit(chat_state.MessageSent(message)),
    );
  }

  Future<void> _onEditMessageRequested(
    chat_event.EditMessageRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.editMessage(event.messageId, event.newContent);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (message) => emit(chat_state.MessageEdited(message)),
    );
  }

  Future<void> _onDeleteMessageRequested(
    chat_event.DeleteMessageRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.deleteMessage(event.messageId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.MessageDeleted(event.messageId)),
    );
  }

  Future<void> _onMarkMessageAsReadRequested(
    chat_event.MarkMessageAsReadRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.markMessageAsRead(event.messageId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.MessageMarkedAsRead(event.messageId)),
    );
  }

  Future<void> _onMarkMessagesAsReadRequested(
    chat_event.MarkMessagesAsReadRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.markMessagesAsRead(event.messageIds);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (messageIds) => emit(chat_state.MessagesMarkedAsRead(messageIds)),
    );
  }

  Future<void> _onReactToMessageRequested(
    chat_event.ReactToMessageRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.reactToMessage(event.messageId, event.emoji);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.MessageReacted(
        event.messageId,
        domain.MessageReaction(
          emoji: event.emoji,
          userId: 'current_user_id',
          userName: 'You',
          createdAt: DateTime.now(),
        ),
      )),
    );
  }

  Future<void> _onRemoveReactionRequested(
    chat_event.RemoveReactionRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.removeReaction(event.messageId, event.emoji);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.ReactionRemoved(event.messageId, event.emoji)),
    );
  }

  Future<void> _onReplyToMessageRequested(
    chat_event.ReplyToMessageRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.replyToMessage(event.request);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (reply) => emit(chat_state.MessageReplied(reply)),
    );
  }

  Future<void> _onForwardMessageRequested(
    chat_event.ForwardMessageRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.forwardMessage(event.request);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (message) => emit(chat_state.MessageForwarded(message, event.request.targetChatId)),
    );
  }

  Future<void> _onSearchMessagesRequested(
    chat_event.SearchMessagesRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.searchMessages(event.request);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (messages) => emit(chat_state.MessagesSearched(messages, event.request.query)),
    );
  }

  Future<void> _onSearchChatsRequested(
    chat_event.SearchChatsRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.searchChats(event.request);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (chats) => emit(chat_state.ChatsSearched(chats, event.request.query)),
    );
  }

  Future<void> _onUploadFileRequested(
    chat_event.UploadFileRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    emit(chat_state.FileUploading(event.request.fileName, 0.0));

    final result = await _chatRepository.uploadFile(event.request);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (attachment) => emit(chat_state.FileUploaded(attachment)),
    );
  }

  Future<void> _onDeleteFileRequested(
    chat_event.DeleteFileRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.deleteFile(event.fileId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.FileDeleted(event.fileId)),
    );
  }

  Future<void> _onSendTypingIndicatorRequested(
    chat_event.SendTypingIndicatorRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.sendTypingIndicator(event.chatId, event.isTyping);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => {}, // Typing indicator sent successfully
    );
  }

  Future<void> _onCreateChatRoomRequested(
    chat_event.CreateChatRoomRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    emit(chat_state.ChatLoading());

    final result = await _chatRepository.createChatRoom(event.request);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (room) => emit(chat_state.ChatRoomCreated(room)),
    );
  }

  Future<void> _onGetChatRoomRequested(
    chat_event.GetChatRoomRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    emit(chat_state.ChatLoading());

    final result = await _chatRepository.getChatRoom(event.roomId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (room) => emit(chat_state.ChatRoomLoaded(room)),
    );
  }

  Future<void> _onGetUserChatRoomsRequested(
    chat_event.GetUserChatRoomsRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.getUserChatRooms();

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (rooms) => emit(chat_state.UserChatRoomsLoaded(rooms)),
    );
  }

  Future<void> _onJoinChatRoomRequested(
    chat_event.JoinChatRoomRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.joinChatRoom(event.roomId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.ChatRoomJoined(event.roomId)),
    );
  }

  Future<void> _onLeaveChatRoomRequested(
    chat_event.LeaveChatRoomRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.leaveChatRoom(event.roomId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.ChatRoomLeft(event.roomId)),
    );
  }

  Future<void> _onAddParticipantToRoomRequested(
    chat_event.AddParticipantToRoomRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.addParticipantToRoom(event.roomId, event.userId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.ParticipantAddedToRoom(
        event.roomId,
        domain.ChatParticipant(
          id: event.userId,
          displayName: 'Participant',
        ),
      )),
    );
  }

  Future<void> _onRemoveParticipantFromRoomRequested(
    chat_event.RemoveParticipantFromRoomRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.removeParticipantFromRoom(event.roomId, event.userId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.ParticipantRemovedFromRoom(event.roomId, event.userId)),
    );
  }

  Future<void> _onUpdateRoomSettingsRequested(
    chat_event.UpdateRoomSettingsRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.updateRoomSettings(event.roomId, event.settings);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.RoomSettingsUpdated(event.roomId, event.settings)),
    );
  }

  Future<void> _onGetChatStatsRequested(
    chat_event.GetChatStatsRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.getChatStats();

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (stats) => emit(chat_state.ChatStatsLoaded(stats)),
    );
  }

  Future<void> _onMarkAllMessagesAsReadRequested(
    chat_event.MarkAllMessagesAsReadRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.markAllMessagesAsRead(event.chatId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.AllMessagesMarkedAsRead(event.chatId)),
    );
  }

  Future<void> _onDeleteMultipleMessagesRequested(
    chat_event.DeleteMultipleMessagesRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.deleteMultipleMessages(event.messageIds);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.MultipleMessagesDeleted(event.messageIds)),
    );
  }

  Future<void> _onClearChatHistoryRequested(
    chat_event.ClearChatHistoryRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.clearChatHistory(event.chatId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.ChatHistoryCleared(event.chatId)),
    );
  }

  Future<void> _onCacheMessagesRequested(
    chat_event.CacheMessagesRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.cacheMessages(event.chatId, event.messages);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.MessagesCached(event.chatId, event.messages)),
    );
  }

  Future<void> _onGetCachedMessagesRequested(
    chat_event.GetCachedMessagesRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.getCachedMessages(event.chatId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (messages) => emit(chat_state.CachedMessagesLoaded(event.chatId, messages)),
    );
  }

  Future<void> _onClearMessageCacheRequested(
    chat_event.ClearMessageCacheRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final result = await _chatRepository.clearMessageCache(event.chatId);

    result.fold(
      (failure) => emit(chat_state.ChatError(failure.message)),
      (_) => emit(chat_state.MessageCacheCleared(event.chatId)),
    );
  }

  Future<void> _onRefreshChatsRequested(
    chat_event.RefreshChatsRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    emit(chat_state.ChatInitial());
  }

  Future<void> _onLoadMoreChatsRequested(
    chat_event.LoadMoreChatsRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is chat_state.ChatsLoaded && currentState.hasMore) {
      emit(chat_state.ChatsLoading(isLoadMore: true));

      final result = await _getChatsUseCase.call(
        filter: event.filter,
        page: currentState.currentPage + 1,
        limit: 20,
      );

      result.fold(
        (failure) => emit(chat_state.ChatError(failure.message)),
        (chats) => emit(chat_state.ChatsLoaded(
          chats: [...currentState.chats, ...chats],
          currentPage: currentState.currentPage + 1,
          hasMore: chats.length == 20,
          totalCount: currentState.totalCount + chats.length,
        )),
      );
    }
  }

  Future<void> _onLoadMoreMessagesRequested(
    chat_event.LoadMoreMessagesRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is chat_state.MessagesLoaded && currentState.hasMore) {
      emit(chat_state.MessagesLoading(isLoadMore: true));

      final result = await _chatRepository.getMessages(
        event.chatId,
        page: currentState.currentPage + 1,
        limit: 50,
        filter: event.filter,
      );

      result.fold(
        (failure) => emit(chat_state.ChatError(failure.message)),
        (messages) => emit(chat_state.MessagesLoaded(
          chatId: event.chatId,
          messages: [...currentState.messages, ...messages],
          currentPage: currentState.currentPage + 1,
          hasMore: messages.length == 50,
        )),
      );
    }
  }

  Future<void> _onClearChatCacheRequested(
    chat_event.ClearChatCacheRequested event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    emit(chat_state.ChatCacheCleared());
  }

  Future<void> _onChatUpdated(
    chat_event.ChatUpdated event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    emit(chat_state.ChatUpdatedInRealTime(event.chat));
  }

  Future<void> _onMessageReceived(
    chat_event.MessageReceived event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    emit(chat_state.MessageReceivedInRealTime(event.message));
  }

  Future<void> _onMessageUpdated(
    chat_event.MessageUpdated event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    emit(chat_state.MessageUpdatedInRealTime(event.message));
  }

  Future<void> _onTypingIndicatorReceived(
    chat_event.TypingIndicatorReceived event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    emit(chat_state.TypingIndicatorReceivedInRealTime(event.indicator));
  }

  Future<void> _onChatParticipantJoined(
    chat_event.ChatParticipantJoined event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    emit(chat_state.ParticipantJoinedRoomInRealTime(event.chatId, event.participant));
  }

  Future<void> _onChatParticipantLeft(
    chat_event.ChatParticipantLeft event,
    Emitter<chat_state.ChatState> emit,
  ) async {
    emit(chat_state.ParticipantLeftRoomInRealTime(event.chatId, event.participantId));
  }

  // Helper methods
  void handleMessageTap(BuildContext context, domain.MessageEntity message) {
    // Handle different message types
    switch (message.type) {
      case domain.MessageType.image:
      case domain.MessageType.video:
      case domain.MessageType.audio:
      case domain.MessageType.file:
        _openAttachment(context, message);
        break;
      case domain.MessageType.location:
        _openLocation(context, message);
        break;
      case domain.MessageType.contact:
        _openContact(context, message);
        break;
      default:
        break;
    }
  }

  void _openAttachment(BuildContext context, domain.MessageEntity message) {
    // TODO: Implement attachment viewer
    debugPrint('Opening attachment: ${message.content}');
  }

  void _openLocation(BuildContext context, domain.MessageEntity message) {
    // TODO: Implement location viewer
    debugPrint('Opening location: ${message.content}');
  }

  void _openContact(BuildContext context, domain.MessageEntity message) {
    // TODO: Implement contact viewer
    debugPrint('Opening contact: ${message.content}');
  }

  void updateTypingStatus(String chatId, bool isTyping) {
    add(chat_event.SendTypingIndicatorRequested(chatId, isTyping));
  }

  void handleFileUpload(String chatId, String filePath, String fileType) {
    // TODO: Get file name and size
    final fileName = filePath.split('/').last;
    final fileSize = 1024; // TODO: Get actual file size

    add(chat_event.UploadFileRequested(UploadFileRequest(
      chatId: chatId,
      fileName: fileName,
      filePath: filePath,
      fileType: fileType,
      fileSize: fileSize,
    )));
  }
}
