// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adherence_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdherenceLog {

 String get id; String get medicineId; DateTime get scheduledTime; DateTime? get takenTime; AdherenceStatus get status; String? get mealNotes;
/// Create a copy of AdherenceLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdherenceLogCopyWith<AdherenceLog> get copyWith => _$AdherenceLogCopyWithImpl<AdherenceLog>(this as AdherenceLog, _$identity);

  /// Serializes this AdherenceLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdherenceLog&&(identical(other.id, id) || other.id == id)&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.takenTime, takenTime) || other.takenTime == takenTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.mealNotes, mealNotes) || other.mealNotes == mealNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicineId,scheduledTime,takenTime,status,mealNotes);

@override
String toString() {
  return 'AdherenceLog(id: $id, medicineId: $medicineId, scheduledTime: $scheduledTime, takenTime: $takenTime, status: $status, mealNotes: $mealNotes)';
}


}

/// @nodoc
abstract mixin class $AdherenceLogCopyWith<$Res>  {
  factory $AdherenceLogCopyWith(AdherenceLog value, $Res Function(AdherenceLog) _then) = _$AdherenceLogCopyWithImpl;
@useResult
$Res call({
 String id, String medicineId, DateTime scheduledTime, DateTime? takenTime, AdherenceStatus status, String? mealNotes
});




}
/// @nodoc
class _$AdherenceLogCopyWithImpl<$Res>
    implements $AdherenceLogCopyWith<$Res> {
  _$AdherenceLogCopyWithImpl(this._self, this._then);

  final AdherenceLog _self;
  final $Res Function(AdherenceLog) _then;

/// Create a copy of AdherenceLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? medicineId = null,Object? scheduledTime = null,Object? takenTime = freezed,Object? status = null,Object? mealNotes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as DateTime,takenTime: freezed == takenTime ? _self.takenTime : takenTime // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdherenceStatus,mealNotes: freezed == mealNotes ? _self.mealNotes : mealNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdherenceLog].
extension AdherenceLogPatterns on AdherenceLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdherenceLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdherenceLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdherenceLog value)  $default,){
final _that = this;
switch (_that) {
case _AdherenceLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdherenceLog value)?  $default,){
final _that = this;
switch (_that) {
case _AdherenceLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String medicineId,  DateTime scheduledTime,  DateTime? takenTime,  AdherenceStatus status,  String? mealNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdherenceLog() when $default != null:
return $default(_that.id,_that.medicineId,_that.scheduledTime,_that.takenTime,_that.status,_that.mealNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String medicineId,  DateTime scheduledTime,  DateTime? takenTime,  AdherenceStatus status,  String? mealNotes)  $default,) {final _that = this;
switch (_that) {
case _AdherenceLog():
return $default(_that.id,_that.medicineId,_that.scheduledTime,_that.takenTime,_that.status,_that.mealNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String medicineId,  DateTime scheduledTime,  DateTime? takenTime,  AdherenceStatus status,  String? mealNotes)?  $default,) {final _that = this;
switch (_that) {
case _AdherenceLog() when $default != null:
return $default(_that.id,_that.medicineId,_that.scheduledTime,_that.takenTime,_that.status,_that.mealNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdherenceLog implements AdherenceLog {
  const _AdherenceLog({required this.id, required this.medicineId, required this.scheduledTime, this.takenTime, required this.status, this.mealNotes});
  factory _AdherenceLog.fromJson(Map<String, dynamic> json) => _$AdherenceLogFromJson(json);

@override final  String id;
@override final  String medicineId;
@override final  DateTime scheduledTime;
@override final  DateTime? takenTime;
@override final  AdherenceStatus status;
@override final  String? mealNotes;

/// Create a copy of AdherenceLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdherenceLogCopyWith<_AdherenceLog> get copyWith => __$AdherenceLogCopyWithImpl<_AdherenceLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdherenceLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdherenceLog&&(identical(other.id, id) || other.id == id)&&(identical(other.medicineId, medicineId) || other.medicineId == medicineId)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.takenTime, takenTime) || other.takenTime == takenTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.mealNotes, mealNotes) || other.mealNotes == mealNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicineId,scheduledTime,takenTime,status,mealNotes);

@override
String toString() {
  return 'AdherenceLog(id: $id, medicineId: $medicineId, scheduledTime: $scheduledTime, takenTime: $takenTime, status: $status, mealNotes: $mealNotes)';
}


}

/// @nodoc
abstract mixin class _$AdherenceLogCopyWith<$Res> implements $AdherenceLogCopyWith<$Res> {
  factory _$AdherenceLogCopyWith(_AdherenceLog value, $Res Function(_AdherenceLog) _then) = __$AdherenceLogCopyWithImpl;
@override @useResult
$Res call({
 String id, String medicineId, DateTime scheduledTime, DateTime? takenTime, AdherenceStatus status, String? mealNotes
});




}
/// @nodoc
class __$AdherenceLogCopyWithImpl<$Res>
    implements _$AdherenceLogCopyWith<$Res> {
  __$AdherenceLogCopyWithImpl(this._self, this._then);

  final _AdherenceLog _self;
  final $Res Function(_AdherenceLog) _then;

/// Create a copy of AdherenceLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? medicineId = null,Object? scheduledTime = null,Object? takenTime = freezed,Object? status = null,Object? mealNotes = freezed,}) {
  return _then(_AdherenceLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicineId: null == medicineId ? _self.medicineId : medicineId // ignore: cast_nullable_to_non_nullable
as String,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as DateTime,takenTime: freezed == takenTime ? _self.takenTime : takenTime // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdherenceStatus,mealNotes: freezed == mealNotes ? _self.mealNotes : mealNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
