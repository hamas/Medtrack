// Developed by Hamas - Medtrack Project [100% Dart Implementation].
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:medtrack/src/features/medication_management/domain/entities/medicine.dart';

part 'dose.freezed.dart';
part 'dose.g.dart';

@freezed
abstract class Dose with _$Dose {
  const factory Dose({
    required String id,
    required Medicine medicine,
    required DateTime scheduledTime,
    @Default(false) bool isTaken,
    DateTime? takenTime,
  }) = _Dose;

  factory Dose.fromJson(Map<String, dynamic> json) => _$DoseFromJson(json);
}
