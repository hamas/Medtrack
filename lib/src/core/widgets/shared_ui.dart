import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../features/medication_management/domain/entities/medicine.dart';

class GlassSectionTitle extends StatelessWidget {
  const GlassSectionTitle({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: Colors.white38,
        letterSpacing: 2,
      ),
    );
  }
}

class GlassSwitchTile extends StatelessWidget {
  const GlassSwitchTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Colors.white38),
        ),
        activeTrackColor: color.withValues(alpha: 0.3),
        activeThumbColor: color,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}

class GlassActionTile extends StatelessWidget {
  const GlassActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.trailing,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Colors.white38),
        ),
        trailing:
            trailing ??
            const Icon(
              Symbols.chevron_right_rounded,
              color: Colors.white10,
              size: 20,
            ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}

Future<T?> showGlassBottomSheet<T>({
  required BuildContext context,
  required String title,
  required Widget content,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: true,
    backgroundColor: const Color(0xFF0F172A),
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (BuildContext ctx) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Symbols.close_rounded, color: Colors.white38),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}

IconData getDeliveryMethodIcon(DeliveryMethod method) {
  switch (method) {
    case DeliveryMethod.tablet:
      return Symbols.pill_rounded;
    case DeliveryMethod.capsule:
      return Symbols.vaccines_rounded;
    case DeliveryMethod.syrup:
      return Symbols.medication_liquid_rounded;
    case DeliveryMethod.injection:
      return Symbols.syringe_rounded;
    case DeliveryMethod.water:
      return Symbols.pill_rounded;
    case DeliveryMethod.milk:
      return Symbols.vaccines_rounded;
    case DeliveryMethod.mixed:
      return Symbols.science_rounded;
    case DeliveryMethod.drops:
      return Symbols.opacity_rounded;
    case DeliveryMethod.inhaler:
      return Symbols.air_rounded;
    case DeliveryMethod.other:
      return Symbols.medication_rounded;
  }
}
