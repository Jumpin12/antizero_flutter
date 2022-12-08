import 'package:json_annotation/json_annotation.dart';

part 'msg_body.g.dart';

enum MsgBodyType {
  PeopleRequested,
  PeopleAccepted,
  PlanAccepted,
  PlanInvited,
  NewPeopleChat,
  NewPlanChat
}

@JsonSerializable(explicitToJson: true)
class MsgBody {
  final String title;
  @JsonKey(defaultValue: MsgBodyType.PeopleRequested)
  final MsgBodyType type;
  final String msg;
  final String userId;
  final String planId;
  final bool isUnRead;

  MsgBody(
      this.title, this.type, this.msg, this.userId, this.planId, this.isUnRead);

  MsgBody.named(
      {this.title,
      this.type,
      this.msg,
      this.userId,
      this.planId,
      this.isUnRead});

  Map<String, dynamic> toJson() => _$MsgBodyToJson(this);

  factory MsgBody.fromJson(json) => _$MsgBodyFromJson(json);
}
