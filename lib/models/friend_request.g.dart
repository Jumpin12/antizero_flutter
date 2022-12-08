// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) {
  return FriendRequest(
    json['id'] as String,
    json['requestedBy'] as String,
    json['requestedTo'] as String,
    DateTime.parse(json['requestedTime'] as String),
    (json['userIds'] as List<dynamic>)?.map((e) => e as String)?.toList(),
    _$enumDecodeNullable(_$FriendRequestStatusEnumMap, json['status']) ??
        FriendRequestStatus.Requested,
    RecentMsg.fromJson(json['recentMsg'] as Map<String, dynamic>),
    DateTime.parse(json['createdAt'] as String),
    json['unseenMsgCount'] as int,
    // json['senderMsgCount'] as int,
    // json['requestedToMsgCount'] as int,
    json['requestedByName'] as String,
    json['requestedByImg'] as String,
    json['requestedById'] as String,
    json['senderName'] as String,
    json['senderImg'] as String,
    json['placeOfWork'] as String
  );
}

Map<String, dynamic> _$FriendRequestToJson(FriendRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestedBy': instance.requestedBy,
      'requestedTo': instance.requestedTo,
      'requestedTime': instance.requestedTime.toIso8601String(),
      'userIds': instance.userIds,
      'status': _$FriendRequestStatusEnumMap[instance.status],
      'recentMsg': instance.recentMsg.toJson(),
      'createdAt': instance.createdAt.toIso8601String(),
      'unseenMsgCount': instance.unseenMsgCount,
      // 'senderMsgCount': instance.senderMsgCount,
      // 'requestedToMsgCount': instance.requestedToMsgCount,
      'requestedByName': instance.requestedByName,
      'requestedByImg': instance.requestedByImg,
      'requestedById': instance.requestedById,
      'senderName': instance.senderName,
      'senderImg': instance.senderImg,
      'placeOfWork': instance.placeOfWork
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

const _$FriendRequestStatusEnumMap = {
  FriendRequestStatus.Accepted: 'Accepted',
  FriendRequestStatus.Denied: 'Denied',
  FriendRequestStatus.Requested: 'Requested',
};
