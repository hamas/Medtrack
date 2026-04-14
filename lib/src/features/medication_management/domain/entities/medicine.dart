import 'package:freezed_annotation/freezed_annotation.dart';

part 'medicine.freezed.dart';
part 'medicine.g.dart';

enum IntervalType { daily, weekly, monthly, custom }

enum IntervalUnit { days, weeks, months }

enum MealContext { beforeMeal, withMeal, afterMeal, none }

enum DeliveryMethod { water, milk, mixed, injection, drops, inhaler, other }

@freezed
abstract class Medicine with _$Medicine {
  const factory Medicine({
    required String id,
    required String userId,
    required String name,
    required String dosage,
    required IntervalType intervalType,
    @Default(1) int intervalCount,
    @Default(IntervalUnit.days) IntervalUnit intervalUnit,
    required List<String> scheduleTimes,
    required MealContext mealContext,
    required DeliveryMethod deliveryMethod,
    required DateTime startDate,
    DateTime? endDate,
    int? durationDays,
    @Default(true) bool isActive,
    DateTime? createdAt,
  }) = _Medicine;

  factory Medicine.fromJson(Map<String, dynamic> json) =>
      _$MedicineFromJson(json);
}
