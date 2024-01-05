import 'package:flutter/cupertino.dart';

class myindex extends ChangeNotifier {
  int myselectedindex = 2;
  selectedindex(int index) {
    myselectedindex = index;
    notifyListeners();
  }
}
