import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Widgets/constants.dart';

class pedometer {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  permission() async {
    await Permission.activityRecognition
        .request()
        .then((value) => initPlatformState());
  }

  void onStepCount(StepCount event) {
    print(event);

    steps = event.steps.toString();
    calories = (double.parse(steps.toString()) / 25).toStringAsFixed(2);
    distance = (double.parse(steps) / 1400).toStringAsFixed(2);
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);

    status = event.status;
  }

  void onPedestrianStatusError(error) {
    debugPrint('onPedestrianStatusError: $error');

    status = 'Pedestrian Status not available';

    debugPrint(status);
  }

  void onStepCountError(error) {
    debugPrint('onStepCountError: $error');

    steps = 'Step Count not available';
  }

  initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }
}
