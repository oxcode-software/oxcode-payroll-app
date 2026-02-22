import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_card.dart';
import 'package:oxcode_payroll/general/core/animations/fade_in_slide.dart';
import 'package:provider/provider.dart';
import 'package:oxcode_payroll/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_app_bar.dart';
import 'package:oxcode_payroll/features/attendance/presentation/pages/face_punch_screen.dart';
import 'package:oxcode_payroll/features/attendance/presentation/pages/qr_punch_screen.dart';
import 'package:oxcode_payroll/features/attendance/domain/models/attendance_activity.dart';
import 'package:oxcode_payroll/features/auth/presentation/provider/auth_provider.dart';
import 'dart:ui';
import 'package:oxcode_payroll/features/attendance/domain/models/punch_request.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Attendance',
        actions: [
          IconButton(
            icon: Icon(LucideIcons.chartArea, size: 20.w),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            // Interactive Timer Header
            const FadeInSlide(child: _AttendanceTimerParams()),
            SizedBox(height: 32.h),

            // Office Information Row
            const FadeInSlide(offset: 40, child: _OfficeInfoRow()),
            SizedBox(height: 32.h),

            // Analytics Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Monthly Analytics",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("Details", style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            const FadeInSlide(offset: 60, child: _AttendanceBentoGrid()),

            SizedBox(height: 32.h),

            // Activity Log
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Activity",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            const FadeInSlide(offset: 120, child: _ActivityTimeline()),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

class _AttendanceTimerParams extends StatelessWidget {
  const _AttendanceTimerParams();

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(
      builder: (context, provider, _) {
        final isCheckedIn = provider.isCheckedIn;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return PremiumCard(
          padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.calendarDays,
                    size: 14.w,
                    color: Colors.grey[500],
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    DateFormat('EEEE, d MMMM').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Glow
                  Container(
                    width: 220.w,
                    height: 220.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isCheckedIn
                                      ? AppColors.secondary
                                      : AppColors.primary)
                                  .withOpacity(0.1),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 210.w,
                    height: 210.w,
                    child: CircularProgressIndicator(
                      value: isCheckedIn ? provider.shiftProgress : 0.0,
                      strokeWidth: 12.w,
                      backgroundColor: isDark
                          ? Colors.grey[900]
                          : Colors.grey[100],
                      valueColor: AlwaysStoppedAnimation(
                        isCheckedIn ? AppColors.secondary : AppColors.primary,
                      ),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        provider.workingHours,
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.w900,
                          fontFeatures: const [FontFeature.tabularFigures()],
                          letterSpacing: -1.5,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (isCheckedIn
                                      ? AppColors.secondary
                                      : AppColors.primary)
                                  .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          isCheckedIn ? "ACTIVE SHIFT" : "SHIFT NOT STARTED",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: isCheckedIn
                                ? AppColors.secondary
                                : AppColors.primary,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isCheckedIn) ...[
                SizedBox(height: 32.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.03)
                        : Colors.black.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.05),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildMiniDetail(
                        context,
                        LucideIcons.clock,
                        "Punch In",
                        DateFormat('hh:mm a').format(
                          provider.activities
                              .lastWhere((a) => a.type == ActivityType.punchIn)
                              .time,
                        ),
                      ),
                      Container(
                        width: 1.w,
                        height: 24.h,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      _buildMiniDetail(
                        context,
                        LucideIcons.coffee,
                        "Break Time",
                        "${provider.activities.where((a) => a.type == ActivityType.endBreak).fold(0, (sum, a) => sum + (a.duration?.inMinutes ?? 0))}m",
                      ),
                      Container(
                        width: 1.w,
                        height: 24.h,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      _buildMiniDetail(
                        context,
                        LucideIcons.timer,
                        "Net Work",
                        provider.workingHours
                                .split(':')
                                .sublist(0, 2)
                                .join(':') +
                            "h",
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 32.h),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FacePunchScreen(),
                          ),
                        );
                        if (result != null) {
                          final auth = context.read<AuthProvider>();
                          final employee = auth.employeeProfile;
                          if (employee != null) {
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
                        foregroundColor: Colors.white,
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
                                : LucideIcons.scanFace,
                            size: 20.w,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            isCheckedIn
                                ? 'PUNCH OUT NOW'
                                : 'PUNCH IN (FACE VERIFY)',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14.sp,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isCheckedIn) ...[
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FacePunchScreen(),
                            ),
                          );
                          if (result != null) {
                            if (provider.isOnBreak) {
                              provider.endBreak(result as String);
                            } else {
                              provider.startBreak(result as String);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: provider.isOnBreak
                              ? AppColors.success
                              : Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              provider.isOnBreak
                                  ? LucideIcons.play
                                  : LucideIcons.coffee,
                              size: 20.w,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              provider.isOnBreak
                                  ? 'RESUME WORK'
                                  : 'TAKE A BREAK',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14.sp,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (!isCheckedIn) ...[
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildPunchOption(
                            context,
                            LucideIcons.qrCode,
                            "QR Scan",
                            Colors.blue,
                            () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const QRPunchScreen(),
                                ),
                              );
                              if (result != null) {
                                final auth = context.read<AuthProvider>();
                                final employee = auth.employeeProfile;
                                if (employee != null) {
                                  await provider.punch(
                                    type: PunchType.qr,
                                    employeeId: employee.id,
                                    employeeName: employee.name,
                                    qrCode: result as String,
                                    skipLocation: true,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildPunchOption(
                            context,
                            LucideIcons.wifi,
                            "WiFi Punch",
                            Colors.purple,
                            () async {
                              final auth = context.read<AuthProvider>();
                              final employee = auth.employeeProfile;
                              if (employee != null) {
                                try {
                                  await provider.punch(
                                    type: PunchType.wifi,
                                    employeeId: employee.id,
                                    employeeName: employee.name,
                                    skipLocation: true,
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPunchOption(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24.w),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniDetail(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 14.w, color: Colors.grey[500]),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey[500],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _OfficeInfoRow extends StatelessWidget {
  const _OfficeInfoRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoBadge(
            context,
            LucideIcons.mapPin,
            "Office Range",
            "Inside",
            AppColors.success,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildInfoBadge(
            context,
            LucideIcons.calendarDays,
            "Shift",
            "General 09-06",
            AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBadge(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return PremiumCard(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 16.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceBentoGrid extends StatelessWidget {
  const _AttendanceBentoGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildMetricCard(
                context,
                "Present",
                "18",
                "Days this month",
                LucideIcons.circleCheck,
                AppColors.success,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildMetricCard(
                context,
                "Absent",
                "01",
                "",
                LucideIcons.circleX,
                AppColors.error,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                "Late",
                "02",
                "",
                LucideIcons.circleAlert,
                AppColors.warning,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              flex: 2,
              child: _buildMetricCard(
                context,
                "Avg Check-in",
                "09:12 AM",
                "Past 30 days",
                LucideIcons.timer,
                Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return PremiumCard(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color.withOpacity(0.8), size: 20.w),
          SizedBox(height: 16.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
          ),
          if (subtitle.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10.sp, color: Colors.grey[500]),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActivityTimeline extends StatelessWidget {
  const _ActivityTimeline();

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(
      builder: (context, provider, _) {
        if (provider.activities.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Text(
                "No activity recorded today",
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.activities.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final activity = provider.activities[index];
            return _buildLogItem(
              context,
              activity.label,
              DateFormat('hh:mm a').format(activity.time),
              activity.duration != null
                  ? "Duration: ${activity.duration!.inMinutes} mins"
                  : activity.type == ActivityType.punchIn
                  ? "Verified via Face/Selfie"
                  : "Logged in System",
              activity.icon,
              _getActivityColor(activity.type),
              imagePath: activity.selfiePath,
            );
          },
        );
      },
    );
  }

  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.punchIn:
        return AppColors.success;
      case ActivityType.punchOut:
        return AppColors.error;
      case ActivityType.startBreak:
        return Colors.orange;
      case ActivityType.endBreak:
        return Colors.blue;
    }
  }

  Widget _buildLogItem(
    BuildContext context,
    String status,
    String time,
    String meta,
    IconData icon,
    Color color, {
    String? imagePath,
  }) {
    return PremiumCard(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: color.withOpacity(0.12)),
            ),
            child: Icon(icon, color: color, size: 20.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      status,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15.sp,
                      ),
                    ),
                    if (imagePath != null) ...[
                      SizedBox(width: 8.w),
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.file(File(imagePath), fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  meta,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13.sp,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
