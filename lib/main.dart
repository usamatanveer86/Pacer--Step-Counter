import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/controller/myproviders.dart';
import '/pro/myindex.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'UI/landing_page.dart';
import 'Widgets/constants.dart';
import 'controller/pedometer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  await Hive.initFlutter();
  await Hive.openBox("goal");
  await Hive.openBox("monthly");
  await Hive.openBox("yearly");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => timepro()),
        ChangeNotifierProvider(create: (_) => myindex())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pacer',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const LandingPage(),
        builder: EasyLoading.init(),
      );
    });
  }
}

Future<void> initializeService() async {
  log("ini");
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

void onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  pedometer().initPlatformState();
  Timer.periodic(const Duration(seconds: 3), (timer) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Today's performance",
        content: "Steps: $steps\t\t Calories:$calories \t\t Distance:$distance",
      );
    }
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }
    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}
