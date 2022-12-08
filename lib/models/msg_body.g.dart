// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsgBody _$MsgBodyFromJson(Map<String, dynamic> json) {
  return MsgBody(
    json['title'] as String,
    _$enumDecodeNullable(_$MsgBodyTypeEnumMap, json['type']) ??
        MsgBodyType.PeopleRequested,
    json['msg'] as String,
    json['userId'] as String,
    json['planId'] as String,
    json['isUnRead'] as bool,
  );
}

Map<String, dynamic> _$MsgBodyToJson(MsgBody instance) => <String, dynamic>{
      'title': instance.title,
      'type': _$MsgBodyTypeEnumMap[instance.type],
      'msg': instance.msg,
      'userId': instance.userId,
      'planId': instance.planId,
      'isUnRead': instance.isUnRead,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object source, {
  K unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$MsgBodyTypeEnumMap = {
  MsgBodyType.PeopleRequested: 'PeopleRequested',
  MsgBodyType.PeopleAccepted: 'PeopleAccepted',
  MsgBodyType.PlanAccepted: 'PlanAccepted',
  MsgBodyType.PlanInvited: 'PlanInvited',
};
