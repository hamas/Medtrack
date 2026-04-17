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
      duration: const Duration(seconds: 50),
    )..repeat(reverse: true);

    _initializeShapes();
  }

  void _initializeShapes() {
    // Exactly 3 massive elements as requested
    _shapes.addAll(<_AmbientShape>[
      // One vibrant Purple circle
      _AmbientShape(
        color: const Color(0xFFF0ABFF).withAlpha(150),
        size: 550.0,
        isCircle: true,
        offset: const Offset(0.2, 0.3),
        velocity: const Offset(0.08, 0.1),
      ),
      // One vibrant Green square
      _AmbientShape(
        color: const Color(0xFF4ADE80).withAlpha(120),
        size: 600.0,
        isCircle: false,
        offset: const Offset(0.8, 0.1),
        velocity: const Offset(-0.06, 0.12),
      ),
      // One vibrant Blue circle
      _AmbientShape(
        color: const Color(0xFF38BDF8).withAlpha(130),
        size: 520.0,
        isCircle: true,
        offset: const Offset(0.5, 0.8),
        velocity: const Offset(-0.1, -0.08),
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
          // The Drifting Shapes layer
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
          // Deep Glassmorphism: Heavy Gaussian Blur (Increased to 30.0)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
              child: const SizedBox.expand(),
            ),
          ),
          // Dark Veil: Black at 90% opacity (High-intensity neon survives this)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(230), // ~90% opacity
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
