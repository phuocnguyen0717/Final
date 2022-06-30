import 'package:endgame/controllers/db_helper.dart';
import 'package:endgame/pages/bottom_selected.dart';
import 'package:flutter/material.dart';

class AddName extends StatefulWidget {
  const AddName({Key key}) : super(key: key);

  @override
  State<AddName> createState() => _AddNameState();
}

class _AddNameState extends State<AddName> {
  DbHelper dbHelper = DbHelper();
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      backgroundColor: Color(0xffe2e7ef),
      body: Padding(
        padding: const EdgeInsets.all(
            12.0
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(12.0,
                ),
              ),
              padding: EdgeInsets.all(16.0,
              ),
              child: Image.asset(
                "assets/money_1.png",
                height: 60.0,
                width: 60.0,

              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text("Hãy nhập tên của bạn ",

              style: TextStyle(
                fontSize: 24.0,
                fontFamily: 'DM_Sans',
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Tên của bạn ",

                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'DM_Sans',
                ),
                maxLength: 15,
                onChanged: (val) {
                  name = val;
                },
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            //Z1
            SizedBox(
              height: 50.0,
              child: ElevatedButton(
                onPressed: () async {
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        action: SnackBarAction(
                          label: "OK",
                          textColor: Colors.white,
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                        backgroundColor: Colors.red[700],
                        content: Text(
                          "Hãy nhập tên của bạn!",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'DM_Sans',
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    );
                  } else {
                    DbHelper dbHelper = DbHelper();
                    await dbHelper.addName(name);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => BottomSelected(),
                      ),
                    );
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Được rồi, đi thôi!",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'DM_Sans',
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Icon(
                      Icons.arrow_right_alt,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
