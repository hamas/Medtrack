// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Medicine {

 String get id; String get userId; String get name; String get dosage; IntervalType get intervalType; int? get customDayInterval; List<String> get scheduleTimes; MealContext get mealContext; DeliveryMethod get deliveryMethod; DateTime get startDate; DateTime? get endDate; bool get isActive; DateTime? get createdAt;
/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicineCopyWith<Medicine> get copyWith => _$MedicineCopyWithImpl<Medicine>(this as Medicine, _$identity);

  /// Serializes this Medicine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Medicine&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.intervalType, intervalType) || other.intervalType == intervalType)&&(identical(other.customDayInterval, customDayInterval) || other.customDayInterval == customDayInterval)&&const DeepCollectionEquality().equals(other.scheduleTimes, scheduleTimes)&&(identical(other.mealContext, mealContext) || other.mealContext == mealContext)&&(identical(other.deliveryMethod, deliveryMethod) || other.deliveryMethod == deliveryMethod)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,dosage,intervalType,customDayInterval,const DeepCollectionEquality().hash(scheduleTimes),mealContext,deliveryMethod,startDate,endDate,isActive,createdAt);

@override
String toString() {
  return 'Medicine(id: $id, userId: $userId, name: $name, dosage: $dosage, intervalType: $intervalType, customDayInterval: $customDayInterval, scheduleTimes: $scheduleTimes, mealContext: $mealContext, deliveryMethod: $deliveryMethod, startDate: $startDate, endDate: $endDate, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MedicineCopyWith<$Res>  {
  factory $MedicineCopyWith(Medicine value, $Res Function(Medicine) _then) = _$MedicineCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, String dosage, IntervalType intervalType, int? customDayInterval, List<String> scheduleTimes, MealContext mealContext, DeliveryMethod deliveryMethod, DateTime startDate, DateTime? endDate, bool isActive, DateTime? createdAt
});




}
/// @nodoc
class _$MedicineCopyWithImpl<$Res>
    implements $MedicineCopyWith<$Res> {
  _$MedicineCopyWithImpl(this._self, this._then);

  final Medicine _self;
  final $Res Function(Medicine) _then;

/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? dosage = null,Object? intervalType = null,Object? customDayInterval = freezed,Object? scheduleTimes = null,Object? mealContext = null,Object? deliveryMethod = null,Object? startDate = null,Object? endDate = freezed,Object? isActive = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dosage: null == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String,intervalType: null == intervalType ? _self.intervalType : intervalType // ignore: cast_nullable_to_non_nullable
as IntervalType,customDayInterval: freezed == customDayInterval ? _self.customDayInterval : customDayInterval // ignore: cast_nullable_to_non_nullable
as int?,scheduleTimes: null == scheduleTimes ? _self.scheduleTimes : scheduleTimes // ignore: cast_nullable_to_non_nullable
as List<String>,mealContext: null == mealContext ? _self.mealContext : mealContext // ignore: cast_nullable_to_non_nullable
as MealContext,deliveryMethod: null == deliveryMethod ? _self.deliveryMethod : deliveryMethod // ignore: cast_nullable_to_non_nullable
as DeliveryMethod,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Medicine].
extension MedicinePatterns on Medicine {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Medicine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Medicine() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Medicine value)  $default,){
final _that = this;
switch (_that) {
case _Medicine():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Medicine value)?  $default,){
final _that = this;
switch (_that) {
case _Medicine() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  String dosage,  IntervalType intervalType,  int? customDayInterval,  List<String> scheduleTimes,  MealContext mealContext,  DeliveryMethod deliveryMethod,  DateTime startDate,  DateTime? endDate,  bool isActive,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Medicine() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.dosage,_that.intervalType,_that.customDayInterval,_that.scheduleTimes,_that.mealContext,_that.deliveryMethod,_that.startDate,_that.endDate,_that.isActive,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  String dosage,  IntervalType intervalType,  int? customDayInterval,  List<String> scheduleTimes,  MealContext mealContext,  DeliveryMethod deliveryMethod,  DateTime startDate,  DateTime? endDate,  bool isActive,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Medicine():
return $default(_that.id,_that.userId,_that.name,_that.dosage,_that.intervalType,_that.customDayInterval,_that.scheduleTimes,_that.mealContext,_that.deliveryMethod,_that.startDate,_that.endDate,_that.isActive,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String name,  String dosage,  IntervalType intervalType,  int? customDayInterval,  List<String> scheduleTimes,  MealContext mealContext,  DeliveryMethod deliveryMethod,  DateTime startDate,  DateTime? endDate,  bool isActive,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Medicine() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.dosage,_that.intervalType,_that.customDayInterval,_that.scheduleTimes,_that.mealContext,_that.deliveryMethod,_that.startDate,_that.endDate,_that.isActive,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Medicine implements Medicine {
  const _Medicine({required this.id, required this.userId, required this.name, required this.dosage, required this.intervalType, this.customDayInterval, required final  List<String> scheduleTimes, required this.mealContext, required this.deliveryMethod, required this.startDate, this.endDate, this.isActive = true, this.createdAt}): _scheduleTimes = scheduleTimes;
  factory _Medicine.fromJson(Map<String, dynamic> json) => _$MedicineFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String name;
@override final  String dosage;
@override final  IntervalType intervalType;
@override final  int? customDayInterval;
 final  List<String> _scheduleTimes;
@override List<String> get scheduleTimes {
  if (_scheduleTimes is EqualUnmodifiableListView) return _scheduleTimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scheduleTimes);
}

@override final  MealContext mealContext;
@override final  DeliveryMethod deliveryMethod;
@override final  DateTime startDate;
@override final  DateTime? endDate;
@override@JsonKey() final  bool isActive;
@override final  DateTime? createdAt;

/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicineCopyWith<_Medicine> get copyWith => __$MedicineCopyWithImpl<_Medicine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Medicine&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.intervalType, intervalType) || other.intervalType == intervalType)&&(identical(other.customDayInterval, customDayInterval) || other.customDayInterval == customDayInterval)&&const DeepCollectionEquality().equals(other._scheduleTimes, _scheduleTimes)&&(identical(other.mealContext, mealContext) || other.mealContext == mealContext)&&(identical(other.deliveryMethod, deliveryMethod) || other.deliveryMethod == deliveryMethod)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,dosage,intervalType,customDayInterval,const DeepCollectionEquality().hash(_scheduleTimes),mealContext,deliveryMethod,startDate,endDate,isActive,createdAt);

