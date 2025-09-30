import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../blocs/chat/chat_bloc.dart';
import '../../blocs/chat/chat_event.dart' as chat_event;
import '../../blocs/chat/chat_state.dart' as chat_state;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/chat.dart';
import '../../../domain/repositories/chat_repository.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage>
    with TickerProviderStateMixin {
  late AnimationController _fabController;
  late ScrollController _scrollController;
  late TextEditingController _searchController;

  bool _isSearching = false;
  String _searchQuery = '';
  ChatTabType _currentTab = ChatTabType.all;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadChats();
  }

  void _initializeControllers() {
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scrollController = ScrollController()
      ..addListener(_onScroll);

    _searchController = TextEditingController()
      ..addListener(_onSearchChanged);

    _fabController.forward();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    if (offset > 100 && _fabController.value == 1.0) {
      _fabController.reverse();
    } else if (offset <= 100 && _fabController.value == 0.0) {
      _fabController.forward();
    }
  }

  void _loadChats() {
    context.read<ChatBloc>().add(const chat_event.GetChatsRequested());
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    _performSearch();
  }

  void _performSearch() {
    if (_searchQuery.isNotEmpty) {
      context.read<ChatBloc>().add(
        chat_event.SearchChatsRequested(SearchChatsRequest(query: _searchQuery)),
      );
    } else {
      _loadChats();
    }
  }

  @override
  void dispose() {
    _fabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      title: _isSearching ? _buildSearchField() : _buildTitle(),
      actions: _buildActions(),
      bottom: _isSearching ? null : _buildTabBar(),
    );
  }

  Widget _buildTitle() {
    return Text(
      'messages'.tr(),
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'search_chats'.tr(),
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textMuted,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 20.w,
            color: AppColors.textMuted,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: Icon(
                    Icons.clear,
                    size: 20.w,
                    color: AppColors.textMuted,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
        ),
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return [];
    }

    return [
      IconButton(
        onPressed: _toggleSearch,
        icon: Icon(
          Icons.search,
          size: 24.w,
        ),
      ),
      IconButton(
        onPressed: _showCreateChatDialog,
        icon: Icon(
          Icons.add,
          size: 24.w,
        ),
      ),
    ];
  }

  PreferredSizeWidget _buildTabBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(48.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          border: Border(
            bottom: BorderSide(
              color: AppColors.border,
              width: 1.w,
            ),
          ),
        ),
        child: Row(
          children: [
            _buildTabItem('all_chats'.tr(), ChatTabType.all),
            _buildTabItem('active'.tr(), ChatTabType.active),
            _buildTabItem('archived'.tr(), ChatTabType.archived),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, ChatTabType type) {
    final isSelected = _currentTab == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabSelected(type),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<ChatBloc, chat_state.ChatState>(
      listener: (context, state) {
        if (state is chat_state.ChatError) {
          _showErrorDialog(state.message);
        }
      },
      builder: (context, state) {
        if (state is chat_state.ChatsLoading) {
          return _buildLoadingState();
        }

        if (state is chat_state.ChatsLoaded) {
          if (state.chats.isEmpty) {
            return _buildEmptyState();
          }

          return _buildChatsList(state.chats);
        }

        if (state is chat_state.ChatsSearched) {
          if (state.chats.isEmpty) {
            return _buildNoSearchResults();
          }

          return _buildChatsList(state.chats);
        }

        return _buildEmptyState();
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      itemCount: 10,
      itemBuilder: (context, index) => _buildChatSkeleton(),
    );
  }

  Widget _buildEmptyState() {
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
            'no_chats_yet'.tr(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.marginS),
          Text(
            'start_a_conversation'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.marginXXL),
          ElevatedButton.icon(
            onPressed: _showCreateChatDialog,
            icon: Icon(Icons.add),
            label: Text('start_chat'.tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
                vertical: AppDimensions.paddingM,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80.w,
            color: AppColors.textMuted,
          ),
          SizedBox(height: AppDimensions.marginL),
          Text(
            'no_search_results'.tr(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.marginS),
          Text(
            'no_chats_match'.tr(args: [_searchQuery]),
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChatsList(List<ChatEntity> chats) {
    final filteredChats = _filterChats(chats);

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(AppDimensions.paddingL),
      itemCount: filteredChats.length,
      itemBuilder: (context, index) {
        final chat = filteredChats[index];
        return _buildChatItem(chat);
      },
    );
  }

  List<ChatEntity> _filterChats(List<ChatEntity> chats) {
    if (_searchQuery.isEmpty) {
      return chats;
    }

    return chats.where((chat) {
      return chat.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             chat.participant.displayName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Widget _buildChatItem(ChatEntity chat) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.marginM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        border: Border.all(
          color: chat.showUnreadBadge ? AppColors.primary.withValues(alpha: 0.2) : AppColors.border,
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        child: InkWell(
          onTap: () => _openChat(chat),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Row(
              children: [
                // Avatar
                _buildChatAvatar(chat),

                SizedBox(width: AppDimensions.marginM),

                // Chat Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              chat.displayTitle,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: chat.showUnreadBadge ? FontWeight.w600 : FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            chat.lastActivityText,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),

                      // Last Message
                      if (chat.lastMessage != null) ...[
                        Text(
                          _getLastMessageText(chat.lastMessage!),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ] else ...[
                        Text(
                          'no_messages_yet'.tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],

                      SizedBox(height: 4.h),

                      // Status Row
                      Row(
                        children: [
                          // Online Status
                          if (chat.participant.isOnline) ...[
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'online'.tr(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.success,
                              ),
                            ),
                          ] else ...[
                            Text(
                              chat.participant.onlineStatus,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],

                          const Spacer(),

                          // Unread Badge
                          if (chat.showUnreadBadge) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                              child: Text(
                                chat.unreadCount > 99 ? '99+' : chat.unreadCount.toString(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatAvatar(ChatEntity chat) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 24.w,
          backgroundImage: chat.participant.avatarUrl != null
              ? CachedNetworkImageProvider(chat.participant.avatarUrl!)
              : null,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: chat.participant.avatarUrl == null
              ? Text(
                  chat.participant.displayName[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                )
              : null,
        ),

        // Online indicator
        if (chat.isOnline) ...[
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white,
                  width: 2.w,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _getLastMessageText(MessageEntity message) {
    switch (message.type) {
      case MessageType.text:
        return message.content;
      case MessageType.image:
        return '📷 ${'photo'.tr()}';
      case MessageType.video:
        return '🎥 ${'video'.tr()}';
      case MessageType.audio:
        return '🎵 ${'audio'.tr()}';
      case MessageType.file:
        return '📎 ${message.content}';
      case MessageType.location:
        return '📍 ${'location'.tr()}';
      case MessageType.contact:
        return '👤 ${'contact'.tr()}';
      case MessageType.sticker:
        return '😊 ${'sticker'.tr()}';
      case MessageType.gif:
        return '🎬 ${'gif'.tr()}';
      case MessageType.system:
        return 'ℹ️ ${message.content}';
    }
  }

  Widget _buildChatSkeleton() {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.marginM),
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        border: Border.all(color: AppColors.border, width: 1.w),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
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

  Widget _buildFloatingActionButton() {
    return AnimatedSlide(
      offset: _fabController.value == 1.0 ? Offset.zero : const Offset(0, 2),
      duration: const Duration(milliseconds: 200),
      child: AnimatedOpacity(
        opacity: _fabController.value,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton.extended(
          onPressed: _loadChats,
          backgroundColor: AppColors.primary,
          icon: Icon(Icons.refresh, size: 20.w),
          label: Text('refresh'.tr()),
        ),
      ),
    );
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        _loadChats();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    _loadChats();
  }

  void _onTabSelected(ChatTabType type) {
    setState(() {
      _currentTab = type;
    });
    // TODO: Filter chats based on tab type
    debugPrint('Tab selected: $type');
  }

  void _openChat(ChatEntity chat) {
    // TODO: Navigate to chat room
    debugPrint('Opening chat: ${chat.title}');
  }

  void _showCreateChatDialog() {
    // TODO: Show create chat dialog
    debugPrint('Show create chat dialog');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('error'.tr()),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ok'.tr()),
          ),
        ],
      ),
    );
  }
}

enum ChatTabType { all, active, archived }
