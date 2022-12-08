// import 'package:antizero_jumpin/screens/profile/profile.dart';
// import 'package:antizero_jumpin/services/user.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:sizer/sizer.dart';
//
// showOkCancelDialog(BuildContext context) {
//   return showDialog(
//     context: context,
//     builder: (context) {
//       return Material(
//         type: MaterialType.transparency,
//         child: Center(
//           child: Container(
//             height: 30.h,
//             width: 80.w,
//             padding: EdgeInsets.all(5.w),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(3.w),
//               color: Colors.white,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   'Give us access to your contacts!',
//                   style: GoogleFonts.nunitoSans(
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Spacer(),
//                 Text(
//                   'It helps us ensure your safety by suggesting '
//                       'profiles with mutual contacts',
//                   style: GoogleFonts.nunitoSans(),
//                 ),
//                 const Spacer(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           Permission.contacts.request().isGranted;
//                         },
//                         child: Text(
//                           'Ok',
//                           style: GoogleFonts.nunitoSans(),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 2.w,
//                     ),
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all(
//                             const Color(0xFFCFD2DD),
//                           ),
//                           foregroundColor: MaterialStateProperty.all(
//                             Colors.black,
//                           ),
//                         ),
//                         onPressed: () {
//                           Permission.contacts.request().isDenied;
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           'Later',
//                           style: GoogleFonts.nunitoSans(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
