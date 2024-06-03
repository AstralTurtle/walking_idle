
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:walking_idle/service/bank_manager.dart';
import 'package:walking_idle/service/idle_manager.dart';

import 'package:walking_idle/service/step_manager.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

void main() {
  runApp(why());
}

class why extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ball(),
    );
  }
}

// test classes please remake
class ball extends StatefulWidget {
  @override
  State<ball> createState() => _ballState();
}

class _ballState extends State<ball> {
  final game = IdleManager();
  late Stream<StepManager> stream ;
  double steps = 0;
  double balance = 0;

  @override
  void initState() {
      
    stream = StepManager().getStepManagerStream();


    // TODO: implement initState
    super.initState();
  }

  void testSubscription(StepManager events){
    print("ping");
    print(events);
    setState(() {
      print("ponged");
    });
  }


  @override
  Widget build(BuildContext context) {
    print("pong");
    print("ponged +" + StepManager().getSteps().toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("hello"),
      ),
      body: Center(
        child: Column(
          children: [
            
            StreamBuilder(stream: StepManager().getStepManagerStream(), builder: (context, snapshot){
              steps = snapshot.data!.getSteps();
              return Text(steps.toString());
            }),
            TextButton(onPressed: (){
              BankManager().deposit(steps);
              StepManager().resetSteps();
            }, child: const Text("Bank")),
            StreamBuilder(stream: BankManager().controller.stream, builder: (context, snapshot){
              balance = snapshot.data ?? 0;
              return Text(balance.toString());
            }),
            GameWidget(game: game),
            // Text(StepManager.instance._status),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          StepManager().addDummySteps();
          print(StepManager().getSteps());
        },
      )
    );
  }
}
