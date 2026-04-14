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
  takenTime: json['takenTime'] == null
      ? null
      : DateTime.parse(json['takenTime'] as String),
);

Map<String, dynamic> _$DoseToJson(_Dose instance) => <String, dynamic>{
  'id': instance.id,
  'medicine': instance.medicine,
  'scheduledTime': instance.scheduledTime.toIso8601String(),
  'isTaken': instance.isTaken,
  'takenTime': instance.takenTime?.toIso8601String(),
};