@override
String toString() {
  return 'Medicine(id: $id, userId: $userId, name: $name, dosage: $dosage, intervalType: $intervalType, customDayInterval: $customDayInterval, scheduleTimes: $scheduleTimes, mealContext: $mealContext, deliveryMethod: $deliveryMethod, startDate: $startDate, endDate: $endDate, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MedicineCopyWith<$Res> implements $MedicineCopyWith<$Res> {
  factory _$MedicineCopyWith(_Medicine value, $Res Function(_Medicine) _then) = __$MedicineCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String name, String dosage, IntervalType intervalType, int? customDayInterval, List<String> scheduleTimes, MealContext mealContext, DeliveryMethod deliveryMethod, DateTime startDate, DateTime? endDate, bool isActive, DateTime? createdAt
});




}
/// @nodoc
class __$MedicineCopyWithImpl<$Res>
    implements _$MedicineCopyWith<$Res> {
  __$MedicineCopyWithImpl(this._self, this._then);

  final _Medicine _self;
  final $Res Function(_Medicine) _then;

/// Create a copy of Medicine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? dosage = null,Object? intervalType = null,Object? customDayInterval = freezed,Object? scheduleTimes = null,Object? mealContext = null,Object? deliveryMethod = null,Object? startDate = null,Object? endDate = freezed,Object? isActive = null,Object? createdAt = freezed,}) {
  return _then(_Medicine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dosage: null == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as String,intervalType: null == intervalType ? _self.intervalType : intervalType // ignore: cast_nullable_to_non_nullable
as IntervalType,customDayInterval: freezed == customDayInterval ? _self.customDayInterval : customDayInterval // ignore: cast_nullable_to_non_nullable
as int?,scheduleTimes: null == scheduleTimes ? _self._scheduleTimes : scheduleTimes // ignore: cast_nullable_to_non_nullable
as List<String>,mealContext: null == mealContext ? _self.mealContext : mealContext // ignore: cast_nullable_to_non_nullable
as MealContext,deliveryMethod: null == deliveryMethod ? _self.deliveryMethod : deliveryMethod // ignore: cast_nullable_to_non_nullable
as DeliveryMethod,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
