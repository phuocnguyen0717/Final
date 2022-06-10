import 'package:flutter/material.dart';

class TienTeModel {
  int idQuocGia;
  String tenTien;
  ///tỷ giá quy đổi giữa 1$ và tiền tệ khác
  double tyGia;
  TienTeModel({this.idQuocGia, this.tenTien, this.tyGia});
}
