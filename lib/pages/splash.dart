import 'package:endgame/pages/local/getLocal.dart';
import 'package:endgame/pages/security.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    getSettings();
  }

  Future getSettings() async {
    String pass = await GetLocal.getPassWord();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) =>
          pass.isEmpty
              ? Security(lanDau: true,)
              : Security()
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      backgroundColor: Color(0xffe2e7ef),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(12.0,
            ),
          ),
          padding: EdgeInsets.all(16.0,
          ),
          child: Image.asset(
            "assets/icon.png",
            height: 64.0,
            width: 64.0,
          ),
        ),
      ),
    );
  }
}
