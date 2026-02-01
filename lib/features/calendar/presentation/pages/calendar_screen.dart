import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_app_bar.dart';
import 'package:oxcode_payroll/features/notifications/presentation/pages/notification_screen.dart';
import 'package:oxcode_payroll/general/core/animations/fade_in_slide.dart';
import 'package:oxcode_payroll/general/core/widgets/premium_card.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime(2026, 1, 18);
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PremiumAppBar(
        title: '',
        actions: [
          IconButton(
            icon: Icon(LucideIcons.clock, color: Colors.black, size: 24.w),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(LucideIcons.bell, color: Colors.black, size: 24.w),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            // Horizontal Summary List
            _buildSummaryRow(),

            SizedBox(height: 24.h),

            // Premium Calendar Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: FadeInSlide(
                duration: const Duration(milliseconds: 600),
                child: PremiumCard(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Column(
                    children: [
                      _buildCalendarHeader(),
                      TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        headerVisible: false,
                        daysOfWeekHeight: 40.h,
                        rowHeight: 52.h,
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                          weekendStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                        calendarStyle: const CalendarStyle(
                          todayDecoration: BoxDecoration(),
                          todayTextStyle: TextStyle(color: Colors.black),
                        ),
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) =>
                              _buildDayCell(day),
                          selectedBuilder: (context, day, focusedDay) =>
                              _buildDayCell(day, isSelected: true),
                          todayBuilder: (context, day, focusedDay) =>
                              _buildDayCell(day, isToday: true),
                          outsideBuilder: (context, day, focusedDay) =>
                              const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
              child: Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF03A9F4),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Attendance Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18.sp,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Daily View',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Attendance Details Card
            _buildAttendanceDetails(),

            SizedBox(height: 120.h), // Space for bottom nav or scroll padding
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow() {
    final summaries = [
      {'label': 'Present', 'count': '13', 'color': const Color(0xFF03A9F4)},
      {'label': 'Absent', 'count': '0', 'color': const Color(0xFFF44336)},
      {'label': 'Half Day', 'count': '0', 'color': const Color(0xFFFFC107)},
      {'label': 'Short Hours', 'count': '0', 'color': const Color(0xFFFF9800)},
      {'label': 'Leave', 'count': '0', 'color': const Color(0xFFE91E63)},
      {'label': 'Holiday', 'count': '0', 'color': const Color(0xFF9C27B0)},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: summaries
            .map(
              (s) => _buildSummaryCard(
                s['label'] as String,
                s['count'] as String,
                s['color'] as Color,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSummaryCard(String label, String count, Color color) {
    return Container(
      width: 80.w,
      height: 80.w,
      margin: EdgeInsets.only(right: 12.w, bottom: 8.h, top: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_focusedDay.monthName} ${_focusedDay.year}',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18.sp,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          Row(
            children: [
              _buildHeaderNavButton(
                Icons.chevron_left,
                () => setState(
                  () => _focusedDay = DateTime(
                    _focusedDay.year,
                    _focusedDay.month - 1,
                    1,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              _buildHeaderNavButton(
                Icons.chevron_right,
                () => setState(
                  () => _focusedDay = DateTime(
                    _focusedDay.year,
                    _focusedDay.month + 1,
                    1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderNavButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.black.withOpacity(0.03)),
        ),
        child: Icon(icon, color: Colors.black, size: 20.w),
      ),
    );
  }

  Widget _buildDayCell(
    DateTime day, {
    bool isSelected = false,
    bool isToday = false,
  }) {
    Color? bgColor;
    Color textColor = Colors.black;
    bool hasMarker = false;

    // Static markers logic
    if (day.month == 1) {
      if (day.day <= 2 ||
          (day.day >= 5 && day.day <= 10) ||
          (day.day >= 12 && day.day <= 16)) {
        bgColor = const Color(0xFF03A9F4).withOpacity(0.1);
        textColor = const Color(0xFF0288D1);
        hasMarker = true;
      } else if (day.day == 3 ||
          day.day == 4 ||
          day.day == 11 ||
          day.day == 17) {
        bgColor = Colors.grey[100];
        textColor = Colors.grey[400]!;
      } else if (day.day == 18) {
        bgColor = const Color(0xFF4CAF50).withOpacity(0.1);
        textColor = const Color(0xFF2E7D32);
        hasMarker = true;
      }
    }

    if (isSelected) {
      bgColor = const Color(0xFF03A9F4);
      textColor = Colors.white;
    }

    return Container(
      margin: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFF03A9F4).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: textColor,
          fontWeight: isSelected || hasMarker
              ? FontWeight.w900
              : FontWeight.w600,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _buildAttendanceDetails() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFFE3F2FD), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFFBBDEFB),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      size: 14,
                      color: Color(0xFF03A9F4),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Full Day',
                      style: TextStyle(
                        color: const Color(0xFF0288D1),
                        fontWeight: FontWeight.w900,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF03A9F4),
                size: 24,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              // Premium Compact Date Box
              Container(
                width: 65.w,
                height: 65.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF03A9F4), Color(0xFF0288D1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF03A9F4).withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '01',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'Thu',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              // Compact Stats
              Expanded(
                child: Row(
                  children: [
                    _buildStatMiniCard(LucideIcons.logIn, 'In', '08:52 AM'),
                    SizedBox(width: 6.w),
                    _buildStatMiniCard(LucideIcons.logOut, 'Out', '05:34 PM'),
                    SizedBox(width: 6.w),
                    _buildStatMiniCard(LucideIcons.timer, 'Hours', '07:47:00'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatMiniCard(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        height: 65.w,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.black.withOpacity(0.02)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14.w, color: const Color(0xFF0288D1)),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 8.sp,
                color: Colors.grey[500],
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  String get monthName {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[month - 1];
  }
}
