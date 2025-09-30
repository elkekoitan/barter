import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bogazici_barter/domain/repositories/auth_repository.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../domain/entities/social_login_settings.dart';

enum SocialLoginType {
  google('google.com', 'Google', Icons.g_mobiledata, AppColors.google),
  facebook('facebook.com', 'Facebook', Icons.facebook, AppColors.facebook),
  apple('apple.com', 'Apple', Icons.apple, AppColors.apple),
  twitter('twitter.com', 'Twitter', Icons.alternate_email, AppColors.info),
  github('github.com', 'GitHub', Icons.code, AppColors.black);

  const SocialLoginType(this.providerId, this.displayName, this.icon, this.color);
  final String providerId;
  final String displayName;
  final IconData icon;
  final Color color;
}

class SocialLoginButton extends StatefulWidget {
  final SocialLoginType type;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isLinked;
  final String? text;
  final ButtonSize size;
  final ButtonStyle style;

  const SocialLoginButton({
    super.key,
    required this.type,
    this.onPressed,
    this.isLoading = false,
    this.isLinked = false,
    this.text,
    this.size = ButtonSize.medium,
    this.style = ButtonStyle.filled,
  });

  @override
  State<SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<SocialLoginButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isLoading && widget.onPressed != null) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final buttonText = widget.text ?? 'Continue with ${widget.type.displayName}';

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildButton(context, buttonText),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context, String buttonText) {
    if (widget.isLoading) {
      return Container(
        width: _getButtonWidth(),
        height: _getButtonHeight(),
        decoration: _getButtonDecoration(),
        child: const Center(
          child: SizedBox(
            width: 20.w,
            height: 20.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
        width: _getButtonWidth(),
        height: _getButtonHeight(),
        decoration: _getButtonDecoration(),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _getPadding()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.type.icon,
                    size: _getIconSize(),
                    color: AppColors.white,
                  ),
                  SizedBox(width: AppDimensions.marginM),
                  Text(
                    buttonText,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: _getFontSize(),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (widget.isLinked) ...[
                    SizedBox(width: AppDimensions.marginS),
                    Icon(
                      Icons.link,
                      size: _getIconSize() * 0.8,
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getButtonDecoration() {
    return BoxDecoration(
      color: widget.type.color,
      borderRadius: BorderRadius.circular(_getBorderRadius()),
      boxShadow: [
        BoxShadow(
          color: widget.type.color.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      border: widget.isLinked
          ? Border.all(
              color: AppColors.white.withValues(alpha: 0.5),
              width: 1.w,
            )
          : null,
    );
  }

  double _getButtonWidth() {
    switch (widget.size) {
      case ButtonSize.small:
        return 120.w;
      case ButtonSize.medium:
        return 280.w;
      case ButtonSize.large:
        return double.infinity;
      case ButtonSize.xlarge:
        return double.infinity;
    }
  }

  double _getButtonHeight() {
    switch (widget.size) {
      case ButtonSize.small:
        return 36.h;
      case ButtonSize.medium:
        return 48.h;
      case ButtonSize.large:
        return 56.h;
      case ButtonSize.xlarge:
        return 64.h;
    }
  }

  double _getBorderRadius() {
    switch (widget.size) {
      case ButtonSize.small:
        return 18.w;
      case ButtonSize.medium:
        return 24.w;
      case ButtonSize.large:
        return 28.w;
      case ButtonSize.xlarge:
        return 32.w;
    }
  }

  double _getPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return 8.w;
      case ButtonSize.medium:
        return 16.w;
      case ButtonSize.large:
        return 20.w;
      case ButtonSize.xlarge:
        return 24.w;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return 16.w;
      case ButtonSize.medium:
        return 20.w;
      case ButtonSize.large:
        return 24.w;
      case ButtonSize.xlarge:
        return 28.w;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return 12.sp;
      case ButtonSize.medium:
        return 14.sp;
      case ButtonSize.large:
        return 16.sp;
      case ButtonSize.xlarge:
        return 18.sp;
    }
  }
}

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;
  final VoidCallback? onApplePressed;
  final bool isGoogleLoading;
  final bool isFacebookLoading;
  final bool isAppleLoading;
  final bool showGoogle;
  final bool showFacebook;
  final bool showApple;
  final String? googleText;
  final String? facebookText;
  final String? appleText;
  final ButtonSize buttonSize;
  final bool verticalLayout;
  final double spacing;

  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onFacebookPressed,
    this.onApplePressed,
    this.isGoogleLoading = false,
    this.isFacebookLoading = false,
    this.isAppleLoading = false,
    this.showGoogle = true,
    this.showFacebook = true,
    this.showApple = false, // iOS only by default
    this.googleText,
    this.facebookText,
    this.appleText,
    this.buttonSize = ButtonSize.medium,
    this.verticalLayout = false,
    this.spacing = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[];

    if (showGoogle) {
      buttons.add(
        SocialLoginButton(
          type: SocialLoginType.google,
          onPressed: onGooglePressed,
          isLoading: isGoogleLoading,
          text: googleText,
          size: buttonSize,
        ),
      );
    }

    if (showFacebook) {
      buttons.add(
        SocialLoginButton(
          type: SocialLoginType.facebook,
          onPressed: onFacebookPressed,
          isLoading: isFacebookLoading,
          text: facebookText,
          size: buttonSize,
        ),
      );
    }

    if (showApple) {
      buttons.add(
        SocialLoginButton(
          type: SocialLoginType.apple,
          onPressed: onApplePressed,
          isLoading: isAppleLoading,
          text: appleText,
          size: buttonSize,
        ),
      );
    }

    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    return verticalLayout
        ? Column(
            children: buttons
                .expand((button) => [button, SizedBox(height: spacing.h)])
                .take(buttons.length * 2 - 1)
                .toList(),
          )
        : Row(
            children: buttons
                .expand((button) => [button, SizedBox(width: spacing.w)])
                .take(buttons.length * 2 - 1)
                .toList(),
          );
  }
}

class SocialLoginDivider extends StatelessWidget {
  final String text;
  final bool showLine;

  const SocialLoginDivider({
    super.key,
    this.text = 'veya',
    this.showLine = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showLine) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
        child: Center(
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1.w,
              color: AppColors.border,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
            child: Text(
              text.toUpperCase(),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1.w,
              color: AppColors.border,
            ),
          ),
        ],
      ),
    );
  }
}

class SocialLoginError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const SocialLoginError({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3), width: 1.w),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 20.w,
              ),
              SizedBox(width: AppDimensions.marginS),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              if (onRetry != null)
                TextButton(
                  onPressed: onRetry,
                  child: Text(
                    'Tekrar Dene',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class SocialLoginSuccess extends StatelessWidget {
  final String message;
  final String? providerName;
  final VoidCallback? onContinue;

  const SocialLoginSuccess({
    super.key,
    required this.message,
    this.providerName,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3), width: 1.w),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: AppColors.success,
                size: 24.w,
              ),
              SizedBox(width: AppDimensions.marginM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Başarıyla Giriş Yapıldı',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (providerName != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        '$providerName ile giriş yapıldı',
                        style: TextStyle(
                          color: AppColors.success.withValues(alpha: 0.8),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                    SizedBox(height: 4.h),
                    Text(
                      message,
                      style: TextStyle(
                        color: AppColors.success.withValues(alpha: 0.8),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onContinue != null) ...[
            SizedBox(height: AppDimensions.marginL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
                  ),
                ),
                child: Text('Devam Et'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SocialLoginSettingsCard extends StatelessWidget {
  final SocialLoginSettings settings;
  final Function(SocialLoginSettings) onSettingsChanged;

  const SocialLoginSettingsCard({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        border: Border.all(color: AppColors.border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sosyal Giriş Ayarları',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.marginL),
          _buildSettingItem(
            title: 'Google Girişi',
            subtitle: 'Google hesabıyla giriş yapma',
            value: settings.enableGoogleLogin,
            onChanged: (value) => onSettingsChanged(
              settings.copyWith(enableGoogleLogin: value),
            ),
          ),
          _buildSettingItem(
            title: 'Facebook Girişi',
            subtitle: 'Facebook hesabıyla giriş yapma',
            value: settings.enableFacebookLogin,
            onChanged: (value) => onSettingsChanged(
              settings.copyWith(enableFacebookLogin: value),
            ),
          ),
          _buildSettingItem(
            title: 'Apple Girişi',
            subtitle: 'Apple hesabıyla giriş yapma (iOS)',
            value: settings.enableAppleLogin,
            onChanged: (value) => onSettingsChanged(
              settings.copyWith(enableAppleLogin: value),
            ),
          ),
          _buildSettingItem(
            title: 'E-posta Doğrulama',
            subtitle: 'Sosyal giriş sonrası e-posta doğrulaması',
            value: settings.requireEmailVerification,
            onChanged: (value) => onSettingsChanged(
              settings.copyWith(requireEmailVerification: value),
            ),
          ),
          _buildSettingItem(
            title: 'Hesap Bağlama',
            subtitle: 'Mevcut hesapla sosyal hesap bağlama',
            value: settings.allowAccountLinking,
            onChanged: (value) => onSettingsChanged(
              settings.copyWith(allowAccountLinking: value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.marginM),
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
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
}

enum ButtonSize {
  small,
  medium,
  large,
  xlarge,
}

enum ButtonStyle {
  filled,
  outlined,
  text,
}
