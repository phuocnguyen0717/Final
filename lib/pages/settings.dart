import 'package:endgame/pages/chuyen_doi_tien_te.dart';
import 'package:endgame/pages/local/getLocal.dart';
import 'package:endgame/pages/local/setLocal.dart';
import 'package:endgame/pages/widgets/web_screen.dart';
import 'package:flutter/material.dart';
import 'package:endgame/pages/widgets/confirm_dialog.dart';
import 'package:endgame/controllers/db_helper.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'bottom_selected.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  //

  DbHelper dbHelper = DbHelper();

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(
          12.0,
        ),
        children: [
          ListTile(
            onTap: () async {
              bool answer = await showConfirmDialog(context, "Warning",
                  "This is irreversible. Your entire data will be Lost");
              if (answer) {
                await dbHelper.cleanData();
                IndexNavigationBar indexNavigationBar =
                    Get.put(IndexNavigationBar());
                indexNavigationBar.updateIndex(0);
              }
            },
            tileColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            title: Text(
              "Clean Data",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            trailing: Icon(
              Icons.delete_forever_outlined,
              size: 32.0,
              color: Colors.black87,
            ),
          ),
          //
          SizedBox(
            height: 20.0,
          ),
          //
          ListTile(
            onTap: () async {
              String nameEditing = "";
              String name = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.grey[300],
                  title: Text(
                    "Enter new name",
                  ),
                  content: Container(
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
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Your Name",
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      maxLength: 12,
                      onChanged: (val) {
                        nameEditing = val;
                      },
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(nameEditing);
                      },
                      child: Text(
                        "OK",
                      ),
                    ),
                  ],
                ),
              );
              //
              if (name != null && name.isNotEmpty) {
                DbHelper dbHelper = DbHelper();
                await dbHelper.addName(name);
              }
            },
            tileColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            title: Text(
              "Change Name",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            trailing: Icon(
              Icons.change_circle_outlined,
              size: 32.0,
              color: Colors.black87,
            ),
          ),
          //
          SizedBox(
            height: 20.0,
          ),
          ListTile(
            onTap: () {
              Get.to(() => ChuyenDoiTienTe());
            },
            tileColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            title: Text(
              "Change Currency",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            trailing: Icon(
              Icons.swap_horizontal_circle_outlined,
              size: 32.0,
              color: Colors.black87,
            ),
          ),
          //
          SizedBox(
            height: 20.0,
          ),
          ListTile(
            onTap: () {
              Get.to(() => WebScreen(
                    url:
                        'https://play.google.com/store/apps/details?id=steptracker.healthandfitness.walkingtracker.pedometer&hl=vi',
                  )
              );
            },
            tileColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            title: Text(
              "Change Password ",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            trailing: Icon(
              Icons.admin_panel_settings_outlined,
              size: 32.0,
              color: Colors.black87,
            ),
          ),
          //
          // FutureBuilder<bool>(
          //   future: dbHelper.getLocalAuth(),
          //   builder: (context, snapshot) {
          //     // print(snapshot.data);
          //     if (snapshot.hasData) {
          //       return SwitchListTile(
          //         onChanged: (val) {
          //           DbHelper dbHelper = DbHelper();
          //           dbHelper.setLocalAuth(val);
          //           setState(() {});
          //         },
          //         value: snapshot.data == null ? false : snapshot.data!,
          //         tileColor: Colors.white,
          //         contentPadding: EdgeInsets.symmetric(
          //           vertical: 12.0,
          //           horizontal: 20.0,
          //         ),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(
          //             8.0,
          //           ),
          //         ),
          //         title: Text(
          //           "Local Bio Auth",
          //           style: TextStyle(
          //             fontSize: 20.0,
          //             fontWeight: FontWeight.w800,
          //           ),
          //         ),
          //         subtitle: Text(
          //           "Secure This app, Use Fingerprint to unlock the app.",
          //         ),
          //       );
          //     } else {
          //       return Container();
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
