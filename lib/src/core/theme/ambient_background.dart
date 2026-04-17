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
  final int _shapeCount = 8;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _initializeShapes();
  }

  void _initializeShapes() {
    final math.Random random = math.Random();
    final List<Color> colors = <Color>[
      const Color(0xFF9333EA).withValues(alpha: 0.4), // Deep Purple
      const Color(0xFF10B981).withValues(alpha: 0.3), // Vibrant Green
      const Color(0xFF3B82F6).withValues(alpha: 0.3), // Soft Blue
    ];

    for (int i = 0; i < _shapeCount; i++) {
      _shapes.add(
        _AmbientShape(
          color: colors[random.nextInt(colors.length)],
          size: 150.0 + random.nextDouble() * 200.0,
          isCircle: random.nextBool(),
          offset: Offset(random.nextDouble(), random.nextDouble()),
          velocity: Offset(
            (random.nextDouble() - 0.5) * 0.2,
            (random.nextDouble() - 0.5) * 0.2,
          ),
        ),
      );
    }
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
              return CustomPaint(
                painter: _AmbientPainter(
                  shapes: _shapes,
                  progress: _controller.value,
                ),
                size: Size.infinite,
              );
            },
          ),
          // Glassmorphism: Gaussian Blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: const SizedBox.expand(),
            ),
          ),
          // Dark Veil: Black at 90% opacity
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.9),
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
