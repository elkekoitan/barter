import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/notification/notification_event.dart';
import '../../blocs/notification/notification_state.dart';
import '../../../domain/entities/notification.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/custom_button.dart';
import 'notification_settings_page.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage>
    with TickerProviderStateMixin {
  late AnimationController _refreshController;
  late AnimationController _fabController;
  late ScrollController _scrollController;

  bool _isRefreshing = false;
  NotificationFilterType _currentFilter = NotificationFilterType.all;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadNotifications();
  }

  void _initializeControllers() {
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scrollController = ScrollController()
      ..addListener(_onScroll);

    // Start FAB animation
    _fabController.forward();
  }

  void _onScroll() {
    final offset = _scrollController.offset;

    // Update FAB visibility based on scroll position
    if (offset > 100 && _fabController.value == 1.0) {
      _fabController.reverse();
    } else if (offset <= 100 && _fabController.value == 0.0) {
      _fabController.forward();
    }
  }

  void _loadNotifications() {
    context.read<NotificationBloc>().add(const GetNotificationsRequested());
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _fabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        child: _buildBody(),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      title: Text(
        'notifications'.tr(),
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationSettingsPage(),
            ),
          ),
          icon: Icon(
            Icons.settings_outlined,
            size: 24.w,
          ),
        ),
        IconButton(
          onPressed: _markAllAsRead,
          icon: Icon(
            Icons.done_all,
            size: 24.w,
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: _buildFilterTabs(),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      color: AppColors.primary.withOpacity(0.05),
      child: Row(
        children: [
          _buildFilterTab('all'.tr(), NotificationFilterType.all),
          _buildFilterTab('unread'.tr(), NotificationFilterType.unread),
          _buildFilterTab('important'.tr(), NotificationFilterType.important),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, NotificationFilterType type) {
    final bool isSelected = _currentFilter == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onFilterSelected(type),
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
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationLoading) {
          setState(() => _isRefreshing = true);
        } else {
          setState(() => _isRefreshing = false);
        }

        if (state is NotificationError) {
          _showErrorDialog(state.message);
        }
      },
      builder: (context, state) {
        if (state is NotificationsLoading) {
          return _buildLoadingState();
        }

        if (state is NotificationsLoaded) {
          if (state.notifications.isEmpty) {
            return _buildEmptyState();
          }

          return _buildNotificationsList(state.notifications);
        }

        return _buildEmptyState();
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      itemCount: 10,
      itemBuilder: (context, index) => _buildNotificationSkeleton(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80.w,
            color: AppColors.textMuted,
          ),
          SizedBox(height: AppDimensions.marginL),
          Text(
            'no_notifications'.tr(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.marginS),
          Text(
            'youll_receive_notifications_here'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.marginXXL),
          CustomButton(
            text: 'refresh'.tr(),
            onPressed: _loadNotifications,
            size: ButtonSize.medium,
            type: ButtonType.outline,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationEntity> notifications) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(AppDimensions.paddingL),
      itemCount: notifications.length + (_isRefreshing ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == notifications.length) {
          return _buildLoadMoreIndicator();
        }

        final notification = notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(NotificationEntity notification) {
    return Slidable(
      key: ValueKey(notification.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _markAsRead(notification),
            backgroundColor: AppColors.success,
            foregroundColor: AppColors.white,
            icon: Icons.visibility,
            label: 'mark_read'.tr(),
          ),
          SlidableAction(
            onPressed: (context) => _deleteNotification(notification),
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.white,
            icon: Icons.delete,
            label: 'delete'.tr(),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: AppDimensions.marginM),
        decoration: BoxDecoration(
          color: notification.isRead ? AppColors.white : AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
          border: Border.all(
            color: notification.isRead ? AppColors.border : AppColors.primary.withOpacity(0.2),
            width: 1.w,
          ),
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
            onTap: () => _onNotificationTap(notification),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.paddingL),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification Icon
                  _buildNotificationIcon(notification),
                  SizedBox(width: AppDimensions.marginM),

                  // Content
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
                                notification.title,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              notification.timeAgo,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppDimensions.marginS),

                        // Message
                        Text(
                          notification.message,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        if (notification.isImportant) ...[
                          SizedBox(height: AppDimensions.marginS),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingS,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXS),
                            ),
                            child: Text(
                              'important'.tr(),
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColors.warning,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationEntity notification) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: notification.isRead
            ? AppColors.textMuted.withOpacity(0.1)
            : _getNotificationColor(notification.type).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        notification.type.icon,
        size: 24.w,
        color: notification.isRead
            ? AppColors.textMuted
            : _getNotificationColor(notification.type),
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.offerReceived:
      case NotificationType.offerAccepted:
        return AppColors.success;
      case NotificationType.offerRejected:
      case NotificationType.listingRejected:
        return AppColors.error;
      case NotificationType.paymentReceived:
        return AppColors.barterPrimary;
      case NotificationType.system:
      case NotificationType.announcement:
        return AppColors.primary;
      default:
        return AppColors.info;
    }
  }

  Widget _buildNotificationSkeleton() {
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
                  width: double.infinity,
                  height: 16.h,
                  color: AppColors.inputBackground,
                ),
                SizedBox(height: AppDimensions.marginS),
                Container(
                  width: double.infinity * 0.7,
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

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      alignment: Alignment.center,
      child: SizedBox(
        width: 24.w,
        height: 24.w,
        child: CircularProgressIndicator(
          strokeWidth: 2.w,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
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
          onPressed: _loadNotifications,
          backgroundColor: AppColors.primary,
          icon: Icon(Icons.refresh, size: 20.w),
          label: Text('refresh'.tr()),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _refreshController.repeat();
    await Future.delayed(const Duration(milliseconds: 1000));
    _loadNotifications();
    _refreshController.stop();
  }

  void _onFilterSelected(NotificationFilterType type) {
    setState(() {
      _currentFilter = type;
    });
    debugPrint('Filter selected: $type');
  }

  void _markAsRead(NotificationEntity notification) {
    context.read<NotificationBloc>().add(
      MarkAsReadRequested(notification.id),
    );
  }

  void _deleteNotification(NotificationEntity notification) {
    context.read<NotificationBloc>().add(
      DeleteNotificationRequested(notification.id),
    );
  }

  void _markAllAsRead() {
    context.read<NotificationBloc>().add(
      MarkAllAsReadRequested(),
    );
  }

  void _onNotificationTap(NotificationEntity notification) {
    context.read<NotificationBloc>().handleNotificationTap(context, notification);
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

enum NotificationFilterType { all, unread, important }
