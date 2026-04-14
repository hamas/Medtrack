import 'package:freezed_annotation/freezed_annotation.dart';
import 'achievement.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    required String name,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default(<Achievement>[]) List<Achievement> earnedBadges,
    DateTime? lastCheckoffDate,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
