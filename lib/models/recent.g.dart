// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecentMsg _$RecentMsgFromJson(Map<String, dynamic> json) {
  return RecentMsg(
    recentMsg: json['recentMsg'] as String,
    sender: json['sender'] as String,
    time: DateTime.parse(json['time'] as String),
  );
}

Map<String, dynamic> _$RecentMsgToJson(RecentMsg instance) => <String, dynamic>{
      'recentMsg': instance.recentMsg,
      'sender': instance.sender,
      'time': instance.time.toIso8601String(),
    };
