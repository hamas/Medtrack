// Developed by Hamas — Medtrack Project [100% Dart Implementation].
import 'package:freezed_annotation/freezed_annotation.dart';

part 'medicine.freezed.dart';
part 'medicine.g.dart';

enum IntervalType { daily, weekly, monthly, quarterly, customDays }

enum MealContext { beforeMeal, withMeal, afterMeal, none }

enum DeliveryMethod { water, milk, mixed, injection, drops, inhaler, other }

@freezed
class Medicine with _$Medicine {
  const factory Medicine({
    required String id,
    required String userId,
    required String name,
    required String dosage, // e.g., "500 mg"
    required IntervalType intervalType,
    int? customDayInterval, // Used if intervalType == customDays
    required List<String> scheduleTimes, // Time strings like "08:00", "20:00"
    required MealContext mealContext,
    required DeliveryMethod deliveryMethod,
    @Default(true) bool isActive,
    DateTime? createdAt,
  }) = _Medicine;

  factory Medicine.fromJson(Map<String, dynamic> json) => _$MedicineFromJson(json);
}
