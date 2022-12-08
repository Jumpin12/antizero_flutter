import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

enum MemberStatus { Invited, Accepted, Denied, Requested }

@JsonSerializable(explicitToJson: true)
class Member {
  String memId;
  @JsonKey(defaultValue: MemberStatus.Requested)
  final MemberStatus status;
  String memName;

  Member({
    this.memId,
    this.status,
    this.memName
  });

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  Map<dynamic, dynamic> toJson() => _$MemberToJson(this);
}
