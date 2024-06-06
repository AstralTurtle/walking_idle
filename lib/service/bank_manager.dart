import "dart:async";
import "dart:io";
import "dart:math";

import "package:flutter/foundation.dart";

class BankManager {
    double balance = 0;
    int maxBankable = 200;
    double interestRate = 0.01;
    DateTime lastDate = DateTime.now();

    StreamController<double> controller = StreamController<double>();

    static BankManager? _instance;

    BankManager._internal(){
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
      _notifyListeners();
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
        // Duration difference = date.difference(lastDate);
        int microseconds = difference.inMicroseconds;
        double days = microseconds / Duration.microsecondsPerMinute;  
     
        balance *= exp(interestRate * days);
        _notifyListeners();

    }






}