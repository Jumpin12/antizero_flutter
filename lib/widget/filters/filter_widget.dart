import 'package:antizero_jumpin/models/sub_category.dart';
import 'package:antizero_jumpin/provider/interest.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/authentication/interest.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/profile/interest_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FilterWidget extends StatefulWidget {
  final String title;

  const FilterWidget({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  // RangeValues _distRangeValues;
  RangeValues _ageRangeValues;
  // GenderFilter _selectedGender;
  bool _random = false;
  bool _isReset = false;
  List<SubCategory> _interestList;
  // List _distanceFilters;

  @override
  void initState() {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.filtersEnabled) {
      presetFilters(userProvider);
    } else {
      defaultFilters();
    }
    super.initState();
  }

  void presetFilters(UserProvider userProvider) {
    _ageRangeValues = userProvider.ageRangeValues;
    _random =
        (userProvider.getOrderFilter == OrderFilter.Random) ? true : false;
    _interestList = [];
    if (userProvider.getSelectedInterests!=null) {
      _interestList = userProvider.getpresetselectedInterests;
      List<String> malInterest = new List<String>();
      for (var i = 0; i < _interestList.length; i++) {
        malInterest.add(_interestList[i].name);
      }
      Provider.of<InterestProvider>(context, listen: false)
          .setSelectedSubCategories(malInterest, init: true);
    }
    setState(() {});
  }

  void defaultFilters() {
    // _distRangeValues = const RangeValues(0, 50);
    _ageRangeValues = const RangeValues(13, 60);
    // _selectedGender = GenderFilter.None;
    _interestList = [];
    Provider.of<InterestProvider>(context, listen: false)
        .setSelectedSubCategories([], init: true);
    // _distanceFilters = [
    //   {
    //     'value': 'People Within State',
    //     'type': LocationType.SearchWithinState,
    //     'isSelected': false
    //   },
    //   {
    //     'value': 'People Within Country',
    //     'type': LocationType.SearchWithinCountry,
    //     'isSelected': false
    //   },
    //   {
    //     'value': 'People Outside Country',
    //     'type': LocationType.SearchOutsideCountry,
    //     'isSelected': false
    //   }
    // ];
    _random = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
//    final interestProv = Provider.of<InterestProvider>(context, listen: false);
    InterestProvider interestProv = Provider.of<InterestProvider>(context);

    return Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.0361111, vertical: size.height * 0.02),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 0.7,
                    child: Text(
                      'Select from a wide range of filters',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              // SizedBox(
              //   width: size.width * 0.7,
              //   child: const Text(
              //     'Distance',
              //     style: TextStyle(
              //       color: Colors.black54,
              //       fontWeight: FontWeight.w500,
              //       fontSize: 17,
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   width: size.width * 0.7,
              //   child: RangeSlider(
              //     onChanged: (RangeValues values) {
              //       setState(() {
              //         _distRangeValues = values;
              //       });
              //     },
              //     min: 0,
              //     max: 50,
              //     divisions: 10,
              //     values: _distRangeValues,
              //     labels: RangeLabels(
              //       _distRangeValues.start.round().toString(),
              //       _distRangeValues.end.round().toString(),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: size.width * 0.018,
              // ),
              SizedBox(
                width: size.width * 0.7,
                child: const Text(
                  'Age (in years)',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.7,
                child: RangeSlider(
                  onChanged: (RangeValues values) {
                    setState(() {
                      _ageRangeValues = values;
                    });
                  },
                  min: 13,
                  max: 60,
                  divisions: 15,
                  values: _ageRangeValues,
                  labels: RangeLabels(
                    _ageRangeValues.start.round().toString(),
                    _ageRangeValues.end.round().toString(),
                  ),
                ),
              ),
              SizedBox(
                height: size.width * 0.018,
              ),
              // SizedBox(
              //   width: size.width * 0.7,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       const Text(
              //         'Gender',
              //         style: TextStyle(
              //           color: Colors.black54,
              //           fontWeight: FontWeight.w500,
              //           fontSize: 17,
              //         ),
              //       ),
              //       const Spacer(),
              //       InkWell(
              //         onTap: () {
              //           setState(() {
              //             _selectedGender = GenderFilter.Male;
              //           });
              //         },
              //         borderRadius: BorderRadius.circular(100000000),
              //         child: Ink(
              //           height: size.width * 0.0833,
              //           width: size.width * 0.0833,
              //           decoration: BoxDecoration(
              //             color: _selectedGender == GenderFilter.Male
              //                 ? Colors.blue
              //                 : Colors.transparent,
              //             shape: BoxShape.circle,
              //             border: Border.all(
              //               color: _selectedGender == GenderFilter.Male
              //                   ? Colors.white
              //                   : Colors.black,
              //             ),
              //           ),
              //           child: Center(
              //             child: ImageIcon(
              //               AssetImage("assets/icon/male.png"),
              //               color: _selectedGender == GenderFilter.Male
              //                   ? Colors.white
              //                   : Colors.black,
              //               size: 18,
              //             ),
              //           ),
              //         ),
              //       ),
              //       SizedBox(width: size.width * 0.0125),
              //       InkWell(
              //         onTap: () {
              //           setState(() {
              //             _selectedGender = GenderFilter.Female;
              //           });
              //         },
              //         borderRadius: BorderRadius.circular(100000000),
              //         child: Ink(
              //           height: size.width * 0.0833,
              //           width: size.width * 0.0833,
              //           decoration: BoxDecoration(
              //             color: _selectedGender == GenderFilter.Female
              //                 ? Colors.blue[400]
              //                 : Colors.transparent,
              //             shape: BoxShape.circle,
              //             border: Border.all(
              //               color: _selectedGender == GenderFilter.Female
              //                   ? Colors.blue[400]
              //                   : Colors.black,
              //             ),
              //           ),
              //           child: Center(
              //             child: ImageIcon(
              //               AssetImage("assets/icon/female.png"),
              //               color: _selectedGender == GenderFilter.Female
              //                   ? Colors.white
              //                   : Colors.black,
              //               size: 18,
              //             ),
              //           ),
              //         ),
              //       ),
              //       SizedBox(width: size.width * 0.0125),
              //       InkWell(
              //         onTap: () {
              //           setState(() {
              //             _selectedGender = GenderFilter.Others;
              //           });
              //         },
              //         borderRadius: BorderRadius.circular(100000000),
              //         child: Ink(
              //           height: size.width * 0.0833,
              //           width: size.width * 0.0833,
              //           decoration: BoxDecoration(
              //             color: _selectedGender == GenderFilter.Others
              //                 ? Colors.blue[400]
              //                 : Colors.transparent,
              //             shape: BoxShape.circle,
              //             border: Border.all(
              //               color: _selectedGender == GenderFilter.Others
              //                   ? Colors.white
              //                   : Colors.black,
              //             ),
              //           ),
              //           child: Center(
              //               child: ImageIcon(
              //             AssetImage("assets/icon/transgender.png"),
              //             color: _selectedGender == GenderFilter.Others
              //                 ? Colors.white
              //                 : Colors.black,
              //             size: 18,
              //           )),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: size.width * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Interests',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        _interestList =
                        await Navigator.of(context)
                            .push<List<SubCategory>>(
                            PageTransition(
                                child: InterestPage(fromFilter: true),
                                type: PageTransitionType.fade));
                        if (!(_interestList.isEmpty)) {
                          userProvider.setPresetSelectedInterets(_interestList);
                          List<String> malInterest = new List<String>();
                          for (var i = 0; i < _interestList.length; i++) {
                            malInterest.add(_interestList[i].name);
                          }
                          interestProv.setSelectedSubCategories(malInterest);
                        }
                        setState(() {});
                      },
                      child: Text(
                        'Select Interests',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.width * 0.018,
              ),
              Container(
                height: size.height * 0.128,
                width: MediaQuery.of(context).size.width,
                child: _interestList.isEmpty
                    ? Center(
                        child: Text(
                          'No interests selected',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _interestList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: InterestCard(
                              url: _interestList[index].img,
                              title: _interestList[index].name,
                              size: MediaQuery.of(context).size.height * 0.04,
                            ),
                          );
                        }),
              ),
              // SizedBox(
              //   width: size.width * 0.7,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       const Text(
              //         'Random',
              //         style: TextStyle(
              //           color: Colors.black54,
              //           fontWeight: FontWeight.w500,
              //           fontSize: 17,
              //         ),
              //       ),
              //       const Spacer(),
              //       CupertinoSwitch(
              //         value: _random,
              //         onChanged: (value) {
              //           setState(() {
              //             _random = value;
              //           });
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: size.width * 0.0312),
              SizedBox(
                width: size.width * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _isReset = true;
                        defaultFilters();
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.red,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        print(_isReset);
                        // if (_isReset) {
                        //   userProvider.setFiltersEnabled(false);
                        //   userProvider.fetchUsers(context);
                        //   Navigator.of(context).pop();
                        // } else {
                        //   userProvider.setAgeRangeValues(_ageRangeValues);
                        //   // userProvider.setDistanceRangeValues(_distRangeValues);
                        //   // userProvider.setGenderFilter(_selectedGender);
                        //   // userProvider.setOrderFilter(
                        //   //     _random ? OrderFilter.Random : OrderFilter.Ordered);
                        //   userProvider.setSelectedInterets(
                        //       interestProv.selectedSubCategories);
                        //   // userProvider.setDistanceFilter(_distanceFilters);
                        //   userProvider.setFiltersEnabled(true);
                        //   userProvider.setDefaults();
                        //   userProvider.fetchFilteredUsers(context);
                          Navigator.of(context).pop();
                        // }
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
