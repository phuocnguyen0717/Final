import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:endgame/controllers/tien_te.dart';
import 'package:endgame/custom/chuyen_doi_tien_te.dart';
import 'package:endgame/modals/transaction_modal.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../modals/report_model.dart';

class ReportScreen extends StatefulWidget {
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    super.initState();
    // getPreference();
    box = Hive.box('money');
    fetch();
  }

  final TienTe tienTe = Get.find();
  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
    locale: 'en_US',
    decimalDigits: 0,
    symbol: '',
  );
  Future<List<TransactionModel>> fetch() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      List<TransactionModel> items = [];
      box.toMap().values.forEach((element) {
        items.add(
          TransactionModel(
            element['amount'],
            element['date'],
            element['dropdownValue'],
            element['type'],
          ),
        );
      });
      return items;
    }
  }

  Map<String, double> dataReport = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Color(0xff004eeb),
          title: Text(
            "Thống kê",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: FutureBuilder<List<TransactionModel>>(
            future: fetch(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Lỗi !",
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data.isEmpty) {
                  return Center(
                    child: Text(
                      "Bạn chưa có dữ liệu!",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'DM_Sans',
                      ),
                    ),
                  );
                } else {
                  dataExpansed(snapshot.data);
                  final List<ReportModel> data = [
                    ReportModel(
                      month: (DateTime.now().month - 2).toString(),
                      subscribers:
                          dataReport['totalExpense${DateTime.now().month - 2}'],
                      barColor: charts.ColorUtil.fromDartColor(Colors.red),
                    ),
                    ReportModel(
                      month: (DateTime.now().month - 1).toString(),
                      subscribers:
                          dataReport['totalExpense${DateTime.now().month - 1}'],
                      barColor: charts.ColorUtil.fromDartColor(Colors.red),
                    ),
                    ReportModel(
                      month: DateTime.now().month.toString(),
                      subscribers:
                          dataReport['totalExpense${DateTime.now().month}'],
                      barColor: charts.ColorUtil.fromDartColor(Colors.red),
                    ),
                  ];
                  final List<ReportModel> data2 = [
                    ReportModel(
                      month: (DateTime.now().month - 2).toString(),
                      subscribers:
                          dataReport['totalIncome${DateTime.now().month - 2}'],
                      barColor: charts.ColorUtil.fromDartColor(Colors.green),
                    ),
                    ReportModel(
                      month: (DateTime.now().month - 1).toString(),
                      subscribers:
                          dataReport['totalIncome${DateTime.now().month - 1}'],
                      barColor: charts.ColorUtil.fromDartColor(Colors.green),
                    ),
                    ReportModel(
                      month: DateTime.now().month.toString(),
                      subscribers:
                          dataReport['totalIncome${DateTime.now().month}'],
                      barColor: charts.ColorUtil.fromDartColor(Colors.green),
                    ),
                  ];
                  List<charts.Series<ReportModel, String>> series = [
                    charts.Series(
                        id: "Subscribers",
                        domainFn: (ReportModel series, _) => series.month,
                        measureFn: (ReportModel series, _) =>
                            series.subscribers,
                        colorFn: (ReportModel series, _) => series.barColor,
                        data: data,
                        labelAccessorFn: (ReportModel subscribers, _) =>
                            formatter.format(subscribers.subscribers.toString())),
                    charts.Series(
                        id: "Subscribers",
                        domainFn: (ReportModel series2, _) => series2.month,
                        measureFn: (ReportModel series2, _) =>
                            series2.subscribers,
                        colorFn: (ReportModel series2, _) => series2.barColor,
                        data: data2,
                        labelAccessorFn: (ReportModel subscribers, _) =>
                            formatter.format(subscribers.subscribers.toString()))
                  ];
                  return Container(
                    height: 400,
                    padding: EdgeInsets.all(20),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            const Text(
                              "Ba Tháng gần đây",
                            ),
                            Expanded(
                              child: charts.BarChart(

                                series,
                                animate: true,
                                animationDuration: Duration(seconds: 2),
                                barRendererDecorator:
                                    charts.BarLabelDecorator<String>(),
                                domainAxis: charts.OrdinalAxisSpec(),
                                
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return Center(
                  child: Text("Loading ..."),
                );
              }
            }));
  }

  Box box;

  void dataExpansed(List<TransactionModel> entireData) {
    double totalExpense1 = 0;
    double totalIncome1 = 0;
    for (TransactionModel data in entireData) {
      if (data.date.month == DateTime.now().month) {
        if (data.type == "Thu") {
          totalIncome1 += data.amount;
        } else {
          totalExpense1 += data.amount;
        }
      }
    }
    dataReport['totalExpense${DateTime.now().month}'] =
        totalExpense1 * tienTe.tyGia;
    dataReport['totalIncome${DateTime.now().month}'] =
        totalIncome1 * tienTe.tyGia;

    double totalExpense2 = 0;
    double totalIncome2 = 0;
    for (TransactionModel data in entireData) {
      if (data.date.month == DateTime.now().month - 1) {
        if (data.type == "Thu") {
          totalIncome2 += data.amount;
        } else {
          totalExpense2 += data.amount;
        }
      }
    }
    dataReport['totalExpense${DateTime.now().month - 1}'] =
        totalExpense2 * tienTe.tyGia;
    dataReport['totalIncome${DateTime.now().month - 1}'] =
        totalIncome2 * tienTe.tyGia;

    double totalExpense3 = 0;
    double totalIncome3 = 0;
    for (TransactionModel data in entireData) {
      if (data.date.month == DateTime.now().month - 2) {
        if (data.type == "Thu") {
          totalIncome3 += data.amount;
        } else {
          totalExpense3 += data.amount;
        }
      }
    }
    dataReport['totalExpense${DateTime.now().month - 2}'] =
        totalExpense3 * tienTe.tyGia;
    dataReport['totalIncome${DateTime.now().month - 2}'] =
        totalIncome3 * tienTe.tyGia;
  }
}
