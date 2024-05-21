import 'dart:io';
import 'package:pedometer/pedometer.dart';


class StepManager {
  int steps = 0;
  DateTime timeStamp = DateTime.now();
  int laststeps = 0;

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';


  static StepManager? _instance;
  
  StepManager._internal();

  factory StepManager() {
    if (_instance == null) {
      _instance = StepManager._internal();
    }
    return _instance!;
  }

  static StepManager get instance => _instance!;

  int getSteps() {
    return steps;
  }

  void init() {
    initPlatformState();


  }

 

  void onStepCount(StepCount event) {
    print(event);
    
      _steps = event.steps.toString();
   
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
      _steps = 'Step Count not available';
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    
  }


}