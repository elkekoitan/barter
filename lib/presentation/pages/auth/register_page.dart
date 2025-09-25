import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _referralCodeController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }

        if (state is Authenticated) {
          // Navigate to home
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state is AuthError) {
          _showErrorDialog(state.message);
        } else if (state is OTPRequired) {
          _showOTPDialog(state.identifier, state.type);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, size: 24.w),
          ),
          title: Text(
            'create_account'.tr(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
                  ),
                  child: Icon(
                    Icons.person_add_outlined,
                    size: 30.w,
                    color: AppColors.primary,
                  ),
                ),

                SizedBox(height: AppDimensions.marginL),

                Text(
                  'join_barter_community'.tr(),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: AppDimensions.marginS),

                Text(
                  'create_account_description'.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                ),

                SizedBox(height: AppDimensions.marginXXL),

                // Registration Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name Fields Row
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _firstNameController,
                              label: 'first_name'.tr(),
                              hintText: 'enter_first_name'.tr(),
                              prefixIcon: Icons.person_outline,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'first_name_required'.tr();
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: AppDimensions.marginM),
                          Expanded(
                            child: CustomTextField(
                              controller: _lastNameController,
                              label: 'last_name'.tr(),
                              hintText: 'enter_last_name'.tr(),
                              prefixIcon: Icons.person_outline,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'last_name_required'.tr();
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppDimensions.marginL),

                      // Email Field
                      CustomTextField(
                        controller: _emailController,
                        label: 'email'.tr(),
                        hintText: 'enter_email'.tr(),
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'email_required'.tr();
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                            return 'invalid_email'.tr();
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: AppDimensions.marginL),

                      // Phone Field
                      CustomTextField(
                        controller: _phoneController,
                        label: 'phone'.tr(),
                        hintText: 'enter_phone'.tr(),
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'phone_required'.tr();
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: AppDimensions.marginL),

                      // Password Field
                      CustomTextField(
                        controller: _passwordController,
                        label: 'password'.tr(),
                        hintText: 'enter_password'.tr(),
                        obscureText: _obscurePassword,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        onSuffixTap: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'password_required'.tr();
                          }
                          if (value!.length < 8) {
                            return 'password_too_short'.tr();
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: AppDimensions.marginL),

                      // Confirm Password Field
                      CustomTextField(
                        controller: _confirmPasswordController,
                        label: 'confirm_password'.tr(),
                        hintText: 'confirm_your_password'.tr(),
                        obscureText: _obscureConfirmPassword,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        onSuffixTap: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'confirm_password_required'.tr();
                          }
                          if (value != _passwordController.text) {
                            return 'passwords_not_match'.tr();
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: AppDimensions.marginL),

                      // Referral Code Field (Optional)
                      CustomTextField(
                        controller: _referralCodeController,
                        label: 'referral_code'.tr(),
                        hintText: 'enter_referral_code'.tr(),
                        prefixIcon: Icons.card_giftcard_outlined,
                        required: false,
                      ),

                      SizedBox(height: AppDimensions.marginL),

                      // Terms and Privacy Checkboxes
                      _buildCheckbox(
                        value: _acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptTerms = value ?? false;
                          });
                        },
                        text: 'accept_terms_and_conditions'.tr(),
                        onTap: () {
                          // Navigate to terms page
                        },
                      ),

                      SizedBox(height: AppDimensions.marginS),

                      _buildCheckbox(
                        value: _acceptPrivacy,
                        onChanged: (value) {
                          setState(() {
                            _acceptPrivacy = value ?? false;
                          });
                        },
                        text: 'accept_privacy_policy'.tr(),
                        onTap: () {
                          // Navigate to privacy policy page
                        },
                      ),

                      SizedBox(height: AppDimensions.marginL),

                      // Register Button
                      CustomButton(
                        text: 'create_account'.tr(),
                        onPressed: _isLoading ? null : _handleRegister,
                        isLoading: _isLoading,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppDimensions.marginXL),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'already_have_account'.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                      child: Text(
                        'login'.tr(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_acceptTerms || !_acceptPrivacy) {
        _showErrorDialog('accept_terms_and_privacy'.tr());
        return;
      }

      context.read<AuthBloc>().add(
        RegisterRequested(
          RegisterRequest(
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text,
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            referralCode: _referralCodeController.text.trim().isEmpty
                ? null
                : _referralCodeController.text.trim(),
          ),
        ),
      );
    }
  }

  Widget _buildCheckbox({
    required bool value,
    required Function(bool?) onChanged,
    required String text,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
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

  void _showOTPDialog(String identifier, OTPType type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => OTPVerificationDialog(
        identifier: identifier,
        type: type,
        onVerified: () {
          Navigator.pop(context);
          // Registration successful, navigate to home
          Navigator.of(context).pushReplacementNamed('/home');
        },
      ),
    );
  }
}

// OTP Verification Dialog (reused from login page)
class OTPVerificationDialog extends StatefulWidget {
  final String identifier;
  final OTPType type;
  final VoidCallback onVerified;

  const OTPVerificationDialog({
    super.key,
    required this.identifier,
    required this.type,
    required this.onVerified,
  });

  @override
  State<OTPVerificationDialog> createState() => _OTPVerificationDialogState();
}

class _OTPVerificationDialogState extends State<OTPVerificationDialog> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('verify_otp'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('otp_sent_to'.tr(args: [widget.identifier])),
          SizedBox(height: AppDimensions.marginM),
          TextField(
            controller: _otpController,
            decoration: InputDecoration(
              labelText: 'otp_code'.tr(),
              hintText: '000000',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
              ),
            ),
            keyboardType: TextInputType.number,
            maxLength: 6,
          ),
          SizedBox(height: AppDimensions.marginM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _isLoading ? null : _resendOTP,
                child: Text('resend_otp'.tr()),
              ),
              TextButton(
                onPressed: _isLoading ? null : _cancel,
                child: Text('cancel'.tr()),
              ),
            ],
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: _isLoading ? null : _verifyOTP,
          child: _isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                )
              : Text('verify'.tr()),
        ),
      ],
    );
  }

  void _verifyOTP() {
    if (_otpController.text.length == 6) {
      setState(() => _isLoading = true);

      context.read<AuthBloc>().add(
        VerifyOTPRequested(
          OTPVerificationRequest(
            identifier: widget.identifier,
            otp: _otpController.text,
            type: widget.type,
          ),
        ),
      );

      // Close dialog and continue
      Navigator.pop(context);
      widget.onVerified();
    }
  }

  void _resendOTP() {
    context.read<AuthBloc>().add(
      SendOTPRequested(widget.identifier, widget.type),
    );
  }

  void _cancel() {
    Navigator.pop(context);
  }
}
