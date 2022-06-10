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
                  itemBuilder: (_, index) => _item(
                      controller.tienTe[index],
                      (controller.idQuocGiaTienTe - 1) == index),
                  separatorBuilder: (_, __) => Divider(),
                  itemCount: controller.tienTe.length),
            );
          }),
    );
  }

  Widget _item(TienTeModel tienTeModel, bool check) {
    return GestureDetector(
      onTap: (){
        TienTe tienTe = Get.find();
        tienTe.updateID(tienTeModel.idQuocGia);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tienTeModel.tenTien,
              style: TextStyle(
                  color: check ? Colors.deepOrange : null,
                  fontWeight: check ? FontWeight.bold : null),
            ),
            // Text(nameCountry)
          ],
        ),
      ),
    );
  }
}
