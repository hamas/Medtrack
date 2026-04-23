import 'dart:ui';
import 'package:flutter/material.dart';
import 'ambient_background.dart';

class PageShell extends StatelessWidget {
  const PageShell({
    super.key,
    required this.child,
    this.appBar,
  });

  final Widget child;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Layer 1: Static Animated Background
        const Positioned.fill(
          child: RepaintBoundary(
            child: AmbientBackground(),
          ),
        ),

        // Layer 2: Midnight Veil & Global Blur
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
            child: Container(
              color: Colors.black.withValues(alpha: 0.8),
            ),
          ),
        ),

        // Layer 3: Scaffold
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar,
          body: child,
        ),
      ],
    );
  }
}
