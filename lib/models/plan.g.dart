// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plan _$PlanFromJson(Map<String, dynamic> json) {
  return Plan(
    json['id'] as String,
    json['host'] as String,
    json['catName'] as String,
    (json['planImg'] as List<dynamic>).map((e) => e as String).toList(),
    json['planName'] as String,
    json['planDisc'] as String,
    json['public'] as bool,
    json['online'] as bool,
    json['multi'] as bool,
    json['age'] as bool,
    json['entryFree'] as bool,
    json['location'] as String,
    json['geoLocation'] as Map<String, dynamic>,
    json['ageLimit'] as String,
    json['fees'] as String,
    json['spot'] as String,
    DateTime.parse(json['startDate'] as String),
    DateTime.parse(json['endDate'] as String),
    DateTime.parse(json['time'] as String),
    (json['userIds'] as List<dynamic>).map((e) => e as String).toList(),
    (json['member'] as List<dynamic>)
        .map((e) => Member.fromJson(e as Map<String, dynamic>))
        .toList(),
    RecentMsg.fromJson(json['recentMsg'] as Map<String, dynamic>),
    DateTime.parse(json['createdAt'] as String),
    json['search_pname'] as String,
    json['chat_activity'] = Map<dynamic, dynamic>.from(json['chat_activity']),
    json['companyName'] as String,
    json['placeOfWork'] as String
  );
}

Map<String, dynamic> _$PlanToJson(Plan instance) => <String, dynamic>{
      'id': instance.id,
      'host': instance.host,
      'catName': instance.catName,
      'planImg': instance.planImg,
      'planName': instance.planName,
      'planDisc': instance.planDisc,
      'public': instance.public,
      'online': instance.online,
      'multi': instance.multi,
      'age': instance.age,
      'entryFree': instance.entryFree,
      'location': instance.location,
      'geoLocation': instance.geoLocation,
      'ageLimit': instance.ageLimit,
      'fees': instance.fees,
      'spot': instance.spot,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'time': instance.time.toIso8601String(),
      'recentMsg': instance.recentMsg.toJson(),
      'userIds': instance.userIds,
      'member': instance.member.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
      'search_pname': instance.searchPname,
      'chat_activity': instance.chatActivity,
      'companyName': instance.companyName,
      'placeOfWork': instance.placeOfWork
    };
