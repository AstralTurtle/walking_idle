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

  final double max_multiplier = 20;
  final int steps_to_increase_multiplier = 2;
  int multiplier_step_stacks = 0;
  // seconds
  int time_for_multiplier_expire = 1;
  Timer? multiplierTimer;

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
    return steps;
  }

  int getMultiplier() {
    return (multiplier_step_stacks / steps_to_increase_multiplier).truncate();
  }

  void init() {
    initPlatformState();
    multiplier_step_stacks = steps_to_increase_multiplier;
  }

  void reset_multiplier_stacks()
  {
    multiplier_step_stacks = steps_to_increase_multiplier;
  }

  void _notifyListeners() {
    controller.add(this);
  }

  void onStepCount(int steps) {
    int steps_multi_applied = steps * getMultiplier();
    laststeps = this.steps;
    // ??
    double newSteps = this.steps + steps_multi_applied - laststeps;
    this.steps += newSteps;

    multiplier_step_stacks++;
    restartMultiplierResetTimer();

    print("new multiplier: ${getMultiplier().toStringAsFixed(2)}");

    _notifyListeners();
  }

  void restartMultiplierResetTimer() {
    multiplierTimer?.cancel();
    multiplierTimer = Timer(Duration(seconds: time_for_multiplier_expire), () {
      // reset that shit
      reset_multiplier_stacks();
      _notifyListeners();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    _status = event.status;
  }

  void onPedestrianStatusError(error) {
    _status = 'Pedestrian Status not available';
  }

  void onStepCountError(error) {
    // Handle error
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream.listen(onPedestrianStatusChanged).onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    void callback_func(StepCount event) {
      onStepCount(event.steps);
    };
    _stepCountStream.listen(callback_func).onError(onStepCountError);

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
    reset_multiplier_stacks();
    _notifyListeners();
  }

  void addDummyHumanStep() {
    laststeps = steps;
    onStepCount(1);
    timeStamp = DateTime.now();
    _notifyListeners();
  }

  void addSteps(double steps) {
    laststeps = this.steps;
    this.steps += steps * getMultiplier();
    timeStamp = DateTime.now();
    _notifyListeners();
  }
}
