// Developed by Hamas - Medtrack Project [100% Dart Implementation].
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
    required String dosage,
    required IntervalType intervalType,
    int? customDayInterval,
    required List<String> scheduleTimes,
    required MealContext mealContext,
    required DeliveryMethod deliveryMethod,
    @Default(true) bool isActive,
    DateTime? createdAt,
  }) = _Medicine;

  factory Medicine.fromJson(Map<String, dynamic> json) => _$MedicineFromJson(json);
}
