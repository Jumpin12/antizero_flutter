import 'package:antizero_jumpin/handler/bookmark.dart';
import 'package:antizero_jumpin/provider/bookmark.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/widget/chat/list.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:antizero_jumpin/widget/common/no_content.dart';
import 'package:antizero_jumpin/widget/common/search.dart';
import 'package:antizero_jumpin/widget/drawer/connection_card.dart';
import 'package:antizero_jumpin/widget/drawer/plan_card.dart';
import 'package:antizero_jumpin/widget/home/tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({Key key}) : super(key: key);

  @override
  _BookMarkPageState createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool loading = true;

  @override
  void initState() {
    getBookMark();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  getBookMark() async {
    bool bMSet = await getUserBookMark(context);
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    var bookMarkProvider = Provider.of<BookMarkProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        // trailing: IconButton(
        //   onPressed: () {
        //     showDialog(
        //         context: context,
        //         builder: (context) {
        //           return SearchWidget();
        //         });
        //   },
        //   icon: Icon(Icons.search,color: Colors.black,),
        // ),
        automaticImplyLeading: true,
        title: 'Bookmarks',
      ),
      body: loading
          ? fadedCircle(32, 32, color: shade1)
          : bookMarkProvider.bookMark == null
              ? NoContentImage(
                  text: 'No book mark available!',
                  refreshText: 'Click here to refresh',
                  onRefresh: () async {
                    setState(() {
                      loading = true;
                    });
                    await getBookMark();
                  },
                )
              : Column(
                  children: [
                    Container(
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelPadding: EdgeInsets.symmetric(horizontal: 4),
                        indicatorColor: blue,
                        labelColor: blue,
                        physics: NeverScrollableScrollPhysics(),
                        unselectedLabelColor: Colors.grey,
                        onTap: (int index) {
                          setState(() {
                            index = _tabController.index;
                          });
                        },
                        tabs: [
                          // people tab
                          CustomTab(
                            active: _tabController.index == 0,
                            label: 'People',
                          ),

                          // plan tab
                          CustomTab(
                            active: _tabController.index == 1,
                            label: 'Plan',
                          ),
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
                          bookMarkProvider.bookMark.peopleMark != null
                              ? CustomList<String>(
                                  crossCount: 3,
                                  elements: bookMarkProvider.bookMark.peopleMark,
                                  padding: EdgeInsets.only(top: 10),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: ConnectionCard(
                                        id: bookMarkProvider
                                            .bookMark.peopleMark[index],
                                      ),
                                    );
                                  })
                              : NoContentImage(
                                  text: 'No bookmark available!',
                                ),

                          // plan
                          bookMarkProvider.bookMark.planMark != null
                              ? CustomList<String>(
                                  crossCount: 3,
                                  elements: bookMarkProvider.bookMark.planMark,
                                  padding: EdgeInsets.only(top: 10),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: PlanCard(
                                        id: bookMarkProvider
                                            .bookMark.planMark[index],
                                      ),
                                    );
                                  })
                              : NoContentImage(
                                  text: 'No bookmark available!',
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
