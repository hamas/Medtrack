// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get uid; String get name; int get currentStreak; int get longestStreak; List<Achievement> get earnedBadges; Map<String, double> get adherenceHistory; DateTime? get lastCheckoffDate; String? get equippedBadgeId; String? get phone; String? get bloodType; int? get age; double? get weight; double? get height; String? get email; String? get gender; String? get emergencyContact; String? get insuranceProvider; String? get primaryPhysician; List<String> get medicalConditions; List<String> get allergies;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&const DeepCollectionEquality().equals(other.earnedBadges, earnedBadges)&&const DeepCollectionEquality().equals(other.adherenceHistory, adherenceHistory)&&(identical(other.lastCheckoffDate, lastCheckoffDate) || other.lastCheckoffDate == lastCheckoffDate)&&(identical(other.equippedBadgeId, equippedBadgeId) || other.equippedBadgeId == equippedBadgeId)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.age, age) || other.age == age)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.height, height) || other.height == height)&&(identical(other.email, email) || other.email == email)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.emergencyContact, emergencyContact) || other.emergencyContact == emergencyContact)&&(identical(other.insuranceProvider, insuranceProvider) || other.insuranceProvider == insuranceProvider)&&(identical(other.primaryPhysician, primaryPhysician) || other.primaryPhysician == primaryPhysician)&&const DeepCollectionEquality().equals(other.medicalConditions, medicalConditions)&&const DeepCollectionEquality().equals(other.allergies, allergies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,uid,name,currentStreak,longestStreak,const DeepCollectionEquality().hash(earnedBadges),const DeepCollectionEquality().hash(adherenceHistory),lastCheckoffDate,equippedBadgeId,phone,bloodType,age,weight,height,email,gender,emergencyContact,insuranceProvider,primaryPhysician,const DeepCollectionEquality().hash(medicalConditions),const DeepCollectionEquality().hash(allergies)]);

