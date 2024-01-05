import 'dart:developer';
import 'package:get/get.dart';

import '/controller/myproviders.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Widgets/TextWidget.dart';
import '../Widgets/constants.dart';

class Trackpage extends StatefulWidget {
  const Trackpage({super.key});

  @override
  State<Trackpage> createState() => _TrackpageState();
}

class _TrackpageState extends State<Trackpage> {
  final Set<Polyline> polyline = {};
  double zoom = 16;
  bool loading = true;
  final Location _location = Location();
  GoogleMapController? _mapController;
  final LatLng _center = const LatLng(33.5641, 73.1659);
  List<LatLng> route = [];
  MapType mapType = MapType.normal;

  // final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    zoom = 16;
  }

  @override
  void dispose() {
    super.dispose();
    _mapController?.dispose();
    // await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  void _onMapCreated(GoogleMapController controller) {
    loading = false;
    _mapController = controller;
    // double appendDist;

    _location.onLocationChanged.listen((event) {
      LatLng loc = LatLng(event.latitude!, event.longitude!);
      _mapController?.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: loc,
        zoom: zoom,
      )));

      // Marker _createMarker() {
      //   if (_markerIcon != null) {
      //     return Marker(
      //       markerId: const MarkerId('marker_1'),
      //       position: loc,
      //       icon: _markerIcon!,
      //     );
      //   } else {
      //     return Marker(
      //       markerId: const MarkerId('marker_1'),
      //       position: loc,
      //     );
      //   }
      // }

      polyline.add(Polyline(
          polylineId: PolylineId(event.toString()),
          visible: true,
          points: route,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          color: Colors.deepOrange));
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        backgroundColor: bgcolor,
      ),
      body: Consumer<timepro>(builder: (context, value, child) {
        return Container(
          height: double.infinity,
          // width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/home_bg.png"),
                  fit: BoxFit.fill)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
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
                    textwidget("Track", Colors.white, () {}, size: 25),
                    SizedBox(
                      width: 4.w,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          height: 55.h,
                          child: GoogleMap(
                            mapType: mapType,
                            trafficEnabled: true,
                            polylines: polyline,
                            zoomControlsEnabled: true,
                            onMapCreated: _onMapCreated,
                            myLocationEnabled: true,
                            minMaxZoomPreference:
                                const MinMaxZoomPreference(10, 35),
                            onCameraMove: (CameraPosition cameraPosition) {
                              log(cameraPosition.zoom.toString());
                              zoom = cameraPosition.zoom;
                              setState(() {});
                            },
                            initialCameraPosition: CameraPosition(
                              target: _center,
                              zoom: zoom,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: !loading,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 60, right: 10),
                              child: InkWell(
                                onTap: () {
                                  Get.defaultDialog(
                                      title: 'Choose Map Type',
                                      middleText: "",
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                mapType = MapType.terrain;
                                                setState(() {});
                                                Get.back();
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 12.h,
                                                    width: 20.w,
                                                    decoration:
                                                        const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/terrain.png'),
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Terrain",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                mapType = MapType.satellite;
                                                setState(() {});
                                                Get.back();
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 12.h,
                                                    width: 20.w,
                                                    decoration:
                                                        const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/satellite.png'),
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Settelite",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                mapType = MapType.normal;
                                                setState(() {});
                                                Get.back();
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 12.h,
                                                    width: 20.w,
                                                    decoration:
                                                        const BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/default.png'),
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Default",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ]);
                                  // mapType == MapType.normal
                                  //     ? mapType = MapType.satellite
                                  //     : mapType = MapType.normal;
                                  // setState(() {});
                                },
                                child: Opacity(
                                  opacity: .7,
                                  child: Material(
                                    elevation: 5,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Colors.white54.withOpacity(.2),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Image.asset(
                                              'assets/images/maptype.PNG')),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          // CircleAvatar(
                          //   radius: 18,
                          //   child: Image.asset(
                          //     'assets/images/maptype.PNG',
                          //     scale: 2,
                          //     fit: BoxFit.contain,
                          //   ),
                          // )

                          // IconButton(
                          //     onPressed: () {},
                          //     icon: const Icon(Icons.map_outlined)),
                        ],
                      ),
                      // Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: ElevatedButton(
                      //       onPressed: () {
                      //         mapType == MapType.normal
                      //             ? mapType = MapType.satellite
                      //             : mapType = MapType.normal;
                      //         setState(() {});
                      //       },
                      //       child: const FittedBox(
                      //           fit: BoxFit.contain,
                      //           child: Text("change map type"))),
                      // ),
                    ],
                  ),
                ),
                GestureDetector(
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 4.h,
                      ),
                      Container(
                        height: 8.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: barcolor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  textwidget(
                                      '$distance Km', Colors.green, () {},
                                      size: 22),
                                  textwidget('Distance', Colors.white, () {},
                                      size: 16),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  textwidget(steps, Colors.green, () {},
                                      size: 20),
                                  textwidget('Steps', Colors.white, () {},
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
                            ]),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
