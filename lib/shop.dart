import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:walking_idle/service/bank_manager.dart';
import 'package:walking_idle/service/idle_manager.dart';

const double var_growth_rate = 1.05;

class Shop extends StatefulWidget {
  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  // Prices for items in the shop
  double walker_price = 100;
  double refinancing_price = 10;
  double credit_report_price = 150;
  double favorable_trading_price = 200;
  double wristwatch_price = 200;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShopItem(
          title: "Walkers",
          price: walker_price,
          description: "Walks for you. Increases steps by 1 per second.",
          onPressed: () {
            if (BankManager().spend(walker_price)) {
              IdleManager().stepspersecond += 1;
              setState(() {
                walker_price *= var_growth_rate;
              });
            }
          },
        ),
        ShopItem(
          title: "Refinancing",
          price: refinancing_price,
          description: "Increase bank interest rate by 0.5% (multiplicative).",
          onPressed: () {
            if (BankManager().spend(refinancing_price)) {
              BankManager().interestRate *= 0.005;
              setState(() {
                refinancing_price *= var_growth_rate;
              });
            }
          },
        ),
        ShopItem(
          title: "Credit Report",
          price: credit_report_price,
          description: "Increase maximum bankable amount.",
          onPressed: () {
            if (BankManager().spend(credit_report_price)) {
              BankManager().maxBankable *= (var_growth_rate + 0.3);
              setState(() {
                credit_report_price *= var_growth_rate;
              });
            }
          },
        ),
        ShopItem(
          title: "Favorable Trading",
          price: favorable_trading_price,
          description: "Increase the currency conversion rate.",
          onPressed: () {
            if (BankManager().spend(favorable_trading_price)) {
              BankManager().conversionRate += 0.2;
              setState(() {
                favorable_trading_price *= var_growth_rate;
              });
            }
          },
        ),
        ShopItem(
          title: "Wristwatch",
          price: wristwatch_price,
          description: "Increase the maximum hours you can go offline for.",
          onPressed: () {
            if (BankManager().spend(wristwatch_price)) {
              IdleManager().maxHours += 1;
              setState(() {
                wristwatch_price *= var_growth_rate;
              });
            }
          },
        ),
      ],
    );
  }
}

class ShopItem extends StatelessWidget {
  final String title;
  final double price;
  final String description;
  final VoidCallback onPressed;

  const ShopItem({
    required this.title,
    required this.price,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: onPressed,
          child: Column(
            children: [
              Text(
                "$title | ${price.toStringAsFixed(2)} points",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
