import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/chat/get_chats_usecase.dart';
import '../../../domain/usecases/chat/send_message_usecase.dart';
import '../../../domain/usecases/chat/create_chat_usecase.dart';
import '../../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
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
        super(ChatInitial()) {
    on<GetChatsRequested>(_onGetChatsRequested);
    on<GetChatByIdRequested>(_onGetChatByIdRequested);
    on<CreateChatRequested>(_onCreateChatRequested);
    on<UpdateChatRequested>(_onUpdateChatRequested);
    on<DeleteChatRequested>(_onDeleteChatRequested);
    on<ArchiveChatRequested>(_onArchiveChatRequested);
    on<UnarchiveChatRequested>(_onUnarchiveChatRequested);
    on<BlockChatRequested>(_onBlockChatRequested);
    on<UnblockChatRequested>(_onUnblockChatRequested);
    on<MuteChatRequested>(_onMuteChatRequested);
    on<UnmuteChatRequested>(_onUnmuteChatRequested);
    on<GetMessagesRequested>(_onGetMessagesRequested);
    on<SendMessageRequested>(_onSendMessageRequested);
    on<EditMessageRequested>(_onEditMessageRequested);
    on<DeleteMessageRequested>(_onDeleteMessageRequested);
    on<MarkMessageAsReadRequested>(_onMarkMessageAsReadRequested);
    on<MarkMessagesAsReadRequested>(_onMarkMessagesAsReadRequested);
    on<ReactToMessageRequested>(_onReactToMessageRequested);
    on<RemoveReactionRequested>(_onRemoveReactionRequested);
    on<ReplyToMessageRequested>(_onReplyToMessageRequested);
    on<ForwardMessageRequested>(_onForwardMessageRequested);
    on<SearchMessagesRequested>(_onSearchMessagesRequested);
    on<SearchChatsRequested>(_onSearchChatsRequested);
    on<UploadFileRequested>(_onUploadFileRequested);
    on<DeleteFileRequested>(_onDeleteFileRequested);
    on<SendTypingIndicatorRequested>(_onSendTypingIndicatorRequested);
    on<CreateChatRoomRequested>(_onCreateChatRoomRequested);
    on<GetChatRoomRequested>(_onGetChatRoomRequested);
    on<GetUserChatRoomsRequested>(_onGetUserChatRoomsRequested);
    on<JoinChatRoomRequested>(_onJoinChatRoomRequested);
    on<LeaveChatRoomRequested>(_onLeaveChatRoomRequested);
    on<AddParticipantToRoomRequested>(_onAddParticipantToRoomRequested);
    on<RemoveParticipantFromRoomRequested>(_onRemoveParticipantFromRoomRequested);
    on<UpdateRoomSettingsRequested>(_onUpdateRoomSettingsRequested);
    on<GetChatStatsRequested>(_onGetChatStatsRequested);
    on<MarkAllMessagesAsReadRequested>(_onMarkAllMessagesAsReadRequested);
    on<DeleteMultipleMessagesRequested>(_onDeleteMultipleMessagesRequested);
    on<ClearChatHistoryRequested>(_onClearChatHistoryRequested);
    on<CacheMessagesRequested>(_onCacheMessagesRequested);
    on<GetCachedMessagesRequested>(_onGetCachedMessagesRequested);
    on<ClearMessageCacheRequested>(_onClearMessageCacheRequested);
    on<RefreshChatsRequested>(_onRefreshChatsRequested);
    on<LoadMoreChatsRequested>(_onLoadMoreChatsRequested);
    on<LoadMoreMessagesRequested>(_onLoadMoreMessagesRequested);
    on<ClearChatCacheRequested>(_onClearChatCacheRequested);
    on<ChatUpdated>(_onChatUpdated);
    on<MessageReceived>(_onMessageReceived);
    on<MessageUpdated>(_onMessageUpdated);
    on<TypingIndicatorReceived>(_onTypingIndicatorReceived);
    on<ChatParticipantJoined>(_onChatParticipantJoined);
    on<ChatParticipantLeft>(_onChatParticipantLeft);
  }

  Future<void> _onGetChatsRequested(
    GetChatsRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatsLoading());

    final result = await _getChatsUseCase.call(
      filter: event.filter,
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (chats) => emit(ChatsLoaded(
        chats: chats,
        currentPage: event.page,
        hasMore: chats.length == event.limit,
        totalCount: chats.length,
      )),
    );
  }

  Future<void> _onGetChatByIdRequested(
    GetChatByIdRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    final result = await _chatRepository.getChatById(event.chatId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (chat) => emit(ChatLoaded(chat)),
    );
  }

  Future<void> _onCreateChatRequested(
    CreateChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    final result = await _createChatUseCase.call(event.request);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (chat) => emit(ChatCreated(chat)),
    );
  }

  Future<void> _onUpdateChatRequested(
    UpdateChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.updateChat(event.chatId, event.request);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (chat) => emit(ChatUpdated(chat)),
    );
  }

  Future<void> _onDeleteChatRequested(
    DeleteChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.deleteChat(event.chatId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(ChatDeleted(event.chatId)),
    );
  }

  Future<void> _onArchiveChatRequested(
    ArchiveChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.archiveChat(event.chatId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(ChatArchived(event.chatId)),
    );
  }

  Future<void> _onUnarchiveChatRequested(
    UnarchiveChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.unarchiveChat(event.chatId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(ChatUnarchived(event.chatId)),
    );
  }

  Future<void> _onBlockChatRequested(
    BlockChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.blockChat(event.chatId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(ChatBlocked(event.chatId)),
    );
  }

  Future<void> _onUnblockChatRequested(
    UnblockChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.unblockChat(event.chatId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(ChatUnblocked(event.chatId)),
    );
  }

  Future<void> _onMuteChatRequested(
    MuteChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.muteChat(event.chatId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(ChatMuted(event.chatId)),
    );
  }

  Future<void> _onUnmuteChatRequested(
    UnmuteChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.unmuteChat(event.chatId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(ChatUnmuted(event.chatId)),
    );
  }

  Future<void> _onGetMessagesRequested(
    GetMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(MessagesLoading());

    final result = await _chatRepository.getMessages(
      event.chatId,
      page: event.page,
      limit: event.limit,
      filter: event.filter,
    );

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (messages) => emit(MessagesLoaded(
        chatId: event.chatId,
        messages: messages,
        currentPage: event.page,
        hasMore: messages.length == event.limit,
      )),
    );
  }

  Future<void> _onSendMessageRequested(
    SendMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _sendMessageUseCase.call(event.request);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (message) => emit(MessageSent(message)),
    );
  }

  Future<void> _onEditMessageRequested(
    EditMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.editMessage(event.messageId, event.newContent);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (message) => emit(MessageEdited(message)),
    );
  }

  Future<void> _onDeleteMessageRequested(
    DeleteMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.deleteMessage(event.messageId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(MessageDeleted(event.messageId)),
    );
  }

  Future<void> _onMarkMessageAsReadRequested(
    MarkMessageAsReadRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.markMessageAsRead(event.messageId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(MessageMarkedAsRead(event.messageId)),
    );
  }

  Future<void> _onMarkMessagesAsReadRequested(
    MarkMessagesAsReadRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.markMessagesAsRead(event.messageIds);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (messageIds) => emit(MessagesMarkedAsRead(messageIds)),
    );
  }

  Future<void> _onReactToMessageRequested(
    ReactToMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.reactToMessage(event.messageId, event.emoji);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (reaction) => emit(MessageReacted(event.messageId, reaction)),
    );
  }

  Future<void> _onRemoveReactionRequested(
    RemoveReactionRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.removeReaction(event.messageId, event.emoji);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(ReactionRemoved(event.messageId, event.emoji)),
    );
  }

  Future<void> _onReplyToMessageRequested(
    ReplyToMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.replyToMessage(event.request);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (reply) => emit(MessageReplied(reply)),
    );
  }

  Future<void> _onForwardMessageRequested(
    ForwardMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.forwardMessage(event.request);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (message) => emit(MessageForwarded(message, event.request.targetChatId)),
    );
  }

  Future<void> _onSearchMessagesRequested(
    SearchMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.searchMessages(event.request);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (messages) => emit(MessagesSearched(messages, event.request.query)),
    );
  }

  Future<void> _onSearchChatsRequested(
    SearchChatsRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.searchChats(event.request);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (chats) => emit(ChatsSearched(chats, event.request.query)),
    );
  }

  Future<void> _onUploadFileRequested(
    UploadFileRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(FileUploading(event.request.fileName, 0.0));

    final result = await _chatRepository.uploadFile(event.request);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (attachment) => emit(FileUploaded(attachment)),
    );
  }

  Future<void> _onDeleteFileRequested(
    DeleteFileRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.deleteFile(event.fileId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(FileDeleted(event.fileId)),
    );
  }

  Future<void> _onSendTypingIndicatorRequested(
    SendTypingIndicatorRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.sendTypingIndicator(event.chatId, event.isTyping);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => {}, // Typing indicator sent successfully
    );
  }

  Future<void> _onCreateChatRoomRequested(
    CreateChatRoomRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    final result = await _chatRepository.createChatRoom(event.request);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (room) => emit(ChatRoomCreated(room)),
    );
  }

  Future<void> _onGetChatRoomRequested(
    GetChatRoomRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    final result = await _chatRepository.getChatRoom(event.roomId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (room) => emit(ChatRoomLoaded(room)),
    );
  }

  Future<void> _onGetUserChatRoomsRequested(
    GetUserChatRoomsRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.getUserChatRooms();

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (rooms) => emit(UserChatRoomsLoaded(rooms)),
    );
  }

  Future<void> _onJoinChatRoomRequested(
    JoinChatRoomRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.joinChatRoom(event.roomId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(ChatRoomJoined(event.roomId)),
    );
  }

  Future<void> _onLeaveChatRoomRequested(
    LeaveChatRoomRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.leaveChatRoom(event.roomId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(ChatRoomLeft(event.roomId)),
    );
  }

  Future<void> _onAddParticipantToRoomRequested(
    AddParticipantToRoomRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.addParticipantToRoom(event.roomId, event.userId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (participant) => emit(ParticipantAddedToRoom(event.roomId, participant)),
    );
  }

  Future<void> _onRemoveParticipantFromRoomRequested(
    RemoveParticipantFromRoomRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.removeParticipantFromRoom(event.roomId, event.userId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(ParticipantRemovedFromRoom(event.roomId, event.userId)),
    );
  }

  Future<void> _onUpdateRoomSettingsRequested(
    UpdateRoomSettingsRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.updateRoomSettings(event.roomId, event.settings);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(RoomSettingsUpdated(event.roomId, event.settings)),
    );
  }

  Future<void> _onGetChatStatsRequested(
    GetChatStatsRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.getChatStats();

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (stats) => emit(ChatStatsLoaded(stats)),
    );
  }

  Future<void> _onMarkAllMessagesAsReadRequested(
    MarkAllMessagesAsReadRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.markAllMessagesAsRead(event.chatId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(AllMessagesMarkedAsRead(event.chatId)),
    );
  }

  Future<void> _onDeleteMultipleMessagesRequested(
    DeleteMultipleMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.deleteMultipleMessages(event.messageIds);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(MultipleMessagesDeleted(event.messageIds)),
    );
  }

  Future<void> _onClearChatHistoryRequested(
    ClearChatHistoryRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.clearChatHistory(event.chatId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(ChatHistoryCleared(event.chatId)),
    );
  }

  Future<void> _onCacheMessagesRequested(
    CacheMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.cacheMessages(event.chatId, event.messages);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(MessagesCached(event.chatId, event.messages)),
    );
  }

  Future<void> _onGetCachedMessagesRequested(
    GetCachedMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.getCachedMessages(event.chatId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (messages) => emit(CachedMessagesLoaded(event.chatId, messages)),
    );
  }

  Future<void> _onClearMessageCacheRequested(
    ClearMessageCacheRequested event,
    Emitter<ChatState> emit,
  ) async {
    final result = await _chatRepository.clearMessageCache(event.chatId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(MessageCacheCleared(event.chatId)),
    );
  }

  Future<void> _onRefreshChatsRequested(
    RefreshChatsRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatInitial());
  }

  Future<void> _onLoadMoreChatsRequested(
    LoadMoreChatsRequested event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is ChatsLoaded && currentState.hasMore) {
      emit(ChatsLoading(isLoadMore: true));

      final result = await _getChatsUseCase.call(
        filter: event.filter,
        page: currentState.currentPage + 1,
        limit: 20,
      );

      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (chats) => emit(ChatsLoaded(
          chats: [...currentState.chats, ...chats],
          currentPage: currentState.currentPage + 1,
          hasMore: chats.length == 20,
          totalCount: currentState.totalCount + chats.length,
        )),
      );
    }
  }

  Future<void> _onLoadMoreMessagesRequested(
    LoadMoreMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    final currentState = state;
    if (currentState is MessagesLoaded && currentState.hasMore) {
      emit(MessagesLoading(isLoadMore: true));

      final result = await _chatRepository.getMessages(
        event.chatId,
        page: currentState.currentPage + 1,
        limit: 50,
        filter: event.filter,
      );

      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (messages) => emit(MessagesLoaded(
          chatId: event.chatId,
          messages: [...currentState.messages, ...messages],
          currentPage: currentState.currentPage + 1,
          hasMore: messages.length == 50,
        )),
      );
    }
  }

  Future<void> _onClearChatCacheRequested(
    ClearChatCacheRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatCacheCleared());
  }

  Future<void> _onChatUpdated(
    ChatUpdated event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatUpdatedInRealTime(event.chat));
  }

  Future<void> _onMessageReceived(
    MessageReceived event,
    Emitter<ChatState> emit,
  ) async {
    emit(MessageReceivedInRealTime(event.message));
  }

  Future<void> _onMessageUpdated(
    MessageUpdated event,
    Emitter<ChatState> emit,
  ) async {
    emit(MessageUpdatedInRealTime(event.message));
  }

  Future<void> _onTypingIndicatorReceived(
    TypingIndicatorReceived event,
    Emitter<ChatState> emit,
  ) async {
    emit(TypingIndicatorReceivedInRealTime(event.indicator));
  }

  Future<void> _onChatParticipantJoined(
    ChatParticipantJoined event,
    Emitter<ChatState> emit,
  ) async {
    emit(ParticipantJoinedRoomInRealTime(event.chatId, event.participant));
  }

  Future<void> _onChatParticipantLeft(
    ChatParticipantLeft event,
    Emitter<ChatState> emit,
  ) async {
    emit(ParticipantLeftRoomInRealTime(event.chatId, event.participantId));
  }

  // Helper methods
  void handleMessageTap(BuildContext context, MessageEntity message) {
    // Handle different message types
    switch (message.type) {
      case MessageType.image:
      case MessageType.video:
      case MessageType.audio:
      case MessageType.file:
        _openAttachment(context, message);
        break;
      case MessageType.location:
        _openLocation(context, message);
        break;
      case MessageType.contact:
        _openContact(context, message);
        break;
      default:
        break;
    }
  }

  void _openAttachment(BuildContext context, MessageEntity message) {
    // TODO: Implement attachment viewer
    debugPrint('Opening attachment: ${message.content}');
  }

  void _openLocation(BuildContext context, MessageEntity message) {
    // TODO: Implement location viewer
    debugPrint('Opening location: ${message.content}');
  }

  void _openContact(BuildContext context, MessageEntity message) {
    // TODO: Implement contact viewer
    debugPrint('Opening contact: ${message.content}');
  }

  void updateTypingStatus(String chatId, bool isTyping) {
    add(SendTypingIndicatorRequested(chatId, isTyping));
  }

  void handleFileUpload(String chatId, String filePath, String fileType) {
    // TODO: Get file name and size
    final fileName = filePath.split('/').last;
    final fileSize = 1024; // TODO: Get actual file size

    add(UploadFileRequested(UploadFileRequest(
      chatId: chatId,
      fileName: fileName,
      filePath: filePath,
      fileType: fileType,
      fileSize: fileSize,
    )));
  }
}
