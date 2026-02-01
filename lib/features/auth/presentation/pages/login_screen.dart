import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';
import 'package:oxcode_payroll/general/core/animations/fade_in_slide.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_button.dart';
import 'package:provider/provider.dart';
import 'package:oxcode_payroll/features/auth/presentation/provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Premium Background blobs
          Positioned(
            top: -150.h,
            right: -100.w,
            child: _buildBlob(300.w, AppColors.primary.withOpacity(0.08)),
          ),
          Positioned(
            bottom: -100.h,
            left: -150.w,
            child: _buildBlob(400.w, AppColors.primary.withOpacity(0.05)),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand Logo
                    FadeInSlide(
                      duration: const Duration(milliseconds: 800),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/svg/Oxcode.svg',
                          height: 150.h,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(height: 48.h),

                    FadeInSlide(
                      duration: const Duration(milliseconds: 1000),
                      child: Column(
                        children: [
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: -1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Sign in to access your employee portal',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 48.h),

                    // Inputs Section
                    FadeInSlide(
                      duration: const Duration(milliseconds: 1200),
                      offset: 30,
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _emailController,
                            label: 'Email Address',
                            icon: LucideIcons.mail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 16.h),
                          _buildTextField(
                            controller: _passwordController,
                            label: 'Password',
                            icon: LucideIcons.lock,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? LucideIcons.eyeOff
                                    : LucideIcons.eye,
                                size: 20.w,
                                color: Colors.grey[400],
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),
                    FadeInSlide(
                      duration: const Duration(milliseconds: 1300),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Login Button
                    FadeInSlide(
                      duration: const Duration(milliseconds: 1400),
                      child: Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          return PremiumButton(
                            label: 'Sign In',
                            isLoading: auth.isLoading,
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              auth.login(
                                _emailController.text,
                                _passwordController.text,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 48.h),

                    // Footer
                    FadeInSlide(
                      duration: const Duration(milliseconds: 1500),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Contact HR",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: AppColors.primary, size: 20.w),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16.r),
              bottomRight: Radius.circular(16.r),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 20.h,
          ),
        ),
      ),
    );
  }
}
