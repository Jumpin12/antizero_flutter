import 'package:flutter/material.dart';

DateTime join(DateTime date, TimeOfDay time) {
  return new DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
