import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '/UI/speedometer.dart';
import '/Widgets/constants.dart';
import '/controller/myproviders.dart';
import '/controller/weatherapi.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../Widgets/TextWidget.dart';
import 'dart:math' as math;

class WidgetsPage extends StatefulWidget {
  const WidgetsPage({super.key});

  @override
  State<WidgetsPage> createState() => _WidgetsPageState();
}

class _WidgetsPageState extends State<WidgetsPage> {
  double temp = 0;
  late Timer timer;
  GeolocatorPlatform locator = GeolocatorPlatform.instance;

  var humdity;
  var sun_rise;
  var sun_set;
  var convert_sunrise;
  var convert_sunset;
  double? gaugeBegin;
  double? gaugeEnd;
  double? velocity;
  var maxVelocity = 100.0;
  var velocityUnit = 'm/s';
  String weather = "";

  /// Stream that emits values when velocity updates
  late StreamController<double?> _velocityUpdatedStreamController;

  /// Current Velocity in m/s
  double? _velocity;
  var unit = 'm/s';

  /// Highest recorded velocity so far in m/s.
  double? _highestVelocity;

  /// Velocity in m/s to km/hr converter
  double mpstokmph(double mps) => mps * 18 / 5;

  /// Velocity in m/s to miles per hour converter
  double mpstomilesph(double mps) => mps * 85 / 38;
  void _onAccelerate(double speed) {
    locator.getCurrentPosition().then(
      (Position updatedPosition) {
        _velocity = (speed + updatedPosition.speed) / 2;
        if (_velocity! > _highestVelocity!) _highestVelocity = _velocity;
        _velocityUpdatedStreamController.add(_velocity);
      },
    );
  }

  double? convertedVelocity(double? velocity) {
    velocity = velocity ?? _velocity;

    if (unit == 'm/s') {
      return velocity;
    }

    return velocity;
  }

  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    var pro = Provider.of<timepro>(context, listen: false);
    loading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer.periodic(const Duration(minutes: 1), (Timer) {
        pro.datetimeis();
      });
    });

    getcurrentlocation();

    super.initState();
    _velocityUpdatedStreamController = StreamController<double?>();
    locator
        .getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation,
          ),
        )
        .listen(
          (Position position) => _onAccelerate(position.speed),
        );

    // Set velocities to zero when app opens
    _velocity = 0;
    _highestVelocity = 0.0;
  }

  getapi(var lat, var long) async {
    await getweather(lat, long);
    temp = maindata["temp"] - 273;
    humdity = maindata["humidity"];
    weather = wetherdata[0]["icon"];
    sun_rise = sys_data["sunrise"];
    sun_set = sys_data["sunset"];

    convert_sunrise = DateTime.fromMillisecondsSinceEpoch(sun_rise * 1000);
    convert_sunset = DateTime.fromMillisecondsSinceEpoch(sun_set * 1000);

    log(weather.toString());
    log(convert_sunrise.toString());
    log(sun_set.toString());

    if (loading == false && mounted) {
      setState(() {});
    }
  }

  var _currentAddress = '';
  getcurrentlocation() async {
    await Permission.location.request().then((value) => null);
    Position position = await Geolocator.getCurrentPosition();
    log(position.latitude.toString());
    log(position.longitude.toString());
    getapi(position.latitude, position.longitude);
    _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      if (mounted) {
        setState(() {
          _currentAddress =
              '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}${place.country}';
        });
      }
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<timepro>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: bgcolor,
      ),
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
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/home_bg.png"),
                    fit: BoxFit.fill)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    textwidget("Widgets", Colors.white, () {}, size: 25),
                    const SizedBox()
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Row(
                  children: [
                    Container(
                      height: 12.h,
                      width: 45.w,
                      decoration: boxdecoration,
                      child: Column(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 2.h,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 10.w,
                                height: 6.h,
                                child: loading
                                    ? null
                                    : Image.network(
                                        "https://openweathermap.org/img/w/$weather.png"),
                              ),
                              SizedBox(
                                width: 3.w,
                              ),
                              Center(
                                  child: Text(
                                loading
                                    ? "--C"
                                    : "${temp.toStringAsFixed(2)} °C",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Humidity:",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                loading ? "--" : "$humdity%",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 3.w,
                      ),
                    ),
                    Container(
                      height: 12.h,
                      width: 45.w,
                      // alignment: Alignment.center,
                      decoration: boxdecoration,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textwidget(
                                pro.datetime.toString(), Colors.white, () {},
                                size: 24),
                            Row(
                              children: [
                                textwidget(
                                    'SunRise: ', Colors.white, size: 16, () {}),
                                textwidget(
                                    loading
                                        ? "---"
                                        : '$convert_sunrise'
                                            .split(" ")[1]
                                            .split(".")[0]
                                            .toString()
                                            .substring(0, 5),
                                    Colors.white,
                                    size: 16,
                                    () {}),
                                textwidget("\tAM", Colors.white, () {}),
                              ],
                            ),
                            Row(
                              children: [
                                textwidget(
                                    'SunSet: ', Colors.white, size: 16, () {}),
                                textwidget(
                                  loading
                                      ? "---"
                                      : '$convert_sunset'
                                          .split(" ")[1]
                                          .split(".")[0]
                                          .toString()
                                          .substring(0, 5),
                                  Colors.white,
                                  () {},
                                  size: 16,
                                ),
                                textwidget("\tPM", Colors.white, () {}),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Container(
                  alignment: Alignment.center,
                  height: 8.h,
                  width: double.infinity,
                  decoration: boxdecoration,
                  child: textwidget(_currentAddress, Colors.white, () {}),
                ),
                SizedBox(
                  height: 2.h,
                ),
                buildCompass(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    height: 22.h,
                    width: 50.w,
                    child: getRadialGauge(),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        double? direction = snapshot.data!.heading;

        // if direction is null, then device does not support this sensor
        // show error message
        if (direction == null) {
          return const Center(
            child: Text("Device does not have sensors !"),
          );
        }

        return Row(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    elevation: 4,
                    child: Container(
                      height: 20.h,
                      width: 43.w,
                      padding: const EdgeInsets.all(12.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xff285682),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color.fromARGB(255, 11, 36, 58),
                              width: 1)),
                      child: Transform.rotate(
                        angle: (direction * (math.pi / 180) * -1),
                        child: Image.asset(
                          'assets/images/compass.PNG',
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    'DIRECTION',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  Widget getRadialGauge() {
    return StreamBuilder<Object?>(
        stream: _velocityUpdatedStreamController.stream,
        builder: (context, snapshot) {
          return Speedometer(
            gaugeBegin: 0,
            gaugeEnd: 30,
            velocity: convertedVelocity(_velocity),
            maxVelocity: convertedVelocity(_highestVelocity),
            velocityUnit: 'km/h',
          );
        });
  }
}
