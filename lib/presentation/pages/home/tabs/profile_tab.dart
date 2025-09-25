import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              _buildProfileHeader(context),

              SizedBox(height: AppDimensions.marginXXL),

              // Quick Stats
              _buildQuickStats(),

              SizedBox(height: AppDimensions.marginXXL),

              // Menu Items
              _buildMenuSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              border: Border.all(
                color: AppColors.white,
                width: 3.w,
              ),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&h=200&fit=crop&crop=face'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: AppDimensions.marginM),

          // User Info
          Text(
            'John Doe',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            '+90 555 123 4567',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.white.withOpacity(0.9),
            ),
          ),

          SizedBox(height: AppDimensions.marginM),

          // Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                size: 16.w,
                color: AppColors.warning,
              ),
              SizedBox(width: 4.w),
              Text(
                '4.8 (127 değerlendirme)',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.marginM),

          // Profile Completion
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
            ),
            child: Text(
              'Profil %95 Tamamlandı',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📊 İstatistiklerim',
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
              child: _buildStatCard(
                icon: Icons.inventory_2,
                title: 'Aktif İlanlar',
                value: '12',
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: AppDimensions.marginM),
            Expanded(
              child: _buildStatCard(
                icon: Icons.swap_horiz,
                title: 'Tamamlanan Takas',
                value: '28',
                color: AppColors.success,
              ),
            ),
          ],
        ),

        SizedBox(height: AppDimensions.marginM),

        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.thumb_up,
                title: 'Pozitif Geri Bildirim',
                value: '98%',
                color: AppColors.info,
              ),
            ),
            SizedBox(width: AppDimensions.marginM),
            Expanded(
              child: _buildStatCard(
                icon: Icons.account_balance_wallet,
                title: 'Cüzdan Bakiyesi',
                value: '1,250 ₺',
                color: AppColors.barterPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
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
      child: Column(
        children: [
          Icon(
            icon,
            size: 24.w,
            color: color,
          ),
          SizedBox(height: AppDimensions.marginS),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '⚙️ Ayarlar',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: AppDimensions.marginM),

        _buildMenuItem(
          context,
          icon: Icons.person,
          title: 'Profil Düzenle',
          subtitle: 'Kişisel bilgiler ve fotoğraf',
          onTap: () => _navigateToEditProfile(context),
        ),

        _buildMenuItem(
          context,
          icon: Icons.notifications,
          title: 'Bildirimler',
          subtitle: 'Bildirim tercihleri',
          onTap: () => _navigateToNotifications(context),
        ),

        _buildMenuItem(
          icon: Icons.security,
          title: 'Güvenlik',
          subtitle: 'Şifre ve güvenlik ayarları',
          onTap: () => _navigateToSecurity(context),
        ),

        _buildMenuItem(
          icon: Icons.payment,
          title: 'Ödeme Yöntemleri',
          subtitle: 'Kredi kartı ve hesap bilgileri',
          onTap: () => _navigateToPaymentMethods(context),
        ),

        _buildMenuItem(
          icon: Icons.help,
          title: 'Yardım & Destek',
          subtitle: 'SSS ve müşteri hizmetleri',
          onTap: () => _navigateToHelp(context),
        ),

        _buildMenuItem(
          icon: Icons.info,
          title: 'Hakkımızda',
          subtitle: 'Uygulama bilgileri',
          onTap: () => _navigateToAbout(context),
        ),

        SizedBox(height: AppDimensions.marginL),

        // Logout Button
        Container(
          width: double.infinity,
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
            border: Border.all(color: AppColors.error.withOpacity(0.3), width: 1.w),
          ),
          child: Material(
            color: AppColors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
            child: InkWell(
              onTap: () => _showLogoutDialog(context),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      size: 20.w,
                      color: AppColors.error,
                    ),
                    SizedBox(width: AppDimensions.marginS),
                    Text(
                      'logout'.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.marginS),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        border: Border.all(color: AppColors.border, width: 1.w),
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
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 20.w,
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
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.w,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profil düzenleme sayfasına yönlendiriliyor...')),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bildirim ayarları sayfasına yönlendiriliyor...')),
    );
  }

  void _navigateToSecurity(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Güvenlik ayarları sayfasına yönlendiriliyor...')),
    );
  }

  void _navigateToPaymentMethods(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ödeme yöntemleri sayfasına yönlendiriliyor...')),
    );
  }

  void _navigateToHelp(BuildContext context) {
    Navigator.pushNamed(context, '/help');
  }

  void _navigateToAbout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hakkımızda sayfasına yönlendiriliyor...')),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('logout'.tr()),
        content: Text('logout_confirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('logout_success'.tr())),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
            child: Text('logout'.tr()),
          ),
        ],
      ),
    );
  }
}
