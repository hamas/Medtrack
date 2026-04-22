import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/widgets/ambient_background.dart';

class ReadmeScreen extends StatelessWidget {
  const ReadmeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Symbols.arrow_back_rounded,
            size: 22,
            color: Colors.white70,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'About Medtrack',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: AmbientBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: <Widget>[
              const SizedBox(height: 24),
              _buildHeader(),
              const SizedBox(height: 32),
              _buildSection(
                'THE VISION',
                'Medtrack is a cinematic medical companion designed for high-fidelity precision. It pairs a stunning aesthetic with a robust medical-grade engine to ensure zero missing doses.',
                Symbols.visibility_rounded,
              ),
              const SizedBox(height: 24),
              _buildSection(
                'CORE CAPABILITIES',
                '• Surgical scheduling accuracy\n• Contextual medical logging\n• Clinical-grade PDF reporting\n• Biometric security gates\n• Gamified adherence tracking',
                Symbols.star_rounded,
              ),
              const SizedBox(height: 24),
              _buildSection(
                'ARCHITECTURE',
                'Built with 100% Clean Architecture (Feature-First) using Riverpod for reactive state management and enterprise scalability.',
                Symbols.architecture_rounded,
              ),
              const SizedBox(height: 48),
              const Center(
                child: Text(
                  'Developed by Hamas ❤️',
                  style: TextStyle(
                    color: Colors.white24,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white10),
          ),
          child: const Icon(
            Symbols.medical_services_rounded,
            color: Colors.white,
            size: 48,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Medtrack',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        const Text(
          'Cinematic Medical Hub',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: Colors.white70, size: 18),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
