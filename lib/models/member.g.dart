// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) {
  return Member(
    memId: json['memId'] as String,
    status: _$enumDecodeNullable(_$MemberStatusEnumMap, json['status']) ??
        MemberStatus.Requested,
    memName: json['memName'] as String
  );
}

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'memId': instance.memId,
      'status': _$MemberStatusEnumMap[instance.status],
      'memName': instance.memName
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

const _$MemberStatusEnumMap = {
  MemberStatus.Invited: 'Invited',
  MemberStatus.Accepted: 'Accepted',
  MemberStatus.Denied: 'Denied',
  MemberStatus.Requested: 'Requested',
};
