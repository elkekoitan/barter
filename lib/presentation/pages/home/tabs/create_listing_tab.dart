import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class CreateListingTab extends StatelessWidget {
  const CreateListingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'create_listing'.tr(),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: AppDimensions.marginS),

              Text(
                'share_what_you_have'.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: AppDimensions.marginXXL),

              // Quick Actions
              _buildQuickActions(context),

              SizedBox(height: AppDimensions.marginXXL),

              // Tips Section
              _buildTipsSection(),

              SizedBox(height: AppDimensions.marginXXL),

              // Recent Drafts
              _buildRecentDrafts(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreateListing(context),
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.add, size: 20.w),
        label: Text('create_listing'.tr()),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'quick_actions'.tr(),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: AppDimensions.marginM),

        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.smartphone,
                title: 'Elektronik',
                subtitle: 'Telefon, bilgisayar, tablet',
                onTap: () => _startQuickListing(context, 'electronics'),
              ),
            ),
            SizedBox(width: AppDimensions.marginM),
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.checkroom,
                title: 'Moda',
                subtitle: 'Giyim, ayakkabı, aksesuar',
                onTap: () => _startQuickListing(context, 'fashion'),
              ),
            ),
          ],
        ),

        SizedBox(height: AppDimensions.marginM),

        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.home,
                title: 'Ev & Bahçe',
                subtitle: 'Mobilya, dekorasyon',
                onTap: () => _startQuickListing(context, 'home_garden'),
              ),
            ),
            SizedBox(width: AppDimensions.marginM),
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.directions_car,
                title: 'Araçlar',
                subtitle: 'Otomobil, motosiklet',
                onTap: () => _startQuickListing(context, 'vehicles'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
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
          child: Column(
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
              SizedBox(height: AppDimensions.marginS),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '💡 ${'tips_for_success'.tr()}',
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
            color: AppColors.info.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
            border: Border.all(color: AppColors.info.withOpacity(0.3), width: 1.w),
          ),
          child: Column(
            children: [
              _buildTipItem('📸 Kaliteli fotoğraflar çekin'),
              _buildTipItem('📝 Detaylı açıklama yazın'),
              _buildTipItem('💰 Gerçekçi fiyat belirleyin'),
              _buildTipItem('🚚 Teslimat seçenekleri sunun'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.info,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: AppDimensions.marginS),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentDrafts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'recent_drafts'.tr(),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: AppDimensions.marginM),

        // Placeholder for drafts - in real app, this would be populated from local storage
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppDimensions.paddingL),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
            border: Border.all(color: AppColors.border, width: 1.w),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.drafts,
                size: 48.w,
                color: AppColors.textMuted,
              ),
              SizedBox(height: AppDimensions.marginM),
              Text(
                'no_drafts_yet'.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppDimensions.marginS),
              Text(
                'your_saved_drafts_will_appear_here'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToCreateListing(BuildContext context) {
    Navigator.pushNamed(context, '/create-listing');
  }

  void _startQuickListing(BuildContext context, String category) {
    Navigator.pushNamed(
      context,
      '/create-listing',
      arguments: {'preselected_category': category},
    );
  }
}
