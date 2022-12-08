import 'dart:io';

import 'package:antizero_jumpin/handler/date_time.dart';
import 'package:antizero_jumpin/handler/img_dialog.dart';
import 'package:antizero_jumpin/handler/notification.dart';
import 'package:antizero_jumpin/handler/plan.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/models/member.dart';
import 'package:antizero_jumpin/models/plan.dart';
import 'package:antizero_jumpin/models/recent.dart';
import 'package:antizero_jumpin/provider/ModeModel.dart';
import 'package:antizero_jumpin/provider/filter.dart';
import 'package:antizero_jumpin/provider/plan.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/home/plans/add_members.dart';
import 'package:antizero_jumpin/services/plan.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/map.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/utils/validators.dart';
import 'package:antizero_jumpin/widget/common/accountLinkButton.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:antizero_jumpin/widget/common/elevated_button.dart';
import 'package:antizero_jumpin/widget/common/fade_animation.dart';
import 'package:antizero_jumpin/widget/common/text_form.dart';
import 'package:antizero_jumpin/widget/home/plans/drop_down.dart';
import 'package:antizero_jumpin/widget/home/plans/img_list.dart';
import 'package:antizero_jumpin/widget/home/plans/time_container.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../widget/home/plans/location.dart';

class CreatePlanPage extends StatefulWidget {
  final bool public;
  final bool isFromEdit;
  final Plan editPlan;
  final List<JumpInUser> members;

  const CreatePlanPage({Key key, this.public = false, this.isFromEdit = false,this.editPlan,this.members}) : super(key: key);

  @override
  _CreatePlanPageState createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends State<CreatePlanPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedPlanCat;
  String title, disc, ageLimit, entryFee, totalSpots;
  List<File> imgFiles = [];
  bool saving = false;
  bool online = false;
  bool multi = false;
  bool age = false;
  bool fees = false;
  Map<String, dynamic> planLocation = {};
  String planAdd;
  DateTime startDate;
  DateTime endDate;
  DateTime time;
  TimeOfDay timeOfPlan;
  List<JumpInUser> planMembers = [];
  Plan currentPlan = Plan.named(createdAt: DateTime.now());
  String companyName = '';

  handleTakePhoto() async {
    Navigator.pop(context);
    PickedFile _imgFile =
    await ImagePicker().getImage(source: ImageSource.camera);
    if (_imgFile != null) {
      imgFiles.add(File(_imgFile.path));
      setState(() {});
    }
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    PickedFile _imgFile =
    await ImagePicker().getImage(source: ImageSource.gallery);
    if (_imgFile != null) {
      imgFiles.add(File(_imgFile.path));
      setState(() {});
    }
  }

