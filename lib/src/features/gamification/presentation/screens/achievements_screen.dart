import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

import '../../domain/entities/achievement.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/user_profile_provider.dart';
import '../providers/adherence_history_provider.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserProfile> profileAsync = ref.watch(
      userProfileStateProvider,
    );
    final AsyncValue<Map<DateTime, int>> adherenceHistoryAsync = ref.watch(
      adherenceHistoryProvider,
    );

    return profileAsync.when(
          data: (UserProfile profile) => SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: <Widget>[
                const SizedBox(height: 20),
                const _SectionTitle(title: 'ADHERENCE MOMENTUM'),
                const SizedBox(height: 12),
                adherenceHistoryAsync.when(
                  data: (Map<DateTime, int> history) =>
                      _AdherenceHeatmap(history: history),
                  loading: () => const SizedBox(height: 180),
                  error: (Object e, StackTrace? _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 32),
                const _SectionTitle(title: 'BADGE GALLERY'),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: AchievementType.values.length,
                  itemBuilder: (BuildContext context, int index) {
                    final AchievementType type = AchievementType.values[index];
                    final bool isEarned = profile.earnedBadges.any(
                      (Achievement a) => a.type == type,
                    );
                    return _BadgeTile(type: type, isEarned: isEarned);
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object e, StackTrace? _) => Center(child: Text('Error: $e')),
        );
  }
}

class _AdherenceHeatmap extends StatelessWidget {
  const _AdherenceHeatmap({required this.history});
  final Map<DateTime, int> history;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: HeatMap(
        datasets: history,
        colorMode: ColorMode.color,
        defaultColor: Colors.white.withValues(alpha: 0.03),
        textColor: Colors.white38,
        showColorTip: false,
        showText: false,
        scrollable: true,
        size: 20,
        colorsets: <int, Color>{
          1: primaryColor.withValues(alpha: 0.3),
          2: primaryColor.withValues(alpha: 0.6),
          3: primaryColor,
        },
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.type, required this.isEarned});
  final AchievementType type;
  final bool isEarned;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = _getBadgeVisuals(type);

    return GestureDetector(
      onTap: () =>
          _showBadgeInfo(context, type.name, type.description, isEarned),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isEarned
              ? color.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isEarned ? color.withValues(alpha: 0.2) : Colors.white10,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 32,
              color: isEarned ? color : Colors.white.withValues(alpha: 0.05),
            ),
            const SizedBox(height: 8),
            Text(
              type.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: isEarned ? Colors.white : Colors.white10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeInfo(
    BuildContext context,
    String title,
    String desc,
    bool earned,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              earned ? Symbols.award_star_rounded : Symbols.lock_rounded,
              color: earned ? Colors.amber : Colors.white10,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              earned ? desc : 'Reach the milestone to unlock this badge.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: Text(earned ? 'Awesome!' : 'I will get it!'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  (IconData, Color) _getBadgeVisuals(AchievementType type) {
    switch (type) {
      case AchievementType.day1:
        return (Symbols.star_rounded, Colors.orangeAccent);
      case AchievementType.streak7:
        return (Symbols.workspace_premium_rounded, Colors.cyanAccent);
      case AchievementType.streak14:
        return (Symbols.military_tech_rounded, Colors.pinkAccent);
      case AchievementType.streak30:
        return (Symbols.diamond_rounded, Colors.blueAccent);
      case AchievementType.day90:
        return (Symbols.emoji_events_rounded, Colors.purpleAccent);
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
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
