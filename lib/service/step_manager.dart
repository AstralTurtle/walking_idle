import 'dart:async';

import 'package:pedometer/pedometer.dart';

class StepManager {
  double steps = 0;
  DateTime timeStamp = DateTime.now();
  double laststeps = 0;

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?';

  late StreamController<StepManager> controller;

  late Stream<StepManager> StepManagerStream;

  static StepManager? _instance;

  StepManager._internal() {
    controller = StreamController<StepManager>();
    init();
  }

  factory StepManager() {
    if (_instance == null) {
      _instance = StepManager._internal();
    }

    return _instance!;
  }

  static StepManager get instance => _instance!;

  double getSteps() {
    // print(steps);
    return steps;
  }

  void init() {
    initPlatformState();
    print("baller");
  }

  void _notifyListeners() {
    controller.add(this);
  }

  void onStepCount(StepCount event) {
    laststeps = steps;
    print(event.steps);
    steps += event.steps - laststeps;
    _notifyListeners();

    // _steps = event.steps.toString();
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    _status = event.status;
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    _status = 'Pedestrian Status not available';
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    // _steps = 'Step Count not available';
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    StepManagerStream = makeStepManagerStream().asBroadcastStream();
  }

  Stream<StepManager> makeStepManagerStream() {
    controller = StreamController<StepManager>();

    return controller.stream;
  }

  Stream<StepManager> getStepManagerStream() {
    return StepManagerStream;
  }

  void resetSteps() {
    steps = 0;
    laststeps = 0;
    _notifyListeners();
  }

  void addDummySteps() {
    laststeps = steps;
    steps += 100;
    timeStamp = DateTime.now();
    _notifyListeners();
  }

  void addSteps(double steps) {
    laststeps = this.steps;
    this.steps += steps;
    timeStamp = DateTime.now();
    _notifyListeners();
  }
}
