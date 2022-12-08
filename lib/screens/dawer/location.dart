import 'package:antizero_jumpin/handler/profile.dart';
import 'package:antizero_jumpin/handler/user.dart';
import 'package:antizero_jumpin/utils/colors.dart';
import 'package:antizero_jumpin/utils/image_strings.dart';
import 'package:antizero_jumpin/utils/loader.dart';
import 'package:antizero_jumpin/utils/size_config.dart';
import 'package:antizero_jumpin/utils/textStyle.dart';
import 'package:antizero_jumpin/widget/common/button.dart';
import 'package:antizero_jumpin/widget/common/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';
// import 'package:photo_manager/photo_manager.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key key}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String address;
  bool loading = true;

  @override
  void initState() {
    getAddress();
    super.initState();
  }

  getAddress() async {
    Map<String, dynamic> geoPoint = await getPreSetLocation(context);
    if (geoPoint != null) {
      String _address = await getAddressFromLatLng(
          Lat: double.parse(geoPoint['Lat'].toString()),
          Long: double.parse(geoPoint['Long'].toString()));
      if (_address != null) {
        address = _address;
      }
    }
    if (mounted)
      setState(() {
        loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        automaticImplyLeading: true,
        title: 'Location',
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // location
            SizedBox(height: size.height / 2.8),
            Container(
              width: SizeConfig.blockSizeHorizontal * 6,
              height: SizeConfig.blockSizeHorizontal * 6,
              child:
                  Image.asset(address == null ? noLocationIcon : locationIcon),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: loading
                  ? ballClipRotateMultiple(45, 45)
                  : Text(
                      address == null ? 'Please choose your location' : address,
                      textAlign: TextAlign.center,
                      style: bodyStyle(
                          context: context,
                          size: 20,
                          color: Colors.black.withOpacity(0.6)),
                    ),
            ),

            // button
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: CustomButton(
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  bool accessGranted = await getLocationPermission();
                  if (accessGranted) {
                    // upload location at backend
                    await handleLocation(context);
                    await getAddress();
                  } else {
                    OpenSettings.openMainSetting();
                    // PhotoManager.openSetting();
                    setState(() {
                      loading = false;
                    });
                  }
                },
                label: 'Choose your location',
                loading: loading,
                bgColor: blue,
                curve: 12,
                labelStyle:
                    bodyStyle(context: context, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
