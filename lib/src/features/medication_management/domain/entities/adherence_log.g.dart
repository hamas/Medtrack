// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adherence_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdherenceLog _$AdherenceLogFromJson(Map<String, dynamic> json) =>
    _AdherenceLog(
      id: json['id'] as String,
      medicineId: json['medicineId'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      takenTime: json['takenTime'] == null
          ? null
          : DateTime.parse(json['takenTime'] as String),
      status: $enumDecode(_$AdherenceStatusEnumMap, json['status']),
      mealNotes: json['mealNotes'] as String?,
    );

Map<String, dynamic> _$AdherenceLogToJson(_AdherenceLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medicineId': instance.medicineId,
      'scheduledTime': instance.scheduledTime.toIso8601String(),
      'takenTime': instance.takenTime?.toIso8601String(),
      'status': _$AdherenceStatusEnumMap[instance.status]!,
      'mealNotes': instance.mealNotes,
    };

const _$AdherenceStatusEnumMap = {
  AdherenceStatus.taken: 'taken',
  AdherenceStatus.skipped: 'skipped',
  AdherenceStatus.missed: 'missed',
};
