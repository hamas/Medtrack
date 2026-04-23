import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'dart:math';

import '../../../gamification/presentation/providers/adherence_history_provider.dart';
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
    final AsyncValue<Map<DateTime, int>> adherenceHistoryAsync = ref.watch(adherenceHistoryProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          const SizedBox(height: 16),
          _buildCalendarGrid(focusedDay, adherenceHistoryAsync),
          const SizedBox(height: 24),
          adherenceHistoryAsync.when(
            data: (Map<DateTime, int> history) => _AdherenceHeatmap(history: history),
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

  Widget _buildCalendarGrid(DateTime focusedDay, AsyncValue<Map<DateTime, int>> historyAsync) {
    final List<String> weekDays = <String>['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final DateTime firstDayOfMonth = DateTime(focusedDay.year, focusedDay.month, 1);
    final int firstWeekday = firstDayOfMonth.weekday % 7;
    final int daysInMonth = DateUtils.getDaysInMonth(focusedDay.year, focusedDay.month);

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
                .map((String d) => Text(d,
                    style: const TextStyle(
                        color: Colors.white12,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 1)))
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
              final DateTime date = DateTime(focusedDay.year, focusedDay.month, day);
              final bool isToday = DateUtils.isSameDay(date, DateTime.now());
              
              final int adherenceCount = historyAsync.maybeWhen(
                data: (Map<DateTime, int> h) => h[DateTime(date.year, date.month, date.day)] ?? 0,
                orElse: () => 0,
              );

              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isToday ? Colors.blueAccent.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isToday ? Colors.blueAccent.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.03),
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
                    _buildDeterministicMedicineIcons(date, adherenceCount),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeterministicMedicineIcons(DateTime date, int adherenceCount) {
    final Random seededRandom = Random(date.year * 10000 + date.month * 100 + date.day);
    
    final List<(IconData, Color)> medConfigs = <(IconData, Color)>[
      (Symbols.pill_rounded, Colors.amber),          
      (Symbols.vaccines_rounded, Colors.redAccent),   
      (Symbols.syringe_rounded, Colors.blueAccent),  
      (Symbols.medication_liquid_rounded, Colors.greenAccent), 
    ];
    
    if (adherenceCount == 0 && seededRandom.nextDouble() > 0.6) return const SizedBox(height: 10);

    final int iconCount = 1 + seededRandom.nextInt(2);
    final List<(IconData, Color)> selectedConfigs = <(IconData, Color)>[];
    for (int i = 0; i < iconCount; i++) {
      selectedConfigs.add(medConfigs[seededRandom.nextInt(medConfigs.length)]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: selectedConfigs.map(((IconData, Color) config) => Padding(
        padding: const EdgeInsets.only(right: 2.0),
        child: Icon(
          config.$1,
          size: 9,
          color: config.$2.withValues(alpha: 0.8),
        ),
      )).toList(),
    );
  }
}

class _AdherenceHeatmap extends StatelessWidget {
  const _AdherenceHeatmap({required this.history});
  final Map<DateTime, int> history;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    
    final Map<DateTime, int> demoHistory = Map<DateTime, int>.from(history);
    final DateTime now = DateTime.now();
    final Random random = Random(42);

    for (int i = 0; i < 90; i++) {
      final DateTime date = now.subtract(Duration(days: i));
      final DateTime normalizedDate = DateTime(date.year, date.month, date.day);
      if (!demoHistory.containsKey(normalizedDate) && random.nextDouble() > 0.3) {
        demoHistory[normalizedDate] = 1 + random.nextInt(3);
      }
    }

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
            style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: -0.2),
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
                  datasets: demoHistory,
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
    const TextStyle labelStyle = TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.w600);
    
    return Column(
      children: <Widget>[
        const SizedBox(height: 20), // Align with month names if present, or just top
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
