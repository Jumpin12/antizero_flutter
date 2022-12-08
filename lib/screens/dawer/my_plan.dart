import 'dart:typed_data';
import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/screens/home/plans/current_plan.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:antizero_jumpin/widget/common/search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MyPlanPage extends StatefulWidget {
  const MyPlanPage({Key key}) : super(key: key);

  @override
  _MyPlanPageState createState() => _MyPlanPageState();
}

class _MyPlanPageState extends State<MyPlanPage> {
  List<Plan> plans = [];
  bool loading = true;
  bool saving = false;
  TextEditingController searchController;

  @override
  void initState() {
    getPlans();
    searchController = TextEditingController();
    super.initState();
  }

  Future<void> searchList(String name) async
  {
    List<Plan> _plans = await getAcceptedPlanForCurrentUserSearch(context,name);
    if (_plans != null) {
      plans = _plans;
      print('searchList plans ${plans}');
    }
    setState(() {

    });
  }

  getPlans() async {
    List<Plan> _plans = await getAcceptedPlanForCurrentUser(context);
    print('_plans $_plans');
    if (_plans != null) {
      plans = _plans;
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var planProvider = Provider.of<PlanProvider>(context);
    // var userProvider = Provider.of<UserProvider>(context);
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        automaticImplyLeading: true,
        title: 'My Plans',
      ),
      body: loading == true
          ? fadedCircle(32, 32, color: Colors.blue[100])
          : plans.isEmpty
              ? Container()
              : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
                            getPlans();
                            setState(()
                            {

                            });
                          }
                      },
                  ),
                  Expanded(
                    child: RefreshIndicator(
                        onRefresh: () async {
                          setState(() {
                            loading = true;
                          });
                          await getPlans();
                        },
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Container(
                            height: size.height - (size.height / 4),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: GridView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: false,
                                itemCount: plans.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  int acceptedMemLength =
                                      getAcceptedMemberLength(plans[index].member);
                                  int totalSpot = int.parse(plans[index].spot);
                                  int spotRem = 0;
                                  if (totalSpot > acceptedMemLength)
                                    spotRem = totalSpot - acceptedMemLength;
                                  String spotLeft =
                                      '${spotRem.toString()} / ${totalSpot.toString()}';

                                  GlobalKey keyK;
                                  Uint8List bytes;

                                  return InkWell(
                                    borderRadius: BorderRadius.circular(1000),
                                    onTap: () {
                                      planProvider.currentPlan = plans[index];
                                      Navigator.of(context).push(PageTransition(
                                          child: CurrentPlanPage(
                                            hostId: plans[index].host,
                                            isFromMyPlan: true
                                          ),
                                          type: PageTransitionType.fade));
                                    },
                                    child: Ink(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: blue,
                                      ),
                                      child: SizedBox.expand(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              plans[index].planName,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Opacity(
                                              opacity: 0.8,
                                              child: Text(
                                                formatter
                                                    .format(plans[index].startDate),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                  ),
                ],
              ),
    );
  }
}
