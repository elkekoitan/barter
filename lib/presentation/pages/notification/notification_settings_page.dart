import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../blocs/notification/notification_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/custom_button.dart';
import '../../../domain/entities/notification.dart' as domain;

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  late bool _pushEnabled;
  late bool _emailEnabled;
  late bool _smsEnabled;
  late bool _inAppEnabled;

  late domain.NotificationCategorySettings _categorySettings;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    context.read<NotificationBloc>().add(GetNotificationSettingsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'notification_settings'.tr(),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: Text(
              'save'.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is SettingsLoaded) {
            _loadSettingsFromState(state.settings);
          } else if (state is SettingsUpdated) {
            _showSuccessDialog();
          } else if (state is NotificationError) {
            _showErrorDialog(state.message);
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading) {
            return _buildLoadingState();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),

                SizedBox(height: AppDimensions.marginXXL),

                // Notification Channels
                _buildChannelsSection(),

                SizedBox(height: AppDimensions.marginXXL),

                // Categories Section
                _buildCategoriesSection(),

                SizedBox(height: AppDimensions.marginXXL),

                // Advanced Settings
                _buildAdvancedSection(),

                SizedBox(height: AppDimensions.marginXXL),

                // Actions
                _buildActions(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔔 ${'notification_settings'.tr()}',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.marginS),
          Text(
            'manage_how_you_receive_notifications'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📱 ${'notification_channels'.tr()}',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: AppDimensions.marginM),

        _buildChannelItem(
          icon: Icons.notifications_active,
          title: 'push_notifications'.tr(),
          subtitle: 'instant_notifications_on_your_device'.tr(),
          value: _pushEnabled,
          onChanged: (value) => setState(() => _pushEnabled = value),
        ),

        SizedBox(height: AppDimensions.marginM),

        _buildChannelItem(
          icon: Icons.email,
          title: 'email_notifications'.tr(),
          subtitle: 'notifications_sent_to_your_email'.tr(),
          value: _emailEnabled,
          onChanged: (value) => setState(() => _emailEnabled = value),
        ),

        SizedBox(height: AppDimensions.marginM),

        _buildChannelItem(
          icon: Icons.sms,
          title: 'sms_notifications'.tr(),
          subtitle: 'text_messages_to_your_phone'.tr(),
          value: _smsEnabled,
          onChanged: (value) => setState(() => _smsEnabled = value),
        ),

        SizedBox(height: AppDimensions.marginM),

        _buildChannelItem(
          icon: Icons.smartphone,
          title: 'in_app_notifications'.tr(),
          subtitle: 'notifications_shown_within_the_app'.tr(),
          value: _inAppEnabled,
          onChanged: (value) => setState(() => _inAppEnabled = value),
        ),
      ],
    );
  }

  Widget _buildChannelItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
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
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24.w,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: AppDimensions.marginM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📂 ${'notification_categories'.tr()}',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: AppDimensions.marginM),

        _buildCategoryItem(
          title: 'listings'.tr(),
          subtitle: 'listing_approvals_rejections_and_updates'.tr(),
          value: _categorySettings.listings,
          onChanged: (value) => setState(() =>
            _categorySettings = _categorySettings.copyWith(listings: value)),
        ),

        SizedBox(height: AppDimensions.marginM),

        _buildCategoryItem(
          title: 'offers'.tr(),
          subtitle: 'offer_received_accepted_rejected'.tr(),
          value: _categorySettings.offers,
          onChanged: (value) => setState(() =>
            _categorySettings = _categorySettings.copyWith(offers: value)),
        ),

        SizedBox(height: AppDimensions.marginM),

        _buildCategoryItem(
          title: 'transactions'.tr(),
          subtitle: 'payment_delivery_and_completion_updates'.tr(),
          value: _categorySettings.transactions,
          onChanged: (value) => setState(() =>
            _categorySettings = _categorySettings.copyWith(transactions: value)),
        ),

        SizedBox(height: AppDimensions.marginM),

        _buildCategoryItem(
          title: 'messages'.tr(),
          subtitle: 'new_messages_and_replies'.tr(),
          value: _categorySettings.messages,
          onChanged: (value) => setState(() =>
            _categorySettings = _categorySettings.copyWith(messages: value)),
        ),

        SizedBox(height: AppDimensions.marginM),

        _buildCategoryItem(
          title: 'security'.tr(),
          subtitle: 'login_alerts_and_security_updates'.tr(),
          value: _categorySettings.security,
          onChanged: (value) => setState(() =>
            _categorySettings = _categorySettings.copyWith(security: value)),
        ),

        SizedBox(height: AppDimensions.marginM),

        _buildCategoryItem(
          title: 'promotions'.tr(),
          subtitle: 'special_offers_and_discounts'.tr(),
          value: _categorySettings.promotions,
          onChanged: (value) => setState(() =>
            _categorySettings = _categorySettings.copyWith(promotions: value)),
        ),
      ],
    );
  }

  Widget _buildCategoryItem({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        border: Border.all(color: AppColors.border, width: 1.w),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '⚙️ ${'advanced_settings'.tr()}',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: AppDimensions.marginM),

        Container(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
            border: Border.all(color: AppColors.warning.withOpacity(0.3), width: 1.w),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info,
                    size: 20.w,
                    color: AppColors.warning,
                  ),
                  SizedBox(width: AppDimensions.marginS),
                  Expanded(
                    child: Text(
                      'these_settings_affect_how_you_receive_notifications'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        CustomButton(
          text: 'save_settings'.tr(),
          onPressed: _saveSettings,
          width: double.infinity,
          size: ButtonSize.large,
        ),

        SizedBox(height: AppDimensions.marginM),

        CustomButton(
          text: 'reset_to_defaults'.tr(),
          onPressed: _resetToDefaults,
          width: double.infinity,
          size: ButtonSize.medium,
          type: ButtonType.outline,
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              strokeWidth: 3.w,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          SizedBox(height: AppDimensions.marginL),
          Text(
            'loading_settings'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _loadSettingsFromState(domain.NotificationSettings settings) {
    setState(() {
      _pushEnabled = settings.pushEnabled;
      _emailEnabled = settings.emailEnabled;
      _smsEnabled = settings.smsEnabled;
      _inAppEnabled = settings.inAppEnabled;
      _categorySettings = settings.categories;
    });
  }

  void _saveSettings() {
    final settings = domain.NotificationSettings(
      userId: 'current',
      pushEnabled: _pushEnabled,
      emailEnabled: _emailEnabled,
      smsEnabled: _smsEnabled,
      inAppEnabled: _inAppEnabled,
      categories: _categorySettings,
    );

    context.read<NotificationBloc>().add(UpdateNotificationSettingsRequested(settings));
  }

  void _resetToDefaults() {
    setState(() {
      _pushEnabled = true;
      _emailEnabled = true;
      _smsEnabled = false;
      _inAppEnabled = true;
      _categorySettings = const domain.NotificationCategorySettings();
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('success'.tr()),
        content: Text('notification_settings_saved'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ok'.tr()),
          ),
        ],
      ),
    );
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
