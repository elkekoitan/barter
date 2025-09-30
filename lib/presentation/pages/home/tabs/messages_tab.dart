import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../widgets/custom_button.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  final List<ChatPreview> recentChats = const [
    ChatPreview(
      id: '1',
      userName: 'Ahmet Yılmaz',
      userAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
      lastMessage: 'Merhaba, ürününüz hakkında bilgi alabilir miyim?',
      lastMessageTime: '10:30',
      unreadCount: 2,
      listingTitle: 'iPhone 13 Pro Max',
      listingImage: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=100&h=100&fit=crop',
    ),
    ChatPreview(
      id: '2',
      userName: 'Ayşe Kara',
      userAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=100&h=100&fit=crop&crop=face',
      lastMessage: 'Takas teklifim için teşekkürler, düşüneceğim.',
      lastMessageTime: 'Dün',
      unreadCount: 0,
      listingTitle: 'Samsung Galaxy S22',
      listingImage: 'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=100&h=100&fit=crop',
    ),
    ChatPreview(
      id: '3',
      userName: 'Mehmet Öz',
      userAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
      lastMessage: 'Ürün elime ulaştı, çok teşekkür ederim!',
      lastMessageTime: '2 gün önce',
      unreadCount: 1,
      listingTitle: 'MacBook Pro M1',
      listingImage: 'https://images.unsplash.com/photo-1517333271689-d6bb5cd1b1c8?w=100&h=100&fit=crop',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'messages'.tr(),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, size: 24.w),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, size: 24.w),
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Stats
          _buildChatStats(),

          // Chat List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              itemCount: recentChats.length + 1,
              itemBuilder: (context, index) {
                if (index == recentChats.length) {
                  return _buildChatActions(context);
                }

                final chat = recentChats[index];
                return ChatListItem(
                  chat: chat,
                  onTap: () => _openChat(context, chat),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startNewConversation(context),
        backgroundColor: AppColors.primary,
        child: Icon(Icons.chat, size: 20.w),
      ),
    );
  }

  Widget _buildChatStats() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      color: AppColors.primary.withOpacity(0.05),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.chat_bubble,
              count: '12',
              label: 'Toplam Sohbet',
            ),
          ),
          Container(
            width: 1.w,
            height: 24.h,
            color: AppColors.border,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.notifications,
              count: '3',
              label: 'Okunmamış',
            ),
          ),
          Container(
            width: 1.w,
            height: 24.h,
            color: AppColors.border,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.swap_horiz,
              count: '5',
              label: 'Aktif Takas',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatActions(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      child: CustomButton(
        text: 'Tüm Sohbetler',
        onPressed: () => _navigateToChats(context),
        size: ButtonSize.medium,
        type: ButtonType.outline,
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String count,
    required String label,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.w,
              color: AppColors.primary,
            ),
            SizedBox(width: 4.w),
            Text(
              count,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class ChatPreview {
  final String id;
  final String userName;
  final String userAvatar;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final String listingTitle;
  final String listingImage;

  const ChatPreview({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.listingTitle,
    required this.listingImage,
  });
}

class ChatListItem extends StatelessWidget {
  final ChatPreview chat;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.marginM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        border: Border.all(color: AppColors.border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            child: Row(
              children: [
                // User Avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24.w,
                      backgroundImage: NetworkImage(chat.userAvatar),
                    ),
                    if (chat.unreadCount > 0)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 16.w,
                          height: 16.w,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 2.w,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              chat.unreadCount.toString(),
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(width: AppDimensions.marginM),

                // Chat Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Name and Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            chat.userName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            chat.lastMessageTime,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),

                      // Listing Title
                      Text(
                        chat.listingTitle,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Last Message
                      Text(
                        chat.lastMessage,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: AppDimensions.marginM),

                // Listing Image
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
                    image: DecorationImage(
                      image: NetworkImage(chat.listingImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _openChat(BuildContext context, ChatPreview chat) {
  // TODO: Navigate to chat screen
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${chat.userName} ile sohbete yönlendiriliyor...'),
    ),
  );
}

  void _startNewConversation(BuildContext context) {
    // TODO: Navigate to new conversation screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Yeni sohbet başlatılıyor...'),
      ),
    );
  }

  void _navigateToChats(BuildContext context) {
    Navigator.pushNamed(context, '/chats');
  }
