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
      // One massive vibrant Purple circle (800px) - Bottom Half
      _AmbientShape(
        color: const Color.fromARGB(255, 255, 34, 248).withAlpha(160),
        size: 800.0,
        isCircle: true,
        isTopHalf: false,
      ),
      // One massive vibrant Blue circle (800px) - Top Half
      _AmbientShape(
        color: const Color.fromARGB(255, 17, 203, 254).withAlpha(150),
        size: 800.0,
        isCircle: true,
        isTopHalf: true,
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
              decoration: BoxDecoration(color: Color.fromARGB(255, 7, 35, 0)),
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
          // 3. Overlay: Deep Gaussian Blur (50.0) combined with 70% black tint
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(179), // 70% opacity
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
    required this.isTopHalf,
  });
  final Color color;
  final double size;
  final bool isCircle;
  final bool isTopHalf;

  Offset getCurrentOffset(double progress, Size screenSize) {
    // Partitioned drift: No overlay, each stays in its 50% half
    double x;
    double y;

    if (isTopHalf) {
      // Blue: Left to Right on Top Side
      x = (0.1 + progress * 0.8) % 1.0;
      // Drift vertically only within the top 40% (staying in top 50%)
      y = 0.2 + 0.1 * math.sin(progress * 2 * math.pi);
    } else {
      // Purple: Right to Left on Bottom Side
      x = (0.9 - progress * 0.8) % 1.0;
      if (x < 0) x += 1.0;
      // Drift vertically only within the bottom 40% (staying in bottom 50%)
      y = 0.8 + 0.1 * math.cos(progress * 2 * math.pi);
    }

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
