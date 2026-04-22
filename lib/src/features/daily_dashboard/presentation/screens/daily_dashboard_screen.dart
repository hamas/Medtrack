import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../medication_management/domain/entities/medicine.dart';
import '../../domain/entities/dose.dart';
import '../providers/daily_timeline_provider.dart';
import '../../../gamification/domain/entities/user_profile.dart';
import '../../../gamification/presentation/providers/user_profile_provider.dart';
import '../../../weather/domain/entities/weather_data.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import 'package:confetti/confetti.dart';
import '../widgets/low_stock_banner.dart';

class DailyDashboardScreen extends ConsumerStatefulWidget {
  const DailyDashboardScreen({super.key});

  @override
  ConsumerState<DailyDashboardScreen> createState() =>
      _DailyDashboardScreenState();
}

class _DailyDashboardScreenState extends ConsumerState<DailyDashboardScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for completion to trigger confetti
    ref.listen(dailyTimelineProvider, (
      AsyncValue<List<Dose>>? prev,
      AsyncValue<List<Dose>> next,
    ) {
      if (next.hasValue && next.value!.isNotEmpty) {
        final bool isComplete = next.value!.every((Dose d) => d.isTaken);
        final bool wasComplete =
            prev?.value?.every((Dose d) => d.isTaken) ?? false;

        if (isComplete && !wasComplete) {
          _confettiController.play();
        }
      }
    });

    final AsyncValue<List<Dose>> timelineAsync = ref.watch(
      dailyTimelineProvider,
    );

    // Fetch dynamic user name for personalized greetings
    final String userName = ref
        .watch(userProfileStateProvider)
        .when(
          data: (UserProfile profile) => profile.name,
          loading: () => 'Hamas',
          error: (Object error, StackTrace stack) => 'Hamas',
        );

    final ({String title, String message}) greeting = _getGreeting(userName);
    final AsyncValue<WeatherData> weatherAsync = ref.watch(weatherProvider);

    // DAILY MOTIVATION QUOTES
    final List<String> quotes = <String>[
      'Consistency is the foundation of recovery.',
      'Your journey to health is a marathon, not a sprint. 🏃‍♂️',
      'Hydration check: Take a sip of water with your next dose. 💧',
      'Every small step counts towards a healthier you. ✨',
    ];
    // Select quote based on day to ensure it stays consistent for the whole day
    final String quote = quotes[DateTime.now().day % quotes.length];

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(56),
                  bottomRight: Radius.circular(56),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Gap: Exactly 16px below TopHeader Area
                  const SizedBox(height: 16),
                  // Header Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  greeting.title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  greeting.message,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withValues(alpha: 0.5),
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                            // Weather Tag: Dynamic Real-time Integration
                            weatherAsync.when(
                              data: (WeatherData weather) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      weather.isNight
                                          ? Symbols.dark_mode_rounded
                                          : Symbols.wb_sunny_rounded,
                                      color: weather.isNight
                                          ? Colors.lightBlueAccent.withValues(
                                              alpha: 0.8,
                                            )
                                          : Colors.amber,
                                      size: 14,
                                      fill: 1,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${weather.temperature.toStringAsFixed(0)}°C',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withValues(
                                          alpha: 0.7,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              loading: () => const SizedBox(
                                width: 40,
                                height: 22,
                                child: Center(
                                  child: SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                              error: (Object err, StackTrace stack) =>
                                  const Icon(
                                    Symbols.cloud_off_rounded,
                                    size: 14,
                                    color: Colors.white24,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const _FocusedDateHeader(hasInternalPadding: false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // [NEW] Motivation Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(child: _MotivationCard(quote: quote)),
            ),

            const LowStockBanner(),

            Expanded(
              child: timelineAsync.when(
                data: (List<Dose> doses) => doses.isEmpty
                    ? const Center(child: Text('No doses scheduled for today.'))
                    : Stack(
                        children: <Widget>[
                          ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            itemCount: doses.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: 12),
                            itemBuilder: (BuildContext context, int index) {
                              final Dose dose = doses[index];
                              return _DashboardItem(dose: dose);
                            },
                          ),
                          Positioned(
                            bottom:
                                80, // Elevation for FAB alignment with nav bar
                            right: 16,
                            child: FloatingActionButton.extended(
                              onPressed: () => context.push('/add-medicine'),
                              icon: const Icon(Symbols.add_rounded),
                              label: const Text('Add Medication'),
                            ),
                          ),
                        ],
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (Object err, StackTrace stack) =>
                    Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const <Color>[
              Color(0xFF2563EB),
              Color(0xFF38BDF8),
              Color(0xFF2DD4BF),
            ],
            numberOfParticles: 20,
            gravity: 0.1,
          ),
        ),
      ],
    );
  }

  ({String title, String message}) _getGreeting(String name) {
    final int hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return (
        title: 'Rise and shine, $name! ☀️',
        message: 'Let’s start the day healthy.',
      );
    } else if (hour >= 12 && hour < 18) {
      return (
        title: 'Good afternoon, $name.',
        message: 'Keeping that momentum going! 💪',
      );
    } else if (hour >= 18 && hour < 23) {
      return (
        title: 'Good evening, $name.',
        message: 'Almost done for today! ✨',
      );
    } else {
      return (title: 'Rest well, $name.', message: 'Health is wealth. 🌙');
    }
  }
}

class _FocusedDateHeader extends StatelessWidget {
  const _FocusedDateHeader({this.hasInternalPadding = true});
  final bool hasInternalPadding;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hasInternalPadding ? 16 : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Date Group
          Row(
            children: <Widget>[
              // Big Date in Minimal Circle
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  now.day.toString(),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Day details consolidated
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        DateFormat('EEEE').format(now), // Monday
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('MMMM yyyy').format(now),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardItem extends ConsumerWidget {
  const _DashboardItem({required this.dose});
  final Dose dose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final Medicine medicine = dose.medicine;
    final String timeStr = DateFormat('hh:mm a').format(dose.scheduledTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(
          alpha: 0.2,
        ), // Glassmorphic base
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          // Glassmorphism Blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const SizedBox.expand(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 3D Medication Asset
                Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/images/medication_3d.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              medicine.name,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Symbols.more_vert_rounded,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${medicine.dosage}, 1 ${medicine.deliveryMethod.name}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.4,
                          ),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Time Chips
                      Wrap(
                        spacing: 8,
                        children: <Widget>[
                          _TimeChip(
                            label: _getMealLabel(medicine.mealContext),
                            color: const Color(0xFFE0F7F6),
                            textColor: const Color(0xFF0D9488),
                          ),
                          _TimeChip(
                            label: timeStr,
                            color: const Color(0xFFE0E7FF),
                            textColor: const Color(0xFF4338CA),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Interaction Layer
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (!dose.isTaken) {
                    ref.read(dailyTimelineProvider.notifier).checkOffDose(dose);
                  }
                },
              ),
            ),
          ),
          // Taken indicator
          if (dose.isTaken)
            Positioned(
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Symbols.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getMealLabel(MealContext context) {
    switch (context) {
      case MealContext.beforeMeal:
        return 'Before Meal';
      case MealContext.withMeal:
        return 'With Meal';
      case MealContext.afterMeal:
        return 'After Meal';
      case MealContext.none:
        return 'Anytime';
    }
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.label,
    required this.color,
    required this.textColor,
  });
  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MotivationCard extends StatelessWidget {
  const _MotivationCard({required this.quote});
  final String quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Symbols.tips_and_updates_rounded,
            color: Colors.amber,
            size: 12,
            fill: 1,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              quote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
