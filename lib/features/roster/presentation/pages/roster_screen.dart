import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_app_bar.dart';
import 'package:oxcode_payroll/features/roster/domain/models/shift_assignment.dart';
import 'package:oxcode_payroll/features/roster/presentation/provider/shift_provider.dart';
import 'package:oxcode_payroll/features/auth/presentation/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class RosterScreen extends StatefulWidget {
  const RosterScreen({super.key});

  @override
  State<RosterScreen> createState() => _RosterScreenState();
}

class _RosterScreenState extends State<RosterScreen> {
  DateTime _currentWeekStart = DateTime.now().subtract(
    Duration(days: DateTime.now().weekday - 1),
  );

  @override
  void initState() {
    super.initState();
    _fetchRoster();
  }

  void _fetchRoster() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employee = context.read<AuthProvider>().employeeProfile;
      if (employee != null) {
        context.read<ShiftProvider>().fetchWeeklyRoster(
          employee.id,
          _currentWeekStart,
        );
      }
    });
  }

  void _changeWeek(bool next) {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(Duration(days: next ? 7 : -7));
    });
    _fetchRoster();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PremiumAppBar(title: "Weekly Roster"),
      body: Column(
        children: [
          _buildWeekPicker(),
          Expanded(
            child: Consumer<ShiftProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.separated(
                  padding: EdgeInsets.all(20.w),
                  itemCount: 7,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final date = _currentWeekStart.add(Duration(days: index));
                    final shift = provider.shifts
                        .cast<ShiftAssignment?>()
                        .firstWhere(
                          (s) =>
                              s != null &&
                              s.date.day == date.day &&
                              s.date.month == date.month,
                          orElse: () => null,
                        );
                    return _buildRosterTile(date, shift);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekPicker() {
    final weekEnd = _currentWeekStart.add(const Duration(days: 6));
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(LucideIcons.chevronLeft),
            onPressed: () => _changeWeek(false),
          ),
          Text(
            "${DateFormat('dd MMM').format(_currentWeekStart)} - ${DateFormat('dd MMM').format(weekEnd)}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
          IconButton(
            icon: const Icon(LucideIcons.chevronRight),
            onPressed: () => _changeWeek(true),
          ),
        ],
      ),
    );
  }

  Widget _buildRosterTile(DateTime date, ShiftAssignment? shift) {
    final isToday =
        date.day == DateTime.now().day && date.month == DateTime.now().month;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isToday ? AppColors.primary.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: isToday
            ? Border.all(color: AppColors.primary.withOpacity(0.2))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            child: Column(
              children: [
                Text(
                  DateFormat('EEE').format(date).toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          VerticalDivider(color: Colors.grey[200]),
          SizedBox(width: 16.w),
          Expanded(
            child: shift != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shift.shiftName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.clock,
                            size: 12.w,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "${shift.startTime} - ${shift.endTime}",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Text(
                    "No Shift Assigned",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontStyle: FontStyle.italic,
                      fontSize: 14.sp,
                    ),
                  ),
          ),
          if (shift != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                shift.location ?? "Office",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
