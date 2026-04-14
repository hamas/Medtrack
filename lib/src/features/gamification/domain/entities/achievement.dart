import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

enum AchievementType {
  streak7('7 Day Streak', 'Consistency is key!', '7_streak'),
  streak14('14 Day Streak', 'Unstoppable!', '14_streak'),
  streak30('30 Day Streak', 'Medication Legend!', '30_streak');

  const AchievementType(this.name, this.description, this.id);
  final String name;
  final String description;
  final String id;
}

@freezed
abstract class Achievement with _$Achievement {
  const factory Achievement({
    required String id,
    required AchievementType type,
    required DateTime dateEarned,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
}
