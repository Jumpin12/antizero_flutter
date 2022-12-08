import 'package:antizero_jumpin/models/msg_body.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

enum NotificationType { People, Plan }

@JsonSerializable(explicitToJson: true)
class UserNotification {
  final String id;
  final String title;
  @JsonKey(defaultValue: NotificationType.People)
  final NotificationType type;
  final String description;
  final DateTime createdAt;
  final MsgBody msgBody;
  final bool isUnRead;

  UserNotification(this.id, this.title, this.type, this.description,
      this.createdAt, this.msgBody, this.isUnRead);

  UserNotification.named(
      {this.id,
      this.title,
      this.type,
      this.description,
      this.createdAt,
      this.msgBody,
      this.isUnRead});

  Map<String, dynamic> toJson() => _$UserNotificationToJson(this);

  factory UserNotification.fromJson(json) => _$UserNotificationFromJson(json);
}
