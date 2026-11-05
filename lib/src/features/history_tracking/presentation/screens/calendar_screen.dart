import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

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
                _AdherenceHeatmap(history: history),
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

              return Container(
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
                        fontWeight: isToday ? FontWeight.w900 : FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    _buildDynamicMedicineIcons(date, medicinesAsync),
                  ],
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
}

class _AdherenceHeatmap extends StatelessWidget {
  const _AdherenceHeatmap({required this.history});
  final Map<DateTime, int> history;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Yearly Adherence',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Static Day Labels on the left
              _buildStaticDayLabels(),
              const SizedBox(width: 8),
              // Scrollable Heatmap
              Expanded(
                child: HeatMap(
                  datasets: history,
                  colorMode: ColorMode.color,
                  defaultColor: Colors.white.withValues(alpha: 0.03),
                  textColor: Colors.white38,
                  showColorTip: false,
                  showText: false, // Turn off internal scrolling labels
                  scrollable: true,
                  size: 18,
                  colorsets: <int, Color>{
                    1: primaryColor.withValues(alpha: 0.3),
                    2: primaryColor.withValues(alpha: 0.6),
                    3: primaryColor,
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStaticDayLabels() {
    const double squareSize = 18.0;
    const double spacing = 2.0; // Default spacing for HeatMap squares
    const TextStyle labelStyle = TextStyle(
      color: Colors.white24,
      fontSize: 10,
      fontWeight: FontWeight.w600,
    );

    return Column(
      children: <Widget>[
        const SizedBox(
          height: 20,
        ), // Align with month names if present, or just top
        _label('Sun', labelStyle, squareSize, spacing),
        _label('Mon', labelStyle, squareSize, spacing),
        _label('Tue', labelStyle, squareSize, spacing),
        _label('Wed', labelStyle, squareSize, spacing),
        _label('Thu', labelStyle, squareSize, spacing),
        _label('Fri', labelStyle, squareSize, spacing),
        _label('Sat', labelStyle, squareSize, spacing),
      ],
    );
  }

  Widget _label(String text, TextStyle style, double size, double spacing) {
    return Container(
      height: size,
      margin: EdgeInsets.only(bottom: spacing),
      alignment: Alignment.centerLeft,
      child: Text(text, style: style),
    );
  }
}
