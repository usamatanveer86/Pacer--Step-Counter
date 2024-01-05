import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'HomePage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      isloading = false;
      if (mounted) {
        setState(() {});
      }
    });
    prefs();
    requestMultiplePermissions();
  }

  prefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("monthno") == null) {
      prefs.setInt("monthno", DateTime.now().month);
    } else {}
  }

  void requestMultiplePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      // Permission.storage,
    ].request();
    print("location permission: ${statuses[Permission.location]}, "
        "storage permission: ${statuses[Permission.storage]}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/splash_bg.png",
                ),
                fit: BoxFit.fill),
          ),
          child: Column(
            children: [
              Container(
                height: isloading ? 0.h : 8.h,
                width: double.infinity,
                color: Colors.white,
                child: const Center(child: Text("Advertisment")),
              ),
              SizedBox(
                height: 1.h,
              ),
              Visibility(
                visible: !isloading,
                child: Container(
                  height: 15.h,
                  width: double.infinity,
                  color: const Color(0xffaa182f4a),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Pacer',
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: Colors.white,
                            fontSize: 44,
                          ),
                        ),
                        Text(
                          'Be Fit Be Healthy',
                          style: TextStyle(
                              fontFamily: "poppins",
                              color: Colors.white,
                              fontSize: 26),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  // requestMultiplePermissions();
                  if (!isloading) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const Bottombar())));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      height: isloading ? 20.h : 6.h,
                      width: isloading ? 80.w : 40.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isloading
                            ? Colors.transparent
                            : const Color(0xff00E676).withOpacity(0.7),
                      ),
                      child: isloading
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  'Pacer',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 44,
                                      fontFamily: "poppins"),
                                ),
                                Text(
                                  'Be Fit Be Healthy',
                                  style: TextStyle(
                                      fontFamily: "poppins",
                                      color: Colors.white,
                                      fontSize: 26),
                                ),
                              ],
                            )
                          : Padding(
                              padding: EdgeInsets.all(3.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Let's Go ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
