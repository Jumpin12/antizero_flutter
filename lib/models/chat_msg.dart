import 'package:json_annotation/json_annotation.dart';

part 'chat_msg.g.dart';

@JsonSerializable()
class ChatMsg {
  String id;
  String message;
  String senderId;
  @JsonKey(defaultValue: '')
  String senderName;
  @JsonKey(defaultValue: '')
  String senderPhoto;
  String imgMsg;
  DateTime time;
  bool read;

  ChatMsg({this.id, this.message, this.senderId,this.senderName,this.senderPhoto, this.imgMsg, this.time, this.read});

  factory ChatMsg.fromJson(Map<String, dynamic> json) =>
      _$ChatMsgFromJson(json);

  Map<dynamic, dynamic> toJson() => _$ChatMsgToJson(this);
}
