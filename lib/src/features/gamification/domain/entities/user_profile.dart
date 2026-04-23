import 'package:freezed_annotation/freezed_annotation.dart';
import 'achievement.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    required String name,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default(<Achievement>[]) List<Achievement> earnedBadges,
    @Default(<String, double>{}) Map<String, double> adherenceHistory,
    DateTime? lastCheckoffDate,
    String? equippedBadgeId,
    String? phone,
    String? bloodType,
    int? age,
    double? weight,
    double? height,
    String? email,
    String? gender,
    String? emergencyContact,
    @Default(<String>[]) List<String> medicalConditions,
    @Default(<String>[]) List<String> allergies,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
