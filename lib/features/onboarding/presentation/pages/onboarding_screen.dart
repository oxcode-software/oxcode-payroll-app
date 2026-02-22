import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';
import 'package:oxcode_payroll/general/core/animations/fade_in_slide.dart';
import 'package:oxcode_payroll/main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Intelligent\nAttendance",
      description:
          "Smart geo-fencing and biometric verification ensure your punch is as unique as you are.",
      icon: LucideIcons.scanFace,
      color: AppColors.primary,
    ),
    OnboardingData(
      title: "Real-time\nPayroll insights",
      description:
          "Detailed salary maps, tax breakdowns, and instant payslip access. Total transparency, zero effort.",
      icon: LucideIcons.chartPie,
      color: const Color(0xFF2E7D32),
    ),
    OnboardingData(
      title: "One-Tap\nManagement",
      description:
          "From advance requests to leave applications, manage your work life with effortless precision.",
      icon: LucideIcons.wand,
      color: const Color(0xFFC62828),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background dynamic shape
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            top: -200.h,
            right: _currentPage == 0
                ? -100.w
                : (_currentPage == 1 ? -150.w : -200.w),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              width: 500.w,
              height: 500.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _pages[_currentPage].color.withOpacity(0.04),
              ),
            ),
          ),

          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: FadeInSlide(
                        duration: const Duration(milliseconds: 800),
                        child: Container(
                          width: 240.w,
                          height: 240.h,
                          decoration: BoxDecoration(
                            color: page.color.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(60.r),
                            border: Border.all(
                              color: page.color.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            page.icon,
                            size: 100.w,
                            color: page.color,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 60.h),
                    FadeInSlide(
                      duration: const Duration(milliseconds: 1000),
                      offset: 30,
                      child: Text(
                        page.title,
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          letterSpacing: -1.5,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    FadeInSlide(
                      duration: const Duration(milliseconds: 1200),
                      offset: 40,
                      child: Text(
                        page.description,
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: Colors.grey[600],
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Bottom Controls
          Positioned(
            bottom: 60.h,
            left: 40.w,
            right: 40.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Indicators
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(right: 8.w),
                      height: 6.h,
                      width: _currentPage == index ? 32.w : 6.w,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? _pages[_currentPage].color
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                  ),
                ),

                // Action Button
                GestureDetector(
                  onTap: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.fastOutSlowIn,
                      );
                    } else {
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const AuthWrapper(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                          transitionDuration: const Duration(milliseconds: 800),
                        ),
                      );
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentPage == _pages.length - 1 ? 160.w : 70.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: _pages[_currentPage].color,
                      borderRadius: BorderRadius.circular(
                        _currentPage == _pages.length - 1 ? 20.r : 35.r,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _pages[_currentPage].color.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _currentPage == _pages.length - 1
                          ? Text(
                              "Get Started",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            )
                          : Icon(
                              LucideIcons.chevronRight,
                              color: Colors.white,
                              size: 28.w,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Skip Button
          if (_currentPage < _pages.length - 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10.h,
              right: 20.w,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const AuthWrapper(),
                    ),
                  );
                },
                child: Text(
                  "SKIP",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
