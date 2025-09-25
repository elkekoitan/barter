import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.padding,
    this.borderRadius,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _internalFocusNode;
  late TextEditingController _internalController;
  bool _hasFocus = false;
  bool _hasError = false;
  String? _currentErrorText;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalController = widget.controller ?? TextEditingController();

    _internalFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _hasFocus = _internalFocusNode.hasFocus;
      _validateField();
    });
  }

  void _validateField() {
    if (widget.validator != null) {
      final error = widget.validator!(_internalController.text);
      setState(() {
        _hasError = error != null;
        _currentErrorText = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasContent = _internalController.text.isNotEmpty;
    final bool showLabel = widget.label != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (showLabel) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: _getLabelColor(),
            ),
          ),
          SizedBox(height: 8.h),
        ],

        // Text Field Container
        Container(
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(AppDimensions.borderRadiusL),
            border: Border.all(
              color: _getBorderColor(),
              width: _getBorderWidth(),
            ),
            boxShadow: _getShadow(),
          ),
          child: TextField(
            controller: _internalController,
            focusNode: _internalFocusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
            textCapitalization: widget.textCapitalization,
            inputFormatters: widget.inputFormatters,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.normal,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textMuted,
                fontWeight: FontWeight.normal,
              ),
              contentPadding: widget.padding ?? EdgeInsets.all(AppDimensions.paddingL),
              border: InputBorder.none,
              prefixIcon: widget.prefixIcon != null ? _buildPrefixIcon() : null,
              suffixIcon: widget.suffixIcon != null || widget.onSuffixTap != null
                  ? _buildSuffixIcon()
                  : null,
              counterText: '',
              errorText: null, // We'll handle error display ourselves
            ),
            onChanged: (value) {
              widget.onChanged?.call(value);
              _validateField();
            },
            onSubmitted: widget.onSubmitted,
          ),
        ),

        // Error Text
        if (_currentErrorText != null || widget.errorText != null) ...[
          SizedBox(height: 8.h),
          Text(
            _currentErrorText ?? widget.errorText!,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.error,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],

        // Helper Text
        if (widget.helperText != null && (_currentErrorText == null && widget.errorText == null)) ...[
          SizedBox(height: 8.h),
          Text(
            widget.helperText!,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPrefixIcon() {
    return Padding(
      padding: EdgeInsets.only(left: AppDimensions.paddingL, right: AppDimensions.paddingS),
      child: Icon(
        widget.prefixIcon,
        size: 20.w,
        color: _hasFocus ? AppColors.primary : AppColors.textMuted,
      ),
    );
  }

  Widget _buildSuffixIcon() {
    return Padding(
      padding: EdgeInsets.only(right: AppDimensions.paddingL),
      child: GestureDetector(
        onTap: widget.onSuffixTap,
        child: widget.suffixIcon ??
            Icon(
              widget.obscureText ? Icons.visibility_off : Icons.visibility,
              size: 20.w,
              color: _hasFocus ? AppColors.primary : AppColors.textMuted,
            ),
      ),
    );
  }

  Color _getLabelColor() {
    if (_hasError) {
      return AppColors.error;
    }
    if (_hasFocus) {
      return AppColors.primary;
    }
    return AppColors.textSecondary;
  }

  Color _getBackgroundColor() {
    if (!widget.enabled) {
      return AppColors.inputBackground.withOpacity(0.5);
    }
    if (_hasError) {
      return AppColors.error.withOpacity(0.05);
    }
    if (_hasFocus) {
      return AppColors.primary.withOpacity(0.02);
    }
    return AppColors.inputBackground;
  }

  Color _getBorderColor() {
    if (_hasError) {
      return AppColors.error;
    }
    if (_hasFocus) {
      return AppColors.primary;
    }
    if (!widget.enabled) {
      return AppColors.border.withOpacity(0.5);
    }
    return AppColors.border;
  }

  double _getBorderWidth() {
    if (_hasFocus) {
      return 2.w;
    }
    return 1.w;
  }

  List<BoxShadow> _getShadow() {
    if (_hasFocus) {
      return [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.1),
          blurRadius: 8,
          spreadRadius: 2,
          offset: const Offset(0, 0),
        ),
      ];
    }
    return [];
  }
}