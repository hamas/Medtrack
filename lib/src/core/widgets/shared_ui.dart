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

const Color kAppSheetBackground = Color(0xFF0D0F22);
const Color kAppDialogBackground = Color(0xFF11142A);

Future<T?> showGlassBottomSheet<T>({
  required BuildContext context,
  required String title,
  required Widget content,
  VoidCallback? onConfirm,
  String? confirmText,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: true,
    backgroundColor: kAppSheetBackground,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (BuildContext ctx) => Container(
      decoration: BoxDecoration(
        color: kAppSheetBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
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
              if (onConfirm != null)
                TextButton(
                  onPressed: () {
                    onConfirm();
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    confirmText ?? 'Done',
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                )
              else
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(
                    Symbols.close_rounded,
                    color: Colors.white38,
                  ),
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

({IconData icon, Color color, String label}) getDeliveryMethodConfig(
  DeliveryMethod method,
) {
  switch (method) {
    case DeliveryMethod.tablet:
      return (icon: Symbols.pill_rounded, color: Colors.amber, label: 'Tablet');
    case DeliveryMethod.capsule:
      return (
        icon: Symbols.vaccines_rounded,
        color: Colors.redAccent,
        label: 'Capsule',
      );
    case DeliveryMethod.syrup:
      return (
        icon: Symbols.medication_liquid_rounded,
        color: Colors.greenAccent,
        label: 'Syrup',
      );
    case DeliveryMethod.injection:
      return (
        icon: Symbols.syringe_rounded,
        color: Colors.blueAccent,
        label: 'Syringe',
      );
    case DeliveryMethod.water:
      return (icon: Symbols.pill_rounded, color: Colors.amber, label: 'Water');
    case DeliveryMethod.milk:
      return (
        icon: Symbols.vaccines_rounded,
        color: Colors.redAccent,
        label: 'Milk',
      );
    case DeliveryMethod.mixed:
      return (
        icon: Symbols.science_rounded,
        color: Colors.purpleAccent,
        label: 'Mixed',
      );
    case DeliveryMethod.drops:
      return (
        icon: Symbols.opacity_rounded,
        color: Colors.cyanAccent,
        label: 'Drops',
      );
    case DeliveryMethod.inhaler:
      return (
        icon: Symbols.air_rounded,
        color: Colors.tealAccent,
        label: 'Inhaler',
      );
    case DeliveryMethod.other:
      return (
        icon: Symbols.medication_rounded,
        color: Colors.blueAccent,
        label: 'Other',
      );
  }
}

IconData getDeliveryMethodIcon(DeliveryMethod method) =>
    getDeliveryMethodConfig(method).icon;

Color getDeliveryMethodColor(DeliveryMethod method) =>
    getDeliveryMethodConfig(method).color;

class MedicationCategoryBadge extends StatelessWidget {
  const MedicationCategoryBadge({
    required this.method,
    this.size = 56,
    this.iconSize = 24,
    this.borderRadius = 20,
    super.key,
  });

  final DeliveryMethod method;
  final double size;
  final double iconSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final ({IconData icon, Color color, String label}) config =
        getDeliveryMethodConfig(method);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: config.color.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Icon(config.icon, color: config.color, size: iconSize),
      ),
    );
  }
}
