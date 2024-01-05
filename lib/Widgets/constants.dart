import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

Color bgcolor = const Color(0xff285682);
Color barcolor = const Color.fromARGB(255, 11, 36, 58);
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
String status = 'static', steps = '--';
String calories = '0';
String distance = '0';

var goalbox = Hive.box("goal");
List dayss = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

DateTime findLastDateOfTheWeek(DateTime dateTime) {
  return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
}

DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday - 1));
}

DateTime findFirstDateOfTheYear(DateTime dateTime) {
  return DateTime(dateTime.year, 1, 1);
}

DateTime findLastDateOfTheYear(DateTime dateTime) {
  return DateTime(dateTime.year, 12, 31);
}
