import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_card.dart';
import 'package:oxcode_payroll/general/core/animations/fade_in_slide.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_app_bar.dart';
import 'package:oxcode_payroll/features/profile/presentation/pages/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: Icon(LucideIcons.settings2, size: 20.w),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            // Profile Header
            FadeInSlide(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                        child: CircleAvatar(
                          radius: 56.r,
                          backgroundColor: theme.scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 52.r,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Hero(
                              tag: 'profile_avatar',
                              child: Text(
                                'JD',
                                style: TextStyle(
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'John Doe',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontSize: 28.sp,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Senior Flutter Developer • #90302',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 100.h,
                    right: (1.sw / 2) - 100.w,
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.scaffoldBackgroundColor,
                          width: 3.w,
                        ),
                      ),
                      child: Icon(
                        LucideIcons.camera,
                        size: 14.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // Metrics Row
            FadeInSlide(
              offset: 20,
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      '98%',
                      'Attendance',
                      LucideIcons.calendarCheck2,
                      AppColors.success,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      '12',
                      'Leaves Left',
                      LucideIcons.plane,
                      AppColors.info,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      '4.9',
                      'Performance',
                      LucideIcons.star,
                      AppColors.warning,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // Sections
            FadeInSlide(
              offset: 40,
              child: Column(
                children: [
                  _buildSectionHeader(context, 'Employment Information'),
                  SizedBox(height: 16.h),
                  _buildInfoCard(context, [
                    _InfoRow(
                      LucideIcons.briefcase,
                      'Department',
                      'Engineering',
                    ),
                    _InfoRow(LucideIcons.calendar, 'Join Date', '12 Jan 2022'),
                    _InfoRow(
                      LucideIcons.mapPin,
                      'Location',
                      'San Francisco, US',
                    ),
                  ]),

                  SizedBox(height: 32.h),
                  _buildSectionHeader(context, 'Personal Settings'),
                  SizedBox(height: 16.h),
                  _buildMenuItem(
                    context,
                    icon: LucideIcons.user,
                    title: 'Personal Info',
                    subtitle: 'E-mail, Phone, Address',
                  ),
                  SizedBox(height: 12.h),
                  _buildMenuItem(
                    context,
                    icon: LucideIcons.landmark,
                    title: 'Bank Details',
                    subtitle: 'Salary account, IFSC, TDS',
                  ),
                  SizedBox(height: 12.h),
                  _buildMenuItem(
                    context,
                    icon: LucideIcons.bell,
                    title: 'Notifications',
                    subtitle: 'Punch reminders, System alerts',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 32.h),
                  _buildSectionHeader(context, 'Account Security'),
                  SizedBox(height: 16.h),
                  _buildMenuItem(
                    context,
                    icon: LucideIcons.shieldCheck,
                    title: 'Change Password',
                    subtitle: 'Last updated 3 months ago',
                  ),
                  SizedBox(height: 12.h),
                  _buildMenuItem(
                    context,
                    icon: LucideIcons.logOut,
                    title: 'Logout',
                    subtitle: 'Safely exit the application',
                    isDestructive: true,
                    onTap: () {
                      // Handle Logout
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 48.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return PremiumCard(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20.w),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey[500],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: Colors.grey[400],
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(child: Divider(color: Colors.grey.withOpacity(0.1))),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, List<_InfoRow> rows) {
    return PremiumCard(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final isLast = entry.key == rows.length - 1;
          final row = entry.value;
          return Column(
            children: [
              Row(
                children: [
                  Icon(row.icon, size: 16.w, color: AppColors.primary),
                  SizedBox(width: 12.w),
                  Text(
                    row.label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    row.value,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (!isLast) ...[
                SizedBox(height: 12.h),
                Divider(color: Colors.grey.withOpacity(0.05)),
                SizedBox(height: 12.h),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return PremiumCard(
      onTap: onTap,
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: isDestructive
                  ? AppColors.error.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              icon,
              color: isDestructive ? AppColors.error : AppColors.primary,
              size: 20.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    color: isDestructive ? AppColors.error : null,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
                  ),
                ],
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight, color: Colors.grey[300], size: 16.w),
        ],
      ),
    );
  }
}

class _InfoRow {
  final IconData icon;
  final String label;
  final String value;
  _InfoRow(this.icon, this.label, this.value);
}
