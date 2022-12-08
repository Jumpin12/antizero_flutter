import 'package:antizero_jumpin/handler/interest.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/main.dart';
import 'package:antizero_jumpin/models/sub_category.dart';
import 'package:antizero_jumpin/provider/interest.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/services/interest.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/auth/Empty_category.dart';
import 'package:antizero_jumpin/widget/auth/category_box.dart';
import 'package:antizero_jumpin/widget/auth/interest_category.dart';
import 'package:antizero_jumpin/widget/auth/interest_subcategory.dart';
import 'package:antizero_jumpin/widget/auth/subCategory_box.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class EditInterestPage extends StatefulWidget {
  const EditInterestPage({Key key}) : super(key: key);

  @override
  _EditInterestPageState createState() => _EditInterestPageState();
}

class _EditInterestPageState extends State<EditInterestPage> {
  ItemScrollController scrollController = ItemScrollController();
  List<String> selectedCat = [];
  List<SubCategory> subCatList = [];
  List<String> selectedSubCat = [];

  @override
  void initState() {
    setInterestCategory(context);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.currentUser.interestList != null &&
        userProvider.currentUser.interestList.isNotEmpty) {
      selectedSubCat = userProvider.currentUser.interestList;
    }
    super.initState();
  }


  Future<void> _refresh(String cat) async {
    if (cat != null)
      await Provider.of<InterestProvider>(context, listen: false).refresh(cat);
    subCatList =
        Provider.of<InterestProvider>(context, listen: false).subCategories;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    InterestProvider interestProvider = Provider.of<InterestProvider>(context);

    return Scaffold(
        appBar: CustomAppBar(
          automaticImplyLeading: true,
          title: 'Edit',
          search: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _refresh(interestProvider.currentCategory);
          },
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    Text(
                      "Choose Your Interests",
                      style: bodyStyle(
                          context: context,
                          size: (constraints.maxHeight * 0.05) * 0.5,
                          color: Colors.black87),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "Select interests and then sub-interests",
                        style: bodyStyle(
                                context: context,
                                size: (constraints.maxHeight * 0.04) * 0.45,
                                color: Colors.black54)
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                    ),
                    Text(
                      " Select minimum 5 Sub-Interests",
                      style: bodyStyle(
                              context: context,
                              size: (constraints.maxHeight * 0.03) * 0.6,
                              color: Colors.red)
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    if (interestProvider.categories != null ||
                        interestProvider.categories.isNotEmpty)
                      Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight * 0.22,
                        child: InterestCategory(
                          direction: Axis.horizontal,
                          scrollController: scrollController,
                          count: interestProvider.categories.length,
                          builder: (context, index) {
                            return CategoryBox(
                              depth: selectedCat.contains(
                                      interestProvider.categories[index])
                                  ? -8
                                  : 7,
                              label: interestProvider.categories[index],
                              // lightSource: selectedCat.contains(interestProvider.categories[index])
                              //     ? LightSource.topLeft
                              //     : LightSource.top,
                              onLongPress: () {
                                if (selectedCat.contains(
                                    interestProvider.categories[index])) {
                                  selectedCat.remove(
                                      interestProvider.categories[index]);
                                } else {
                                  showToast('Nothing to deselect!');
                                }
                                setState(() {});
                              },
                              color: selectedCat.contains(
                                      interestProvider.categories[index])
                                  ? Colors.blue[700]
                                  : Colors.white,
                              textColor: selectedCat.contains(
                                      interestProvider.categories[index])
                                  ? Colors.white
                                  : Colors.black,
                              onTap: () async {
                                if (!selectedCat.contains(
                                    interestProvider.categories[index])) {
                                  selectedCat
                                      .add(interestProvider.categories[index]);
                                }
                                interestProvider.currentCategory =
                                    interestProvider.categories[index];
                                var _subCatList = await locator
                                    .get<InterestService>()
                                    .getInterestSubCategory(
                                        interestProvider.categories[index]);
                                subCatList = _subCatList;
                                setState(() {});
                              },
                              constraints: constraints,
                            );
                          },
                        ),
                      ),

                    if (subCatList.isNotEmpty &&
                        interestProvider.currentCategory ==
                            subCatList[0].catName)
                      InterestSubCategory(
                        count: subCatList.length,
                        builder: (context, index) {
                          return SubCategoryBox(
                            constraints: constraints,
                            color: selectedSubCat.contains(subCatList[index].id)
                                ? Colors.transparent
                                : Colors.white30,
                            checkBox:
                                selectedSubCat.contains(subCatList[index].id),
                            subCatImage: subCatList[index].img,
                            label: subCatList[index].name,
                            onTap: () {
                              if (selectedSubCat
                                  .contains(subCatList[index].id)) {
                                selectedSubCat.remove(subCatList[index].id);
                              } else {
                                selectedSubCat.add(subCatList[index].id);
                              }
                              setState(() {});
                            },
                          );
                        },
                      )
                    else
                      EmptyCategoryContainer(
                        constraints: constraints,
                      )
                  ],
                ),
              ),
            );
          }),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () async {
            if (selectedSubCat.length >= 5) {
              interestProvider.setSelectedSubCategories(selectedSubCat);
              await updateInterest(context, selectedSubCat);
            } else {
              showToast('Minimum 5 interest required!');
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.07,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.blue[900], Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            child: Text("DONE",
                style: TextStyle(
                    letterSpacing: 1,
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    fontWeight: FontWeight.w500)),
          ),
        ));
  }
}
