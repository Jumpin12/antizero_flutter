// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_msg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMsg _$ChatMsgFromJson(Map<String, dynamic> json) {
  return ChatMsg(
    id: json['id'] as String,
    message: json['message'] as String,
    senderId: json['senderId'] as String,
    senderName: json['senderName'] as String,
    senderPhoto: json['senderPhoto'] as String,
    imgMsg: json['imgMsg'] as String,
    time: DateTime.parse(json['time'] as String),
    read: json['read'] as bool
  );
}

Map<String, dynamic> _$ChatMsgToJson(ChatMsg instance) => <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderPhoto': instance.senderPhoto,
      'imgMsg': instance.imgMsg,
      'time': instance.time.toIso8601String(),
      'read': instance.read
    };
