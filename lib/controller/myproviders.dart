import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Widgets/constants.dart';

class timepro extends ChangeNotifier {
  int myselectedindex = 2;
  var datetime = DateFormat('hh:mm a').format(DateTime.now());
  datetimeis() {
    datetime = DateFormat('hh:mm a').format(DateTime.now());

    notifyListeners();
  }

  swipe(int index) {
    myselectedindex = index;
    log(myselectedindex.toString());
    notifyListeners();
  }
}
