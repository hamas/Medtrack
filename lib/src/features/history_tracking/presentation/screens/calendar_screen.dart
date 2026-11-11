import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../core/widgets/adherence_heatmap_card.dart';
import '../../../../core/widgets/shared_ui.dart';

import '../../../gamification/domain/entities/user_profile.dart';
import '../../../gamification/presentation/providers/user_profile_provider.dart';
import '../../../gamification/presentation/providers/adherence_history_provider.dart';
import '../../../medication_management/domain/entities/medicine.dart';
import '../../../medication_management/domain/entities/adherence_log.dart';
import '../../../medication_management/domain/usecases/dose_scheduler.dart';
import '../../../medication_management/presentation/providers/all_medicines_provider.dart';
import '../../../daily_dashboard/domain/entities/dose.dart';
import '../../data/datasources/reporting_data_source.dart';
import '../providers/calendar_month_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    final DateTime focusedDay = ref.watch(calendarMonthProvider);
    final AsyncValue<Map<DateTime, int>> adherenceHistoryAsync = ref.watch(
      adherenceHistoryProvider,
    );

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          const SizedBox(height: 16),
          _buildCalendarGrid(focusedDay, adherenceHistoryAsync),
          const SizedBox(height: 24),
          _buildExportReportCard(context),
          const SizedBox(height: 24),
          adherenceHistoryAsync.when(
            data: (Map<DateTime, int> history) =>
                AdherenceHeatmapCard(history: history),
            loading: () => Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(child: CircularProgressIndicator()),
            ),
            error: (Object e, StackTrace? _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildExportReportCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Symbols.description_rounded,
              color: Colors.blueAccent,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Clinical PDF Report',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Generate verified adherence log for your doctor',
                  style: TextStyle(fontSize: 11, color: Colors.white38),
                ),
              ],
            ),
          ),
          FilledButton.tonalIcon(
            onPressed: () async {
              final UserProfile? profile = ref
                  .read(userProfileStateProvider)
                  .value;
              final List<Medicine> medicines =
                  ref.read(allMedicinesProvider).value ?? <Medicine>[];
              final List<AdherenceLog> logs = await ref
                  .read(medicationRepositoryProvider)
                  .getAllAdherenceLogs();

              await ReportingService.generateComprehensiveReport(
                patientName: profile?.name ?? 'Patient',
                medicines: medicines,
                logs: logs,
              );
            },
            icon: const Icon(Symbols.download_rounded, size: 16),
            label: const Text('Export', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(
    DateTime focusedDay,
    AsyncValue<Map<DateTime, int>> historyAsync,
  ) {
    final List<String> weekDays = <String>['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final DateTime firstDayOfMonth = DateTime(
      focusedDay.year,
      focusedDay.month,
      1,
    );
    final int firstWeekday = firstDayOfMonth.weekday % 7;
    final int daysInMonth = DateUtils.getDaysInMonth(
      focusedDay.year,
      focusedDay.month,
    );

    // Watch all medicines to render dynamic icons
    final AsyncValue<List<Medicine>> medicinesAsync = ref.watch(
      allMedicinesProvider,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays
                .map(
                  (String d) => Text(
                    d,
                    style: const TextStyle(
                      color: Colors.white12,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 12,
              crossAxisSpacing: 8,
              childAspectRatio: 0.82,
            ),
            itemCount: firstWeekday + daysInMonth,
            itemBuilder: (BuildContext context, int index) {
              if (index < firstWeekday) return const SizedBox.shrink();
              final int day = index - firstWeekday + 1;
              final DateTime date = DateTime(
                focusedDay.year,
                focusedDay.month,
                day,
              );
              final bool isToday = DateUtils.isSameDay(date, DateTime.now());

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _showDayInspectorSheet(
                    context,
                    date,
                    medicinesAsync.value ?? <Medicine>[],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isToday
                          ? Colors.blueAccent.withValues(alpha: 0.08)
                          : Colors.white.withValues(alpha: 0.02),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isToday
                            ? Colors.blueAccent.withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.03),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          day.toString(),
                          style: TextStyle(
                            color: isToday ? Colors.blueAccent : Colors.white60,
                            fontWeight: isToday
                                ? FontWeight.w900
                                : FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        _buildDynamicMedicineIcons(date, medicinesAsync),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicMedicineIcons(
    DateTime date,
    AsyncValue<List<Medicine>> medicinesAsync,
  ) {
    return medicinesAsync.maybeWhen(
      data: (List<Medicine> medicines) {
        final List<Medicine> scheduledToday = medicines.where((Medicine m) {
          final List<Dose> doses = DoseScheduler.calculateNextDoses(
            m,
            startAfter: DateTime(
              date.year,
              date.month,
              date.day,
            ).subtract(const Duration(seconds: 1)),
          );
          return doses.any(
            (Dose d) => DateUtils.isSameDay(d.scheduledTime, date),
          );
        }).toList();

        if (scheduledToday.isEmpty) return const SizedBox(height: 10);

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: scheduledToday.take(3).map((Medicine m) {
            final ({IconData icon, Color color}) config = _getMedicineConfig(
              m.deliveryMethod,
            );
            return Padding(
              padding: const EdgeInsets.only(right: 2.0),
              child: Icon(
                config.icon,
                size: 9,
                color: config.color.withValues(alpha: 0.8),
              ),
            );
          }).toList(),
        );
      },
      orElse: () => const SizedBox(height: 10),
    );
  }

  ({IconData icon, Color color}) _getMedicineConfig(DeliveryMethod method) {
    switch (method) {
      case DeliveryMethod.tablet:
        return (icon: Symbols.pill_rounded, color: Colors.amber);
      case DeliveryMethod.capsule:
        return (icon: Symbols.vaccines_rounded, color: Colors.redAccent);
      case DeliveryMethod.injection:
        return (icon: Symbols.syringe_rounded, color: Colors.blueAccent);
      case DeliveryMethod.syrup:
        return (
          icon: Symbols.medication_liquid_rounded,
          color: Colors.greenAccent,
        );
      default:
        return (icon: Symbols.medication_rounded, color: Colors.blueAccent);
    }
  }

  Future<void> _showDayInspectorSheet(
    BuildContext context,
    DateTime date,
    List<Medicine> medicines,
  ) async {
    final List<AdherenceLog> allLogs = await ref
        .read(medicationRepositoryProvider)
        .getAllAdherenceLogs();

    final List<AdherenceLog> dayLogs = allLogs.where((AdherenceLog l) {
      final bool matchesScheduled = DateUtils.isSameDay(l.scheduledTime, date);
      final bool matchesTaken =
          l.takenTime != null && DateUtils.isSameDay(l.takenTime!, date);
      return matchesScheduled || matchesTaken;
    }).toList();

    final Map<String, Medicine> medMap = <String, Medicine>{
      for (final Medicine m in medicines) m.id: m,
    };

    final List<Dose> scheduledDoses = <Dose>[];
    for (final Medicine m in medicines) {
      if (!m.isActive) continue;
      final List<Dose> doses = DoseScheduler.calculateNextDoses(
        m,
        startAfter: DateTime(
          date.year,
          date.month,
          date.day,
        ).subtract(const Duration(seconds: 1)),
      );
      for (final Dose d in doses) {
        if (DateUtils.isSameDay(d.scheduledTime, date)) {
          scheduledDoses.add(d);
        }
      }
    }

    final int takenCount = dayLogs
        .where((AdherenceLog l) => l.status == AdherenceStatus.taken)
        .length;
    final int skippedCount = dayLogs
        .where((AdherenceLog l) => l.status == AdherenceStatus.skipped)
        .length;
    final int totalActivity = takenCount + skippedCount;
    final double adherenceRate = totalActivity == 0
        ? 0.0
        : (takenCount / totalActivity) * 100.0;

    if (!context.mounted) return;

    final List<Dose> pendingScheduledDoses = scheduledDoses.where((Dose d) {
      final bool alreadyLogged = dayLogs.any(
        (AdherenceLog log) =>
            log.medicineId == d.medicine.id &&
            log.scheduledTime.hour == d.scheduledTime.hour &&
            log.scheduledTime.minute == d.scheduledTime.minute,
      );
      return !alreadyLogged;
    }).toList();

    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: kAppSheetBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        side: BorderSide(color: Color(0x14FFFFFF), width: 1),
      ),
      builder: (BuildContext sheetCtx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Handle and Close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(width: 32),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Symbols.close_rounded,
                      color: Colors.white54,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(sheetCtx),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        DateFormat('EEEE, MMM d').format(date),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateUtils.isSameDay(date, DateTime.now())
                            ? "Today's Medication Timeline"
                            : 'Historical Day Breakdown',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (totalActivity > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: adherenceRate >= 80
                            ? Colors.green.withValues(alpha: 0.2)
                            : Colors.amber.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        '${adherenceRate.toStringAsFixed(0)}% Adherence',
                        style: TextStyle(
                          color: adherenceRate >= 80
                              ? Colors.greenAccent
                              : Colors.amberAccent,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _buildSummaryMetric(
                      label: 'Taken',
                      value: '$takenCount',
                      color: Colors.tealAccent,
                      icon: Symbols.check_circle_rounded,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSummaryMetric(
                      label: 'Skipped',
                      value: '$skippedCount',
                      color: Colors.amberAccent,
                      icon: Symbols.cancel_rounded,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSummaryMetric(
                      label: 'Scheduled',
                      value: '${pendingScheduledDoses.length}',
                      color: Colors.blueAccent,
                      icon: Symbols.schedule_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'LOGGED ACTIVITY & STATUS',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              if (dayLogs.isEmpty && pendingScheduledDoses.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'No medication activity recorded on this day.',
                      style: TextStyle(color: Colors.white38, fontSize: 13),
                    ),
                  ),
                )
              else
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(sheetCtx).size.height * 0.42,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ...dayLogs.map((AdherenceLog log) {
                          final Medicine? med = medMap[log.medicineId];
                          final DeliveryMethod method =
                              med?.deliveryMethod ?? DeliveryMethod.tablet;
                          final bool isTaken =
                              log.status == AdherenceStatus.taken;
                          final DateTime displayTime =
                              (isTaken && log.takenTime != null)
                              ? log.takenTime!
                              : log.scheduledTime;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                MedicationCategoryBadge(
                                  method: method,
                                  size: 38,
                                  iconSize: 20,
                                  borderRadius: 14,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        med?.name ?? 'Unknown Medication',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${med?.dosage ?? ''} • ${isTaken ? 'Taken' : 'Skipped'}',
                                        style: const TextStyle(
                                          color: Colors.white38,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isTaken
                                        ? Colors.greenAccent.withValues(
                                            alpha: 0.12,
                                          )
                                        : Colors.amberAccent.withValues(
                                            alpha: 0.12,
                                          ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        isTaken
                                            ? Symbols.check_circle_rounded
                                            : Symbols.cancel_rounded,
                                        color: isTaken
                                            ? Colors.greenAccent
                                            : Colors.amberAccent,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        DateFormat(
                                          'hh:mm a',
                                        ).format(displayTime),
                                        style: TextStyle(
                                          color: isTaken
                                              ? Colors.greenAccent
                                              : Colors.amberAccent,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        ...pendingScheduledDoses.map((Dose dose) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.02),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.04),
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                MedicationCategoryBadge(
                                  method: dose.medicine.deliveryMethod,
                                  size: 38,
                                  iconSize: 20,
                                  borderRadius: 14,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        dose.medicine.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${dose.medicine.dosage} • Upcoming',
                                        style: const TextStyle(
                                          color: Colors.white38,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Icon(
                                        Symbols.schedule_rounded,
                                        color: Colors.blueAccent,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        DateFormat(
                                          'hh:mm a',
                                        ).format(dose.scheduledTime),
                                        style: const TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryMetric({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
