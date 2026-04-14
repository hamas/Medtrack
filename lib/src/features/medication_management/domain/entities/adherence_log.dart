// Developed by Hamas — Medtrack Project [100% Dart]
// Developed by Hamas — Medtrack Project [100% Dart Implementation]
import 'package:freezed_annotation/freezed_annotation.dart';

part 'adherence_log.freezed.dart';
part 'adherence_log.g.dart';

enum AdherenceStatus { taken, skipped, missed }

@freezed
class AdherenceLog with _$AdherenceLog {
  const factory AdherenceLog({
    required String id,
    required String medicineId,
    required DateTime scheduledTime,
    DateTime? takenTime,
    required AdherenceStatus status,
    String? mealNotes,
  }) = _AdherenceLog;

  factory AdherenceLog.fromJson(Map<String, dynamic> json) => _$AdherenceLogFromJson(json);
}
