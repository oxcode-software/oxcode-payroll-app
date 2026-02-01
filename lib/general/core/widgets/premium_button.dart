import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';

class PremiumButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? color;
  final double? width;

  const PremiumButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 56.h,
      decoration: BoxDecoration(
        color:
            color ??
            (onPressed != null ? AppColors.primary : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: (color ?? AppColors.primary).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        child: isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 20.w),
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
