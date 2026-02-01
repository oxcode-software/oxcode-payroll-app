import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_card.dart';
import 'package:oxcode_payroll/general/core/animations/fade_in_slide.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_app_bar.dart';

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Leaves',
        actions: [
          IconButton(
            icon: Icon(LucideIcons.history, size: 20.w),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leave Balance Header
            const FadeInSlide(child: _LeaveBalanceHeader()),
            SizedBox(height: 32.h),

            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Requests',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('View All', style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Leave List
            const FadeInSlide(offset: 30, child: _LeaveRequestsList()),

            SizedBox(height: 80.h), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FadeInSlide(
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: AppColors.primary,
          elevation: 4,
          icon: Icon(LucideIcons.plus, color: Colors.white, size: 20.w),
          label: Text(
            'Request Leave',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class _LeaveBalanceHeader extends StatelessWidget {
  const _LeaveBalanceHeader();

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBalanceItem(
                context,
                'Total Balance',
                '24',
                AppColors.primary,
              ),
              Container(
                height: 40.h,
                width: 1,
                color: Colors.grey.withOpacity(0.2),
              ),
              _buildBalanceItem(context, 'Used', '08', AppColors.accent),
              Container(
                height: 40.h,
                width: 1,
                color: Colors.grey.withOpacity(0.2),
              ),
              _buildBalanceItem(context, 'Available', '16', AppColors.success),
            ],
          ),
          SizedBox(height: 24.h),
          const Divider(height: 1),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: _buildTypeStat(context, 'Sick', '02', Colors.red),
              ),
              Expanded(
                child: _buildTypeStat(context, 'Casual', '04', Colors.blue),
              ),
              Expanded(
                child: _buildTypeStat(context, 'Earned', '10', Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: -1,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeStat(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: 8.w),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: Colors.grey[500]),
        ),
      ],
    );
  }
}

class _LeaveRequestsList extends StatelessWidget {
  const _LeaveRequestsList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLeaveItem(
          context,
          type: 'Sick Leave',
          date: 'Jan 24 - Jan 25',
          duration: '2 Days',
          status: 'Approved',
          color: AppColors.success,
          reason: 'Recovering from seasonal flu',
        ),
        SizedBox(height: 16.h),
        _buildLeaveItem(
          context,
          type: 'Casual Leave',
          date: 'Feb 12, 2026',
          duration: '1 Day',
          status: 'Pending',
          color: AppColors.warning,
          reason: 'Personal family event',
        ),
        SizedBox(height: 16.h),
        _buildLeaveItem(
          context,
          type: 'Emergency Leave',
          date: 'Dec 01, 2025',
          duration: '1 Day',
          status: 'Rejected',
          color: AppColors.error,
          reason: 'Urgent home maintenance',
        ),
      ],
    );
  }

  Widget _buildLeaveItem(
    BuildContext context, {
    required String type,
    required String date,
    required String duration,
    required String status,
    required Color color,
    required String reason,
  }) {
    return PremiumCard(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(LucideIcons.calendar, color: color, size: 20.w),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  reason,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 13.sp,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                duration,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
