// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  uid: json['uid'] as String,
  name: json['name'] as String,
  currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
  longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
  earnedBadges:
      (json['earnedBadges'] as List<dynamic>?)
          ?.map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Achievement>[],
  lastCheckoffDate: json['lastCheckoffDate'] == null
      ? null
      : DateTime.parse(json['lastCheckoffDate'] as String),
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'earnedBadges': instance.earnedBadges,
      'lastCheckoffDate': instance.lastCheckoffDate?.toIso8601String(),
    };
