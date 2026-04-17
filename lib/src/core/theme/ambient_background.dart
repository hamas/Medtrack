import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class AmbientBackground extends StatefulWidget {
  const AmbientBackground({super.key, this.child});

  final Widget? child;

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with TickerProviderStateMixin {
  late AnimationController _lickController;
  late AnimationController _flickerController;
  final math.Random _random = math.Random();
  final List<_Spark> _sparks = <_Spark>[];

  @override
  void initState() {
    super.initState();
    // Extremely slow 25s loop for absolute ambient tranquility
    _lickController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 25000),
    )..repeat(reverse: true);

    // High-speed jitter for fire flicker
    _flickerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat();

    _initializeSparks();
  }

  void _initializeSparks() {
    for (int i = 0; i < 15; i++) {
      _sparks.add(_Spark(random: _random));
    }
  }

  @override
  void dispose() {
    _lickController.dispose();
    _flickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: <Widget>[
          // 1. Foundation: Deepest Navy/Lavender base layer
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Color(0xFF090A1A)),
            ),
          ),

          // 2. The Midnight Inferno: Animated Flames & Sparks
          AnimatedBuilder(
            animation: Listenable.merge(<AnimationController>[
              _lickController,
              _flickerController,
            ]),
            builder: (BuildContext context, Widget? child) {
              return CustomPaint(
                painter: _MidnightInfernoPainter(
                  lickProgress: _lickController.value,
                  flickerValue: _random.nextDouble(),
                  sparks: _sparks,
                  random: _random,
                ),
                size: Size.infinite,
              );
            },
          ),

          // 3. Extreme Glassmorphism: Gaussian Hyper-Blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 300.0, sigmaY: 300.0),
              child: const SizedBox.shrink(),
            ),
          ),

          // 4. Midnight Veil: 80% Black Overlay
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.6)),
          ),

          // 5. Content Slot
          if (widget.child != null) Positioned.fill(child: widget.child!),
        ],
      ),
    );
  }
}

class _MidnightInfernoPainter extends CustomPainter {
  _MidnightInfernoPainter({
    required this.lickProgress,
    required this.flickerValue,
    required this.sparks,
    required this.random,
  });

  final double lickProgress;
  final double flickerValue;
  final List<_Spark> sparks;
  final math.Random random;

  @override
  void paint(Canvas canvas, Size size) {
    // Colors from visualizer
    const Color indigo = Color(0xFF6367FF);
    const Color navyLavender = Color(0xFF15173D);

    // Flicker jitter: Affects global brightness/opacity slightly
    final double flickerAlpha = 0.7 + (flickerValue * 0.3);

    final Paint flamePaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50.0);

    // Draw 10 Overlapping Tongues of Light distributed across the baseline
    for (int i = 0; i < 10; i++) {
      final double phase = (i / 10) * math.pi * 2;
      final double individualScale =
          1.0 + 0.2 * math.sin(lickProgress * math.pi * 2 + phase);

      // Dynamic color blending for each tongue
      flamePaint.color = Color.lerp(
        navyLavender,
        indigo,
        (i / 10),
      )!.withValues(alpha: 0.35 * flickerAlpha);

      final Path path = Path();
      // Distribute centered points across the full screen width
      final double xPos = (size.width * 0.1) + (size.width * 0.8 * (i / 9));
      final double bottomY = size.height;

      // Tongue dimensions - varied for organic distribution
      final double width =
          (size.width * 0.3) * (0.8 + 0.4 * random.nextDouble());
      final double height = (size.height * 0.55) * individualScale;

      path.moveTo(xPos - (width / 2), bottomY);
      path.quadraticBezierTo(
        xPos,
        bottomY - (height * 1.3),
        xPos + (width / 2),
        bottomY,
      );
      path.close();

      canvas.drawPath(path, flamePaint);
    }

    // Paint Spark Particles
    final Paint sparkPaint = Paint()..color = Colors.white;
    for (final _Spark spark in sparks) {
      spark.update(size);
      sparkPaint.color = Colors.white.withValues(alpha: spark.opacity);
      canvas.drawCircle(spark.position, spark.size, sparkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Spark {
  _Spark({required this.random}) {
    _reset();
  }

  final math.Random random;
  late Offset position;
  late double velocityY;
  late double size;
  late double opacity;

  void _reset() {
    position = Offset(
      random.nextDouble() * 1000,
      1000,
    ); // Temporary large off-screen
    velocityY = 1.0 + random.nextDouble() * 3.0;
    size = 0.5 + random.nextDouble() * 2.0;
    opacity = 0.0;
  }

  void update(Size screenSize) {
    if (opacity <= 0.0) {
      // Re-spawn spark at bottom center area
      position = Offset(
        (screenSize.width / 2) +
            (random.nextDouble() - 0.5) * (screenSize.width * 0.6),
        screenSize.height,
      );
      opacity = 0.5 + random.nextDouble() * 0.5;
    } else {
      position = Offset(position.dx, position.dy - velocityY);
      opacity -= 0.005; // Fade out as they ascend
    }
  }
}
