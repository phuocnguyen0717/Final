import 'package:endgame/pages/add_name.dart';
import 'package:endgame/pages/add_transaction.dart';
import 'package:endgame/pages/auth.dart';
import 'package:endgame/pages/bottom_selected.dart';
import 'package:endgame/pages/homepage.dart';
import 'package:endgame/pages/money_converter.dart';
import 'package:endgame/pages/report.dart';
import 'package:endgame/pages/security.dart';
import 'package:endgame/pages/settings.dart';
import 'package:endgame/pages/splash.dart';
import 'package:endgame/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  await Hive.initFlutter();
  await Hive.openBox('money');
  runApp(
      const MyApp(
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Manager',
      theme: myTheme,
      home:  BottomSelected(),
    );
  }
}

