import 'dart:convert';

import 'package:antizero_jumpin/models/member.dart';
import 'package:antizero_jumpin/models/recent.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plan.g.dart';

@JsonSerializable(explicitToJson: true)
class Plan {
  final String id;
  final String host;
  final String catName;
  final List<String> planImg;
  final String planName;
  final String planDisc;
  final bool public;
  final bool online;
  final bool multi;
  final bool age;
  final bool entryFree;
  final String location;
  final Map<String, dynamic> geoLocation;
  final String ageLimit;
  final String fees;
  final String spot;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime time;
  final RecentMsg recentMsg;
  final List<String> userIds;
  final List<Member> member;
  final DateTime createdAt;
  final String searchPname;
  @JsonKey(defaultValue: "")
  String companyName;
  Map<dynamic, dynamic> chatActivity;
  String placeOfWork;

  Plan(
      this.id,
      this.host,
      this.catName,
      this.planImg,
      this.planName,
      this.planDisc,
      this.public,
      this.online,
      this.multi,
      this.age,
      this.entryFree,
      this.location,
      this.geoLocation,
      this.ageLimit,
      this.fees,
      this.spot,
      this.startDate,
      this.endDate,
      this.time,
      this.userIds,
      this.member,
      this.recentMsg,
      this.createdAt,
      this.searchPname,
      this.chatActivity,this.companyName,this.placeOfWork);

  Plan.named(
      {this.id,
      this.host,
      this.catName,
      this.planName,
      this.planDisc,
      this.planImg,
      this.public,
      this.online,
      this.multi,
      this.age,
      this.entryFree,
      this.location,
      this.geoLocation,
      this.ageLimit,
      this.fees,
      this.spot,
      this.startDate,
      this.endDate,
      this.time,
      this.userIds,
      this.member,
      this.recentMsg,
      this.createdAt,
      this.searchPname,
      this.chatActivity,this.companyName,this.placeOfWork});

  Plan copyWith(
      {String id,
      String host,
      String catName,
      List<String> planImg,
      String planName,
      String planDisc,
      bool public,
      bool online,
      bool multi,
      bool age,
      bool entryFree,
      String location,
      Map<String, dynamic> geoLocation,
      String ageLimit,
      String fees,
      String spot,
      DateTime startDate,
      DateTime endDate,
      DateTime time,
      RecentMsg recentMsg,
      List<String> userIds,
      List<Member> member,
      DateTime createdAt,
      String searchPname,
      Map<dynamic, dynamic> chatActivity,bool isCompanyPlan,String companyName,String placeOfWork}) {
    return Plan.named(
      id: id ?? this.id,
      host: host ?? this.host,
      catName: catName ?? this.catName,
      planImg: planImg ?? this.planImg,
      planName: planName ?? this.planName,
      planDisc: planDisc ?? this.planDisc,
      public: public ?? this.public,
      online: online ?? this.online,
      multi: multi ?? this.multi,
      age: age ?? this.age,
      entryFree: entryFree ?? this.entryFree,
      location: location ?? this.location,
      geoLocation: geoLocation ?? this.geoLocation,
      ageLimit: ageLimit ?? this.ageLimit,
      fees: fees ?? this.fees,
      spot: spot ?? this.spot,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      time: time ?? this.time,
      recentMsg: recentMsg ?? this.recentMsg,
      userIds: userIds ?? this.userIds,
      member: member ?? this.member,
      createdAt: createdAt ?? this.createdAt,
      searchPname: searchPname ?? this.searchPname,
      chatActivity: chatActivity ?? this.chatActivity,
      companyName: companyName ?? this.companyName,
      placeOfWork: placeOfWork ?? this.placeOfWork
    );
  }

  Map<String, dynamic> toJson() => _$PlanToJson(this);

  factory Plan.fromJson(json) => _$PlanFromJson(json);
}
