import 'package:endgame/controllers/tien_te.dart';
import 'package:endgame/pages/models/tien_te_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChuyenDoiTienTe extends StatelessWidget {
  const ChuyenDoiTienTe({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chuyển đổi tiền tệ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GetBuilder<TienTe>(
          init: TienTe(),
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView.separated(
                  itemBuilder: (_, index) => _item(controller.tienTe[index],
                      (controller.idQuocGiaTienTe - 1) == index),
                  separatorBuilder: (_, __) => Divider(),
                  itemCount: controller.tienTe.length),
            );
          }),
    );
  }

  Widget _item(TienTeModel tienTeModel, bool check) {
    return GestureDetector(
      onTap: () {
        _showConvertMoney(tienTeModel);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,
          vertical: 10
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tienTeModel.tenTien,
              style: TextStyle(
                  fontSize: 20,
                  color: check ? Colors.deepOrange : null,
                  fontWeight: check ? FontWeight.bold : null),
            ),
          ],
        ),
      ),
    );
  }

  void _showConvertMoney(TienTeModel tienTeModel) {
    TienTe tienTe = Get.find();
    Get.dialog(AlertDialog(
      title: Text("THÔNG BÁO",
      style: TextStyle(
        fontSize: 20,
        fontFamily: 'DM_Sans',
      ),
      ),
      content: Text("Bạn đã đổi tiền sang đơn vị " + tienTeModel.tenTien,
      style: TextStyle(
        fontSize: 20,
        fontFamily: 'DM_Sans'
      ),),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              tienTe.updateID(tienTeModel.idQuocGia);
              Get.back();
            },
            child: Text("OK"))
      ],
    ));
  }
}
