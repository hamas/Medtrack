import 'package:flutter/material.dart';

class AppMotion {
  /// M3 Emphasized Easing: cubic-bezier(0.2, 0, 0, 1)
  static const Curve emphasizedEasing = Cubic(0.2, 0.0, 0, 1.0);

  /// M3 Standard Easing: cubic-bezier(0.2, 0, 0, 1)
  static const Curve standardEasing = Curves.easeInOutCubic;

  /// M3 Expressive Durations
  static const Duration durationShort = Duration(milliseconds: 200);
  static const Duration durationMedium = Duration(milliseconds: 400);
  static const Duration durationLong = Duration(milliseconds: 500);

  /// Page transition duration (Standard smooth duration)
  static const Duration pageTransitionDuration = Duration(milliseconds: 350);

  /// Smooth Fade Transition Builder for Tabs and Pages
  static Widget fadeTransitionBuilder({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
      child: child,
    );
  }

  /// Page transition builder (Fade Through pattern) for navigation
  static Widget pageFadeTransitionBuilder({
    required Widget child,
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: Curves.easeInOut,
          ),
        ),
        child: child,
      ),
    );
  }
}
