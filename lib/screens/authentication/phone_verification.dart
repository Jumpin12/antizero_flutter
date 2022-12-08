import 'dart:async';

import 'package:antizero_jumpin/handler/local.dart';
import 'package:antizero_jumpin/handler/toast.dart';
import 'package:antizero_jumpin/provider/phone_auth.dart';
import 'package:antizero_jumpin/screens/authentication/interest.dart';
import 'package:antizero_jumpin/utils/applogo.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/auth/handstack_container.dart';
import 'package:antizero_jumpin/widget/auth/phone_no.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:antizero_jumpin/widget/common/elevated_button.dart';
import 'package:antizero_jumpin/widget/on_board/progress_indicator.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class PhoneNumberScreen extends StatefulWidget {

  bool isFromProfile;

  PhoneNumberScreen({Key key, @required this.isFromProfile}) : super(key: key);

  @override
  _PhoneNumberScreenState createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  // ConnectionChecker checkConnection = ConnectionChecker();

  int _start = 59;
  Widget otpEntryBox = Container();
  bool verifyButtonVisible = false;
  bool timerVisible = false;
  // bool otpSend = false;
  String dialCode = "+91";
  Timer _timer;

  bool loading = true;
  bool verifying = false;
  TextEditingController otpController = TextEditingController();
  TextEditingController phoneNoKey = TextEditingController();
  String phoneNo = "";

  @override
  void initState() {
    // checkConnection.checkConnection(context);
    setDialCode();
    super.initState();
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'Phone Verification Screen',
      screenClass: 'Authentication',
    );
  }

  @override
  void dispose() {
    // checkConnection.listener.cancel();
    // phoneNoKey.clear();
    // otpController.clear();
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  setDialCode() async {
    String _dialCode = await getDialCode();
    if (_dialCode != null) {
      dialCode = _dialCode;
    }
    setState(() {
      loading = false;
    });
  }

  void startTimer() {
    if (_timer != null) {
      _timer.cancel();
      _start = 59;
    }
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer)
    {
      if (_start <= 0) {
        _start = 59;
        // otpSend = false;
        timer.cancel();
        setState(() {});
      } else {
        if (mounted)
          setState(
            () {
              _start = _start - 1;
            },
          );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    PhoneAuth phoneAuth = Provider.of<PhoneAuth>(context);

    print(phoneAuth.status);

    return WillPopScope(
        onWillPop: () async => false,
        child: loading
            ? fadedCircle(32, 32)
            : Scaffold(
                appBar: widget.isFromProfile ? CustomAppBar(automaticImplyLeading: true, title: '',)
                    : CustomAppBar(automaticImplyLeading: false, title: '',),
                body: LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                          minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            HandStackContainer(
                              child: Column(
                                children: [
                                  UpperProgressIndicator(
                                    progressImage: progress1,
                                  ),
                                  AppLogo(
                                    height: 50,
                                    width: 40,
                                  ),
                                ],
                              ),
                            ),
                            Row(children: [
                              Container(
                                child: CountryListPick(
                                    appBar: AppBar(
                                      backgroundColor: Colors.blue,
                                      title: Text(
                                        'Choose a country',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    pickerBuilder:
                                        (context, CountryCode countryCode) {
                                      return Row(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 40,
                                            child: Image.asset(
                                              countryCode.flagUri,
                                              package: 'country_list_pick',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(countryCode.dialCode,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700)),
                                        ],
                                      );
                                    },
                                    theme: CountryTheme(
                                      isShowFlag: true,
                                      isShowTitle: true,
                                      isShowCode: true,
                                      isDownIcon: true,
                                      showEnglishName: true,
                                    ),
                                    initialSelection: dialCode,
                                    onChanged: (CountryCode code) {
                                      dialCode = code.dialCode;
                                    },
                                    useUiOverlay: true,
                                    useSafeArea: false),
                              ),
                              PhoneNoEntry(
                                phoneNoKey: phoneNoKey,
                                keyBoardType: TextInputType.phone,
                                onSave: (val) {
                                  setState(() {
                                    phoneNo = phoneNoKey.text;
                                  });
                                },
                              )
                            ]),
                            SizedBox(height: 10),
                            if (phoneAuth.status == Status.OtpSend &&
                                _start < 59)
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Text(
                                  '0:' + _start.toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            if (phoneAuth.status != Status.OtpSend)
                              Container(
                                height: 40,
                                width: 120,
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(right: 10),
                                child: CustomElevatedButton(
                                  bgColor: phoneAuth.status == Status.OtpSend
                                      ? Colors.grey[400]
                                      : ColorsJumpIn.kPrimaryColorLite,
                                  curve: 12,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    if (phoneAuth.status != Status.OtpSend) {
                                      startTimer();
                                      // setState(() {
                                      //   otpSend = true;
                                      // });
                                      await phoneAuth.verifyPhoneNumber(context,
                                          '$dialCode${phoneNoKey.text}');
                                    }
                                  },
                                  loading: phoneAuth.status == Status.OtpSend,
                                  label: phoneAuth.status == Status.OtpSend
                                      ? "Verifying"
                                      : 'Send OTP',
                                  labelColor: Colors.black,
                                  labelSize: SizeConfig.blockSizeHorizontal * 3,
                                  loaderSize: 15,
                                ),
                              ),
                            SizedBox(height: 30),
                            if (phoneAuth.status == Status.OtpSend)
                              PinCodeTextField(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  autoDismissKeyboard: true,
                                  controller: otpController,
                                  pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      fieldHeight: 40,
                                      fieldWidth: 40,
                                      borderRadius: BorderRadius.circular(5),
                                      activeColor: skyBlue1,
                                      inactiveColor: Colors.grey,
                                      selectedColor: Colors.blueGrey),
                                  animationType: AnimationType.fade,
                                  animationDuration:
                                      Duration(milliseconds: 150),
                                  textStyle: headingStyle(
                                      context: context,
                                      size: 17,
                                      color: Colors.black54),
                                  appContext: context,
                                  keyboardType: TextInputType.number,
                                  length: 6,
                                  onChanged: (val) {}),
                            SizedBox(height: 10),
                            if (phoneAuth.status == Status.OtpSend)
                              Center(
                                child: Text(
                                  'Please enter the OTP sent to your number',
                                  style: bodyStyle(
                                      context: context,
                                      size: 14,
                                      color: Colors.black54),
                                ),
                              ),
                            SizedBox(height: 10),
                            if (phoneAuth.status == Status.OtpSend)
                              Center(
                                child: Container(
                                    height: 50,
                                    width: 150,
                                    margin: EdgeInsets.all(30),
                                    child: CustomElevatedButton(
                                      bgColor: ColorsJumpIn.kPrimaryColorLite,
                                      curve: 12,
                                      loaderSize: 30,
                                      labelSize: 16,
                                      labelColor: Colors.black,
                                      label: 'Verify',
                                      loading: verifying,
                                      onTap: () async {
                                        if (otpController.text.isEmpty) {
                                          showError(
                                              context: context,
                                              errMsg: 'Please enter OTP');
                                        } else {
                                          setState(() {
                                            verifying = true;
                                          });
                                          bool success =
                                              await phoneAuth.verifyOTP(
                                                  context, otpController.text);
                                          if (success) {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: Text(
                                                          "Phone number verified successfully!"),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          InterestPage()),
                                                            );
                                                          },
                                                          child: const Text(
                                                              'Alright'),
                                                        )
                                                      ],
                                                    ));
                                          } else {
                                            if (_timer != null) _timer.cancel();
                                            setState(() {
                                              verifying = false;
                                            });
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                    )),
                              )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ));
  }
}
