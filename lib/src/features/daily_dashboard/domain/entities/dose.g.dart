// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Dose _$DoseFromJson(Map<String, dynamic> json) => _Dose(
  id: json['id'] as String,
  medicine: Medicine.fromJson(json['medicine'] as Map<String, dynamic>),
  scheduledTime: DateTime.parse(json['scheduledTime'] as String),
  isTaken: json['isTaken'] as bool? ?? false,
  isSkipped: json['isSkipped'] as bool? ?? false,
  isSnoozed: json['isSnoozed'] as bool? ?? false,
  skipReason: json['skipReason'] as String?,
  observation: json['observation'] as String?,
  takenTime: json['takenTime'] == null
      ? null
      : DateTime.parse(json['takenTime'] as String),
);

Map<String, dynamic> _$DoseToJson(_Dose instance) => <String, dynamic>{
  'id': instance.id,
  'medicine': instance.medicine,
  'scheduledTime': instance.scheduledTime.toIso8601String(),
  'isTaken': instance.isTaken,
  'isSkipped': instance.isSkipped,
  'isSnoozed': instance.isSnoozed,
  'skipReason': instance.skipReason,
  'observation': instance.observation,
  'takenTime': instance.takenTime?.toIso8601String(),
};
