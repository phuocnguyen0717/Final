import 'package:charts_flutter/flutter.dart' as charts;

class ReportModel {
  final String month;
  final double subscribers;
  final charts.Color barColor;

  ReportModel({this.month, this.subscribers, this.barColor});
}
