// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserNotification _$UserNotificationFromJson(Map<String, dynamic> json) {
  return UserNotification(
    json['id'] as String,
    json['title'] as String,
    _$enumDecodeNullable(_$NotificationTypeEnumMap, json['type']) ??
        NotificationType.People,
    json['description'] as String,
    DateTime.parse(json['createdAt'] as String),
    MsgBody.fromJson(json['msgBody']),
    json['isUnRead'] as bool,
  );
}

Map<String, dynamic> _$UserNotificationToJson(UserNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': _$NotificationTypeEnumMap[instance.type],
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'msgBody': instance.msgBody.toJson(),
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

const _$NotificationTypeEnumMap = {
  NotificationType.People: 'People',
  NotificationType.Plan: 'Plan',
};
