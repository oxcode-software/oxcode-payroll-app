import 'package:flutter/material.dart';

class FadeInSlide extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double offset; // Initial vertical offset

  const FadeInSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.offset = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, offset * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }
}
