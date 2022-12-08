import 'package:geocoding/geocoding.dart';

int getAgeFromDob(DateTime dob) {
  int age;
  if (DateTime.now().month - dob.month > 0) {
    age = DateTime.now().year - dob.year;
  } else if (DateTime.now().month - dob.month < 0) {
    age = (DateTime.now().year - dob.year) - 1;
  } else {
    if (DateTime.now().day - dob.day >= 0) {
      age = DateTime.now().year - dob.year;
    } else {
      age = (DateTime.now().year - dob.year) - 1;
    }
  }
  return age;
}

// ignore: non_constant_identifier_names
Future<String> getAddressFromLatLng({double Lat, double Long}) async {
  try {
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(Lat, Long, localeIdentifier: 'en_US');
    Placemark place = placeMarks[0];
    String state;
    String country;

    if (place != null) {
      if (place.locality != null && place.locality.trim() != "") {
        state = place.locality;
      } else {
        state = "N/A";
      }

      await Future.delayed(Duration(seconds: 2));

      if (place.country != null && place.country != "") {
        country = place.country;
      } else {
        country = "N/A";
      }
    } else {
      return null;
    }

    return "$state, $country";
  } catch (e) {
    print(e);
    return null;
  }
}
