import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class AmbientBackground extends StatefulWidget {
  const AmbientBackground({super.key});

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_AmbientShape> _shapes = <_AmbientShape>[];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat(reverse: true);

    _initializeShapes();
  }

  void _initializeShapes() {
    // Exactly 2 massive elements as requested for a dual-tone nebula
    _shapes.addAll(<_AmbientShape>[
      // One massive vibrant Purple circle (800px)
      _AmbientShape(
        color: const Color(0xFFF0ABFF).withAlpha(160),
        size: 800.0,
        isCircle: true,
        offset: const Offset(0.3, 0.4),
        velocity: const Offset(0.04, 0.06),
      ),
      // One massive vibrant Blue circle (800px)
      _AmbientShape(
        color: const Color(0xFF38BDF8).withAlpha(150),
        size: 800.0,
        isCircle: true,
        offset: const Offset(0.7, 0.6),
        velocity: const Offset(-0.05, -0.04),
      ),
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: <Widget>[
          // 1. Pure black background layer
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black),
            ),
          ),
          // 2. The Drifting Shapes layer (Nebula blobs - 400px)
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              final double curvedValue = CurvedAnimation(
                parent: _controller,
                curve: Curves.easeInOut,
              ).value;

              return CustomPaint(
                painter: _AmbientPainter(
                  shapes: _shapes,
                  progress: curvedValue,
                ),
                size: Size.infinite,
              );
            },
          ),
          // 3. Overlay: Heavy Gaussian Blur (40.0) combined with 90% black tint
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(230), // ~90% opacity
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmbientShape {
  _AmbientShape({
    required this.color,
    required this.size,
    required this.isCircle,
    required this.offset,
    required this.velocity,
  });
  final Color color;
  final double size;
  final bool isCircle;
  final Offset offset;
  final Offset velocity;

  Offset getCurrentOffset(double progress, Size screenSize) {
    // Non-linear drifting logic using Sine curves for natural feel
    final double xBase = offset.dx + velocity.dx * progress * 5;
    final double yBase = offset.dy + velocity.dy * progress * 5;

    // Add some organic drift
    final double x = (xBase + 0.05 * math.sin(progress * 2 * math.pi)) % 1.0;
    final double y = (yBase + 0.05 * math.cos(progress * 2 * math.pi)) % 1.0;

    return Offset(x * screenSize.width, y * screenSize.height);
  }
}

class _AmbientPainter extends CustomPainter {
  _AmbientPainter({required this.shapes, required this.progress});
  final List<_AmbientShape> shapes;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final _AmbientShape shape in shapes) {
      final Paint paint = Paint()
        ..color = shape.color
        ..style = PaintingStyle.fill;

      final Offset center = shape.getCurrentOffset(progress, size);

      if (shape.isCircle) {
        canvas.drawCircle(center, shape.size / 2, paint);
      } else {
        final double s = shape.size;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: center, width: s, height: s),
            const Radius.circular(32),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_AmbientPainter oldDelegate) => true;
}
