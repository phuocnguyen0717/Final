import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:endgame/controllers/tien_te.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomText {
  CustomText._();

  static Widget TextX(String text,
      {FontWeight fontWeight, Color color, double fontSize, String operator}) {
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'en_US',
      decimalDigits: 0,
      symbol: '',
    );
    return GetBuilder<TienTe>(
        init: TienTe(),
        builder: (controller) {
          return Text(
            '${operator ?? ''}${formatter.format((int.parse(text) * controller.tyGia /10).toString())}',
            style: TextStyle(
              fontSize: fontSize ?? 20.0,
              fontWeight: fontWeight ?? FontWeight.bold,
              color: color ?? Colors.black,
            ),
          );
        });
  }

  static Widget TextOperator(String text,
      {FontWeight fontWeight, Color color, double fontSize}) {
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
      locale: 'en_US',
      decimalDigits: 0,
      symbol: '',
    );
    String operator = '';
    String money = '';
    if (double.parse(text) < 0) {
      operator = text.substring(0, 1);
      money = text.substring(1, text.length);
    } else {
      money = text;
    }
    return GetBuilder<TienTe>(
        init: TienTe(),
        builder: (controller) {
          return Text(
            '${operator ?? ''}${formatter.format((int.parse(money) * controller.tyGia).toString())}',
            style: TextStyle(
              fontSize: fontSize ?? 20.0,
              fontWeight: fontWeight ?? FontWeight.bold,
              color: color ?? Colors.black,
            ),
          );
        });
  }
}
