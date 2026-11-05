import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calendar_month_provider.g.dart';

@riverpod
class CalendarMonth extends _$CalendarMonth {
  @override
  DateTime build() => DateTime.now();

  void setMonth(DateTime date) {
    state = date;
  }

  void nextMonth() {
    state = DateTime(state.year, state.month + 1);
  }

  void previousMonth() {
    state = DateTime(state.year, state.month - 1);
  }
}
