import 'package:endgame/pages/models/tien_te_model.dart';
import 'package:get/get.dart';

class TienTe extends GetxController {
  int idQuocGiaTienTe = 1;
  double tyGia = 1;
  List<TienTeModel> tienTe = [];

  void updateID(int id) {
    idQuocGiaTienTe = id;
    tyGia = quyDoiTyGia(idQuocGiaTienTe);
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
    tienTe.add(TienTeModel(idQuocGia: 1, tenTien: 'USD', tyGia: 1));
    tienTe.add(TienTeModel(idQuocGia: 2, tenTien: 'VNĐ', tyGia: 23190));
    tienTe.add(TienTeModel(idQuocGia: 3, tenTien: 'Bảng Anh', tyGia: 1.25));
    tienTe.add(TienTeModel(idQuocGia: 4, tenTien: 'WON', tyGia: 1287));
    tienTe.add(TienTeModel(idQuocGia: 5, tenTien: 'YEN', tyGia: 135));
    tienTe.add(TienTeModel(idQuocGia: 6, tenTien: 'EURO', tyGia: 0.96));
  }
}