  submit() async {
    print('Create plan');
    if (!_formKey.currentState.validate()) {
      showError(context: context, errMsg: 'Required fields are missing');
      return;
    } else {
      if (_selectedPlanCat == null ||
          title == null ||
          disc == null ||
          startDate == null ||
          time == null ||
          totalSpots == null) {
        showError(context: context, errMsg: 'Required fields are missing');
        return;
      }
      // else if(totalSpots.length>0)
      // {
      //   if(int.tryParse(totalSpots) > 1000)
      //     showError(context: context, errMsg: 'Max spot value is 1000');
      // }
      else if (multi == true && endDate == null) {
        showError(context: context, errMsg: 'End date is not selected');
        return;
      } else if (age == true && ageLimit == null) {
        showError(context: context, errMsg: 'Please enter age limit!');
        return;
      } else if (fees == true && entryFee == null) {
        showError(
            context: context, errMsg: 'Please enter entry fee for your plan!');
        return;
      } else if (multi == true && startDate.isAfter(endDate)) {
        showError(
            context: context, errMsg: 'Start date cannot be after end date');
      } else if (online == false && (planLocation == null || planAdd == null)) {
        showError(context: context, errMsg: 'Location is not selected');
        return;
      } else if (planMembers.isNotEmpty &&
          (planMembers.length + 1) > int.parse(totalSpots)) {
        showError(
            context: context, errMsg: 'Members can\'t exceed total spot.');
        return;
      }
      else {
        setState(() {
          saving = true;
        });
        print('Create plan $_selectedPlanCat $title $disc $startDate $time $totalSpots $companyName');
        currentPlan = currentPlan.copyWith(
            catName: _selectedPlanCat,
            planName: title,
            planDisc: disc,
            public: widget.public,
            online: online,
            multi: multi,
            age: age,
            entryFree: fees,
            location: online == true ? 'N/A' : planAdd,
            geoLocation:
            online == true ? {'Lat': 'N/A', 'Long': 'N/A'} : planLocation,
            ageLimit: age == true ? ageLimit : 'N/A',
            fees: fees == true ? entryFee : 'N/A',
            spot: totalSpots,
            startDate: startDate,
            companyName: companyName,
            endDate: multi == true
                ? endDate
                : startDate.add(const Duration(days: 1)),
            time: time,
            recentMsg: RecentMsg(
                recentMsg: 'N/A', sender: 'N/A', time: DateTime.now()),
            createdAt: DateTime.now());
        if(widget.isFromEdit==true)
          {
            print('Edit plan $_selectedPlanCat $title $disc $startDate $time $totalSpots $companyName');
            Plan currentPlanEdit = Plan.named(createdAt: DateTime.now());
            currentPlanEdit = currentPlanEdit.copyWith(
                id: widget.editPlan.id,
                host: widget.editPlan.host,
                chatActivity: widget.editPlan.chatActivity,
                companyName: companyName,
                catName: _selectedPlanCat,
                planName: title,
                planImg: widget.editPlan.planImg,
                planDisc: disc,
                public: widget.public,
                online: online,
                multi: multi,
                age: age,
                entryFree: fees,
                location: online == true ? 'N/A' : planAdd,
                geoLocation:
                online == true ? {'Lat': 'N/A', 'Long': 'N/A'} : planLocation,
                ageLimit: age == true ? ageLimit : 'N/A',
                fees: fees == true ? entryFee : 'N/A',
                spot: totalSpots,
                startDate: startDate,
                endDate: multi == true
                    ? endDate
                    : startDate.add(const Duration(days: 1)),
                time: time,
                recentMsg: RecentMsg(
                    recentMsg: 'N/A', sender: 'N/A', time: DateTime.now()),
                createdAt: DateTime.now(),
                userIds: widget.editPlan.userIds);
            List<Member> attendees = [];
            List<String> userIds = [];
            for(int i=0;i<planMembers.length;i++)
              {
                userIds.add(planMembers[i].id);
                // all users are accepted
                if(widget.editPlan.userIds.contains(planMembers[i].id))
                  {
                    Member attendee = Member(memId: planMembers[i].id,
                        status: MemberStatus.Accepted,
                        memName: planMembers[i].name);
                    attendees.add(attendee);
                  }
                else
                  {
                    Member attendee = Member(memId: planMembers[i].id,
                        status: MemberStatus.Accepted,
                        memName: planMembers[i].name);
                    attendees.add(attendee);
                  }
              }
            var userIdUnique = Set<String>();
            List<String> uniqueUserIds = userIds.where((userId) => userIdUnique.add(userId)).toList();
            var memberUnique = Set<Member>();
            List<Member> uniqueAttendes = attendees.where((member) => memberUnique.add(member)).toList();
            currentPlanEdit = currentPlanEdit.copyWith(
              userIds: uniqueUserIds,
              member: uniqueAttendes,
              host: widget.editPlan.id);
              bool success = await editPlan(
                context: context,
                plan: currentPlanEdit,
                members: planMembers,
                imgFiles: imgFiles);
            if (success != null) {
              getUser(context);
              showToast('Plan edited successfully!');
              if (planMembers.isNotEmpty)
              {
                await sendPrivatePlanAcceptNot(
                    context, planMembers, currentPlan.id,
                    widget.public, title);
              }
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                await Provider.of<PlanProvider>(context, listen: false)
                    .getHomePlan(context);
              });
              var planProvider = Provider.of<PlanProvider>(context,listen: false);
              Plan newcurrentPlan = await locator.get<PlanService>().getPlanById(widget.editPlan.id);
              planProvider.currentPlan = newcurrentPlan;
              Navigator.pop(context);
            } else {
              showError(context: context, errMsg: 'Error caught in editing plan!');
            }
          }
        else
          {
            String successId = await savePlan(
                context: context,
                plan: currentPlan,
                members: planMembers,
                imgFile: imgFiles);
            if (successId != null) {
              getUser(context);
              showToast('Plan saved successfully!');
              if (planMembers.isNotEmpty)
              {
                await sendPrivatePlanAcceptNot(
                    context, planMembers, successId, widget.public, title);
              }
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                await Provider.of<PlanProvider>(context, listen: false)
                    .getHomePlan(context);
              });
              Navigator.pop(context);
            } else {
              showError(context: context, errMsg: 'Error caught in saving plan!');
            }
          }
        setState(()
        {
          saving = false;
        });
      }
    }
  }

  @override
  Future<void> initState() {
    super.initState();
    if(widget.isFromEdit == true)
      {
        FirebaseAnalytics.instance.logScreenView(
          screenName: 'Edit Plan Screen',
          screenClass: 'Plans',
        );
        initValues();
      }
    else
      {
        FirebaseAnalytics.instance.logScreenView(
          screenName: 'Create Plan Screen',
          screenClass: 'Plans',
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: primaryGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar:
        CustomAppBar(
          backgroundColor: Colors.transparent,
          title:  widget.isFromEdit == true ? 'Edit Plan' : 'Create Plan',
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
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // category
                  CustomDropDown(
                    leading: SvgPicture.asset(
                      createDocumentIcon,
                      height: 5.w,
                      width: 5.w,
                    ),
                    label: 'Choose Category',
                    hint: 'Select category',
                    borderColor: blue,
                    list: PlanCatName.keys.map((selected) {
                      return DropdownMenuItem(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              backgroundImage:
                              AssetImage(PlanCatName[selected]),
                            ),
                            const SizedBox(width: 5),
                            Text(selected),
                          ],
                        ),
                        value: selected,
                      );
                    }).toList(),
                    onChanged: (String newSelection) {
                      setState(() {
                        _selectedPlanCat = newSelection;
                      });
                    },
                    selectedValue: _selectedPlanCat,
                  ),

                  // plan image
                  const SizedBox(
                    height: 20,
                  ),
                  if (imgFiles.isEmpty)
                    Text(
                      'No images selected for plan',
                      style: bodyStyle(
                          context: context, size: 14, color: Colors.black54),
                    ),
                  if (imgFiles.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(right: 10),
                        itemCount: imgFiles.length,
                        itemBuilder: (context, index) {
                          return CustomImageCard(
                            imgFile: imgFiles[index],
                            onDelete: () {
                              imgFiles.remove(imgFiles[index]);
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  CustomElevatedButton(
                    buttonType: ElevatedButtonType.createPlan,
                    bgColor: blue,
                    curve: 7,
                    onTap: () {
                      ImageDialog(
                          parentContext: context,
                          camera: handleTakePhoto,
                          gallery: handleChooseFromGallery);
                    },
                    loading: false,
                    label: 'Choose image',
                    loaderSize: 15,
                  ),

                  // plan title
                  CustomFormField(
                    prefix: SvgPicture.asset(
                      createDocumentIcon,
                      fit: BoxFit.scaleDown,
                    ),
                    richLabel: 'A catchy plan title',
                    fillColor: Colors.blue[50],
                    hint: 'Enter plan title',
                    initValue: title,
                    validatorFn: jumpValidator,
                    onChanged: (String val) {
                      setState(() {
                        title = val;
                      });
                    },

                  ),

                  // plan description
                  CustomFormField(
                    prefix: SvgPicture.asset(
                      createDocumentIcon,
                      fit: BoxFit.scaleDown,
                    ),
                    richLabel: 'Plan description',
                    fillColor: Colors.blue[50],
                    hint: 'Enter plan description',
                    maxLine: 2,
                    initValue: disc,
                    validatorFn: jumpValidator,
                    onChanged: (String val) {
                      setState(() {
                        disc = val;
                      });
                    },
                  ),
                  // location
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, left: 5, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          text: TextSpan(
                              text: 'Plan location',
                              style: bodyStyle(
                                  context: context,
                                  size: 16,
                                  color: Colors.black),
                              children: [
                                TextSpan(
                                  text: " *",
                                  style: bodyStyle(
                                      context: context,
                                      size: 14,
                                      color: Colors.redAccent),
                                ),
                              ]),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                              EdgeInsets.only(right: size.width * 0.02),
                              child: Text("Online",
                                  style: TextStyle(
                                      fontSize: size.height * 0.023,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.6))),
                            ),
                            SizedBox(
                              width: size.width * 0.05,
                              child: Checkbox(
                                value: online ?? false,
                                onChanged: (value) {
                                  setState(() {
                                    online = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (!online)
                  // plan description
                    CustomFormField(
                      prefix: SvgPicture.asset(
                        createLocationIcon,
                        fit: BoxFit.scaleDown,
                      ),
                      fillColor: Colors.blue[50],
                      hint: 'Enter plan location',
                      maxLine: 2,
                      initValue: planAdd,
                      validatorFn: jumpValidator,
                      onChanged: (String val) {
                        setState(() {
                          planAdd = val;
                          planLocation = {
                          'Lat': 27.666994,
                          'Long': 85.309289
                        };
                        });
                      },
                    ),
                    // FadeAnimation(
                    //   0.2,
                    //   Padding(
                    //     padding:
                    //     EdgeInsets.symmetric(vertical: size.height * 0.01),
                    //     child: GestureDetector(
                    //       onTap: () async {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(builder: (context) =>
                    //               PlanLocationCard()),
                    //         );
                    //         // Navigator.push(
                    //         //   context,
                    //         //   MaterialPageRoute(
                    //         //     builder: (context) => PlacePicker(
                    //         //       apiKey: googleMapApiKey,
                    //         //       onPlacePicked: (resultingLocation) {
                    //         //         planLocation = {
                    //         //           'Lat': resultingLocation
                    //         //               .geometry.location.lat,
                    //         //           'Long': resultingLocation
                    //         //               .geometry.location.lng
                    //         //         };
                    //         //         planAdd =
                    //         //             resultingLocation.formattedAddress;
                    //         //         setState(() {});
                    //         //         Navigator.of(context).pop();
                    //         //       },
                    //         //       initialPosition:
                    //         //       userProvider.currentUser.geoPoint != null
                    //         //           ? LatLng(
                    //         //           userProvider
                    //         //               .currentUser.geoPoint['Lat'],
                    //         //           userProvider
                    //         //               .currentUser.geoPoint['Long'])
                    //         //           : const LatLng(23.0, 80.0),
                    //         //       useCurrentLocation: true,
                    //         //     ),
                    //         //   ),
                    //         // );
                    //       },
                    //       child: Container(
                    //         width: 90.w,
                    //         height: 7.h,
                    //         padding: EdgeInsets.symmetric(horizontal: 3.w),
                    //         decoration: BoxDecoration(
                    //           color: Colors.blue[50],
                    //           borderRadius: BorderRadius.circular(10),
                    //           border: Border.all(
                    //             color: Colors.grey,
                    //           ),
                    //         ),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: [
                    //             SvgPicture.asset(createLocationIcon),
                    //             SizedBox(
                    //               width: 3.w,
                    //             ),
                    //             Expanded(
                    //               child: Text(
                    //                 planAdd ?? 'Pick a location',
                    //                 style: bodyStyle(
                    //                     context: context,
                    //                     size: 16,
                    //                     color: Colors.grey),
                    //               ),
                    //             ),
                    //             SvgPicture.asset(createAttachIcon),
                    //             SizedBox(
                    //               width: 3.w,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                  // date
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 10, left: 5, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          text: TextSpan(
                              text: 'Date',
                              style: bodyStyle(
                                  context: context,
                                  size: 16,
                                  color: Colors.black),
                              children: [
                                TextSpan(
                                  text: " *",
                                  style: bodyStyle(
                                      context: context,
                                      size: 14,
                                      color: Colors.redAccent),
                                ),
                              ]),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                              EdgeInsets.only(right: size.width * 0.02),
                              child: Text("Multi date",
                                  style: TextStyle(
                                      fontSize: size.height * 0.023,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.6))),
                            ),
                            SizedBox(
                              width: size.width * 0.05,
                              child: Checkbox(
                                value: multi ?? false,
                                onChanged: (value) {
                                  setState(() {
                                    multi = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTime(
                          onTap: () async {
                            final DateTime picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                initialDatePickerMode: DatePickerMode.day,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2030));
                            if (picked != null) {
                              setState(() {
                                startDate = picked;
                              });
                            }

                            // DatePicker.showDatePicker(context,
                            //     showTitleActions: true,
                            //     minTime: DateTime.now(),
                            //     currentTime: startDate,
                            //     maxTime: DateTime(2050, 1, 1),
                            //     onConfirm: (date) {
                            //       setState(() {
                            //         startDate = picked;
                            //       });
                            //     });
                          },
                          label: startDate == null
                              ? "Start Date"
                              : Jiffy(startDate).yMMMd,
                        ),
                         if (multi == true || online == true)
                          CustomTime(
                            onTap: () async {
                              final DateTime picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  initialDatePickerMode: DatePickerMode.day,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030));
                              if (picked != null) {
                                setState(() {
                                  endDate = picked;
                                });
                              }

                              // DatePicker.showDatePicker(context,
                              //     showTitleActions: true,
                              //     minTime: DateTime.now().add(Duration(minutes: 15)),
                              //     currentTime: endDate,
                              //     maxTime: DateTime(2050, 1, 1),
                              //     onConfirm: (date) {
                              //       setState(() {
                              //         endDate = date;
                              //       });
                              //     });
                            },
                            label: endDate == null
                                ? "End Date"
                                : Jiffy(endDate).yMMMd,
                          ),
                      ],
                    ),
                  ),

                  // time
                  if (startDate != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                        const EdgeInsets.only(top: 20, left: 5, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                  text: 'Time',
                                  style: bodyStyle(
                                      context: context,
                                      size: 16,
                                      color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: " *",
                                      style: bodyStyle(
                                          context: context,
                                          size: 14,
                                          color: Colors.redAccent),
                                    ),
                                  ]),
                            ),
                            FadeAnimation(
                              0.2,
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.01),
                                child: GestureDetector(
                                    onTap: () async {
                                      Navigator.of(context).push(
                                        showPicker(
                                          context: context,
                                          value: timeOfPlan ?? TimeOfDay.now(),
                                          onChange: (val) {
                                            timeOfPlan = val;
                                            time = join(startDate, val);
                                            setState(() {});
                                          },
                                        ),
                                      );
                                    },
                                    child: Card(
                                      color: Colors.blue[50],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      shadowColor:
                                      Colors.blueGrey.withOpacity(0.2),
                                      elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 8),
                                        child: Text(
                                          time == null
                                              ? 'Choose time'
                                              : Jiffy(time).jm,
                                          style: bodyStyle(
                                              context: context,
                                              size: 16,
                                              color: Colors.black54),
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // age
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, left: 5, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: 'Age',
                            style: bodyStyle(
                                context: context,
                                size: 16,
                                color: Colors.black),
                            children: const [],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                              EdgeInsets.only(right: size.width * 0.02),
                              child: Text("Restriction",
                                  style: TextStyle(
                                      fontSize: size.height * 0.023,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.6))),
                            ),
                            SizedBox(
                              width: size.width * 0.05,
                              child: Checkbox(
                                value: age ?? false,
                                onChanged: (value) {
                                  setState(() {
                                    age = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (age == true)
                    FadeAnimation(
                      0.2,
                      CustomFormField(
                        prefix: SvgPicture.asset(
                          createCalendarIcon,
                          fit: BoxFit.scaleDown,
                        ),
                        fillColor: Colors.blue[50],
                        hint: 'Enter minimum age required',
                        inputType: TextInputType.number,
                        validatorFn: jumpValidator,
                        initValue: ageLimit,
                        onChanged: (String val) {
                          setState(() {
                            ageLimit = val;
                          });
                        },
                      ),
                    ),

                  // fees
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, left: 5, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: 'Entry fees',
                            style: bodyStyle(
                                context: context,
                                size: 16,
                                color: Colors.black),
                            children: const [],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                              EdgeInsets.only(right: size.width * 0.02),
                              child: Text("Fees",
                                  style: TextStyle(
                                      fontSize: size.height * 0.023,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.6))),
                            ),
                            SizedBox(
                              width: size.width * 0.05,
                              child: Checkbox(
                                value: fees ?? false,
                                onChanged: (value) {
                                  setState(() {
                                    fees = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (fees == true)
                    FadeAnimation(
                      0.2,
                      CustomFormField(
                        prefix: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: RichText(
                                softWrap: true,
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                text: 'Rs.',
                                style: bodyStyle(
                                context: context,
                                size: 12,
                                color: Colors.blueAccent)),
                                ),
                        ),
                        fillColor: Colors.blue[50],
                        hint: 'Enter entry fees',
                        inputType: TextInputType.number,
                        validatorFn: jumpValidator,
                        initValue: entryFee,
                        onChanged: (String val) {
                          setState(() {
                            entryFee = val;
                          });
                        },
                      ),
                    ),

                  // spots
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, left: 5, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        text: TextSpan(
                            text: 'Total no. of spots',
                            style: bodyStyle(
                                context: context,
                                size: 16,
                                color: Colors.black),
                            children: [
                              TextSpan(
                                text: " *",
                                style: bodyStyle(
                                    context: context,
                                    size: 14,
                                    color: Colors.redAccent),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  FadeAnimation(
                    0.2,
                    CustomFormField(
                      prefix: SvgPicture.asset(
                        createClipboardIcon,
                        fit: BoxFit.scaleDown,
                      ),
                      // enableinteractiveSelection: false,
                      fillColor: Colors.blue[50],
                      hint: 'Total no. of spots',
                      validatorFn: jumpValidator,
                      inputType: TextInputType.number,
                      initValue: totalSpots,// Only numbers can be entered
                      onChanged: (String val) {
                        setState(() {
                          totalSpots = val;
                        });
                      },
                    ),
                  ),
                  // member list
                  if (planMembers.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                    text: 'Members',
                                    style: bodyStyle(
                                        context: context,
                                        size: 16,
                                        color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: " ",
                                        style: bodyStyle(
                                            context: context,
                                            size: 14,
                                            color: Colors.redAccent),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          FadeAnimation(
                            0.2,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.blue[100],
                              ),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: planMembers.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Card(
                                        color: Colors.white,
                                        shadowColor:
                                        Colors.blueGrey.withOpacity(0.2),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 3),
                                          child: ListTile(
                                            dense: true,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            leading: CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Colors.blue[100],
                                              child: CircleAvatar(
                                                radius: 22,
                                                backgroundImage:
                                                planMembers[index]
                                                    .photoList.last ==
                                                    null
                                                    ? const AssetImage(
                                                    avatarIcon)
                                                    : NetworkImage(
                                                    planMembers[index]
                                                        .photoList.last),
                                              ),
                                            ),
                                            title: Text(
                                              planMembers[index].name ?? '',
                                              style: bodyStyle(
                                                  context: context,
                                                  size: 18,
                                                  color: Colors.black54),
                                            ),
                                            subtitle: Text(
                                              planMembers[index].username ==
                                                  null
                                                  ? ''
                                                  : '@ ${planMembers[index].username}',
                                              style: bodyStyle(
                                                  context: context,
                                                  size: 16,
                                                  color: Colors.teal),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // members
                  const SizedBox(
                    height: 30,
                  ),
                  TextButton(
                    onPressed: () async {
                      List<JumpInUser> members =
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddMemberPage(
                          plan: widget.editPlan,
                          onSubmit: (members) {
                            Navigator.of(context).pop(members);
                          },
                        ),
                      ));
                      if (members != null) {
                        setState(() {
                          planMembers = members;
                        });
                      }
                    },
                    child: Text(
                      "Add Member",
                      style: bodyStyle(
                        context: context,
                        size: 17,
                        color: blue,
                      ).copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  // submit button
                  CustomLogoButton(
                    icon: true,
                    iconData: Icons.save,
                    iconColor: Colors.black54,
                    color: Colors.redAccent,
                    loading: saving,
                    title: widget.isFromEdit==true ? 'Edit' : 'Create',
                    onTap: submit,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void initValues() async {
    _selectedPlanCat = widget.editPlan.catName;
    title = widget.editPlan.planName;
    disc = widget.editPlan.planDisc;
    planAdd = widget.editPlan.location;
    online = widget.editPlan.online;
    multi = widget.editPlan.multi;
    startDate = widget.editPlan.startDate;
    endDate = widget.editPlan.endDate;
    time = widget.editPlan.time;
    age = widget.editPlan.age;
    ageLimit = widget.editPlan.ageLimit;
    fees = widget.editPlan.entryFree;
    entryFee = widget.editPlan.fees;
    planAdd = widget.editPlan.location;
    totalSpots = widget.editPlan.spot;
    if(widget.editPlan.planImg!=null)
    {
      for(int i=0;i<widget.editPlan.planImg.length;i++)
      {
        imgFiles.add(File(widget.editPlan.planImg[i]));
      }
    }
    if(widget.editPlan.member.isNotEmpty)
    {
      List<JumpInUser> users = [];
      for (int i = 0; i < widget.editPlan.member.length; i++)
      {
        JumpInUser user = await locator
            .get<UserService>()
            .getUserById(widget.editPlan.member[i].memId);
        if (user != null)
        {
          users.add(user);
        }
      }
      planMembers.addAll(users);
    }
    setState(() {

    });
  }
}
