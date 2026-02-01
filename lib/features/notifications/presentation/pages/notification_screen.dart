import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_app_bar.dart';
import 'package:oxcode_payroll/general/core/animations/fade_in_slide.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Notifications',
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all read',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        children: [
          _buildSectionHeader('Today'),
          FadeInSlide(
            duration: const Duration(milliseconds: 600),
            child: _buildNotificationItem(
              title: 'Leave Approved',
              subtitle:
                  'Your leave request for Jan 25 has been approved by HR.',
              time: '2h ago',
              icon: LucideIcons.check,
              iconColor: AppColors.success,
              isUnread: true,
            ),
          ),
          FadeInSlide(
            duration: const Duration(milliseconds: 700),
            child: _buildNotificationItem(
              title: 'Attendance Alert',
              subtitle:
                  'You forgot to punch out yesterday. Please update your status.',
              time: '5h ago',
              icon: LucideIcons.info,
              iconColor: AppColors.warning,
              isUnread: true,
            ),
          ),
          SizedBox(height: 24.h),
          _buildSectionHeader('Yesterday'),
          FadeInSlide(
            duration: const Duration(milliseconds: 800),
            child: _buildNotificationItem(
              title: 'New Policy Update',
              subtitle:
                  'The company has updated the remote work policy effective form next month.',
              time: '1d ago',
              icon: LucideIcons.fileText,
              iconColor: AppColors.primary,
            ),
          ),
          FadeInSlide(
            duration: const Duration(milliseconds: 900),
            child: _buildNotificationItem(
              title: 'Payroll Generated',
              subtitle:
                  'Your salary slip for December 2025 is now available for download.',
              time: '1d ago',
              icon: LucideIcons.banknote,
              iconColor: Colors.purple,
            ),
          ),
          SizedBox(height: 24.h),
          _buildSectionHeader('Earlier'),
          FadeInSlide(
            duration: const Duration(milliseconds: 1000),
            child: _buildNotificationItem(
              title: 'Welcome to Oxcode',
              subtitle:
                  'Glad to have you onboard, Abhinav! Explore your dashboard to get started.',
              time: '1w ago',
              icon: LucideIcons.partyPopper,
              iconColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w900,
          color: Colors.grey[400],
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color iconColor,
    bool isUnread = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: PremiumCard(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(icon, color: iconColor, size: 22.w),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
