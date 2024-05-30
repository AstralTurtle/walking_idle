import 'dart:ui';

import 'package:flame/game.dart';
import 'package:walking_idle/service/bank_manager.dart';
import 'package:walking_idle/service/step_manager.dart';

class IdleManager extends FlameGame{
  DateTime lasttime = DateTime.now();
  int maxHours = 1;

  double stepspersecond = 0;

  IdleManager(){
    pauseWhenBackgrounded = true;
   
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement render
    super.render(canvas);
  }

  @override
  void update(double dt) {
    Duration diff = DateTime.now().difference(lasttime);
    if (diff.inHours > maxHours) {
      diff = Duration(hours: maxHours);
    }

    StepManager().addSteps(stepspersecond * diff.inSeconds);
    BankManager().applyInterest(diff);

    lasttime = DateTime.now();
    // TODO: implement update
    super.update(dt);
  }




}