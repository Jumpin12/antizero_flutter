import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/models/company.dart';
import 'package:antizero_jumpin/models/jumpin_user.dart';
import 'package:antizero_jumpin/provider/user.dart';
import 'package:antizero_jumpin/screens/profile/profile.dart';
import 'package:antizero_jumpin/services/user.dart';
import 'package:antizero_jumpin/widget/common/text_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

showCompanyCodeDialog(BuildContext context,FocusNode _uname,TextEditingController uCodeController,
    Company newSelection) {
  return showDialog(
    context: context,
    builder: (context) {
      return Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            height: 30.h,
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
                CustomFormField(
                  label: 'Enter pass code for this company',
                  focus: _uname,
                  hint: 'Enter your code',
                  controller: uCodeController,
                  inputType: TextInputType.name,
                  validatorFn: null,
                  onChanged: (String val) {},
                  onFiledSubmitted: (String value) {
                    _uname.unfocus();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Expanded(
                       child: ElevatedButton(
                         onPressed: () async
                         {
                           if((uCodeController.text.length>0))
                           {
                             if(newSelection.passCode == uCodeController.text.toString())
                             {
                               UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                               JumpInUser _currentUser = userProvider.currentUser;
                               _currentUser.placeOfWork = newSelection.companyName;
                               Navigator.pop(context);
                             }
                             else
                             {
                               showToast('Please enter right company passcode!');
                             }
                           }
                           else
                           {
                             showToast('Please enter company passcode!');
                           }
                         },
                         child: Text(
                           'Check',
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
