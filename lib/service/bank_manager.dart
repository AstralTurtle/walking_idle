import "dart:async";
import "dart:io";
import "dart:math";

import "package:flutter/foundation.dart";

class BankManager {
  double balance = 0;
  double maxBankable = 200;
  double interestRate = 0.01;
  double conversionRate = 1;

  DateTime lastDate = DateTime.now();

  StreamController<double> controller = StreamController<double>();

  static BankManager? _instance;

  BankManager._internal() {
    balance = readFromFile();
  }

  factory BankManager() {
    if (_instance == null) {
      _instance = BankManager._internal();
    }
    return _instance!;
  }
  static const double microsPerDay = 86400000000; // 24 * 60 * 60 * 1,000,000

  static const secsperyear = 31536000;

  void _notifyListeners() {
    controller.add(balance);
  }

  void writeToFile() {
    File file = File('balance.txt');
    file.writeAsString('$balance');
  }

  double readFromFile() {
    File file = File('balance.txt');
    try {
      return double.parse(file.readAsStringSync());
    } catch (e) {
      return 0;
    }
  }

  // returns the amount of STEPS converted/banked
  double deposit(double steps) {
    double amount = steps * conversionRate;
    if (amount + balance > maxBankable)
    {
      double steps_banked = (maxBankable - balance)/conversionRate;
      balance = maxBankable;
      _notifyListeners();
      return steps_banked;
    }
    balance += amount;
    _notifyListeners();
    return steps;
  }

  bool spend(double amount) {
    if (amount > 0 && balance >= amount) {
      balance -= amount;
      _notifyListeners();
      return true;
    }
    return false;
  }

  void applyInterest(Duration difference) {
    if (balance >= maxBankable)
    {
      balance = maxBankable;
      return;
    }
    // Duration difference = date.difference(lastDate);
    int microseconds = difference.inMicroseconds;
    double days = microseconds / Duration.microsecondsPerMinute;

    balance *= exp(interestRate * days);
    _notifyListeners();
  }
}
