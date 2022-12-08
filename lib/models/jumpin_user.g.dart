// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jumpin_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JumpInUser _$JumpInUserFromJson(Map<String, dynamic> json) {
  return JumpInUser(
    id: json['id'] as String,
    name: json['name'] as String,
    gender: json['gender'] as String,
    username: json['username'] as String,
    dob: DateTime.parse(json['dob'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
    profession: json['profession'] as String,
    placeOfWork: json['placeOfWork'] as String,
    placeOfEdu: json['placeOfEdu'] as String,
    academicCourse: json['academicCourse'] as String,
    bio: json['bio'] as String,
    email: json['email'] as String,
    inJumpInFor: json['inJumpInFor'] as String,
    geoPoint: json['geoPoint'] as Map<String, dynamic>,
    interestList: (json['interestList'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    photoList:
        (json['photoList'] as List<dynamic>).map((e) => e as String).toList(),
    audio: json['audio'] as String,
    contacts: (json['contacts'] as List<dynamic>)
        .map((e) => UserContact.fromJson(e as Map<String, dynamic>))
        .toList(),
    connection: (json['connection'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    plans: (json['plans'] as List<dynamic>).map((e) => e as String).toList(),
    phoneNo: json['phoneNo'] as String,
    searchUname: json['search_uname'] as String,
    favourites: json['favourites'] as Map<String, dynamic>,
    unseenTotalCount: json['unseen_total_count'] as int,
    isOnline: json['isOnline'] as bool,
    geohash: json['geohash'] as String,
    location: json['location'] as Map<String, dynamic>,
    mode: json['mode'] as int,
    deactivate: json['deactivate'] as int
  );
}

Map<String, dynamic> _$JumpInUserToJson(JumpInUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gender': instance.gender,
      'username': instance.username,
      'dob': instance.dob.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'profession': instance.profession,
      'placeOfWork': instance.placeOfWork,
      'placeOfEdu': instance.placeOfEdu,
      'academicCourse': instance.academicCourse,
      'bio': instance.bio,
      'email': instance.email,
      'inJumpInFor': instance.inJumpInFor,
      'geoPoint': instance.geoPoint,
      'interestList': instance.interestList,
      'photoList': instance.photoList,
      'audio': instance.audio,
      'contacts': instance.contacts.map((e) => e.toJson()).toList(),
      'connection': instance.connection,
      'plans': instance.plans,
      'phoneNo': instance.phoneNo,
      'search_uname': instance.searchUname,
      'unseen_total_count': instance.unseenTotalCount,
      'isOnline': instance.isOnline,
      'favourites': instance.favourites,
      'geohash': instance.geohash,
      'location': instance.location,
      'mode': instance.mode,
      'deactivate': instance.deactivate
    };
