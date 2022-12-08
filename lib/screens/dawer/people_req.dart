import 'package:antizero_jumpin/handler/chat.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/friend_request.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/screens/home/jumpInuser_profile.dart';
import 'package:antizero_jumpin/services/chat.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/common_methods.dart';
import 'package:antizero_jumpin/utils/decoration.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:antizero_jumpin/widget/common/no_content.dart';
import 'package:antizero_jumpin/widget/common/search.dart';
import 'package:antizero_jumpin/widget/notification/container_list.dart';
import 'package:antizero_jumpin/widget/notification/req_card.dart';
import 'package:flutter/material.dart';

class PeopleRequestPage extends StatefulWidget {
  const PeopleRequestPage({Key key}) : super(key: key);

  @override
  _PeopleRequestPageState createState() => _PeopleRequestPageState();
}

class _PeopleRequestPageState extends State<PeopleRequestPage> {
  List<FriendRequest> friendReq = [];
  bool loading = true;
  TextEditingController searchController;

  @override
  void initState() {
    getPeopleRequest();
    searchController = TextEditingController();
    super.initState();
  }


  getPeopleRequest() async {
    List<FriendRequest> _friendRequests = await getUserPeopleReq();
    if (_friendRequests != null) {
      friendReq = _friendRequests;
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  Future<void> searchList(String name) async
  {
    print('searchList $name');
    List<FriendRequest> _friendRequests = await getUserPeopleReqBySearch(name);
    if (_friendRequests != null) {
      friendReq = _friendRequests;
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        automaticImplyLeading: true,
        title: 'People Requests',
      ),
      body: loading
          ? fadedCircle(32, 32, color: Colors.blue[100])
          : friendReq.isEmpty
              ? NoContentImage(
                  text: 'No pending request for you!',
                  refreshText: 'Click here to refresh',
                  onRefresh: () async {
                    setState(() {
                      loading = true;
                    });
                    await getPeopleRequest();
                  },
                )
              : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SearchWidget(
                        searchcontroller: this.searchController,
                        onSubmitted: (String newSelection)
                        {
                          print('newSelection ${newSelection.length}');
                          if(newSelection.length>0)
                          {
                            searchList(newSelection);
                          }
                          else
                          {
                            setState(() {
                              loading = true;
                            });
                            getPeopleRequest();
                            setState(()
                            {

                            });
                          }
                        }
                    ),
                    ContainerListView(
                        gradient: gradient3,
                        heading: false,
                        count: friendReq.length,
                        builder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              JumpInUser user = await locator
                                  .get<UserService>()
                                  .getUserById(friendReq[index].requestedBy);
                              navKey.currentState.push(
                                MaterialPageRoute(
                                  builder: (context) => JumpInUserPage(
                                    user: user,
                                    withoutProvider: true,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: RequestCard(
                                date: formatTime(friendReq[index].createdAt),
                                userId: friendReq[index].requestedBy,
                                onAccept: () async {
                                  bool accept = await locator
                                      .get<ChatService>()
                                      .acceptRequest(friendReq[index]);
                                  if (accept) {
                                    bool connected = await locator
                                        .get<ChatService>()
                                        .createConnection(
                                            friendReq[index].requestedBy,
                                            friendReq[index].requestedTo);
                                    if (connected) {
                                      friendReq.remove(friendReq[index]);
                                      setState(() {});
                                    }
                                  }
                                },
                                onDeny: () async {
                                  bool deny = await locator
                                      .get<ChatService>()
                                      .denyRequest(friendReq[index]);
                                  if (deny) {
                                    friendReq.remove(friendReq[index]);
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
    );
  }
}
