import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:walking_idle/service/bank_manager.dart';
import 'package:walking_idle/service/idle_manager.dart';
import 'package:walking_idle/service/step_manager.dart';
import 'package:walking_idle/shop.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      ShopPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_cart),
        title: ("Shop"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final game = IdleManager();
  late Stream<StepManager> stream;
  double steps = 0;
  double balance = 0;

  @override
  void initState() {
    stream = StepManager().getStepManagerStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  steps = 0;
                } else {
                  steps = snapshot.data!.getSteps();
                }
                return Column(
                  children: [
                    Text(
                      "${steps.toStringAsFixed(0)} steps",
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      "${StepManager().getMultiplier()}x walker boost",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey
                      ),
                    )
                  ],
                );
              },
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    double amount_banked = BankManager().deposit(steps);
                    StepManager().steps -= amount_banked;
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20),  
                    textStyle: TextStyle(fontSize: 24),  
                  ),
                  child: const Text("Cash in"),
                ),
              ),
            ),
            SizedBox(
              height: 1,
              width: 1,
              child: GameWidget(
                game: game,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          StepManager().addDummyHumanStep();
        },
      ),
    );
  }
}

class ShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: BankManager().controller.stream,
              builder: (context, snapshot) {
                double balance = snapshot.data ?? 0;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bank balance:"
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${balance.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 40,
                            ),
                          ),
                          Text(
                            "/${BankManager().maxBankable.toStringAsFixed(2)}", // Display max bank balance here
                            style: TextStyle(
                              fontSize: 24,
                              color: const Color.fromARGB(255, 81, 79, 79),
                            ),
                          ),
                          Text(
                            " AUC",
                            style: TextStyle(
                              fontSize: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                );
              },
            ),
          ),
          Shop()
        ],
      ),
    );
  }
}
