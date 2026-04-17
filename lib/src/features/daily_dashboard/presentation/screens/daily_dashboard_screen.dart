import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../medication_management/domain/entities/medicine.dart';
import '../../domain/entities/dose.dart';
import '../providers/daily_timeline_provider.dart';

class DailyDashboardScreen extends ConsumerWidget {
  const DailyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Dose>> timelineAsync = ref.watch(
      dailyTimelineProvider,
    );

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(56),
              bottomRight: Radius.circular(56),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _GreetingHeader(),
              _HorizontalDatePicker(),
              SizedBox(height: 24),
            ],
          ),
        ),
        Expanded(
          child: timelineAsync.when(
            data: (List<Dose> doses) => doses.isEmpty
                ? const Center(child: Text('No doses scheduled for today.'))
                : Stack(
                    children: <Widget>[
                      ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: doses.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (BuildContext context, int index) {
                          final Dose dose = doses[index];
                          return _DashboardItem(dose: dose);
                        },
                      ),
                      Positioned(
                        bottom: 80, // Elevation for FAB alignment with nav bar
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
    );
  }
}

class _GreetingHeader extends ConsumerWidget {
  const _GreetingHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 140, 16, 16),
      child: Text(
        'Welcome',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w300,
              fontSize: 32,
              height: 1.2,
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
    );
  }
}

class _HorizontalDatePicker extends ConsumerStatefulWidget {
  const _HorizontalDatePicker({super.key});

  @override
  ConsumerState<_HorizontalDatePicker> createState() => _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends ConsumerState<_HorizontalDatePicker> {
  late final ScrollController _scrollController;
  static const double _itemWidth = 65.0 + (6.0 * 2); // width + margin
  static const double _padding = 16.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _snapToClosest(double offset) {
    if (!_scrollController.hasClients) return;
    final int index = (offset / _itemWidth).round();
    _scrollToIndex(index);
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double targetOffset =
        (index * _itemWidth) - (screenWidth / 2) + (_itemWidth / 2) + _padding;

    _scrollController.animateTo(
      targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final DateTime lastDayOfMonth = DateTime(today.year, today.month + 1, 0);
    final int daysCount = lastDayOfMonth.difference(today).inDays + 1;

    final DateTime selectedDate = ref.watch(selectedDateProvider);

    return Column(
      children: <Widget>[
        SizedBox(
          height: 110,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollEndNotification) {
                _snapToClosest(notification.metrics.pixels);
              }
              return false;
            },
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: _padding),
              itemCount: daysCount,
              itemBuilder: (BuildContext context, int index) {
                final DateTime date = today.add(Duration(days: index));
                final bool isSelected = date.year == selectedDate.year &&
                    date.month == selectedDate.month &&
                    date.day == selectedDate.day;

                return GestureDetector(
                  onTap: () {
                    ref.read(selectedDateProvider.notifier).set(date);
                    _scrollToIndex(index);
                  },
                  child: _DateItem(date: date, isSelected: isSelected),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        const _ViewSegmentedControl(),
      ],
    );
  }
}

class _ViewSegmentedControl extends StatelessWidget {
  const _ViewSegmentedControl({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _SegmentItem(label: 'Today', isActive: true),
          _SegmentItem(label: 'Week', isActive: false),
          _SegmentItem(label: 'Month', isActive: false),
        ],
      ),
    );
  }
}

class _SegmentItem extends StatelessWidget {
  const _SegmentItem({required this.label, required this.isActive});
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(height: 4),
        if (isActive)
          Container(
            width: 24,
            height: 3,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}

class _DateItem extends StatelessWidget {
  const _DateItem({required this.date, required this.isSelected});
  final DateTime date;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 65,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primary
            : colorScheme.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(32),
        border: isSelected
            ? null
            : Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
        boxShadow: isSelected
            ? <BoxShadow>[
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat('E').format(date),
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface.withValues(alpha: 0.6),
            ),
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
        color: theme.colorScheme.surface.withValues(alpha: 0.2), // Glassmorphic base
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
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${medicine.dosage}, 1 ${medicine.deliveryMethod.name}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
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
  const _TimeChip({required this.label, required this.color, required this.textColor});
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
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
