import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/social_login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              children: [
                // Header
                _buildHeader(),

                SizedBox(height: AppDimensions.marginXXL),

                // Login Form
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildLoginForm(),
                  ),
                ),

                SizedBox(height: AppDimensions.marginXXL),

                // Social Login
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildSocialLogin(),
                  ),
                ),

                SizedBox(height: AppDimensions.marginXXL),

                // Footer
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.1),
          ),
          child: Icon(
            Icons.swap_horiz_rounded,
            size: 40.w,
            color: AppColors.primary,
          ),
        ),

        SizedBox(height: AppDimensions.marginL),

        // Title
        Text(
          'welcome_back'.tr(),
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: AppDimensions.marginS),

        // Subtitle
        Text(
          'login_to_continue'.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Field
          CustomTextField(
            controller: _emailController,
            label: 'email'.tr(),
            hint: 'enter_email'.tr(),
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
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

          // Password Field
          CustomTextField(
            controller: _passwordController,
            label: 'password'.tr(),
            hint: 'enter_password'.tr(),
            prefixIcon: Icons.lock_outlined,
            obscureText: _obscurePassword,
            suffixIcon: _obscurePassword ? Icons.visibility_off : Icons.visibility,
            onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'password_required'.tr();
              }
              if (value!.length < 6) {
                return 'password_min_length'.tr();
              }
              return null;
            },
          ),

          SizedBox(height: AppDimensions.marginM),

          // Remember Me & Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (value) => setState(() => _rememberMe = value ?? false),
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.w),
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimensions.marginS),
                  Text(
                    'remember_me'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: _forgotPassword,
                child: Text(
                  'forgot_password'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.marginXXL),

          // Login Button
          CustomButton(
            text: 'login'.tr(),
            onPressed: _login,
            isLoading: _isLoading,
            width: double.infinity,
            size: ButtonSize.large,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Divider
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColors.border,
                thickness: 1.w,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.marginM),
              child: Text(
                'or_continue_with'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppColors.border,
                thickness: 1.w,
              ),
            ),
          ],
        ),

        SizedBox(height: AppDimensions.marginXXL),

        // Social Login Buttons
        Row(
          children: [
            Expanded(
              child: SocialLoginButton(
                type: SocialLoginType.google,
                onPressed: _loginWithGoogle,
              ),
            ),
            SizedBox(width: AppDimensions.marginM),
            Expanded(
              child: SocialLoginButton(
                type: SocialLoginType.facebook,
                onPressed: _loginWithFacebook,
              ),
            ),
            SizedBox(width: AppDimensions.marginM),
            Expanded(
              child: SocialLoginButton(
                type: SocialLoginType.apple,
                onPressed: _loginWithApple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textSecondary,
        ),
        children: [
          TextSpan(text: 'dont_have_account'.tr()),
          TextSpan(
            text: ' ${'register'.tr()}',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Navigator.pushNamed(context, '/register'),
          ),
        ],
      ),
    );
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // TODO: Implement login logic
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        // Navigate to home
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  void _forgotPassword() {
    // TODO: Navigate to forgot password page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('forgot_password_feature'.tr()),
      ),
    );
  }

  void _loginWithGoogle() {
    // TODO: Implement Google login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('google_login_feature'.tr()),
      ),
    );
  }

  void _loginWithFacebook() {
    // TODO: Implement Facebook login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('facebook_login_feature'.tr()),
      ),
    );
  }

  void _loginWithApple() {
    // TODO: Implement Apple login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('apple_login_feature'.tr()),
      ),
    );
  }
}