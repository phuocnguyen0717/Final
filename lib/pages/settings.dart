import 'package:endgame/pages/chuyen_doi_tien_te.dart';
import 'package:endgame/pages/widgets/web_screen.dart';
import 'package:flutter/material.dart';
import 'package:endgame/pages/widgets/confirm_dialog.dart';
import 'package:endgame/controllers/db_helper.dart';
import 'package:get/get.dart';
import 'bottom_selected.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  DbHelper dbHelper = DbHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Cài Đặt",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'DM_Sans',
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(
          12.0,
        ),
        children: [
          Center(
              child: Text(
            "Chuỗi chức năng",
            style: TextStyle(
              fontFamily: 'DM_Sans',
            ),
          )),
          SizedBox(
            height: 10,
          ),
          _deleteData(),
          SizedBox(
            height: 20.0,
          ),
          _changeName(),
          SizedBox(
            height: 20.0,
          ),
          _convertMoney(),
          SizedBox(
            height: 20.0,
          ),
          Center(
              child: Text(
            "Chuỗi ứng dụng hỗ trợ",
            style: TextStyle(fontFamily: 'DM_Sans'),
          )),
          SizedBox(
            height: 20.0,
          ),
          _appChayBo(),
          SizedBox(
            height: 20,
          ),
          _appHocNgoaiNgu(),
          SizedBox(
            height: 20,
          ),
          _appQuyDoiTien(),
          SizedBox(
            height: 20,
          ),
          _appMomo(),
          SizedBox(
            height: 20,
          ),
          _appFinhay(),
          SizedBox(
            height: 90,
          )
        ],
      ),
    );
  }

  Widget _deleteData() {
    return ListTile(
      onTap: () async {
        bool answer = await showConfirmDialog(context, "THÔNG BÁO",
            "Tất cả dữ liệu của bạn sẽ bị xóa!");
        if (answer) {
          await dbHelper.cleanData();
          setState(() {
            IndexNavigationBar indexNavigationBar = Get.put(IndexNavigationBar());
            indexNavigationBar.updateIndex(0);
          });

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
        "Xóa dữ liệu",
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: 'DM_Sans',
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: Icon(
        Icons.delete_forever_outlined,
        size: 32.0,
        color: Colors.black87,
      ),
    );
  }

  Widget _changeName() {
    return ListTile(
      onTap: () async {
        String nameEditing = "";
        String name = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.grey[300],
            title: Text(
              "Nhập tên mới",
              style: TextStyle(
                fontFamily: 'DM_Sans',
              ),
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
                  hintText: "Tên mới",
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'DM_Sans',
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
        "Thay đổi tên người dùng",
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: 'DM_Sans',
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: Icon(
        Icons.change_circle_outlined,
        size: 32.0,
        color: Colors.black87,
      ),
    );
  }

  Widget _convertMoney() {
    return ListTile(
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
        "Thay đổi tiền tệ",
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: 'DM_Sans',
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 32.0,
        color: Colors.black87,
      ),
    );
  }

  Widget _appChayBo() {
    return ListTile(
      onTap: () {
        Get.to(() => WebScreen(
              url:
                  'https://play.google.com/store/apps/details?id=steptracker.healthandfitness.walkingtracker.pedometer&hl=vi',
            ));
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
        "Chạy bộ ",
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: 'DM_Sans',
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ),
        padding: EdgeInsets.all(
          16.0,
        ),
        child: Image.asset(
          "assets/diBo.png",
          height: 50.0,
          width: 50.0,
        ),
      ),
    );
  }

  Widget _appHocNgoaiNgu() {
    return ListTile(
      onTap: () {
        Get.to(() => WebScreen(
              url:
                  'https://play.google.com/store/apps/details?id=org.whiteglow.keepmynotes&hl=vi&gl=US',
            ));
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
        "Ghi chú - Sổ tay ",
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: 'DM_Sans',
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ),
        padding: EdgeInsets.all(
          16.0,
        ),
        child: Image.asset(
          "assets/xoTay.png",
          height: 50.0,
          width: 50.0,
        ),
      ),
    );
  }

  Widget _appQuyDoiTien() {
    return ListTile(
      onTap: () {
        Get.to(() => WebScreen(
              url:
                  'https://play.google.com/store/apps/details?id=com.digitalchemy.currencyconverter&hl=vi&gl=US',
            ));
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
        "Quy đổi tiền ",
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: 'DM_Sans',
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ),
        padding: EdgeInsets.all(
          16.0,
        ),
        child: Image.asset(
          "assets/thayDoiTien.png",
          height: 50.0,
          width: 50.0,
        ),
      ),
    );
  }

  Widget _appMomo() {
    return ListTile(
      onTap: () {
        Get.to(() => WebScreen(
              url:
                  'https://play.google.com/store/search?q=momo&c=apps&hl=vi&gl=US',
            ));
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
        "Ví điện tử ",
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: 'DM_Sans',
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ),
        padding: EdgeInsets.all(
          16.0,
        ),
        child: Image.asset(
          "assets/momo.jpg",
          height: 50.0,
          width: 50.0,
        ),
      ),
    );
  }

  Widget _appFinhay() {
    return ListTile(
      onTap: () {
        Get.to(() => WebScreen(
              url: 'https://play.google.com/store/search?q=finhay&c=apps&hl=vi',
            ));
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
        "Đầu tư và tích lũy ",
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.w800, fontFamily: 'DM_Sans'),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ),
        padding: EdgeInsets.all(
          16.0,
        ),
        child: Image.asset(
          "assets/finhay.jpg",
          height: 50.0,
          width: 50.0,
        ),
      ),
    );
  }
}
