import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Widgets/TextWidget.dart';
import '../Widgets/constants.dart';
import '../controller/myproviders.dart';

class Goalpage extends StatefulWidget {
  const Goalpage({super.key});

  @override
  State<Goalpage> createState() => _GoalpageState();
}

class _GoalpageState extends State<Goalpage> {
  List textfieldvalues = [];

  int? foundindex;
  double maxheight = 150.0;
  List _items = [];
  Future<void> createItem(Map<String, dynamic> newItem) async {
    await goalbox.add(newItem); // update the UI
  }

  _refreshItems() async {
    final data = goalbox.keys.map((key) {
      final value = goalbox.get(key);
      return {
        "key": key,
        "calories": value["calories"],
        "steps": value["steps"],
        "distance": value["distance"],
        "day": value["day"],
        "date": value["date"],
        "progress": value["progress"],
        "weekstartdate": value["weekstartdate"],
        "weekenddate": value["weekenddate"]
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();
      // we use "reversed" to sort items in order from the latest to the oldest
    });
    log(_items.toString());
  }

  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  @override
  void initState() {
    calories.text = 0.toString();
    steps.text = 0.toString();
    distance.text = 0.toString();
    super.initState();
    getdata();
    log(findLastDateOfTheYear(DateTime.now()).toString());
    data = [
      // _ChartData('Mon', 0),
      // _ChartData('Tue', 0),
      // _ChartData('Wed', 0),
      // _ChartData('Thu', 0),
      // _ChartData('Fri', 0),
      // _ChartData("Sat", 0),
      // _ChartData("Sun", 0)
    ];
    _tooltip = TooltipBehavior(enable: true);
  }

  serach(String day) {
    for (int i = 0; i < _items.length; i++) {
      if (day == _items[i]["day"]) {
        foundindex = i;
        return true;
      }
    }
    return false;
  }

  getdata() async {
    await _refreshItems();
    data = [];
    for (int i = 0; i < dayss.length; i++) {
      if (serach(dayss[i])) {
        data.add(_ChartData(
            _items[foundindex!]["day"].toString().substring(0, 3),
            double.parse(_items[foundindex!]["calories"])));
        if (maxheight < double.parse(_items[foundindex!]["calories"])) {
          maxheight = double.parse(_items[foundindex!]["calories"]) + 100.0;
        } else {
          //  maxheight = double.parse(_items[foundindex!]["calories"]) + 100.0;
        }
        textfieldvalues.add(double.parse(_items[foundindex!]["calories"]));
      } else {
        data.add(_ChartData(dayss[i].toString().substring(0, 3), 0.0));
        textfieldvalues.add(0.0);
      }
    }
    calories.text = textfieldvalues[index].toStringAsFixed(2);
    steps.text = (textfieldvalues[index] * 25).toStringAsFixed(0);
    distance.text = (textfieldvalues[index] / 57).toStringAsFixed(2);
    setState(() {});
    // for (int i = 0; i < _items.length; i++) {
    //   data.add(_ChartData(_items[i]["day"].toString().substring(0, 3),
    //       double.parse(_items[i]["calories"])));
    // }
  }

  var calories = TextEditingController();
  var steps = TextEditingController();
  var distance = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Consumer<timepro>(builder: (context, value, child) {
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
            onTap: () {
              FocusManager.instance.primaryFocus!.unfocus();
            },
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/home_bg.png"),
                      fit: BoxFit.fill)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            // scaffoldKey.currentState!.openDrawer();
                          },
                          child: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        textwidget("Goal Settings", Colors.white, () {},
                            size: 25),
                        InkWell(
                          onTap: () async {
                            // for (var item in _items) {
                            //   goalbox.delete(item["key"]);
                            // }

                            if (_items.isEmpty) {
                              createItem({
                                "calories": calories.text.toString(),
                                "steps": steps.text.toString(),
                                "distance": distance.text.toString(),
                                "day": dayss[index],
                                "date": DateTime.now(),
                                "progress": 0.0,
                                "weekstartdate":
                                    findFirstDateOfTheWeek(DateTime.now())
                                        .toString(),
                                "weekenddate":
                                    findLastDateOfTheWeek(DateTime.now())
                              });
                            } else if (_items.isNotEmpty) {
                              bool isenterd = false;
                              for (var item in _items) {
                                if (item["day"] == dayss[index]) {
                                  isenterd = true;
                                  goalbox.delete(item["key"]);
                                  createItem({
                                    "calories": calories.text.toString(),
                                    "steps": steps.text.toString(),
                                    "distance": distance.text.toString(),
                                    "day": dayss[index],
                                    "date": DateTime.now(),
                                    "progress": 0.0,
                                    "weekstartdate":
                                        findFirstDateOfTheWeek(DateTime.now())
                                            .toString(),
                                    "weekenddate":
                                        findLastDateOfTheWeek(DateTime.now())
                                  });
                                }
                              }
                              if (isenterd) {
                              } else {
                                createItem({
                                  "calories": calories.text.toString(),
                                  "steps": steps.text.toString(),
                                  "distance": distance.text.toString(),
                                  "day": dayss[index],
                                  "date": DateTime.now(),
                                  "progress": 0.0,
                                  "weekstartdate":
                                      findFirstDateOfTheWeek(DateTime.now())
                                          .toString(),
                                  "weekenddate":
                                      findLastDateOfTheWeek(DateTime.now())
                                });
                              }
                            }
                            textfieldvalues[index] =
                                double.parse(calories.text.toString());
                            await getdata();
                          },
                          child: CircleAvatar(
                            radius: 26,
                            backgroundColor: bgcolor,
                            child: const Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < days.length; i++) ...[
                          InkWell(
                            onTap: () {
                              calories.text =
                                  textfieldvalues[i].toStringAsFixed(2);
                              steps.text =
                                  (textfieldvalues[i] * 25).toStringAsFixed(0);
                              distance.text =
                                  (textfieldvalues[i] / 57).toStringAsFixed(2);
                              index = i;
                              setState(() {});
                            },
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor:
                                  index == i ? Colors.green : barcolor,
                              child: Text(days[i]),
                            ),
                          ),
                        ]
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          height: 5.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                              color: barcolor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12))),
                          child: const Text(
                            "Calories(Kcal)",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.only(left: 6),
                              height: 5.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                  color: barcolor,
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(12))),
                              child: TextField(
                                style: const TextStyle(color: Colors.white),
                                controller: calories,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (calories.text.isEmpty) {
                                    steps.text = '0.0';
                                    distance.text = '0.0';
                                  } else {
                                    steps.text = (double.parse(value) * 25)
                                        .toStringAsFixed(0);
                                    distance.text = (double.parse(value) / 57)
                                        .toStringAsFixed(2);
                                    log(distance.text.toString());
                                  }
                                },
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: .5.h,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          height: 5.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                            color: barcolor,
                          ),
                          child: const Text(
                            "Steps",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.only(left: 6),
                              height: 5.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                color: barcolor,
                              ),
                              child: TextField(
                                style: const TextStyle(color: Colors.white),
                                controller: steps,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    labelStyle: TextStyle(color: Colors.white)),
                                onChanged: (value) {
                                  if (steps.text.isEmpty) {
                                    calories.text = '0.0';
                                    distance.text = '0.0';
                                  } else {
                                    calories.text = (double.parse(value) / 25)
                                        .toStringAsFixed(2);
                                    distance.text = (double.parse(value) / 1400)
                                        .toStringAsFixed(2);
                                  }
                                },
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: .5.h,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          height: 5.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                              color: barcolor,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12))),
                          child: const Text(
                            "Distance(Km)",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.only(left: 6),
                              height: 5.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                  color: barcolor,
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(12))),
                              child: TextField(
                                style: const TextStyle(color: Colors.white),
                                controller: distance,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    labelStyle: TextStyle(color: Colors.white)),
                                onChanged: (value) {
                                  if (distance.text.isEmpty) {
                                    steps.text = '0.0';
                                    calories.text = '0.0';
                                  } else {
                                    steps.text = (double.parse(value) * 1428.54)
                                        .toStringAsFixed(0);
                                    calories.text =
                                        (double.parse(value) * 57.15)
                                            .toStringAsFixed(2);
                                  }
                                },
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: barcolor),
                      child: SfCartesianChart(
                          plotAreaBorderColor: Colors.transparent,
                          primaryXAxis: CategoryAxis(
                              borderColor: Colors.transparent,
                              majorGridLines: const MajorGridLines(width: 0),
                              minorGridLines: const MinorGridLines(width: 0),
                              labelStyle: const TextStyle(color: Colors.white)),
                          primaryYAxis: NumericAxis(
                              borderColor: Colors.transparent,
                              minimum: 0,
                              maximum: maxheight,
                              majorGridLines: const MajorGridLines(width: 0),
                              minorGridLines: const MinorGridLines(width: 0),
                              axisLine: const AxisLine(width: 0),
                              labelStyle: const TextStyle(color: Colors.white)),
                          tooltipBehavior: _tooltip,
                          series: <ChartSeries<_ChartData, String>>[
                            ColumnSeries<_ChartData, String>(
                                dataSource: data,
                                xValueMapper: (_ChartData data, _) => data.x,
                                yValueMapper: (_ChartData data, _) => data.y,
                                name: "Calories",
                                color: Colors.green)
                          ]),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  List days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  int index = 0;
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
