import 'package:endgame/pages/models/tien_te_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TienTe extends GetxController {
  int idQuocGiaTienTe = 1;
  double tyGia = 1;
  List<TienTeModel> tienTe = [];

  void updateID(int id) {
    this.idQuocGiaTienTe = id;
    this.tyGia = quyDoiTyGia(idQuocGiaTienTe);
    update();
  }

  double quyDoiTyGia(int id) {
    for (var item in tienTe) {
      if (item.idQuocGia == id) {
        return item.tyGia;
      }
    }
    return 1;
  }

  @override
  void onInit() {
    super.onInit();
    tienTe.add(TienTeModel(idQuocGia: 1, tenTien: 'Đô la Mỹ', tyGia: 1));
    tienTe.add(TienTeModel(idQuocGia: 2, tenTien: 'VNĐ', tyGia: 23190));
    tienTe.add(TienTeModel(idQuocGia: 3, tenTien: 'Bảng anh', tyGia: 1.25));
  }
}
