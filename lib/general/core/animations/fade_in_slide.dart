import 'package:flutter/material.dart';

enum FadeInSlideDirection { ltr, rtl, ttb, btt }

class FadeInSlide extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final FadeInSlideDirection direction;

  const FadeInSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.offset = 30.0,
    this.direction = FadeInSlideDirection.btt,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        double x = 0;
        double y = 0;

        switch (direction) {
          case FadeInSlideDirection.ltr:
            x = -offset * (1 - value);
            break;
          case FadeInSlideDirection.rtl:
            x = offset * (1 - value);
            break;
          case FadeInSlideDirection.ttb:
            y = -offset * (1 - value);
            break;
          case FadeInSlideDirection.btt:
            y = offset * (1 - value);
            break;
        }

        return Transform.translate(
          offset: Offset(x, y),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }
}
