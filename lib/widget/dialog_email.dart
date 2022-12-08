import 'dart:io';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

showEmailDialog(BuildContext context,int limit) {
  String downloadString = 'Download Users';

  var userProvider = Provider.of<UserProvider>(context, listen: false);
  return showDialog(
    context: context,
    builder: (context) {
      return Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            height: 25.h,
            width: 80.w,
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.w),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Do you want to download User Details?',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          AlertDialog alert = showLoaderDialog(context);
                          // fetch all db email
                          List<JumpInUser> tempUsersList = await userProvider.fetchUserEmail(context,limit);
                          await getCSV(context,tempUsersList);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            downloadString,
                            style: GoogleFonts.nunitoSans(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color(0xFFCFD2DD),
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            Colors.black,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Later',
                          style: GoogleFonts.nunitoSans(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

getCSV(BuildContext context,List<JumpInUser> tempUsersList) async
{
  print('getCSV');
  List<List<dynamic>> employeeData  = List<List<dynamic>>.empty(growable: true);
  List<dynamic> row = List.empty(growable: true);
  row.add("Sr No.");
  row.add("Name");
  row.add("Email");
  row.add("Gender");
  row.add("Bio");
  row.add("DOB");
  row.add("Academic Course");
  employeeData.add(row);
  for (int i = 0; i < tempUsersList.length ;i++) {
    //row refer to each column of a row in csv file and rows refer to each row in a file
    List<dynamic> row1 = List.empty(growable: true);
    row1.add(i);
    row1.add(tempUsersList[i].name);
    row1.add(tempUsersList[i].email);
    row1.add(tempUsersList[i].gender);
    row1.add(tempUsersList[i].bio);
    row1.add(tempUsersList[i].dob);
    row1.add(tempUsersList[i].academicCourse);
    employeeData.add(row1);
  }
  if(employeeData.length>0)
  {
    if (await Permission.storage.request().isGranted)
    {
      //store file in documents folder
      String dir = "";
      if(Platform.isIOS)
      {
        dir = (await getApplicationDocumentsDirectory()).path + "/jumpin_emailids.csv";
      }
      else
      {
        dir = (await getExternalStorageDirectory()).path + "/jumpin_emailids.csv";
      }
      String file = "$dir";
      File f = new File(file);
      // convert rows to String and write as csv file
      String csv = const ListToCsvConverter().convert(employeeData);
      f.writeAsString(csv);
      Share.shareFiles(['${dir}']);
    }
    else{
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
  }
  Navigator.pop(context);
}

AlertDialog showLoaderDialog(BuildContext context){
  AlertDialog alert=AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7),child:Text("Fetching all email ids" )),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}