import 'package:flutter/material.dart';
import 'package:oxcode_payroll/general/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:oxcode_payroll/general/core/theme/app_theme.dart';
import 'package:oxcode_payroll/features/auth/presentation/provider/auth_provider.dart';
import 'package:oxcode_payroll/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:oxcode_payroll/features/auth/presentation/provider/subscription_provider.dart';
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
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
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
          home: const DashboardScreen(),
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
          return const DashboardScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
