import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:walking_idle/service/bank_manager.dart';
import 'package:walking_idle/service/idle_manager.dart';

import 'package:walking_idle/service/step_manager.dart';

import 'package:walking_idle/shop.dart';

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
  late Stream<StepManager> stream;
  double steps = 0;
  double balance = 0;

  @override
  void initState() {
    stream = StepManager().getStepManagerStream();

    // TODO: implement initState
    super.initState();
  }

  void testSubscription(StepManager events) {
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
          title: Text("Walking Idle Game"),
        ),
        body: Center(
          child: Column(
            children: [
              StreamBuilder(
                  stream: StepManager().getStepManagerStream(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Text("0");
                    }
                    steps = snapshot.data!.getSteps() ?? 0;
                    return Text(steps.toString());
                  }),
              TextButton(
                  onPressed: () {
                    BankManager().deposit(steps);
                    StepManager().resetSteps();
                  },
                  child: const Text("Bank")),
              StreamBuilder(
                  stream: BankManager().controller.stream,
                  builder: (context, snapshot) {
                    balance = snapshot.data ?? 0;
                    return Text(balance.toString());
                  }),
              SingleChildScrollView(
                  child: Center(
                      child: Column(
                children: [
                  TextButton(
                      onPressed: () {
                        if (BankManager().spend(100))
                          IdleManager().stepspersecond += 1;
                      },
                      child: const Text("Walkers | 100 points ")),
                  TextButton(
                      onPressed: () {
                        if (BankManager().spend(10))
                          BankManager().interestRate += 0.005;
                      },
                      child: Text("Refinancing | 10 points ")),
                  TextButton(
                      onPressed: () {
                        if (BankManager().spend(150))
                          BankManager().maxBankable *= 2;
                      },
                      child: Text("Credit Report | 150 points ")),
                  TextButton(
                      onPressed: () {
                        if (BankManager().spend(200))
                          BankManager().conversionRate += 0.2;
                      },
                      child: Text("Favorable Trading | 200 points ")),
                  TextButton(
                      onPressed: () {
                        if (BankManager().spend(200))
                          IdleManager().maxHours += 1;
                      },
                      child: Text("Wristwatch | 200 points "))
                ],
              ))),

              SizedBox(
                height: 1,
                width: 1,
                child: GameWidget(game: game),
              ),

              // Text(StepManager.instance._status),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            StepManager().addDummySteps();
            // print(StepManager().getSteps());
          },
        ));
  }
}
