import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../medication_management/domain/entities/medicine.dart';

part 'dose.freezed.dart';
part 'dose.g.dart';

@freezed
class Dose with _$Dose {
  const factory Dose({
    required String id,
    required Medicine medicine,
    required DateTime scheduledTime,
    @Default(false) bool isTaken,
    DateTime? takenTime,
  }) = _Dose;

  factory Dose.fromJson(Map<String, dynamic> json) => _$DoseFromJson(json);
}
