// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Achievement _$AchievementFromJson(Map<String, dynamic> json) => _Achievement(
  id: json['id'] as String,
  type: $enumDecode(_$AchievementTypeEnumMap, json['type']),
  dateEarned: DateTime.parse(json['dateEarned'] as String),
);

Map<String, dynamic> _$AchievementToJson(_Achievement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AchievementTypeEnumMap[instance.type]!,
      'dateEarned': instance.dateEarned.toIso8601String(),
    };

const _$AchievementTypeEnumMap = {
  AchievementType.streak7: 'streak7',
  AchievementType.streak14: 'streak14',
  AchievementType.streak30: 'streak30',
};
