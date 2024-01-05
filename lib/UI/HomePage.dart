import 'dart:developer';

import 'package:flutter/material.dart';
import '../controller/myproviders.dart';
import '/UI/PerformancePage.dart';
import '/UI/GoalPage.dart';
import '/UI/Historypage.dart';
import '/UI/WidgetsPage.dart';
import '/Widgets/TextWidget.dart';
import '/Widgets/constants.dart';
import '/pro/myindex.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'TrackPage.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  Color selectedcolor = Colors.green;
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<myindex>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgcolor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 7.h, // Set this height
          flexibleSpace: Column(
            children: [
              Container(
                color: Colors.white,
                child: textwidget("Advertisment", Colors.black, () {}),
              ),
            ],
          ),
        ),
        body: Consumer<timepro>(builder: (context, value, child) {
          return value.myselectedindex == 0
              ? const WidgetsPage()
              : value.myselectedindex == 1
                  ? const Trackpage()
                  : value.myselectedindex == 2
                      ? const Performancepage()
                      : value.myselectedindex == 3
                          ? const Goalpage()
                          : const HistoryPage();
        }),
        bottomNavigationBar: Container(
          height: 10.h,
          color: Colors.transparent,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    color: bgcolor,
                    height: 3.h,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    color: const Color.fromARGB(255, 11, 36, 58),
                    height: 7.h,
                  ),
                ],
              ),
              Consumer<timepro>(builder: (context, value, child) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      color: Colors.transparent,
                      height: 10.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textwidget(
                              "\nWidgets",
                              value.myselectedindex == 0
                                  ? selectedcolor
                                  : Colors.white, () {
                            value.myselectedindex = 0;
                            value.swipe(0);
                          }),
                          textwidget(
                              "\nTrack",
                              value.myselectedindex == 1
                                  ? selectedcolor
                                  : Colors.white, () {
                            value.myselectedindex = 1;
                            value.swipe(1);
                          }),
                          InkWell(
                            onTap: () {
                              value.myselectedindex = 2;
                              value.swipe(2);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(bottom: 8),
                              height: 10.h,
                              width: 10.h,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: value.myselectedindex == 2
                                      ? selectedcolor
                                      : const Color.fromARGB(255, 11, 36, 58),
                                  border: Border.all(
                                      color: bgcolor,
                                      width: value.myselectedindex == 2
                                          ? 0.0
                                          : 2.0)),
                              child: Image.asset("assets/images/ic_shoes.PNG"),
                            ),
                          ),
                          textwidget(
                              "\nGoal",
                              value.myselectedindex == 3
                                  ? selectedcolor
                                  : Colors.white, () {
                            log("");
                            value.swipe(3);
                          }),
                          textwidget(
                              "\nHistory",
                              value.myselectedindex == 4
                                  ? selectedcolor
                                  : Colors.white, () {
                            log("");
                            value.swipe(4);
                          }),
                        ],
                      ),
                    )
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
