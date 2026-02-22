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
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  final _employeeCodeController = TextEditingController();
  final _employeePasswordController = TextEditingController();
  bool _otpSent = false;
  bool _useCodeLogin = false;

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    _employeeCodeController.dispose();
    _employeePasswordController.dispose();
    super.dispose();
  }

  void _showCompanySelectionDialog(List<Map<String, dynamic>> companies) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Select Company',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Multiple companies found for this number. Please select one to continue.',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 20.h),
              ...companies.map(
                (company) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      context.read<AuthProvider>().loginWithUid(company['uid']);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.building,
                            color: AppColors.primary,
                            size: 20.w,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  company['companyName'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Text(
                                  'Code: ${company['companyCode']}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            LucideIcons.chevronRight,
                            color: Colors.grey,
                            size: 20.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                            'Corporate Login',
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
                            _useCodeLogin
                                ? 'Sign in with your employee code and password'
                                : (_otpSent
                                    ? 'Enter the security code sent to your mobile'
                                    : 'Enter your registered mobile number'),
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

                    // Mode toggle
                    FadeInSlide(
                      duration: const Duration(milliseconds: 1100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChoiceChip(
                            label: const Text('OTP Login'),
                            selected: !_useCodeLogin,
                            onSelected: (v) {
                              setState(() {
                                _useCodeLogin = false;
                                _otpSent = false;
                              });
                            },
                          ),
                          SizedBox(width: 12.w),
                          ChoiceChip(
                            label: const Text('Employee Code'),
                            selected: _useCodeLogin,
                            onSelected: (v) {
                              setState(() {
                                _useCodeLogin = true;
                                _otpSent = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Inputs Section
                    FadeInSlide(
                      duration: const Duration(milliseconds: 1200),
                      offset: 30,
                      child: Column(
                        children: [
                          if (_useCodeLogin) ...[
                            _buildTextField(
                              controller: _employeeCodeController,
                              label: 'Employee Code',
                              icon: LucideIcons.badgeInfo,
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(height: 16.h),
                            _buildTextField(
                              controller: _employeePasswordController,
                              label: 'Password',
                              icon: LucideIcons.lock,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                            ),
                          ] else ...[
                            _buildTextField(
                              controller: _mobileController,
                              label: 'Mobile Number',
                              icon: LucideIcons.phone,
                              keyboardType: TextInputType.phone,
                              enabled: !_otpSent,
                            ),
                            if (_otpSent) ...[
                              SizedBox(height: 16.h),
                              _buildTextField(
                                controller: _otpController,
                                label: 'One Time Password',
                                icon: LucideIcons.keyRound,
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),
                    if (_otpSent && !_useCodeLogin)
                      FadeInSlide(
                        duration: const Duration(milliseconds: 1300),
                        child: TextButton(
                          onPressed: () => setState(() => _otpSent = false),
                          child: Text(
                            'Change Mobile Number',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
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
                            label: _useCodeLogin
                                ? 'Login'
                                : (_otpSent ? 'Verify & Continue' : 'Send OTP'),
                            isLoading: auth.isLoading,
                            onPressed: () async {
                              HapticFeedback.mediumImpact();
                              try {
                                if (_useCodeLogin) {
                                  await auth.loginWithEmployeeCode(
                                    employeeCode:
                                        _employeeCodeController.text.trim(),
                                    password:
                                        _employeePasswordController.text.trim(),
                                  );
                                } else if (_otpSent) {
                                  final companies = await auth.verifyMSG91Token(
                                    _otpController.text,
                                  );

                                  if (companies.isEmpty) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'No employee record found for this number.',
                                          ),
                                        ),
                                      );
                                    }
                                  } else if (companies.length == 1) {
                                    await auth.loginWithUid(
                                      companies[0]['uid'],
                                    );
                                  } else {
                                    _showCompanySelectionDialog(companies);
                                  }
                                } else {
                                  await auth.sendMSG91Otp(
                                    _mobileController.text,
                                  );
                                  setState(() => _otpSent = true);
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        e.toString().replaceAll(
                                          'Exception: ',
                                          '',
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 48.h),

                    // Footer
                    FadeInSlide(
                      duration: const Duration(milliseconds: 1500),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Employee access only. ",
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
                          SizedBox(height: 12.h),
                          Text(
                            "Securely managed by MSG91",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
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
    bool enabled = true,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.6,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: enabled,
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
      ),
    );
  }
}
