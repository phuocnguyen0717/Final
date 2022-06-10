import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:endgame/controllers/tien_te.dart';

import 'package:endgame/pages/add_transaction.dart';
import 'package:endgame/pages/homepage.dart';
import 'package:endgame/pages/report.dart';
import 'package:endgame/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BottomSelected extends StatefulWidget {
  BottomSelected({key, this.title = ''}) : super(key: key);

  final String title;

  @override
  _BottomSelectedState createState() => _BottomSelectedState();
}

class _BottomSelectedState extends State<BottomSelected>
    with SingleTickerProviderStateMixin {
  final autoSizeGroup = AutoSizeGroup();

  final TienTe tienTe = Get.put(TienTe());
  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;

  final iconList = <IconData>[
    Icons.home,
    Icons.stacked_bar_chart,
    Icons.add_box,
    Icons.settings,
  ];
  final iconListWidget = <Widget>[
    Homepage(),
    ReportScreen(),
    AddTransaction(),
    Settings()
  ];
  final textList = <String>['HOME', 'REPORT', 'TRANSACTION', 'SETTING'];

  @override
  void initState() {
    super.initState();
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndexNavigationBar>(
      init: IndexNavigationBar(),
      builder: (controller) {
        return Scaffold(
          extendBody: true,
          body: NavigationScreen(iconList[controller.index],
              iconListWidget[controller.index]),
          bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            itemCount: iconList.length,
            tabBuilder: (int index, bool isActive) {
              const color = Colors.white;
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconList[index],
                    size: 24,
                    color: color,
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AutoSizeText(
                      textList[index],
                      maxLines: 1,
                      style: TextStyle(color: color),
                      group: autoSizeGroup,
                    ),
                  )
                ],
              );
            },
            backgroundColor: Color(0xff004eeb),
            activeIndex: controller.index,
            splashColor: Colors.red,
            notchAndCornersAnimation: animation,
            splashSpeedInMilliseconds: 300,
            notchSmoothness: NotchSmoothness.defaultEdge,
            gapLocation: GapLocation.center,
            // leftCornerRadius: 32,
            // rightCornerRadius: 32,
            onTap: (index) => setState(() {
              IndexNavigationBar indexNavigationBar = Get.put(IndexNavigationBar());
              indexNavigationBar.updateIndex(index);
            }),
            splashRadius: 50.0,
          ),
        );
      }
    );
  }

// static void routing(int index){
//   setState(()  {
//     constain.bottomNavIndex = index;});
// }
}

class NavigationScreen extends StatefulWidget {
  final IconData iconData;
  final Widget iconListWidget;

  const NavigationScreen(this.iconData, this.iconListWidget) : super();

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void didUpdateWidget(NavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.iconData != widget.iconData) {
      _startAnimation();
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    super.initState();
  }

  _startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Center(
        child: CircularRevealAnimation(
          animation: animation,
          centerOffset: Offset(80, 80),
          maxRadius: MediaQuery.of(context).size.longestSide * 1.1,
          child: widget.iconListWidget,
        ),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class IndexNavigationBar extends GetxController {
  int index = 0;

  void updateIndex(int index) {
    this.index = index;
    update();
  }
}
