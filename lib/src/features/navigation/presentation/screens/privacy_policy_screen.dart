import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/widgets/ambient_background.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
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
              _buildPolicyItem(
                'DATA PRIVACY',
                'Your health data is sensitive and personal. Medtrack uses local-first encryption and secure cloud synchronization to ensure that only you can access your medication history.',
                Symbols.lock_rounded,
              ),
              const SizedBox(height: 16),
              _buildPolicyItem(
                'BIOMETRIC SECURITY',
                'FaceID and Fingerprint data never leave your device. We use industry-standard biometric APIs to verify your identity locally before granting access to sensitive records.',
                Symbols.fingerprint_rounded,
              ),
              const SizedBox(height: 16),
              _buildPolicyItem(
                'THIRD-PARTY SERVICES',
                'We use Firebase for authentication and cloud sync. No medical data is shared with third parties for marketing or tracking purposes.',
                Symbols.share_off_rounded,
              ),
              const SizedBox(height: 16),
              _buildPolicyItem(
                'YOUR RIGHTS',
                'You have the right to export your adherence reports and delete your account data at any time through the Profile settings.',
                Symbols.delete_rounded,
              ),
              const SizedBox(height: 48),
              const Center(
                child: Text(
                  'Last Updated: April 2026',
                  style: TextStyle(
                    color: Colors.white24,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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

  Widget _buildPolicyItem(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: Colors.white70, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
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
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