@override
String toString() {
  return 'UserProfile(uid: $uid, name: $name, currentStreak: $currentStreak, longestStreak: $longestStreak, earnedBadges: $earnedBadges, adherenceHistory: $adherenceHistory, lastCheckoffDate: $lastCheckoffDate, equippedBadgeId: $equippedBadgeId, phone: $phone, bloodType: $bloodType, age: $age, weight: $weight, height: $height, email: $email, gender: $gender, emergencyContact: $emergencyContact, insuranceProvider: $insuranceProvider, primaryPhysician: $primaryPhysician, medicalConditions: $medicalConditions, allergies: $allergies)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String uid, String name, int currentStreak, int longestStreak, List<Achievement> earnedBadges, Map<String, double> adherenceHistory, DateTime? lastCheckoffDate, String? equippedBadgeId, String? phone, String? bloodType, int? age, double? weight, double? height, String? email, String? gender, String? emergencyContact, String? insuranceProvider, String? primaryPhysician, List<String> medicalConditions, List<String> allergies
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? name = null,Object? currentStreak = null,Object? longestStreak = null,Object? earnedBadges = null,Object? adherenceHistory = null,Object? lastCheckoffDate = freezed,Object? equippedBadgeId = freezed,Object? phone = freezed,Object? bloodType = freezed,Object? age = freezed,Object? weight = freezed,Object? height = freezed,Object? email = freezed,Object? gender = freezed,Object? emergencyContact = freezed,Object? insuranceProvider = freezed,Object? primaryPhysician = freezed,Object? medicalConditions = null,Object? allergies = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,earnedBadges: null == earnedBadges ? _self.earnedBadges : earnedBadges // ignore: cast_nullable_to_non_nullable
as List<Achievement>,adherenceHistory: null == adherenceHistory ? _self.adherenceHistory : adherenceHistory // ignore: cast_nullable_to_non_nullable
as Map<String, double>,lastCheckoffDate: freezed == lastCheckoffDate ? _self.lastCheckoffDate : lastCheckoffDate // ignore: cast_nullable_to_non_nullable
as DateTime?,equippedBadgeId: freezed == equippedBadgeId ? _self.equippedBadgeId : equippedBadgeId // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,bloodType: freezed == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,emergencyContact: freezed == emergencyContact ? _self.emergencyContact : emergencyContact // ignore: cast_nullable_to_non_nullable
as String?,insuranceProvider: freezed == insuranceProvider ? _self.insuranceProvider : insuranceProvider // ignore: cast_nullable_to_non_nullable
as String?,primaryPhysician: freezed == primaryPhysician ? _self.primaryPhysician : primaryPhysician // ignore: cast_nullable_to_non_nullable
as String?,medicalConditions: null == medicalConditions ? _self.medicalConditions : medicalConditions // ignore: cast_nullable_to_non_nullable
as List<String>,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String name,  int currentStreak,  int longestStreak,  List<Achievement> earnedBadges,  Map<String, double> adherenceHistory,  DateTime? lastCheckoffDate,  String? equippedBadgeId,  String? phone,  String? bloodType,  int? age,  double? weight,  double? height,  String? email,  String? gender,  String? emergencyContact,  String? insuranceProvider,  String? primaryPhysician,  List<String> medicalConditions,  List<String> allergies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.uid,_that.name,_that.currentStreak,_that.longestStreak,_that.earnedBadges,_that.adherenceHistory,_that.lastCheckoffDate,_that.equippedBadgeId,_that.phone,_that.bloodType,_that.age,_that.weight,_that.height,_that.email,_that.gender,_that.emergencyContact,_that.insuranceProvider,_that.primaryPhysician,_that.medicalConditions,_that.allergies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String name,  int currentStreak,  int longestStreak,  List<Achievement> earnedBadges,  Map<String, double> adherenceHistory,  DateTime? lastCheckoffDate,  String? equippedBadgeId,  String? phone,  String? bloodType,  int? age,  double? weight,  double? height,  String? email,  String? gender,  String? emergencyContact,  String? insuranceProvider,  String? primaryPhysician,  List<String> medicalConditions,  List<String> allergies)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.uid,_that.name,_that.currentStreak,_that.longestStreak,_that.earnedBadges,_that.adherenceHistory,_that.lastCheckoffDate,_that.equippedBadgeId,_that.phone,_that.bloodType,_that.age,_that.weight,_that.height,_that.email,_that.gender,_that.emergencyContact,_that.insuranceProvider,_that.primaryPhysician,_that.medicalConditions,_that.allergies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String name,  int currentStreak,  int longestStreak,  List<Achievement> earnedBadges,  Map<String, double> adherenceHistory,  DateTime? lastCheckoffDate,  String? equippedBadgeId,  String? phone,  String? bloodType,  int? age,  double? weight,  double? height,  String? email,  String? gender,  String? emergencyContact,  String? insuranceProvider,  String? primaryPhysician,  List<String> medicalConditions,  List<String> allergies)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.uid,_that.name,_that.currentStreak,_that.longestStreak,_that.earnedBadges,_that.adherenceHistory,_that.lastCheckoffDate,_that.equippedBadgeId,_that.phone,_that.bloodType,_that.age,_that.weight,_that.height,_that.email,_that.gender,_that.emergencyContact,_that.insuranceProvider,_that.primaryPhysician,_that.medicalConditions,_that.allergies);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({required this.uid, required this.name, this.currentStreak = 0, this.longestStreak = 0, final  List<Achievement> earnedBadges = const <Achievement>[], final  Map<String, double> adherenceHistory = const <String, double>{}, this.lastCheckoffDate, this.equippedBadgeId, this.phone, this.bloodType, this.age, this.weight, this.height, this.email, this.gender, this.emergencyContact, this.insuranceProvider, this.primaryPhysician, final  List<String> medicalConditions = const <String>[], final  List<String> allergies = const <String>[]}): _earnedBadges = earnedBadges,_adherenceHistory = adherenceHistory,_medicalConditions = medicalConditions,_allergies = allergies;
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String uid;
@override final  String name;
@override@JsonKey() final  int currentStreak;
@override@JsonKey() final  int longestStreak;
 final  List<Achievement> _earnedBadges;
@override@JsonKey() List<Achievement> get earnedBadges {
  if (_earnedBadges is EqualUnmodifiableListView) return _earnedBadges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_earnedBadges);
}

 final  Map<String, double> _adherenceHistory;
@override@JsonKey() Map<String, double> get adherenceHistory {
  if (_adherenceHistory is EqualUnmodifiableMapView) return _adherenceHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_adherenceHistory);
}

@override final  DateTime? lastCheckoffDate;
@override final  String? equippedBadgeId;
@override final  String? phone;
@override final  String? bloodType;
@override final  int? age;
@override final  double? weight;
@override final  double? height;
@override final  String? email;
@override final  String? gender;
@override final  String? emergencyContact;
@override final  String? insuranceProvider;
@override final  String? primaryPhysician;
 final  List<String> _medicalConditions;
@override@JsonKey() List<String> get medicalConditions {
  if (_medicalConditions is EqualUnmodifiableListView) return _medicalConditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_medicalConditions);
}

 final  List<String> _allergies;
