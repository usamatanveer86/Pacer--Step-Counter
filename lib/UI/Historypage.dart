import 'dart:developer' as dev;
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/myproviders.dart';
import '/Widgets/TextWidget.dart';
import '/Widgets/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List<_ChartData> datax;
  String? currentweekstartdate;
  String? currentweekenddate;
  late List<_ChartData> datay;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    // datax = [
    //   _ChartData('MON', 12),
    //   _ChartData('TUE', 24),
    //   _ChartData('WED', 30),
    //   _ChartData('THR', 6.4),
    //   _ChartData('FRI', 23),
    //   _ChartData('SAT', 13),
    //   _ChartData('SUN', 22)
    // ];
    // datay = [
    //   _ChartData('MON', 45),
    //   _ChartData('TUE', 3),
    //   _ChartData('WED', 4),
    //   _ChartData('THR', 9),
    //   _ChartData('FRI', 12),
    //   _ChartData('SAT', 3),
    //   _ChartData('SUN', 3)
    // ];

    super.initState();
    currentweekenddate = findLastDateOfTheWeek(DateTime.now()).toString();
    currentweekstartdate = findFirstDateOfTheWeek(DateTime.now()).toString();
    _tooltip = TooltipBehavior(enable: true);
    iconindex = 0;
    datax = [];
    datay = [];
    buildlist();
    _refreshItems("calories");
  }

  List items = [];
  buildlist() {
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
    items = data.reversed.toList();
    setState(() {});
    log(findLastDateOfTheWeek(DateTime.now()).toString());
    log(findFirstDateOfTheWeek(DateTime.now()).toString());
  }

  _refreshItems(String whichone) async {
    bool isfound = false;
    datax = [];
    datay = [];
    for (int i = 0; i < dayss.length; i++) {
      for (int j = 0; j < items.length; j++) {
        if (currentweekstartdate.toString().split(" ")[0] ==
                items[j]["weekstartdate"].toString().split(" ")[0] &&
            currentweekenddate.toString().split(" ")[0] ==
                items[j]["weekenddate"].toString().split(" ")[0]) {
          if (dayss[i] == items[j]["day"]) {
            datax.add(_ChartData(items[j]["day"].toString().substring(0, 3),
                double.parse(items[j][whichone])));
            datay.add(_ChartData(items[j]["day"].toString().substring(0, 3),
                items[j]["progress"]));
            isfound = true;
            break;
          } else {
            isfound = false;
          }
        }
      }
      if (isfound == false) {
        datax.add(_ChartData(dayss[i].toString().substring(0, 3), 0));
        datay.add(_ChartData(dayss[i].toString().substring(0, 3), 0));
      }
    }

    setState(() {});
    log(items.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(backgroundColor: bgcolor),
      body: Consumer<timepro>(builder: (context, value, child) {
        return GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! > 0) {
              if (value.myselectedindex == 0) {
              } else {
                dev.log((value.myselectedindex--).toString());
                value.swipe(value.myselectedindex--);
              }
              // User swiped Left
            } else if (details.primaryVelocity! < 0) {
              if (value.myselectedindex == 4) {
              } else {
                dev.log((value.myselectedindex++).toString());
                value.swipe(value.myselectedindex++);
              }

              // User swiped Right
            }
          },
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/home_bg.png"),
                    fit: BoxFit.fill)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(children: [
                Row(
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
                    textwidget(
                      "History",
                      Colors.white,
                      () {},
                      size: 28,
                    ),
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: bgcolor,
                      child: const Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < allhistory.length; i++) ...[
                      InkWell(
                        onTap: () {
                          index = i;
                          if (index == 0) {
                            value.myselectedindex = 2;
                            value.swipe(2);
                          } else if (index == 1) {
                            iconindex = i;
                            if (iconindex == 0) {
                              _refreshItems("calories");
                            } else if (iconindex == 1) {
                              _refreshItems("steps");
                            } else {
                              _refreshItems("distance");
                            }
                            setState(() {});

                            // datax = [
                            //   _ChartData('MON', 12),
                            //   _ChartData('TUE', 24),
                            //   _ChartData('WED', 30),
                            //   _ChartData('THR', 6.4),
                            //   _ChartData('FRI', 23),
                            //   _ChartData('SAT', 13),
                            //   _ChartData('SUN', 22)
                            // ];
                            // datay = [
                            //   _ChartData('MON', 45),
                            //   _ChartData('TUE', 3),
                            //   _ChartData('WED', 4),
                            //   _ChartData('THR', 9),
                            //   _ChartData('FRI', 12),
                            //   _ChartData('SAT', 3),
                            //   _ChartData('SUN', 3)
                            // ];
                          } else if (index == 2) {
                            data();
                          } else {
                            yearlydata();
                          }

                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: barcolor,
                          ),
                          height: 3.8.h,
                          width: 9.8.h,
                          child: Center(
                            child: Text(
                              allhistory[i],
                              style: TextStyle(
                                  color:
                                      index == i ? Colors.green : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      )
                    ]
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6.5.h,
                        // width: 50.w,
                        decoration: BoxDecoration(
                            color: barcolor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.green,
                              ),
                              textwidget(
                                  "${currentweekstartdate!.split(" ")[0]} - ${currentweekenddate!.split(" ")[0]}",
                                  Colors.green,
                                  () {},
                                  size: 18),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.green.withOpacity(.6),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Expanded(
                  child: SizedBox(
                      height: 38.h,
                      child: Container(
                        color: barcolor,
                        child: InteractiveViewer(
                          child: SfCartesianChart(
                              zoomPanBehavior: ZoomPanBehavior(
                                  enableSelectionZooming: true,
                                  selectionRectBorderColor: Colors.red,
                                  selectionRectBorderWidth: 1,
                                  selectionRectColor: Colors.grey),
                              primaryXAxis: CategoryAxis(
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                borderColor: Colors.transparent,
                                majorGridLines: const MajorGridLines(width: 0),
                                minorGridLines: const MinorGridLines(width: 0),
                              ),
                              primaryYAxis: NumericAxis(
                                  minimum: 0,
                                  maximum: 40,
                                  interval: 10,
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                  minorGridLines:
                                      const MinorGridLines(width: 0),
                                  labelStyle:
                                      const TextStyle(color: Colors.white)),
                              tooltipBehavior: _tooltip,
                              series: <ChartSeries<_ChartData, String>>[
                                ColumnSeries<_ChartData, String>(
                                    width: .3,
                                    // spacing: 1.5,
                                    dataSource: datax,
                                    xValueMapper: (_ChartData data, _) =>
                                        data.x,
                                    yValueMapper: (_ChartData data, _) =>
                                        data.y,
                                    name: 'Goal',
                                    color: Colors.green),
                                ColumnSeries<_ChartData, String>(
                                    width: .3,
                                    // spacing: 1.5,
                                    dataSource: datay,
                                    xValueMapper: (_ChartData data, _) =>
                                        data.x,
                                    yValueMapper: (_ChartData data, _) =>
                                        data.y,
                                    name: "Progress",
                                    color: Colors.pink[300]),
                              ]),
                        ),
                      )),
                ),
                Container(
                  color: barcolor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.green,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          textwidget("Goal", Colors.white, () {})
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.pink[300],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          textwidget("Progress", Colors.white, () {})
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1.h,
                  color: barcolor,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < icons.length; i++) ...[
                      InkWell(
                        onTap: () {
                          iconindex = i;
                          if (iconindex == 0) {
                            _refreshItems("calories");
                          } else if (iconindex == 1) {
                            _refreshItems("steps");
                          } else {
                            _refreshItems("distance");
                          }
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: bgcolor,
                          child: CircleAvatar(
                            backgroundColor: barcolor,
                            radius: 18,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                icons[i],
                                color: iconindex == i
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: barcolor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Total Calories Burnt:\t\t\t 0',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: 'poppins',
                            ),
                          ),
                          Text(
                            'Total Steps Taken:\t\t\t 0',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: 'poppins'),
                          ),
                          Text(
                            'Total Distance Covered:\t\t\t 0',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: 'poppins'),
                          ),
                          Text(
                            'Average Calories Burnt:\t\t\t 0',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: 'poppins'),
                          ),
                        ]),
                  ),
                ),
              ]),
            ),
          ),
        );
      }),
    );
  }

  List allhistory = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  data() {
    datax = [];
    datay = [];
    for (int i = 0; i < 30; i++) {
      datax.add(_ChartData(i.toString(), 12));
      datay.add(_ChartData(i.toString(), 8));
    }
    setState(() {});
  }

  yearlydata() {
    datax = [];
    datay = [];
    for (int i = 0; i < months.length; i++) {
      datax.add(_ChartData(months[i].toString(), 5));
      datay.add(_ChartData(months[i].toString(), 8));
    }
  }

  int index = 1;
}

int iconindex = 0;
List icons = [
  'assets/images/fire.png',
  "assets/images/foot_steps.PNG",
  'assets/images/distance_roadview.PNG'
];

List months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
