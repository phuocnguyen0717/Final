import 'dart:core';
import 'dart:math' as math;
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../controllers/tien_te.dart';

class IncomeChart extends StatefulWidget {
  final Map<String, double> dataIncome;

  const IncomeChart({Key key, @required this.dataIncome}) : super(key: key);

  @override
  _IncomeChartState createState() => _IncomeChartState();
}

class _IncomeChartState extends State<IncomeChart> {
  List<double> price = [];
  List<String> title = [];
  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
    locale: 'en_US',
    decimalDigits: 0,
    symbol: '',
  );
  @override
  void initState() {
    super.initState();
    for (var entry in widget.dataIncome.entries) {
      price.add(entry.value);
      title.add(entry.key);
    }
  }

  Box box;
  final TienTe tienTe = Get.find();
  final ChartType _chartType = ChartType.disc;
  final double _ringStrokeWidth = 32;

  int key = 0;

  @override
  Widget build(BuildContext context) {
    final chart = PieChart(
      key: ValueKey(key),
      dataMap: widget.dataIncome,
      animationDuration: Duration(seconds: 2),
      chartRadius: math.min(MediaQuery.of(context).size.width / 1.2, 300),
      initialAngleInDegree: 0,
      chartType: _chartType,
      centerText: "Income",
      chartValuesOptions: ChartValuesOptions(
          showChartValues: true, showChartValuesInPercentage: true),
      ringStrokeWidth: _ringStrokeWidth,
      emptyColor: Colors.grey,
      emptyColorGradient: [
        Color(0xff6c5ce7),
        Colors.blue,
      ],
      baseChartColor: Colors.transparent,
    );
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Thông kê thu",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: LayoutBuilder(
        builder: (_, constraints) {
          if (constraints.maxWidth >= 200) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: chart,
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: ListView.separated(
                      itemBuilder: (_, index) =>
                          _item(title[index], price[index]),
                      separatorBuilder: (_, __) => Divider(),
                      itemCount: widget.dataIncome.length),
                )
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: chart,
                    margin: EdgeInsets.symmetric(
                      vertical: 32,
                    ),
                  ),
                  // settings,
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _item(String title, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "+" + formatter.format((price* tienTe.tyGia).toString()),
            style: TextStyle(fontSize: 15, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
