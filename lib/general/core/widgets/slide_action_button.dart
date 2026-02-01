import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:oxcode_payroll/general/core/constants/app_colors.dart';

class SlideActionButton extends StatefulWidget {
  final String text;
  final VoidCallback onSlide;
  final bool isCheckedIn;
  final double? height;
  final double? width;

  const SlideActionButton({
    super.key,
    required this.text,
    required this.onSlide,
    required this.isCheckedIn,
    this.height,
    this.width,
  });

  @override
  State<SlideActionButton> createState() => _SlideActionButtonState();
}

class _SlideActionButtonState extends State<SlideActionButton>
    with SingleTickerProviderStateMixin {
  double _dragValue = 0.0;

  @override
  Widget build(BuildContext context) {
    final height = widget.height ?? 60.h;
    final width = widget.width ?? 280.w;
    final maxWidth = width - height;
    final color = widget.isCheckedIn ? AppColors.error : AppColors.secondary;
    final bgColor = color.withOpacity(0.2);

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Background Text
          Center(
            child: Opacity(
              opacity: 1 - (_dragValue / maxWidth),
              child: Text(
                widget.text,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),

          // Slider Thumb
          Positioned(
            left: _dragValue,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _dragValue = (_dragValue + details.delta.dx).clamp(
                    0.0,
                    maxWidth,
                  );
                });
              },
              onHorizontalDragEnd: (details) {
                if (_dragValue >= maxWidth * 0.8) {
                  // Completed slide
                  widget.onSlide();
                  setState(() {
                    _dragValue = 0.0; // Reset for next interaction
                  });
                } else {
                  // Snap back
                  setState(() {
                    _dragValue = 0.0;
                  });
                }
              },
              child: Container(
                height: height,
                width: height,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 10.w,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Icon(
                  LucideIcons.chevronRight,
                  color: Colors.white,
                  size: 28.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
