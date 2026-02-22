import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_card.dart';
import 'package:oxcode_payroll/general/core/animations/fade_in_slide.dart';
import 'package:provider/provider.dart';
import 'package:oxcode_payroll/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:oxcode_payroll/features/auth/presentation/provider/auth_provider.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_app_bar.dart';
import 'package:oxcode_payroll/features/notifications/presentation/pages/notification_screen.dart';
import 'package:oxcode_payroll/features/attendance/presentation/pages/face_punch_screen.dart';
import 'package:oxcode_payroll/features/leave/presentation/pages/leave_history_screen.dart';
import 'package:oxcode_payroll/features/roster/presentation/pages/roster_screen.dart';
import 'package:oxcode_payroll/features/payroll/presentation/pages/payroll_screen.dart';
import 'package:oxcode_payroll/features/expense/presentation/pages/expense_history_screen.dart';
import 'package:oxcode_payroll/features/loan/presentation/pages/loan_history_screen.dart';
import 'package:oxcode_payroll/features/profile/presentation/pages/profile_screen.dart';
import 'package:oxcode_payroll/features/communication/presentation/provider/announcement_provider.dart';
import 'package:intl/intl.dart';
import 'package:oxcode_payroll/features/attendance/domain/models/punch_request.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnnouncementProvider>().listenAnnouncements();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final userName = user?.displayName ?? "Employee";

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Dashboard',
        actions: [
          IconButton(
            icon: Icon(LucideIcons.bell, size: 24.w),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting & Date
            FadeInSlide(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning,',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                        ),
                        Text(
                          userName,
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -1,
                                fontSize: 36.sp,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.1),
                        width: 2.w,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 24.r,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        'JD',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // Attendance Action Card (Modern Bento Style)
            const FadeInSlide(offset: 20, child: _QuickPunchCard()),
            SizedBox(height: 32.h),

            // Statistics Row & Salary Summary
            const FadeInSlide(offset: 30, child: _ModernStatsRow()),
            SizedBox(height: 24.h),
            const FadeInSlide(offset: 35, child: _SalarySummaryCard()),
            SizedBox(height: 32.h),

            // Quick Actions Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Quick Actions",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                const SizedBox(),
              ],
            ),
            SizedBox(height: 16.h),

            // Bento Grid Actions
            const FadeInSlide(offset: 40, child: _BentoActionGrid()),

            SizedBox(height: 32.h),

            // Upcoming Events/Holidays
            Text(
              "Upcoming Holiday",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 16.h),
            const FadeInSlide(offset: 50, child: _UpcomingHolidayCard()),
            SizedBox(height: 32.h),

            // Announcements Section
            Text(
              "Announcements",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 16.h),
            const FadeInSlide(offset: 60, child: _AnnouncementsList()),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

class _QuickPunchCard extends StatelessWidget {
  const _QuickPunchCard();

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(
      builder: (context, provider, _) {
        final isCheckedIn = provider.isCheckedIn;
        return PremiumCard(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color:
                          (isCheckedIn ? AppColors.success : AppColors.primary)
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      isCheckedIn ? LucideIcons.clock : LucideIcons.logIn,
                      color: isCheckedIn
                          ? AppColors.success
                          : AppColors.primary,
                      size: 24.w,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCheckedIn ? "Checked In" : "Ready to Start?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RosterScreen(),
                            ),
                          ),
                          child: Text(
                            isCheckedIn
                                ? "Shift started at 09:00 AM"
                                : "Next Shift: 09:00 AM - 06:00 PM",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 13.sp,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildShiftBadge(context, "General"),
                  if (isCheckedIn) ...[
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          provider.workingHours,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                          "Hrs Worked",
                          style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: () async {
                    final auth = context.read<AuthProvider>();
                    final employee = auth.employeeProfile;
                    if (employee == null) return;

                    if (isCheckedIn) {
                      await provider.punch(
                        type: PunchType.gps,
                        employeeId: employee.id,
                        employeeName: employee.name,
                        imagePath: null,
                      );
                    } else {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FacePunchScreen(),
                        ),
                      );
                      if (result != null) {
                        await provider.punch(
                          type: PunchType.selfie,
                          employeeId: employee.id,
                          employeeName: employee.name,
                          imagePath: result as String,
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCheckedIn
                        ? AppColors.error
                        : AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isCheckedIn
                            ? LucideIcons.logOut
                            : LucideIcons.mousePointerClick,
                        color: Colors.white,
                        size: 20.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        isCheckedIn ? "Punch Out Now" : "Punch In Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShiftBadge(BuildContext context, String shiftName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        shiftName,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ModernStatsRow extends StatelessWidget {
  const _ModernStatsRow();

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, AttendanceProvider>(
      builder: (context, auth, attendance, _) {
        return Row(
          children: [
            _buildSmallStat(
              context,
              "Leave Bal",
              "12", // In a full implementation, this would come from auth.employeeProfile?.leaveBalance
              "Days",
              LucideIcons.umbrella,
              Colors.orange,
            ),
            SizedBox(width: 16.w),
            _buildSmallStat(
              context,
              "Status",
              attendance.isCheckedIn ? "Active" : "Off",
              attendance.isCheckedIn ? "On Clock" : "Not In",
              LucideIcons.circleCheck,
              attendance.isCheckedIn ? Colors.green : Colors.grey,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSmallStat(
    BuildContext context,
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: PremiumCard(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 16.w),
                ),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class _BentoActionGrid extends StatelessWidget {
  const _BentoActionGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildBentoItem(
              context,
              "Payslips",
              LucideIcons.fileText,
              Colors.blue,
              1,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PayrollScreen()),
              ),
            ),
            SizedBox(width: 12.w),
            _buildBentoItem(
              context,
              "Leaves",
              LucideIcons.calendarDays,
              Colors.orange,
              1,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeaveHistoryScreen(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildBentoItem(
              context,
              "Claims",
              LucideIcons.wallet,
              Colors.purple,
              1,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExpenseHistoryScreen(),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            _buildBentoItem(
              context,
              "Documents",
              LucideIcons.folderClosed,
              Colors.teal,
              1,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildBentoItem(
              context,
              "Loans",
              LucideIcons.banknote,
              Colors.red,
              1,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoanHistoryScreen(),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            _buildBentoItem(
              context,
              "Profile",
              LucideIcons.user,
              Colors.blueGrey,
              1,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBentoItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    int flex, {
    VoidCallback? onTap,
  }) {
    return Expanded(
      flex: flex,
      child: PremiumCard(
        onTap: onTap ?? () {},
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 20.w),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingHolidayCard extends StatelessWidget {
  const _UpcomingHolidayCard();

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Text(
                  "26",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Jan",
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Republic Day",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  "Monday • Mandatory Holiday",
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight, color: Colors.grey[400], size: 20.w),
        ],
      ),
    );
  }
}

class _SalarySummaryCard extends StatelessWidget {
  const _SalarySummaryCard();

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PayrollScreen()),
      ),
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(LucideIcons.banknote, color: Colors.green, size: 24.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Last Paid Salary",
                  style: TextStyle(color: Colors.grey[600], fontSize: 13.sp),
                ),
                Text(
                  "₹ 45,000.00",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Jan 2026",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: AppColors.primary,
                ),
              ),
              Text(
                "Paid on 05 Feb",
                style: TextStyle(fontSize: 10.sp, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnnouncementsList extends StatelessWidget {
  const _AnnouncementsList();

  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.announcements.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.announcements.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Text(
                "No announcements yet",
                style: TextStyle(color: Colors.grey, fontSize: 13.sp),
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.announcements.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final announcement = provider.announcements[index];
            return PremiumCard(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      LucideIcons.info,
                      color: AppColors.primary,
                      size: 20.w,
                    ),
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
                              announcement.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                            Text(
                              DateFormat(
                                'HH:mm',
                              ).format(announcement.createdAt),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          announcement.content,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13.sp,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
