// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dose.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Dose {

 String get id; Medicine get medicine; DateTime get scheduledTime; bool get isTaken; DateTime? get takenTime;
/// Create a copy of Dose
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoseCopyWith<Dose> get copyWith => _$DoseCopyWithImpl<Dose>(this as Dose, _$identity);

  /// Serializes this Dose to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Dose&&(identical(other.id, id) || other.id == id)&&(identical(other.medicine, medicine) || other.medicine == medicine)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.isTaken, isTaken) || other.isTaken == isTaken)&&(identical(other.takenTime, takenTime) || other.takenTime == takenTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicine,scheduledTime,isTaken,takenTime);

@override
String toString() {
  return 'Dose(id: $id, medicine: $medicine, scheduledTime: $scheduledTime, isTaken: $isTaken, takenTime: $takenTime)';
}


}

/// @nodoc
abstract mixin class $DoseCopyWith<$Res>  {
  factory $DoseCopyWith(Dose value, $Res Function(Dose) _then) = _$DoseCopyWithImpl;
@useResult
$Res call({
 String id, Medicine medicine, DateTime scheduledTime, bool isTaken, DateTime? takenTime
});


$MedicineCopyWith<$Res> get medicine;

}
/// @nodoc
class _$DoseCopyWithImpl<$Res>
    implements $DoseCopyWith<$Res> {
  _$DoseCopyWithImpl(this._self, this._then);

  final Dose _self;
  final $Res Function(Dose) _then;

/// Create a copy of Dose
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? medicine = null,Object? scheduledTime = null,Object? isTaken = null,Object? takenTime = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicine: null == medicine ? _self.medicine : medicine // ignore: cast_nullable_to_non_nullable
as Medicine,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as DateTime,isTaken: null == isTaken ? _self.isTaken : isTaken // ignore: cast_nullable_to_non_nullable
as bool,takenTime: freezed == takenTime ? _self.takenTime : takenTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Dose
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicineCopyWith<$Res> get medicine {
  
  return $MedicineCopyWith<$Res>(_self.medicine, (value) {
    return _then(_self.copyWith(medicine: value));
  });
}
}


/// Adds pattern-matching-related methods to [Dose].
extension DosePatterns on Dose {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Dose value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Dose() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Dose value)  $default,){
final _that = this;
switch (_that) {
case _Dose():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Dose value)?  $default,){
final _that = this;
switch (_that) {
case _Dose() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Medicine medicine,  DateTime scheduledTime,  bool isTaken,  DateTime? takenTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Dose() when $default != null:
return $default(_that.id,_that.medicine,_that.scheduledTime,_that.isTaken,_that.takenTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Medicine medicine,  DateTime scheduledTime,  bool isTaken,  DateTime? takenTime)  $default,) {final _that = this;
switch (_that) {
case _Dose():
return $default(_that.id,_that.medicine,_that.scheduledTime,_that.isTaken,_that.takenTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Medicine medicine,  DateTime scheduledTime,  bool isTaken,  DateTime? takenTime)?  $default,) {final _that = this;
switch (_that) {
case _Dose() when $default != null:
return $default(_that.id,_that.medicine,_that.scheduledTime,_that.isTaken,_that.takenTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Dose implements Dose {
  const _Dose({required this.id, required this.medicine, required this.scheduledTime, this.isTaken = false, this.takenTime});
  factory _Dose.fromJson(Map<String, dynamic> json) => _$DoseFromJson(json);

@override final  String id;
@override final  Medicine medicine;
@override final  DateTime scheduledTime;
@override@JsonKey() final  bool isTaken;
@override final  DateTime? takenTime;

/// Create a copy of Dose
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DoseCopyWith<_Dose> get copyWith => __$DoseCopyWithImpl<_Dose>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Dose&&(identical(other.id, id) || other.id == id)&&(identical(other.medicine, medicine) || other.medicine == medicine)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.isTaken, isTaken) || other.isTaken == isTaken)&&(identical(other.takenTime, takenTime) || other.takenTime == takenTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicine,scheduledTime,isTaken,takenTime);

@override
String toString() {
  return 'Dose(id: $id, medicine: $medicine, scheduledTime: $scheduledTime, isTaken: $isTaken, takenTime: $takenTime)';
}


}

/// @nodoc
abstract mixin class _$DoseCopyWith<$Res> implements $DoseCopyWith<$Res> {
  factory _$DoseCopyWith(_Dose value, $Res Function(_Dose) _then) = __$DoseCopyWithImpl;
@override @useResult
$Res call({
 String id, Medicine medicine, DateTime scheduledTime, bool isTaken, DateTime? takenTime
});


@override $MedicineCopyWith<$Res> get medicine;

}
/// @nodoc
class __$DoseCopyWithImpl<$Res>
    implements _$DoseCopyWith<$Res> {
  __$DoseCopyWithImpl(this._self, this._then);

  final _Dose _self;
  final $Res Function(_Dose) _then;

/// Create a copy of Dose
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? medicine = null,Object? scheduledTime = null,Object? isTaken = null,Object? takenTime = freezed,}) {
  return _then(_Dose(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicine: null == medicine ? _self.medicine : medicine // ignore: cast_nullable_to_non_nullable
as Medicine,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as DateTime,isTaken: null == isTaken ? _self.isTaken : isTaken // ignore: cast_nullable_to_non_nullable
as bool,takenTime: freezed == takenTime ? _self.takenTime : takenTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Dose
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicineCopyWith<$Res> get medicine {
  
  return $MedicineCopyWith<$Res>(_self.medicine, (value) {
    return _then(_self.copyWith(medicine: value));
  });
}
}

// dart format on
