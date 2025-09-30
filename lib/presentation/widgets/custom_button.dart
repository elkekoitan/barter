import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

enum ButtonSize { small, medium, large }
enum ButtonType { primary, outline, ghost }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final ButtonSize size;
  final ButtonType type;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.size = ButtonSize.medium,
    this.type = ButtonType.primary,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.borderRadius,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final buttonSize = _getButtonSize();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.onPressed != null ? _scaleAnimation.value : 1.0,
          child: SizedBox(
            width: widget.width ?? double.infinity,
            height: buttonSize.height,
            child: ElevatedButton(
              onPressed: widget.onPressed != null && !widget.isLoading ? _onPressed : null,
              style: buttonStyle,
              child: _buildButtonContent(),
            ),
          ),
        );
      },
    );
  }

  void _onPressed() {
    if (widget.onPressed != null) {
      _scaleController.forward().then((_) {
        _scaleController.reverse();
        widget.onPressed!();
      });
    }
  }

  Widget _buildButtonContent() {
    if (widget.isLoading) {
      return _buildLoadingContent();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            size: _getIconSize(),
          ),
          SizedBox(width: AppDimensions.marginS),
        ],
        Text(widget.text.tr(), style: _getTextStyle()),
      ],
    );
  }

  Widget _buildLoadingContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 16.w,
          height: 16.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.type == ButtonType.primary
                  ? AppColors.white
                  : _getButtonColor(),
            ),
          ),
        ),
        SizedBox(width: AppDimensions.marginS),
        Text('loading'.tr(), style: _getTextStyle()),
      ],
    );
  }

  ButtonStyle _getButtonStyle() {
    final baseStyle = ElevatedButton.styleFrom(
      backgroundColor: _getButtonColor(),
      foregroundColor: _getTextColor(),
      disabledBackgroundColor: AppColors.textMuted.withOpacity(0.3),
      disabledForegroundColor: AppColors.textMuted,
      padding: widget.padding ?? _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: widget.borderRadius ?? _getBorderRadius(),
      ),
      elevation: _getElevation(),
      shadowColor: _getShadowColor(),
      side: _getBorderSide(),
      textStyle: _getTextStyle(),
      minimumSize: _getMinimumSize(),
    );

    return baseStyle.copyWith(
      overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.pressed)) {
          return _getButtonColor().withOpacity(0.8);
        }
        return _getButtonColor();
      }),
    );
  }

  Color _getButtonColor() {
    if (widget.backgroundColor != null) {
      return widget.backgroundColor!;
    }

    switch (widget.type) {
      case ButtonType.primary:
        return AppColors.primary;
      case ButtonType.outline:
        return AppColors.transparent;
      case ButtonType.ghost:
        return AppColors.transparent;
    }
  }

  Color _getTextColor() {
    if (widget.textColor != null) {
      return widget.textColor!;
    }

    switch (widget.type) {
      case ButtonType.primary:
        return AppColors.white;
      case ButtonType.outline:
        return AppColors.primary;
      case ButtonType.ghost:
        return AppColors.primary;
    }
  }

  Color _getShadowColor() {
    switch (widget.type) {
      case ButtonType.primary:
        return AppColors.primary.withOpacity(0.3);
      case ButtonType.outline:
        return AppColors.transparent;
      case ButtonType.ghost:
        return AppColors.transparent;
    }
  }

  BorderSide? _getBorderSide() {
    switch (widget.type) {
      case ButtonType.primary:
        return null;
      case ButtonType.outline:
        return BorderSide(
          color: widget.onPressed != null ? AppColors.primary : AppColors.border,
          width: 1.w,
        );
      case ButtonType.ghost:
        return null;
    }
  }

  double _getElevation() {
    switch (widget.type) {
      case ButtonType.primary:
        return widget.onPressed != null ? 4 : 0;
      case ButtonType.outline:
        return 0;
      case ButtonType.ghost:
        return 0;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    final buttonSize = _getButtonSize();
    return EdgeInsets.symmetric(
      horizontal: buttonSize.padding,
      vertical: buttonSize.padding,
    );
  }

  BorderRadiusGeometry _getBorderRadius() {
    return BorderRadius.circular(AppDimensions.borderRadiusL);
  }

  TextStyle _getTextStyle() {
    final buttonSize = _getButtonSize();
    final isDisabled = widget.onPressed == null;

    return TextStyle(
      fontSize: buttonSize.fontSize,
      fontWeight: FontWeight.w600,
      color: isDisabled ? AppColors.textMuted : _getTextColor(),
      letterSpacing: 0.5,
    );
  }

  Size _getMinimumSize() {
    final buttonSize = _getButtonSize();
    return Size(buttonSize.minWidth, buttonSize.height);
  }

  ButtonSizeData _getButtonSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return ButtonSizeData(
          height: 32.h,
          minWidth: 80.w,
          fontSize: 12.sp,
          padding: AppDimensions.paddingS,
          iconSize: 16.w,
        );
      case ButtonSize.medium:
        return ButtonSizeData(
          height: 44.h,
          minWidth: 120.w,
          fontSize: 14.sp,
          padding: AppDimensions.paddingM,
          iconSize: 18.w,
        );
      case ButtonSize.large:
        return ButtonSizeData(
          height: 52.h,
          minWidth: 160.w,
          fontSize: 16.sp,
          padding: AppDimensions.paddingL,
          iconSize: 20.w,
        );
    }
  }

  double _getIconSize() {
    final buttonSize = _getButtonSize();
    return buttonSize.iconSize;
  }
}

class ButtonSizeData {
  final double height;
  final double minWidth;
  final double fontSize;
  final double padding;
  final double iconSize;

  const ButtonSizeData({
    required this.height,
    required this.minWidth,
    required this.fontSize,
    required this.padding,
    required this.iconSize,
  });
}

// Removed custom tr() extension to avoid ambiguity with EasyLocalization