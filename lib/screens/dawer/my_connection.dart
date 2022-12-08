import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/widget/chat/list.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:antizero_jumpin/widget/common/no_content.dart';
import 'package:antizero_jumpin/widget/common/search.dart';
import 'package:antizero_jumpin/widget/drawer/connection_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyConnectionPage extends StatefulWidget {
  const MyConnectionPage({Key key}) : super(key: key);

  @override
  _MyConnectionPageState createState() => _MyConnectionPageState();
}

class _MyConnectionPageState extends State<MyConnectionPage> {
  List<String> userIds = [];
  bool loading = true;
  TextEditingController searchController;

  @override
  void initState() {
    getConnection();
    searchController = TextEditingController();
    super.initState();
  }

  getConnection() async {
    List<String> uIds = getUserConnections(context);
    if (uIds != null) {
      userIds = uIds;
      print('userIds $userIds');
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }


  Future<void> searchList(String subcat) async
  {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    if(userProvider.malConnnections!=null)
      {
        print('Search userProvider.malConnnections ${userProvider.malConnnections}');
        List<JumpInUser> malUsers = userProvider.malConnnections;
        userProvider.resetConnectionSearch();
        for(int i=0;i<malUsers.length;i++)
          {
            JumpInUser user = malUsers[i];
            if(user.name == subcat)
              {
                userIds = [];
                print('Search userIds $userIds');
                userIds.add(user.id);
                setState(() {

                });
                print('Search userIds $userIds');
              }
          }
      }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print('build userIds ${userIds}');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        automaticImplyLeading: true,
        title: 'My Connections',
      ),
      body: loading == true
          ? fadedCircle(32, 32, color: Colors.blue[100])
          : userIds.isEmpty
              ? NoContentImage(
                  height: size.height,
                  width: size.width,
                  text: 'Oops... No connection',
                  refreshText: 'Click here to refresh',
                  onRefresh: () async {
                    setState(() {
                      loading = true;
                    });
                    await getConnection();
                  },
                )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SearchWidget(
                      searchcontroller: this.searchController,
                      onSubmitted: (String newSelection)
                      {
                        print('newSelection $newSelection');
                        searchList(newSelection);
                      }
                  ),
                  Expanded(
                    child: CustomList<String>(
                        crossCount: 3,
                        elements: userIds,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ConnectionCard(
                              id: userIds[index],
                            ),
                          );
                        }),
                  ),
                ],
              ),
    );
  }
}
