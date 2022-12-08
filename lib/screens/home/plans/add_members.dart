import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:flutter/material.dart';

class AddMemberPage extends StatefulWidget {
  final Function(List<JumpInUser> users) onSubmit;
  final Plan plan;

  const AddMemberPage({Key key, this.onSubmit, this.plan}) : super(key: key);

  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  bool loading = true;
  List<JumpInUser> users = [];
  List<JumpInUser> selectedUsers = [];
  TextEditingController controller = new TextEditingController();
  List<JumpInUser> _searchResult = [];

  @override
  void initState() {
    if (widget.plan == null) getConnections();
    if (widget.plan != null) getConnectionsNotInPlan();
    super.initState();
  }

  getConnections() async {
    List<String> ids = getUserConnections(context);
    if (ids != null) {
      List<JumpInUser> _users = await getUsers(ids);
      if (_users.isNotEmpty || _users != null) {
        users = _users;
      }
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  getConnectionsNotInPlan() async {
    print('getConnectionsNotInPlan');
    List<String> ids = [];
    List<String> connectionIds = getUserConnections(context);
    if (connectionIds != null) {
      for (int i = 0; i < connectionIds.length; i++) {
        if (widget.plan.member.contains(connectionIds[i]) == false) {
          ids.add(connectionIds[i]);
        }
      }
    }
    if (ids.isNotEmpty) {
      List<JumpInUser> _users = await getUsers(ids);
      if (_users.isNotEmpty || _users != null) {
        users = _users;
        for(int i=0;i<users.length;i++)
        {
          for(int j=0;j<widget.plan.member.length;j++)
          {
            if(users[i].id == widget.plan.member[j].memId)
            {
              selectedUsers.add(users[i]);
            }
          }
        }
      }
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        automaticImplyLeading: true,
        title: 'Select members',
        trailing: selectedUsers.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 5),
                child: TextButton.icon(
                    onPressed: () {
                      widget.onSubmit(selectedUsers);
                    },
                    icon: Icon(
                      Icons.add,
                      color: blue,
                    ),
                    label: Text(
                      'Add',
                      style: bodyStyle(context: context, size: 14, color: blue),
                    )),
              )
            : null,
      ),
      body: loading == true
          ? fadedCircle(32, 32, color: Colors.blue[100])
          : users.isEmpty
              ? Center(
                  child: Text(
                    widget.plan == null
                        ? 'Oops.... No connection made yet!'
                        : 'Oops.... No one to add!',
                    style: bodyStyle(
                        context: context, size: 18, color: Colors.black54),
                  ),
                )
              :
                  Column(
                    children: [
                      new Container(
                        color: Theme.of(context).primaryColor,
                        child: new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Card(
                            child: new ListTile(
                              leading: new Icon(Icons.search),
                              title: new TextField(
                                controller: controller,
                                decoration: new InputDecoration(
                                    hintText: 'Search', border: InputBorder.none),
                                onChanged: onSearchTextChanged,
                              ),
                              trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                                controller.clear();
                                onSearchTextChanged('');
                              },),
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                          child: _searchResult.length != 0 || controller.text.isNotEmpty
                              ?
                          new ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: _searchResult.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Card(
                                    color: selectedUsers.contains(users[index])
                                        ? Colors.blue[100]
                                        : Colors.grey[100],
                                    shadowColor: Colors.blueGrey.withOpacity(0.2),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 3),
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                        leading: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.blue[100],
                                          child: CircleAvatar(
                                            radius: 22,
                                            backgroundImage: _searchResult[index].photoList.last ==
                                                null
                                                ? AssetImage(avatarIcon)
                                                : NetworkImage(_searchResult[index].photoList.last),
                                          ),
                                        ),
                                        title: Text(
                                          _searchResult[index].name ?? '',
                                          style: bodyStyle(
                                              context: context,
                                              size: 18,
                                              color: selectedUsers.contains(_searchResult[index])
                                                  ? Colors.black
                                                  : Colors.black54),
                                        ),
                                        subtitle: Text(
                                          _searchResult[index].username == null
                                              ? ''
                                              : '@ ${_searchResult[index].username}',
                                          style: bodyStyle(
                                              context: context,
                                              size: 16,
                                              color: Colors.teal),
                                        ),
                                        trailing: selectedUsers.contains(_searchResult[index])
                                            ? Icon(
                                          Icons.done,
                                          size: 25,
                                          color: Colors.black,
                                        )
                                            : null,
                                        onTap: () {
                                          if (selectedUsers.contains(_searchResult[index])) {
                                            selectedUsers.remove(_searchResult[index]);
                                          } else {
                                            selectedUsers.add(_searchResult[index]);
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }) :
                          ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: users.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Card(
                                    color: selectedUsers.contains(users[index])
                                        ? Colors.blue[100]
                                        : Colors.grey[100],
                                    shadowColor: Colors.blueGrey.withOpacity(0.2),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 3),
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                        leading: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.blue[100],
                                          child: CircleAvatar(
                                            radius: 22,
                                            backgroundImage: users[index].photoList.last ==
                                                null
                                                ? AssetImage(avatarIcon)
                                                : NetworkImage(users[index].photoList.last),
                                          ),
                                        ),
                                        title: Text(
                                          users[index].name ?? '',
                                          style: bodyStyle(
                                              context: context,
                                              size: 18,
                                              color: selectedUsers.contains(users[index])
                                                  ? Colors.black
                                                  : Colors.black54),
                                        ),
                                        subtitle: Text(
                                          users[index].username == null
                                              ? ''
                                              : '@ ${users[index].username}',
                                          style: bodyStyle(
                                              context: context,
                                              size: 16,
                                              color: Colors.teal),
                                        ),
                                        trailing: selectedUsers.contains(users[index])
                                            ? Icon(
                                          Icons.done,
                                          size: 25,
                                          color: Colors.black,
                                        )
                                            : null,
                                        onTap: () {
                                          if (selectedUsers.contains(users[index])) {
                                            selectedUsers.remove(users[index]);
                                          } else {
                                            selectedUsers.add(users[index]);
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }),
                      )
                    ],
                  ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    users.forEach((userDetail) {
      if (userDetail.name.contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}