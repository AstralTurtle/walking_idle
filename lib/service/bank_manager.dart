import "dart:async";
import "dart:io";
import "dart:math";

import "package:flutter/foundation.dart";

class BankManager {
    double balance = 0;
    int maxBankable = 200;
    double interestRate = 0.1;
    DateTime lastDate = DateTime.now();

    StreamController<double> controller = StreamController<double>();

    static BankManager? _instance;

    BankManager._internal(){
      balance = readFromFile();
    }

    

    factory BankManager() {
      if (_instance == null) {
          _instance = BankManager._instance;
      }
      return _instance!;
    }

    static const secsperyear = 3.154e+7;

    void _notifyListeners(){
      controller.add(balance);
    }

    


     void writeToFile(){
    File file = File('balance.txt');
file.writeAsString('$balance');
     }
     double readFromFile(){

       File file = File('balance.txt');
       try {
       return double.parse(file.readAsStringSync());
       } catch (e) {
        return 0;
       }
     }

    void deposit(double amount) {
        if (amount > 0) {
            if (amount > maxBankable) {
                amount = maxBankable.toDouble();
            }
            balance += amount;
        }
    }

    void applyInterest(Duration difference) {
        // Duration difference = date.difference(lastDate);
        int seconds = difference.inSeconds;
        balance += balance * pow((1+ interestRate/secsperyear),seconds * interestRate);
    }






}