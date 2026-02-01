import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_card.dart';
import 'package:oxcode_payroll/general/core/animations/fade_in_slide.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:oxcode_payroll/features/attendance/presentation/provider/attendance_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PremiumAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Punch Reminders",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 16.h),
            const FadeInSlide(child: _ReminderSettingsSection()),

            SizedBox(height: 32.h),

            Text(
              "App Preferences",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 16.h),
            FadeInSlide(
              offset: 20,
              child: PremiumCard(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    _buildPreferenceTile(
                      context,
                      LucideIcons.moon,
                      "Dark Mode",
                      trailing: Switch.adaptive(
                        value: false,
                        activeColor: AppColors.primary,
                        onChanged: (val) {},
                      ),
                    ),
                    Divider(height: 32.h, color: Colors.grey.withOpacity(0.1)),
                    _buildPreferenceTile(
                      context,
                      LucideIcons.globe,
                      "Language",
                      value: "English (US)",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceTile(
    BuildContext context,
    IconData icon,
    String title, {
    String? value,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20.w),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
        ),
        if (value != null)
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (trailing != null) trailing,
        if (value != null) ...[
          SizedBox(width: 8.w),
          Icon(LucideIcons.chevronRight, size: 14.w, color: Colors.grey[300]),
        ],
      ],
    );
  }
}

class _ReminderSettingsSection extends StatelessWidget {
  const _ReminderSettingsSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(
      builder: (context, provider, _) {
        return PremiumCard(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildReminderTile(
                context,
                "Punch In Reminder",
                provider.punchInReminder,
                provider.punchInTimeSet,
                (enabled, time) =>
                    provider.updatePunchInReminder(enabled, time),
              ),
              Divider(height: 32.h, color: Colors.grey.withOpacity(0.1)),
              _buildReminderTile(
                context,
                "Punch Out Reminder",
                provider.punchOutReminder,
                provider.punchOutTimeSet,
                (enabled, time) =>
                    provider.updatePunchOutReminder(enabled, time),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReminderTile(
    BuildContext context,
    String title,
    bool enabled,
    TimeOfDay time,
    Function(bool, TimeOfDay) onChanged,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: (enabled ? AppColors.primary : Colors.grey).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            LucideIcons.bell,
            color: enabled ? AppColors.primary : Colors.grey,
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              GestureDetector(
                onTap: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: time,
                  );
                  if (pickedTime != null) {
                    onChanged(enabled, pickedTime);
                  }
                },
                child: Text(
                  time.format(context),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: enabled,
          activeColor: AppColors.primary,
          onChanged: (val) => onChanged(val, time),
        ),
      ],
    );
  }
}
