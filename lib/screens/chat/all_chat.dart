import 'dart:async';

import 'package:antizero_jumpin/handler/chat.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/common_methods.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/chat/chat_header.dart';
import 'package:antizero_jumpin/widget/chat/plan_chat_header.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:antizero_jumpin/widget/common/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

class AllChatPage extends StatefulWidget
{
  final StreamController userChatsController;
  final StreamController planChatsController;
  AllChatPage({this.userChatsController, this.planChatsController});

  @override
  _AllChatPageState createState() => _AllChatPageState();
}

class _AllChatPageState extends State<AllChatPage>
    with SingleTickerProviderStateMixin,WidgetsBindingObserver {
  TabController _tabController;
  bool isSearch;
  TextEditingController searchController;
  String companyName;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    isSearch = false;
    searchController = TextEditingController();
    companyName = getCompanyNameFromMode(context);
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'All Chats',
      screenClass: 'Chats',
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    print('didChangeAppLifecycleState');
  }

  @override
  void dispose() {
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: primaryGradient,
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            // trailing: IconButton(
            //   onPressed: () {
            //     showDialog(
            //         context: context,
            //         builder: (context) {
            //           return SearchWidget();
            //         });
            //   },
            //   icon: Icon(Icons.search,color: Colors.white,),
            // ),
            backgroundColor: Colors.transparent,
            title: 'Chat',
            automaticImplyLeading: true,
            labelColor: Colors.white,
            iconColor: Colors.white,
          ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3.h),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              // tab
              Container(
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.symmetric(horizontal: 4),
                  indicatorColor: blue,
                  labelColor: blue,
                  unselectedLabelStyle:
                      bodyStyle(context: context, size: 16, color: blue),
                  labelStyle:
                      bodyStyle(context: context, size: 16, color: blue),
                  physics: NeverScrollableScrollPhysics(),
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    // people tab
                    Tab(
                      text: 'People',
                    ),
                    // plan tab
                    Tab(
                      text: 'Plan',
                    )
                  ],
                ),
              ),
              // tab bar view
              Flexible(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    // people
                    peopleStream(),
                    // plan
                    planStream()
                  ],
                ),
              ),
            ],
          ),
        ))
    );
  }

  formatTime(DateTime fetchedDateTime) {
    DateTime currentDateTime = DateTime.now();
    if (fetchedDateTime != null &&
        currentDateTime.year == fetchedDateTime.year &&
        currentDateTime.month == fetchedDateTime.month &&
        currentDateTime.day - fetchedDateTime.day == 0) {
      return timeago.format(fetchedDateTime);
    } else {
      return Jiffy(fetchedDateTime ?? DateTime.now()).yMMMd;
    }
  }

  peopleStream() {
    return StreamBuilder(
      stream: widget.userChatsController.stream,
      builder: (context, snapshot) {
        List<FriendRequest> chatsList = [];
        if (snapshot.data != null) {
          snapshot.data.docs.forEach((element)
          {
            if(companyName.length>0)
            {
              if(FriendRequest.fromJson(element.data()).placeOfWork == companyName)
                {
                  chatsList.add(FriendRequest.fromJson(element.data()));
                }
            }
            else
              {
                chatsList.add(FriendRequest.fromJson(element.data()));
              }
          });
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index)
          {
            return ChatHeader(
              people: chatsList[index],
              timeFunc: formatTime,
            );
          },
          itemCount: chatsList.length,
        );
      },
    );
  }

  planStream()
  {
    return StreamBuilder(
      stream: widget.planChatsController.stream,
      builder: (context, snapshot) {
        List<Plan> acceptedPlans = [];
        if (snapshot.data != null) {
          snapshot.data.docs.forEach((element) {
            // if(companyName.length>0)
            // {
            //   print('StreamBuilder ${companyName}');
            //   if(Plan.fromJson(element.data()).companyName == companyName)
            //   {
            //     acceptedPlans.add(Plan.fromJson(element.data()));
            //   }
            // }
            // else
            //   {
            //    acceptedPlans.add(Plan.fromJson(7element.data()));
            //   }
            acceptedPlans.add(Plan.fromJson(element.data()));
          });
        }
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return PlanChatHeader(
              plan: acceptedPlans[index],
              timeFunc: formatTime,
            );
          },
          itemCount: acceptedPlans.length,
        );
      },
    );
  }
}
