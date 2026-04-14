// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Medicine _$MedicineFromJson(Map<String, dynamic> json) => _Medicine(
  id: json['id'] as String,
  userId: json['userId'] as String,
  name: json['name'] as String,
  dosage: json['dosage'] as String,
  intervalType: $enumDecode(_$IntervalTypeEnumMap, json['intervalType']),
  customDayInterval: (json['customDayInterval'] as num?)?.toInt(),
  scheduleTimes: (json['scheduleTimes'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  mealContext: $enumDecode(_$MealContextEnumMap, json['mealContext']),
  deliveryMethod: $enumDecode(_$DeliveryMethodEnumMap, json['deliveryMethod']),
  isActive: json['isActive'] as bool? ?? true,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$MedicineToJson(_Medicine instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'name': instance.name,
  'dosage': instance.dosage,
  'intervalType': _$IntervalTypeEnumMap[instance.intervalType]!,
  'customDayInterval': instance.customDayInterval,
  'scheduleTimes': instance.scheduleTimes,
  'mealContext': _$MealContextEnumMap[instance.mealContext]!,
  'deliveryMethod': _$DeliveryMethodEnumMap[instance.deliveryMethod]!,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$IntervalTypeEnumMap = {
  IntervalType.daily: 'daily',
  IntervalType.weekly: 'weekly',
  IntervalType.monthly: 'monthly',
  IntervalType.quarterly: 'quarterly',
  IntervalType.customDays: 'customDays',
};

const _$MealContextEnumMap = {
  MealContext.beforeMeal: 'beforeMeal',
  MealContext.withMeal: 'withMeal',
  MealContext.afterMeal: 'afterMeal',
  MealContext.none: 'none',
};

const _$DeliveryMethodEnumMap = {
  DeliveryMethod.water: 'water',
  DeliveryMethod.milk: 'milk',
  DeliveryMethod.mixed: 'mixed',
  DeliveryMethod.injection: 'injection',
  DeliveryMethod.drops: 'drops',
  DeliveryMethod.inhaler: 'inhaler',
  DeliveryMethod.other: 'other',
};
