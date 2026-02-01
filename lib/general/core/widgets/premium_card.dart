import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.r);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: borderRadius,
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFE2E8F0)
              : const Color(0xFF334155),
        ),
        boxShadow: Theme.of(context).brightness == Brightness.light
            ? [
                BoxShadow(
                  color: const Color(0xFF64748B).withOpacity(0.08),
                  blurRadius: 16.w,
                  offset: Offset(0, 8.h),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
