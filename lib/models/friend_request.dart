import 'package:antizero_jumpin/models/recent.dart';
import 'package:json_annotation/json_annotation.dart';

part 'friend_request.g.dart';

enum FriendRequestStatus { Accepted, Denied, Requested }

// https://stackoverflow.com/questions/66044997/count-of-total-unread-messages
@JsonSerializable(explicitToJson: true)
class FriendRequest {
  final String id;
  final String requestedBy;
  final String requestedTo;
  final DateTime requestedTime;
  final List<String> userIds;
  @JsonKey(defaultValue: FriendRequestStatus.Requested)
  final FriendRequestStatus status;
  final RecentMsg recentMsg;
  final DateTime createdAt;
  @JsonKey(defaultValue: 0)
  int unseenMsgCount;
  // @JsonKey(defaultValue: 0)
  // int senderMsgCount;
  // @JsonKey(defaultValue: 0)
  // int requestedToMsgCount;
  String requestedByName;
  String requestedByImg;
  String requestedById;
  String senderName;
  String senderImg;
  String placeOfWork;
  String placeOfEdu;

  FriendRequest(
      this.id,
      this.requestedBy,
      this.requestedTo,
      this.requestedTime,
      this.userIds,
      this.status,
      this.recentMsg,
      this.createdAt,
      this.unseenMsgCount,
      // this.senderMsgCount,
      // this.requestedToMsgCount,
      this.requestedByName,
      this.requestedByImg,this.requestedById,this.senderName,this.senderImg,this.placeOfWork,this.placeOfEdu);

  FriendRequest.named({
    this.id,
    this.requestedBy,
    this.requestedTo,
    this.requestedTime,
    this.userIds,
    this.status,
    this.recentMsg,
    this.createdAt,
    this.unseenMsgCount,
    // this.senderMsgCount,
    // this.requestedToMsgCount,
    this.requestedByName,
    this.requestedByImg,
    this.requestedById,
    this.senderName,
    this.senderImg,
    this.placeOfWork,
    this.placeOfEdu
  });

  FriendRequest copyWith({
    String id,
    String requestedBy,
    String requestedTo,
    DateTime requestedTime,
    List<String> userIds,
    FriendRequestStatus status,
    RecentMsg recentMsg,
    DateTime createdAt,
    int unseenMsgCount,
    int senderMsgCount,
    int requestedToMsgCount,
    String requestedByName,
    String requestedByImg,
    String requestedById,
    String sendToName,
    String sendToImg,
    String placeOfWork,
    String placeOfEdu
  }) =>
      FriendRequest.named(
        id: id ?? this.id,
        requestedBy: requestedBy ?? this.requestedBy,
        requestedTo: requestedBy ?? this.requestedTo,
        requestedTime: requestedTime ?? this.requestedTime,
        userIds: userIds ?? this.userIds,
        status: status ?? this.status,
        recentMsg: recentMsg ?? this.recentMsg,
        createdAt: createdAt ?? this.createdAt,
        unseenMsgCount: unseenMsgCount ?? this.unseenMsgCount,
        // senderMsgCount: senderMsgCount ?? this.senderMsgCount,
        // requestedToMsgCount: requestedToMsgCount ?? this.requestedToMsgCount,
        requestedByName: requestedByName ?? this.requestedByName,
        requestedByImg: requestedByImg ?? this.requestedByImg,
        requestedById: requestedById ?? this.requestedById,
        senderName: sendToName ?? this.senderName,
        senderImg: sendToImg ?? this.senderImg,
        placeOfWork: placeOfWork ?? this.placeOfWork,
        placeOfEdu: placeOfEdu ?? this.placeOfEdu
      );

  Map<String, dynamic> toJson() => _$FriendRequestToJson(this);

  factory FriendRequest.fromJson(json) => _$FriendRequestFromJson(json);
}
