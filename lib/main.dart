import 'package:flutter/material.dart';
import 'package:oxcode_payroll/general/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:oxcode_payroll/general/core/theme/app_theme.dart';
import 'package:oxcode_payroll/features/auth/presentation/provider/auth_provider.dart';
import 'package:oxcode_payroll/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:oxcode_payroll/features/leave/presentation/provider/leave_provider.dart';
import 'package:oxcode_payroll/features/roster/presentation/provider/shift_provider.dart';
import 'package:oxcode_payroll/features/payroll/presentation/provider/payroll_provider.dart';
import 'package:oxcode_payroll/features/expense/presentation/provider/expense_provider.dart';
import 'package:oxcode_payroll/features/loan/presentation/provider/loan_provider.dart';
import 'package:oxcode_payroll/features/communication/presentation/provider/announcement_provider.dart';
import 'package:oxcode_payroll/features/splash/presentation/pages/splash_screen.dart';
import 'package:oxcode_payroll/features/auth/presentation/pages/login_screen.dart';
import 'package:oxcode_payroll/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Notifications
  final notificationService = NotificationService();
  await notificationService.init();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase Initialization Error: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => LeaveProvider()),
        ChangeNotifierProvider(create: (_) => ShiftProvider()),
        ChangeNotifierProvider(create: (_) => PayrollProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => LoanProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 13/14 size as base
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Oxcode Payroll',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          home: const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.user != null) {
          // Initialize Attendance Provider
          final attendanceProvider = context.read<AttendanceProvider>();
          attendanceProvider.init(auth.user!.uid);
          return const DashboardScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
