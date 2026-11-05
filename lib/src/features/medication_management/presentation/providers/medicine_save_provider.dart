import 'package:flutter_riverpod/flutter_riverpod.dart';

class MedicineSaveTrigger extends Notifier<int> {
  @override
  int build() => 0;

  void trigger() => state = state + 1;
  void reset() => state = 0;
}

final NotifierProvider<MedicineSaveTrigger, int> medicineSaveTriggerProvider =
    NotifierProvider<MedicineSaveTrigger, int>(MedicineSaveTrigger.new);
