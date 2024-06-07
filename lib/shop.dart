import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:walking_idle/service/step_manager.dart';
import 'package:walking_idle/service/idle_manager.dart';
import 'package:walking_idle/service/bank_manager.dart';

class Shop extends StatefulWidget {
  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  Widget build(BuildContext context) {
    print("what in the shop");
    return Row(
      children: [
        TextButton(
            onPressed: () {
              if (BankManager().spend(100)) IdleManager().stepspersecond += 1;
            },
            child: Text("Walkers | 100 points ")),
        TextButton(
            onPressed: () {
              if (BankManager().spend(10)) BankManager().interestRate += 0.005;
            },
            child: Text("Refinancing | 10 points ")),
        TextButton(
            onPressed: () {
              if (BankManager().spend(150)) BankManager().maxBankable *= 2;
            },
            child: Text("Credit Report | 150 points ")),
        TextButton(
            onPressed: () {
              if (BankManager().spend(200)) BankManager().conversionRate += 0.2;
            },
            child: Text("Favorable Trading | 200 points ")),
        TextButton(
            onPressed: () {
              if (BankManager().spend(200)) IdleManager().maxHours += 1;
            },
            child: Text("Wristwatch | 200 points "))
      ],
    );
  }
}
