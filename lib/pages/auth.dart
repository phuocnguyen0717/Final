// to launch local auth
import 'package:endgame/pages/bottom_selected.dart';
import 'package:endgame/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class FingerPrintAuth extends StatefulWidget {
  const FingerPrintAuth({Key key}) : super(key: key);

  @override
  _FingerPrintAuthState createState() => _FingerPrintAuthState();
}

class _FingerPrintAuthState extends State<FingerPrintAuth> {
  bool authenticated = false;
  void authenticate() async {
    try {
      var localAuth = LocalAuthentication();
      authenticated = await localAuth.authenticate(
        localizedReason: 'Vui lòng xác thực',
        biometricOnly: false
      );
      if (authenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BottomSelected(),
          ),
        );
      } else {
        setState((  ) {});
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "LỖI!!",
          ),
          content: Text(
            "Bạn cần thiết lập mã Pin hoặc vân tay để bảo mật ứng dụng",
            style: TextStyle(
              fontFamily: 'DM_Sans',
              fontSize: 26
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Ok",
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bảo Mật",
        style: TextStyle(
          fontFamily: 'DM_Sans',
        ),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.white54,
              ),
              child: Icon(
                Icons.fingerprint_outlined,
                color: Theme.of(context).primaryColor,
                size: 150.0,
              ),
            ),
            //
            SizedBox(
              height: 15.0,
            ),
            //
            if (!authenticated)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Bạn vui lòng xác thực để sử dụng ứng dụng",
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'DM_Sans',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  //
                  SizedBox(
                    height: 15.0,
                  ),
                  //
                  TextButton(
                    onPressed: () {
                      authenticate();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Thử lại",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'DM_Sans',
                          ),
                        ),
                        //
                        SizedBox(
                          width: 5.0,
                        ),
                        //
                        Icon(
                          Icons.replay_rounded,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