@override@JsonKey() List<String> get allergies {
  if (_allergies is EqualUnmodifiableListView) return _allergies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergies);
}


/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&const DeepCollectionEquality().equals(other._earnedBadges, _earnedBadges)&&const DeepCollectionEquality().equals(other._adherenceHistory, _adherenceHistory)&&(identical(other.lastCheckoffDate, lastCheckoffDate) || other.lastCheckoffDate == lastCheckoffDate)&&(identical(other.equippedBadgeId, equippedBadgeId) || other.equippedBadgeId == equippedBadgeId)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.bloodType, bloodType) || other.bloodType == bloodType)&&(identical(other.age, age) || other.age == age)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.height, height) || other.height == height)&&(identical(other.email, email) || other.email == email)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.emergencyContact, emergencyContact) || other.emergencyContact == emergencyContact)&&(identical(other.insuranceProvider, insuranceProvider) || other.insuranceProvider == insuranceProvider)&&(identical(other.primaryPhysician, primaryPhysician) || other.primaryPhysician == primaryPhysician)&&const DeepCollectionEquality().equals(other._medicalConditions, _medicalConditions)&&const DeepCollectionEquality().equals(other._allergies, _allergies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,uid,name,currentStreak,longestStreak,const DeepCollectionEquality().hash(_earnedBadges),const DeepCollectionEquality().hash(_adherenceHistory),lastCheckoffDate,equippedBadgeId,phone,bloodType,age,weight,height,email,gender,emergencyContact,insuranceProvider,primaryPhysician,const DeepCollectionEquality().hash(_medicalConditions),const DeepCollectionEquality().hash(_allergies)]);

@override
String toString() {
  return 'UserProfile(uid: $uid, name: $name, currentStreak: $currentStreak, longestStreak: $longestStreak, earnedBadges: $earnedBadges, adherenceHistory: $adherenceHistory, lastCheckoffDate: $lastCheckoffDate, equippedBadgeId: $equippedBadgeId, phone: $phone, bloodType: $bloodType, age: $age, weight: $weight, height: $height, email: $email, gender: $gender, emergencyContact: $emergencyContact, insuranceProvider: $insuranceProvider, primaryPhysician: $primaryPhysician, medicalConditions: $medicalConditions, allergies: $allergies)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String uid, String name, int currentStreak, int longestStreak, List<Achievement> earnedBadges, Map<String, double> adherenceHistory, DateTime? lastCheckoffDate, String? equippedBadgeId, String? phone, String? bloodType, int? age, double? weight, double? height, String? email, String? gender, String? emergencyContact, String? insuranceProvider, String? primaryPhysician, List<String> medicalConditions, List<String> allergies
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? name = null,Object? currentStreak = null,Object? longestStreak = null,Object? earnedBadges = null,Object? adherenceHistory = null,Object? lastCheckoffDate = freezed,Object? equippedBadgeId = freezed,Object? phone = freezed,Object? bloodType = freezed,Object? age = freezed,Object? weight = freezed,Object? height = freezed,Object? email = freezed,Object? gender = freezed,Object? emergencyContact = freezed,Object? insuranceProvider = freezed,Object? primaryPhysician = freezed,Object? medicalConditions = null,Object? allergies = null,}) {
  return _then(_UserProfile(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,earnedBadges: null == earnedBadges ? _self._earnedBadges : earnedBadges // ignore: cast_nullable_to_non_nullable
as List<Achievement>,adherenceHistory: null == adherenceHistory ? _self._adherenceHistory : adherenceHistory // ignore: cast_nullable_to_non_nullable
as Map<String, double>,lastCheckoffDate: freezed == lastCheckoffDate ? _self.lastCheckoffDate : lastCheckoffDate // ignore: cast_nullable_to_non_nullable
as DateTime?,equippedBadgeId: freezed == equippedBadgeId ? _self.equippedBadgeId : equippedBadgeId // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,bloodType: freezed == bloodType ? _self.bloodType : bloodType // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,emergencyContact: freezed == emergencyContact ? _self.emergencyContact : emergencyContact // ignore: cast_nullable_to_non_nullable
as String?,insuranceProvider: freezed == insuranceProvider ? _self.insuranceProvider : insuranceProvider // ignore: cast_nullable_to_non_nullable
as String?,primaryPhysician: freezed == primaryPhysician ? _self.primaryPhysician : primaryPhysician // ignore: cast_nullable_to_non_nullable
as String?,medicalConditions: null == medicalConditions ? _self._medicalConditions : medicalConditions // ignore: cast_nullable_to_non_nullable
as List<String>,allergies: null == allergies ? _self._allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
