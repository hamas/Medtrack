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
      earnedBadges: (json['earnedBadges'] as List<dynamic>?)
              ?.map((e) => Achievement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Achievement>[],
      adherenceHistory:
          (json['adherenceHistory'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const <String, double>{},
      lastCheckoffDate: json['lastCheckoffDate'] == null
          ? null
          : DateTime.parse(json['lastCheckoffDate'] as String),
      equippedBadgeId: json['equippedBadgeId'] as String?,
      phone: json['phone'] as String?,
      bloodType: json['bloodType'] as String?,
      age: (json['age'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      emergencyContact: json['emergencyContact'] as String?,
      medicalConditions: (json['medicalConditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      allergies: (json['allergies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'earnedBadges': instance.earnedBadges,
      'adherenceHistory': instance.adherenceHistory,
      'lastCheckoffDate': instance.lastCheckoffDate?.toIso8601String(),
      'equippedBadgeId': instance.equippedBadgeId,
      'phone': instance.phone,
      'bloodType': instance.bloodType,
      'age': instance.age,
      'weight': instance.weight,
      'height': instance.height,
      'email': instance.email,
      'gender': instance.gender,
      'emergencyContact': instance.emergencyContact,
      'medicalConditions': instance.medicalConditions,
      'allergies': instance.allergies,
    };
