import 'dart:ui';

import 'package:flame/game.dart';
import 'package:walking_idle/service/bank_manager.dart';
import 'package:walking_idle/service/step_manager.dart';

class IdleManager extends FlameGame {
  DateTime lasttime = DateTime.now();
  int maxHours = 1;

  double stepspersecond = 0;

  static IdleManager? _instance;

  IdleManager._internal() {
    pauseWhenBackgrounded = true;
  }

  factory IdleManager() {
    if (_instance == null) {
      _instance = IdleManager._internal();
    }
    return _instance!;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset.zero, 0, Paint()..color = Color(0xff00ff00));
    // TODO: implement render
    super.render(canvas);
  }

  @override
  void update(double dt) {
    Duration diff = DateTime.now().difference(lasttime);
    if (diff.inHours > maxHours) {
      diff = Duration(hours: maxHours);
    }
    // print(diff.inMicroseconds);
    // print(BankManager().balance);
    StepManager().addSteps(
        stepspersecond * diff.inMicroseconds / Duration.microsecondsPerSecond);
    BankManager().applyInterest(diff);

    lasttime = DateTime.now();
    // TODO: implement update
    super.update(dt);
  }
}
