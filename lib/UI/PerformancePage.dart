import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/myproviders.dart';
import '/Widgets/TextWidget.dart';
import '/Widgets/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

class Performancepage extends StatefulWidget {
  const Performancepage({super.key});

  @override
  State<Performancepage> createState() => _PerformancepageState();
}

class _PerformancepageState extends State<Performancepage> {
  bool trackingstatus = true;
  var completed = "---";
  var stepsgoal;
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  var datetime;
  var dayofweek;
  String? day;
  @override
  void initState() {
    super.initState();

    permission();
    Future.delayed(const Duration(seconds: 3), () {
      checkcalories();
    });

    // _refreshItems();
  }

  checkcalories() async {
    if (steps == "--") {
      log("stesdbhbdbdj");
    } else {
      datetime = DateTime.now();
      dayofweek = DateTime.now().weekday;
      day = dayslist[dayofweek - 1];

      final data = goalbox.keys.map((key) {
        final value = goalbox.get(key);
        return {
          "key": key,
          "calories": value["calories"],
          "steps": value["steps"],
          "distance": value["distance"],
          "day": value["day"],
          "date": value["date"]
        };
      }).toList();
      for (int i = 0; i < data.length; i++) {
        if (day == data[i]["day"] &&
            datetime.toString().split(" ")[0] ==
                data[i]["date"].toString().split(" ")[0]) {
          stepsgoal = data[i]["steps"];
          if (steps == "--") {
          } else {
            if (double.parse(stepsgoal.toString()) <
                double.parse(steps.toString())) {
              completed = 100.toString();
            } else if (double.parse(stepsgoal.toString()) >
                double.parse(steps.toString())) {
              completed = (double.parse(steps) *
                      100 /
                      double.parse(stepsgoal.toString()))
                  .toStringAsFixed(2);
            }
          }

          log("sddssd$stepsgoal");
        }
      }
      log(data.toString());
      var caloriess = int.parse(steps.toString()) / 25;
      calories = caloriess.toString();
      var distancee = int.parse(steps.toString()) / 1000;
      distance = distancee.toString();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("Steps", steps);

      log(prefs.getString("Steps").toString());
      if (mounted) {
        setState(() {});
      }
    }
  }

  // _refreshItems() async {
  //   final data = goalbox.keys.map((key) {
  //     final value = goalbox.get(key);
  //     return {
  //       "key": key,
  //       "calories": value["calories"],
  //       "steps": value["steps"],
  //       "distance": value["distance"],
  //       "day": value["day"],
  //       "date": value["date"]
  //     };
  //   }).toList();

  //   setState(() {
  //     _items = data.reversed.toList();
  //     // we use "reversed" to sort items in order from the latest to the oldest
  //   });
  //   for (int i = 0; i < _items.length; i++) {}
  //   log(_items.toString());
  // }

  permission() async {
    await Permission.activityRecognition
        .request()
        .then((value) => initPlatformState());
  }

  void onStepCount(StepCount event) {
    if (trackingstatus == true) {
      checkcalories();
      print(event);
      if (mounted) {
        setState(() {
          steps = event.steps.toString();
        });
      }
    } else {}
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    if (trackingstatus == true) {
      print(event);
      if (mounted) {
        setState(() {
          status = event.status;
        });
      }
    } else {}
  }

  void onPedestrianStatusError(error) {
    debugPrint('onPedestrianStatusError: $error');
    setState(() {
      status = 'Pedestrian Status not available';
    });
    debugPrint(status);
  }

  void onStepCountError(error) {
    debugPrint('onStepCountError: $error');
    setState(() {
      steps = 'Step Count not available';
    });
  }

  initPlatformState() {
    if (trackingstatus == true) {
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _pedestrianStatusStream
          .listen(onPedestrianStatusChanged)
          .onError(onPedestrianStatusError);
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Consumer<timepro>(builder: (context, value, child) {
        return GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! > 0) {
              log("swipe right");
              if (value.myselectedindex == 0) {
              } else {
                log((value.myselectedindex--).toString());
                value.swipe(value.myselectedindex--);
              }
              // User swiped Left
            } else if (details.primaryVelocity! < 0) {
              if (value.myselectedindex == 4) {
              } else {
                log((value.myselectedindex++).toString());
                value.swipe(value.myselectedindex++);
              }

              log("swipe left");
              // User swiped Right
            }
          },
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/home_bg.png"),
                    fit: BoxFit.fill)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            scaffoldKey.currentState!.openDrawer();
                          },
                          child: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        textwidget("Performance", Colors.white, () {
                          checkcalories();
                        }, size: 25),
                        InkWell(
                          onTap: () {
                            if (trackingstatus == false) {
                              trackingstatus = true;
                              setState(() {});
                              EasyLoading.showToast("Pacer is tracking steps");
                            } else {
                              Get.defaultDialog(
                                  backgroundColor: bgcolor,
                                  title: "Turn Off",
                                  middleTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "poppins"),
                                  titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "poppins"),
                                  middleText:
                                      "Are you Sure you want to Turn Off Tracking",
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          EasyLoading.showToast(
                                              "Tracking turned off");
                                          trackingstatus = false;
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Yes")),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("No"))
                                  ]).then((value) {
                                setState(() {});
                              });
                            }
                          },
                          child: CircleAvatar(
                            radius: 26,
                            backgroundColor: bgcolor,
                            child: const Icon(
                              CupertinoIcons.power,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    height: 8.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: barcolor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.green,
                        ),
                        textwidget("Today", Colors.green, () {}, size: 20),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.green.withOpacity(.4),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  //circular chart
                  Container(
                    padding: const EdgeInsets.all(20),
                    height: 34.h,
                    // width: 37.h,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: barcolor),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularPercentIndicator(
                          animation: true,
                          animationDuration: 90,
                          radius: 110,
                          lineWidth: 7.5,
                          percent:
                              completed == "---" || completed == 100.toString()
                                  ? 0.8
                                  : (double.parse(completed) / 125),
                          startAngle: 216,
                          progressColor: Colors.white,
                          backgroundColor: Colors.transparent,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        textwidget1("$steps\nSteps", Colors.white, () {},
                            size: 28),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: textwidget1(
                                "$completed %\nCompleted", Colors.green, () {},
                                size: 17),
                          ),
                        )
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                status == 'walking' ? Colors.green : barcolor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                status == 'walking'
                                    ? 'assets/images/man_walk.PNG'
                                    : 'assets/images/man_static.PNG',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            status == 'walking' ? 'Walking' : 'Static',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.green.shade600,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/location_ok.PNG',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Text(
                            'Tracking',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ],
                  ),

                  const Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Dedicated step sensor activated",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w700,
                            color: Colors.green),
                      ),
                      SizedBox(width: 1.w),
                      const Icon(
                        Icons.help,
                        color: Colors.white,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.3.h),
                    child: Container(
                      height: 8.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: barcolor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textwidget('$distance Km', Colors.green, () {},
                                    size: 22),
                                textwidget('Distance', Colors.white, () {},
                                    size: 16),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textwidget(
                                    '$calories Kcal', Colors.green, () {},
                                    size: 20),
                                textwidget('Calories', Colors.white, () {},
                                    size: 16),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textwidget('0h 0m', Colors.green, () {},
                                    size: 20),
                                textwidget('Duration', Colors.white, () {},
                                    size: 16),
                              ],
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  List dayslist = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
}
