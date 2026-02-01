import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBrand;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? iconColor;

  const PremiumAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.showBrand = true,
    this.backgroundColor,
    this.titleColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 70.h,
      iconTheme: iconColor != null ? IconThemeData(color: iconColor) : null,
      leadingWidth: showBrand ? 60.w : null,
      leading:
          leading ??
          (showBrand
              ? Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: SvgPicture.asset('assets/svg/Oxcode.svg'),
                )
              : null),
      title: showBrand
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null && title != 'Oxcode')
                  Text(
                    title!,
                    style: TextStyle(
                      color: titleColor ?? Colors.grey[500],
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
              ],
            )
          : (title != null
                ? Text(
                    title!,
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 20.sp,
                      letterSpacing: -0.5,
                    ),
                  )
                : null),
      centerTitle: centerTitle,
      actions: actions != null ? [...actions!, SizedBox(width: 8.w)] : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70.h);
}

class PremiumSliverAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;

  const PremiumSliverAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      toolbarHeight: 70.h,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 20.sp,
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: centerTitle,
      actions: actions != null ? [...actions!, SizedBox(width: 8.w)] : null,
    );
  }
}
