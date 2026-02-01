import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';
import 'package:oxcode_payroll/features/attendance/presentation/pages/attendance_screen.dart';
import 'package:oxcode_payroll/features/calendar/presentation/pages/calendar_screen.dart';
import 'package:oxcode_payroll/features/dashboard/presentation/pages/home_dashboard_screen.dart';
import 'package:oxcode_payroll/features/leave/presentation/pages/leave_screen.dart';
import 'package:oxcode_payroll/features/profile/presentation/pages/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeDashboardScreen(),
    LeaveScreen(),
    AttendanceScreen(),
    CalendarScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: _buildPremiumNavBar(),
    );
  }

  Widget _buildPremiumNavBar() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      height: 70.h,
      decoration: BoxDecoration(
        color: AppColors.primary, // Solid premium green from image
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, LucideIcons.layoutGrid, "Dashboard"),
          _buildNavItem(1, LucideIcons.plane, "Leave"),
          _buildNavItem(2, LucideIcons.timer, "Attendance"),
          _buildNavItem(3, LucideIcons.calendar, "Calendar"),
          _buildNavItem(4, LucideIcons.user, "Profile"),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? Colors.white : Colors.white.withOpacity(0.5);

    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _selectedIndex = index);
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.1 : 1.0,
              child: Icon(icon, color: color, size: 24.w),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
