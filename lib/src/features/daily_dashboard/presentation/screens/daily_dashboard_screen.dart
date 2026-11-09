import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/widgets/shared_ui.dart';

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

    final List<String> quotes = <String>[
      'Consistency is the foundation of recovery.',
      'Your journey to health is a marathon, not a sprint. 🏃‍♂️',
      'Hydration check: Take a sip of water with your next dose. 💧',
      'Every small step counts towards a healthier you. ✨',
    ];
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
                  const SizedBox(height: 16),
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Center(child: _MotivationCard(quote: quote)),
            ),

            const LowStockBanner(),

            Expanded(
              child: timelineAsync.when(
                data: (List<Dose> doses) => doses.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'No doses scheduled for today.',
                              style: TextStyle(color: Colors.white60),
                            ),
                            const SizedBox(height: 16),
                            FloatingActionButton.extended(
                              onPressed: () => context.push('/medicines/add'),
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              icon: const Icon(Symbols.add_rounded),
                              label: const Text(
                                'Add Medication',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(
                        children: <Widget>[
                          ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 6, 16, 96),
                            itemCount: doses.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: 8),
                            itemBuilder: (BuildContext context, int index) {
                              final Dose dose = doses[index];
                              return _DashboardItem(dose: dose);
                            },
                          ),
                          Positioned(
                            bottom: 80,
                            right: 16,
                            child: FloatingActionButton.extended(
                              onPressed: () => context.push('/medicines/add'),
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              icon: const Icon(Symbols.add_rounded),
                              label: const Text(
                                'Add Medication',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        DateFormat('EEEE').format(now),
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
    final Medicine medicine = dose.medicine;
    final String timeStr = DateFormat('hh:mm a').format(dose.scheduledTime);
    final bool isHandled = dose.isTaken || dose.isSkipped;
    final bool isOverdue = !isHandled &&
        !dose.isSnoozed &&
        DateTime.now().difference(dose.scheduledTime).inMinutes > 60;

    return Container(
      decoration: BoxDecoration(
        color: isHandled
            ? Colors.white.withValues(alpha: 0.02)
            : (dose.isSnoozed
                ? Colors.amber.withValues(alpha: 0.04)
                : Colors.white.withValues(alpha: 0.05)),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHandled
              ? Colors.white.withValues(alpha: 0.03)
              : (dose.isSnoozed
                  ? Colors.amberAccent.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.07)),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: const SizedBox.expand(),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (!dose.isTaken) {
                  _handleDoseCheckOff(context, ref);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: <Widget>[
                    MedicationCategoryBadge(
                      method: medicine.deliveryMethod,
                      size: 46,
                      iconSize: 22,
                      borderRadius: 14,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  medicine.name,
                                  style: TextStyle(
                                    color: isHandled
                                        ? Colors.white54
                                        : Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    letterSpacing: -0.2,
                                    decoration: isHandled
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isOverdue) ...<Widget>[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.redAccent.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    'Overdue by ${_formatOverdue(dose.scheduledTime)}',
                                    style: const TextStyle(
                                      color: Color(0xFFFCA5A5),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${medicine.dosage} • ${_getMealLabel(medicine.mealContext)}',
                            style: TextStyle(
                              color: isHandled
                                  ? Colors.white30
                                  : Colors.white60,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              if (dose.isTaken) ...<Widget>[
                                const Icon(
                                  Symbols.check_circle_rounded,
                                  size: 13,
                                  color: Colors.greenAccent,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Taken at ${DateFormat('hh:mm a').format(dose.takenTime ?? dose.scheduledTime)}',
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ] else if (dose.isSkipped) ...<Widget>[
                                const Icon(
                                  Symbols.cancel_rounded,
                                  size: 13,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Skipped: ${dose.skipReason ?? 'By user'}',
                                    style: const TextStyle(
                                      color: Color(0xFFFCA5A5),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ] else if (dose.isSnoozed) ...<Widget>[
                                const Icon(
                                  Symbols.snooze_rounded,
                                  size: 13,
                                  color: Colors.amberAccent,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Snoozed to $timeStr',
                                  style: const TextStyle(
                                    color: Colors.amberAccent,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ] else ...<Widget>[
                                const Icon(
                                  Symbols.schedule_rounded,
                                  size: 13,
                                  color: Color(0xFF93C5FD),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  timeStr,
                                  style: const TextStyle(
                                    color: Color(0xFF93C5FD),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (dose.observation != null) ...<Widget>[
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: dose.observation!.startsWith('Vitals:')
                                    ? Colors.cyanAccent.withValues(alpha: 0.1)
                                    : Colors.pinkAccent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: dose.observation!.startsWith('Vitals:')
                                      ? Colors.cyanAccent.withValues(alpha: 0.25)
                                      : Colors.pinkAccent.withValues(alpha: 0.25),
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    dose.observation!.startsWith('Vitals:')
                                        ? Symbols.monitor_heart_rounded
                                        : Symbols.vital_signs_rounded,
                                    size: 12,
                                    color: dose.observation!.startsWith('Vitals:')
                                        ? Colors.cyanAccent
                                        : Colors.pinkAccent,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      dose.observation!,
                                      style: TextStyle(
                                        color: dose.observation!.startsWith('Vitals:')
                                            ? Colors.cyanAccent
                                            : Colors.pinkAccent,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Symbols.more_vert_rounded,
                            color: Colors.white24,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: kAppDialogBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          onSelected: (String action) {
                            if (action == 'take') {
                              ref
                                  .read(dailyTimelineProvider.notifier)
                                  .checkOffDose(dose);
                            } else if (action == 'snooze') {
                              ref
                                  .read(dailyTimelineProvider.notifier)
                                  .snoozeDose(
                                    dose,
                                    const Duration(minutes: 30),
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Dose snoozed for 30 minutes'),
                                ),
                              );
                            } else if (action == 'skip') {
                              _showSkipDoseDialog(context, ref);
                            } else if (action == 'symptom') {
                              _showSymptomCheckInDialog(context, ref);
                            } else if (action == 'vitals') {
                              _showVitalsDialog(context, ref);
                            }
                          },
                          itemBuilder: (BuildContext ctx) =>
                              <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'take',
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Symbols.check_circle_rounded,
                                        color: Colors.greenAccent,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Take Dose'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'snooze',
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Symbols.snooze_rounded,
                                        color: Colors.amberAccent,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Snooze (30m)'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'skip',
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Symbols.cancel_rounded,
                                        color: Colors.redAccent,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Skip Dose (Reason)'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'symptom',
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Symbols.vital_signs_rounded,
                                        color: Colors.pinkAccent,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Log Side Effect'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'vitals',
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Symbols.monitor_heart_rounded,
                                        color: Colors.cyanAccent,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Log Vitals / Biometrics'),
                                    ],
                                  ),
                                ),
                              ],
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () {
                            if (!dose.isTaken) {
                              _handleDoseCheckOff(context, ref);
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: dose.isTaken
                                  ? Colors.greenAccent.withValues(alpha: 0.15)
                                  : (dose.isSkipped
                                      ? Colors.redAccent.withValues(alpha: 0.15)
                                      : (dose.isSnoozed
                                          ? Colors.amberAccent.withValues(alpha: 0.15)
                                          : Colors.white.withValues(alpha: 0.05))),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: dose.isTaken
                                    ? Colors.greenAccent.withValues(alpha: 0.5)
                                    : (dose.isSkipped
                                        ? Colors.redAccent.withValues(alpha: 0.5)
                                        : (dose.isSnoozed
                                            ? Colors.amberAccent.withValues(alpha: 0.4)
                                            : Colors.white.withValues(alpha: 0.12))),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              dose.isTaken
                                  ? Symbols.check_rounded
                                  : (dose.isSkipped
                                      ? Symbols.close_rounded
                                      : (dose.isSnoozed
                                          ? Symbols.snooze_rounded
                                          : Symbols.radio_button_unchecked_rounded)),
                              color: dose.isTaken
                                  ? Colors.greenAccent
                                  : (dose.isSkipped
                                      ? Colors.redAccent
                                      : (dose.isSnoozed
                                          ? Colors.amberAccent
                                          : Colors.white30)),
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSkipDoseDialog(BuildContext context, WidgetRef ref) {
    final List<String> reasons = <String>[
      'Experiencing side effects / Nausea',
      'Fasting or Medical Procedure',
      'Medication temporarily unavailable',
      'Doctor advised to hold dose',
      'Forgot / Missed window',
      'Other reason',
    ];

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: kAppSheetBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: kAppSheetBackground,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Skip Dose: ${dose.medicine.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Symbols.close_rounded, color: Colors.white38),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Clinical protocol requires logging the clinical or lifestyle reason for skipping a scheduled medication.',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: reasons.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(color: Colors.white12, height: 1),
                    itemBuilder: (BuildContext ctx, int index) {
                      final String reason = reasons[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Symbols.cancel_rounded,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        title: Text(
                          reason,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(sheetContext).pop();
                          ref
                              .read(dailyTimelineProvider.notifier)
                              .skipDose(dose, reason: reason);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Dose skipped: $reason'),
                              backgroundColor: Colors.redAccent.shade700,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSymptomCheckInDialog(BuildContext context, WidgetRef ref) {
    String selectedSymptom = 'Nausea / Upset Stomach';
    String selectedSeverity = 'Mild';
    final TextEditingController detailsController = TextEditingController();

    final List<String> commonSymptoms = <String>[
      'Nausea / Upset Stomach',
      'Headache / Dizziness',
      'Fatigue / Drowsiness',
      'Skin Rash / Itching',
      'Gastrointestinal Cramps',
      'Dry Mouth / Dehydration',
      'Palpitations',
      'Other reaction',
    ];

    final List<String> severities = <String>['Mild', 'Moderate', 'Severe'];

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: kAppSheetBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (BuildContext sheetCtx) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: kAppSheetBackground,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                ),
              ),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Symbols.vital_signs_rounded,
                          color: Colors.pinkAccent,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Symptom Check-In: ${dose.medicine.name}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(sheetCtx),
                          icon: const Icon(Symbols.close_rounded, color: Colors.white38),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Log tolerability observations or adverse reactions to share with your physician.',
                      style: TextStyle(fontSize: 12, color: Colors.white60),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'SYMPTOM',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white38,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: commonSymptoms.map((String sym) {
                        final bool isSel = selectedSymptom == sym;
                        return ChoiceChip(
                          label: Text(
                            sym,
                            style: TextStyle(
                              fontSize: 11,
                              color: isSel ? Colors.white : Colors.white70,
                            ),
                          ),
                          selected: isSel,
                          selectedColor: Colors.pinkAccent.withValues(
                            alpha: 0.3,
                          ),
                          backgroundColor: Colors.white.withValues(alpha: 0.05),
                          side: BorderSide(
                            color: isSel ? Colors.pinkAccent : Colors.white12,
                          ),
                          onSelected: (bool sel) {
                            if (sel) {
                              setModalState(() => selectedSymptom = sym);
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'SEVERITY',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white38,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: severities.map((String sev) {
                        final bool isSel = selectedSeverity == sev;
                        final Color sevColor = sev == 'Severe'
                            ? Colors.redAccent
                            : sev == 'Moderate'
                            ? Colors.amberAccent
                            : Colors.tealAccent;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(
                              sev,
                              style: TextStyle(
                                fontSize: 11,
                                color: isSel ? Colors.white : Colors.white70,
                              ),
                            ),
                            selected: isSel,
                            selectedColor: sevColor.withValues(alpha: 0.3),
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.05,
                            ),
                            side: BorderSide(
                              color: isSel ? sevColor : Colors.white12,
                            ),
                            onSelected: (bool sel) {
                              if (sel) {
                                setModalState(() => selectedSeverity = sev);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                      child: TextField(
                        controller: detailsController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Additional notes / details for doctor...',
                          hintStyle: TextStyle(
                            color: Colors.white24,
                            fontSize: 12,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.pop(sheetCtx);
                          ref
                              .read(dailyTimelineProvider.notifier)
                              .logSideEffect(
                                dose,
                                symptom: selectedSymptom,
                                severity: selectedSeverity,
                                details: detailsController.text,
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Logged symptom: $selectedSymptom ($selectedSeverity)',
                              ),
                              backgroundColor: Colors.pink[800],
                            ),
                          );
                        },
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        icon: const Icon(Symbols.check_rounded, size: 18),
                        label: const Text(
                          'Save Tolerability Log',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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

  String _formatOverdue(DateTime scheduled) {
    final Duration diff = DateTime.now().difference(scheduled);
    final int hours = diff.inHours;
    final int mins = diff.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }

  Future<void> _handleDoseCheckOff(BuildContext context, WidgetRef ref) async {
    final int lateHours = DateTime.now().difference(dose.scheduledTime).inHours;
    if (lateHours >= 2) {
      final bool? proceed = await showDialog<bool>(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
          backgroundColor: kAppDialogBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          icon: const Icon(
            Symbols.info_rounded,
            color: Colors.amberAccent,
            size: 36,
          ),
          title: const Text(
            'Late Dose Guidance',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(
            'This dose of ${dose.medicine.name} was scheduled $lateHours hours ago.\n\nClinical Rule: If it is almost time for your next scheduled dose, skip this dose. Never double up on medication to compensate for a missed dose.',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white60),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.amber[800]),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Take Dose Now'),
            ),
          ],
        ),
      );
      if (proceed != true) return;
    }

    if (context.mounted) {
      await ref.read(dailyTimelineProvider.notifier).checkOffDose(dose);
    }
  }

  void _showVitalsDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController bpController = TextEditingController();
    final TextEditingController glucoseController = TextEditingController();
    final TextEditingController hrController = TextEditingController();
    final TextEditingController spo2Controller = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: kAppSheetBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (BuildContext sheetCtx) {
        return Container(
          decoration: BoxDecoration(
            color: kAppSheetBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    const Icon(
                      Symbols.monitor_heart_rounded,
                      color: Colors.cyanAccent,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Log Vitals: ${dose.medicine.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetCtx),
                      icon: const Icon(Symbols.close_rounded, color: Colors.white38),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Record paired physiological readings (e.g. BP for hypertension meds, Glucose for insulin).',
                  style: TextStyle(fontSize: 12, color: Colors.white60),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: TextField(
                          controller: bpController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'BP (mmHg)',
                            labelStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                            hintText: '120/80',
                            hintStyle: TextStyle(
                              color: Colors.white24,
                              fontSize: 12,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: TextField(
                          controller: glucoseController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Glucose (mg/dL)',
                            labelStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                            hintText: '100',
                            hintStyle: TextStyle(
                              color: Colors.white24,
                              fontSize: 12,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: TextField(
                          controller: hrController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Heart Rate (bpm)',
                            labelStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                            hintText: '72',
                            hintStyle: TextStyle(
                              color: Colors.white24,
                              fontSize: 12,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: TextField(
                          controller: spo2Controller,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'SpO2 Oxygen (%)',
                            labelStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                            hintText: '98',
                            hintStyle: TextStyle(
                              color: Colors.white24,
                              fontSize: 12,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      final List<String> entries = <String>[];
                      if (bpController.text.trim().isNotEmpty) {
                        entries.add('BP: ${bpController.text.trim()} mmHg');
                      }
                      if (glucoseController.text.trim().isNotEmpty) {
                        entries.add(
                          'Glucose: ${glucoseController.text.trim()} mg/dL',
                        );
                      }
                      if (hrController.text.trim().isNotEmpty) {
                        entries.add('HR: ${hrController.text.trim()} bpm');
                      }
                      if (spo2Controller.text.trim().isNotEmpty) {
                        entries.add('SpO2: ${spo2Controller.text.trim()}%');
                      }

                      if (entries.isEmpty) {
                        Navigator.pop(sheetCtx);
                        return;
                      }

                      final String summary = entries.join(', ');
                      Navigator.pop(sheetCtx);
                      ref
                          .read(dailyTimelineProvider.notifier)
                          .logVitals(dose, summary);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Vitals logged: $summary'),
                          backgroundColor: Colors.teal[800],
                        ),
                      );
                    },
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black87,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    icon: const Icon(Symbols.check_rounded, size: 18),
                    label: const Text(
                      'Save Vitals & Readings',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
