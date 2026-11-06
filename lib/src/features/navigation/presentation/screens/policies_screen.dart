import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/widgets/shared_ui.dart';

class PoliciesScreen extends StatelessWidget {
  const PoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          const SizedBox(height: 20),
          GlassActionTile(
            title: 'About Medtrack',
            subtitle: 'Vision, Features & Tech Stack',
            icon: Symbols.info_rounded,
            color: Colors.blueAccent,
            onTap: () => context.push('/menu/policies/readme'),
          ),
          GlassActionTile(
            title: 'Privacy Policy',
            subtitle: 'How we handle your medical data',
            icon: Symbols.security_rounded,
            color: Colors.tealAccent,
            onTap: () => context.push('/menu/policies/privacy'),
          ),
          const SizedBox(height: 32),
          const Center(
            child: Text(
              'Version 1.0.0 (Stable)',
              style: TextStyle(
                color: Colors.white24,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
