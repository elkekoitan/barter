import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:async';
import '../../../domain/entities/chat.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../blocs/chat/chat_bloc.dart';
import '../../blocs/chat/chat_event.dart' as chat_event;
import '../../blocs/chat/chat_state.dart' as chat_state;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/chat_repository.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatId;
  final ChatEntity? chat;

  const ChatRoomPage({
    super.key,
    required this.chatId,
    this.chat,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage>
    with TickerProviderStateMixin {
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  late FocusNode _messageFocusNode;
  late AnimationController _typingController;
  // late KeyboardVisibilityController _keyboardController;

  bool _isTyping = false;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadMessages();
    _startListeningToTyping();
  }

  void _initializeControllers() {
    _messageController = TextEditingController()
      ..addListener(_onMessageChanged);

    _scrollController = ScrollController()
      ..addListener(_onScroll);

    _messageFocusNode = FocusNode();

    _typingController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // _keyboardController = KeyboardVisibilityController();
  }

  void _onMessageChanged() {
    final isTyping = _messageController.text.isNotEmpty;
    if (isTyping != _isTyping) {
      setState(() => _isTyping = isTyping);
      _handleTypingIndicator();
    }
  }

  void _handleTypingIndicator() {
    context.read<ChatBloc>().updateTypingStatus(widget.chatId, _isTyping);

    _typingTimer?.cancel();
    if (_isTyping) {
      _typingTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          context.read<ChatBloc>().updateTypingStatus(widget.chatId, false);
        }
      });
    }
  }

  void _onScroll() {
    // Auto-scroll to bottom when new messages arrive
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Already at bottom
    }
  }

  void _loadMessages() {
    context.read<ChatBloc>().add(
      chat_event.GetMessagesRequested(chatId: widget.chatId),
    );
  }

  void _startListeningToTyping() {
    // TODO: Subscribe to typing indicators
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageFocusNode.dispose();
    _typingController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: _buildMessagesList(),
          ),

          // Typing Indicator
          _buildTypingIndicator(),

          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      title: _buildChatTitle(),
      actions: _buildChatActions(),
    );
  }

  Widget _buildChatTitle() {
    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 20.w,
          backgroundImage: widget.chat?.participant.avatarUrl != null
              ? CachedNetworkImageProvider(widget.chat!.participant.avatarUrl!)
              : null,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: widget.chat?.participant.avatarUrl == null
              ? Text(
                  widget.chat?.participant.displayName[0].toUpperCase() ?? 'U',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                )
              : null,
        ),

        SizedBox(width: AppDimensions.marginM),

        // User Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.chat?.displayTitle ?? 'Chat',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.chat?.participant.isOnline ?? false) ...[
                Text(
                  'online'.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.success,
                  ),
                ),
              ] else ...[
                Text(
                  widget.chat?.participant.onlineStatus ?? '',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChatActions() {
    return [
      IconButton(
        onPressed: _showChatInfo,
        icon: Icon(Icons.info_outline, size: 24.w),
      ),
      IconButton(
        onPressed: _makeVoiceCall,
        icon: Icon(Icons.call, size: 24.w),
      ),
      IconButton(
        onPressed: _makeVideoCall,
        icon: Icon(Icons.videocam, size: 24.w),
      ),
    ];
  }

  Widget _buildMessagesList() {
    return BlocConsumer<ChatBloc, chat_state.ChatState>(
      listener: (context, state) {
        if (state is chat_state.MessagesLoaded) {
          _scrollToBottom();
        } else if (state is chat_state.MessageReceivedInRealTime) {
          _scrollToBottom();
        } else if (state is chat_state.ChatError) {
          _showErrorSnackBar(state.message);
        }
      },
      builder: (context, state) {
        if (state is chat_state.MessagesLoading && state is! chat_state.MessagesLoaded) {
          return _buildMessagesLoading();
        }

        if (state is chat_state.MessagesLoaded) {
          if (state.messages.isEmpty) {
            return _buildEmptyMessages();
          }

          return _buildMessagesContent(state.messages);
        }

        return _buildEmptyMessages();
      },
    );
  }

  Widget _buildMessagesLoading() {
    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      itemCount: 20,
      reverse: true,
      itemBuilder: (context, index) => _buildMessageSkeleton(),
    );
  }

  Widget _buildEmptyMessages() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80.w,
            color: AppColors.textMuted,
          ),
          SizedBox(height: AppDimensions.marginL),
          Text(
            'no_messages_yet'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.marginS),
          Text(
            'start_conversation'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesContent(List<MessageEntity> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(AppDimensions.paddingL),
      itemCount: messages.length,
      reverse: true,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isLast = index == messages.length - 1;
        return _buildMessageItem(message, isLast);
      },
    );
  }

  Widget _buildMessageItem(MessageEntity message, bool isLast) {
    final isOwnMessage = message.senderId == 'current_user_id'; // TODO: Get from auth

    return Container(
      margin: EdgeInsets.only(
        left: isOwnMessage ? 60.w : 0,
        right: isOwnMessage ? 0 : 60.w,
        bottom: isLast ? 20.h : AppDimensions.marginM,
      ),
      child: Row(
        mainAxisAlignment: isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar (for received messages)
          if (!isOwnMessage) ...[
            CircleAvatar(
              radius: 16.w,
              backgroundImage: message.senderAvatar != null
                  ? CachedNetworkImageProvider(message.senderAvatar!)
                  : null,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: message.senderAvatar == null
                  ? Text(
                      message.senderName[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: AppDimensions.marginS),
          ],

          // Message Bubble
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.paddingS,
              ),
              decoration: BoxDecoration(
                color: isOwnMessage
                    ? AppColors.primary
                    : AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
                border: Border.all(
                  color: isOwnMessage
                      ? AppColors.transparent
                      : AppColors.border,
                  width: 1.w,
                ),
                boxShadow: isOwnMessage
                    ? []
                    : [
                        BoxShadow(
                          color: AppColors.shadow.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: isOwnMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // Sender Name (for group chats)
                  if (!isOwnMessage && widget.chat?.type == ChatType.group) ...[
                    Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],

                  // Message Content
                  _buildMessageContent(message),

                  // Message Info
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.displayTime,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: isOwnMessage
                              ? AppColors.white.withOpacity(0.7)
                              : AppColors.textMuted,
                        ),
                      ),

                      if (isOwnMessage) ...[
                        SizedBox(width: 4.w),
                        _buildMessageStatus(message.status),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(MessageEntity message) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: TextStyle(
            fontSize: 14.sp,
            color: message.senderId == 'current_user_id'
                ? AppColors.white
                : AppColors.textPrimary,
            height: 1.4,
          ),
        );

      case MessageType.image:
        return _buildImageMessage(message);

      case MessageType.video:
        return _buildVideoMessage(message);

      case MessageType.audio:
        return _buildAudioMessage(message);

      case MessageType.file:
        return _buildFileMessage(message);

      case MessageType.location:
        return _buildLocationMessage(message);

      case MessageType.contact:
        return _buildContactMessage(message);

      case MessageType.sticker:
        return _buildStickerMessage(message);

      case MessageType.gif:
        return _buildGifMessage(message);

      case MessageType.system:
        return _buildSystemMessage(message);
    }
  }

  Widget _buildImageMessage(MessageEntity message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 200.w,
          height: 150.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
            image: DecorationImage(
              image: NetworkImage(message.content),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (message.content.isNotEmpty) ...[
          SizedBox(height: AppDimensions.marginS),
          Text(
            message.content,
            style: TextStyle(
              fontSize: 14.sp,
              color: message.senderId == 'current_user_id'
                  ? AppColors.white
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVideoMessage(MessageEntity message) {
    return Row(
      children: [
        Icon(
          Icons.play_circle_fill,
          size: 40.w,
          color: message.senderId == 'current_user_id'
              ? AppColors.white
              : AppColors.primary,
        ),
        SizedBox(width: AppDimensions.marginS),
        Expanded(
          child: Text(
            message.content,
            style: TextStyle(
              fontSize: 14.sp,
              color: message.senderId == 'current_user_id'
                  ? AppColors.white
                  : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAudioMessage(MessageEntity message) {
    return Row(
      children: [
        Icon(
          Icons.mic,
          size: 24.w,
          color: message.senderId == 'current_user_id'
              ? AppColors.white
              : AppColors.primary,
        ),
        SizedBox(width: AppDimensions.marginS),
        Expanded(
          child: Text(
            '🔊 ${message.content}',
            style: TextStyle(
              fontSize: 14.sp,
              color: message.senderId == 'current_user_id'
                  ? AppColors.white
                  : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileMessage(MessageEntity message) {
    return Row(
      children: [
        Icon(
          Icons.insert_drive_file,
          size: 24.w,
          color: message.senderId == 'current_user_id'
              ? AppColors.white
              : AppColors.primary,
        ),
        SizedBox(width: AppDimensions.marginS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: message.senderId == 'current_user_id'
                      ? AppColors.white
                      : AppColors.textPrimary,
                ),
              ),
              Text(
                'file_size'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: message.senderId == 'current_user_id'
                      ? AppColors.white.withOpacity(0.7)
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationMessage(MessageEntity message) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 24.w,
          color: message.senderId == 'current_user_id'
              ? AppColors.white
              : AppColors.primary,
        ),
        SizedBox(width: AppDimensions.marginS),
        Expanded(
          child: Text(
            '📍 ${message.content}',
            style: TextStyle(
              fontSize: 14.sp,
              color: message.senderId == 'current_user_id'
                  ? AppColors.white
                  : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactMessage(MessageEntity message) {
    return Row(
      children: [
        Icon(
          Icons.person,
          size: 24.w,
          color: message.senderId == 'current_user_id'
              ? AppColors.white
              : AppColors.primary,
        ),
        SizedBox(width: AppDimensions.marginS),
        Expanded(
          child: Text(
            '👤 ${message.content}',
            style: TextStyle(
              fontSize: 14.sp,
              color: message.senderId == 'current_user_id'
                  ? AppColors.white
                  : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStickerMessage(MessageEntity message) {
    return Text(
      message.content,
      style: TextStyle(fontSize: 40.sp),
    );
  }

  Widget _buildGifMessage(MessageEntity message) {
    return Container(
      width: 150.w,
      height: 100.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
        color: AppColors.inputBackground,
      ),
      child: Icon(
        Icons.gif,
        size: 40.w,
        color: AppColors.textMuted,
      ),
    );
  }

  Widget _buildSystemMessage(MessageEntity message) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
      ),
      child: Text(
        message.content,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.info,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMessageStatus(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return SizedBox(
          width: 12.w,
          height: 12.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white.withOpacity(0.7)),
          ),
        );
      case MessageStatus.sent:
        return Icon(
          Icons.check,
          size: 12.w,
          color: AppColors.white.withOpacity(0.7),
        );
      case MessageStatus.delivered:
        return Icon(
          Icons.done_all,
          size: 12.w,
          color: AppColors.white.withOpacity(0.7),
        );
      case MessageStatus.read:
        return Icon(
          Icons.done_all,
          size: 12.w,
          color: AppColors.white,
        );
      case MessageStatus.failed:
        return Icon(
          Icons.error,
          size: 12.w,
          color: AppColors.error,
        );
    }
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Row(
        children: [
          // Avatar placeholder for typing indicator
          SizedBox(
            width: 32.w,
            child: Text(
              '💭',
              style: TextStyle(fontSize: 20.sp),
            ),
          ),
          SizedBox(width: AppDimensions.marginM),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
              border: Border.all(color: AppColors.border, width: 1.w),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const DotsTypingIndicator(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1.w,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment Button
            IconButton(
              onPressed: _showAttachmentOptions,
              icon: Icon(
                Icons.attach_file,
                size: 24.w,
                color: AppColors.textSecondary,
              ),
            ),

            SizedBox(width: AppDimensions.marginS),

            // Message Input
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXXL),
                  border: Border.all(color: AppColors.border, width: 1.w),
                ),
                child: TextField(
                  controller: _messageController,
                  focusNode: _messageFocusNode,
                  decoration: InputDecoration(
                    hintText: 'type_message'.tr(),
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textMuted,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
                  ),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),

            SizedBox(width: AppDimensions.marginS),

            // Send Button
            AnimatedOpacity(
              opacity: _isTyping ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                onPressed: _isTyping ? _sendMessage : null,
                icon: Icon(
                  Icons.send,
                  size: 24.w,
                  color: _isTyping ? AppColors.primary : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageSkeleton() {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.marginM),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: AppDimensions.marginM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity * 0.6,
                  height: 16.h,
                  color: AppColors.inputBackground,
                ),
                SizedBox(height: AppDimensions.marginS),
                Container(
                  width: double.infinity * 0.4,
                  height: 14.h,
                  color: AppColors.inputBackground,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0, // Reverse list, so 0 is bottom
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final messageRequest = SendMessageRequest(
        chatId: widget.chatId,
        type: MessageType.text,
        content: _messageController.text.trim(),
      );

      context.read<ChatBloc>().add(chat_event.SendMessageRequested(messageRequest));

      _messageController.clear();
      _messageFocusNode.unfocus();

      // Clear typing indicator
      context.read<ChatBloc>().updateTypingStatus(widget.chatId, false);
    }
  }

  void _showAttachmentOptions() {
    // TODO: Show attachment options (camera, gallery, file, etc.)
    debugPrint('Show attachment options');
  }

  void _showChatInfo() {
    // TODO: Show chat info dialog
    debugPrint('Show chat info');
  }

  void _makeVoiceCall() {
    // TODO: Start voice call
    debugPrint('Make voice call');
  }

  void _makeVideoCall() {
    // TODO: Start video call
    debugPrint('Make video call');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }
}

class DotsTypingIndicator extends StatefulWidget {
  const DotsTypingIndicator({super.key});

  @override
  State<DotsTypingIndicator> createState() => _DotsTypingIndicatorState();
}

class _DotsTypingIndicatorState extends State<DotsTypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _animations = List.generate(3, (index) {
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 33.3,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 33.3,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: 0.0),
          weight: 33.4,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.2, (index + 1) * 0.2, curve: Curves.linear),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              width: 4.w,
              height: 4.w,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(_animations[index].value),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
