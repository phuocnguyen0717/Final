import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:endgame/controllers/db_helper.dart';
import 'package:endgame/custom/chuyen_doi_tien_te.dart';
import 'package:endgame/modals/transaction_modal.dart';
import 'package:endgame/pages/add_transaction.dart';
import 'package:endgame/pages/details/expensed.dart';
import 'package:endgame/pages/details/income.dart';
import 'package:endgame/pages/settings.dart';
import 'package:endgame/pages/widgets/confirm_dialog.dart';
import 'package:endgame/pages/widgets/info_snackbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:endgame/static.dart' as Static;
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
    locale: 'en_US',
    decimalDigits: 0,
    symbol: '',
  );
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  DateTime today = DateTime.now();
  DbHelper dbHelper = DbHelper();
  SharedPreferences preferences;
  Box box;
  Map data;
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;
  List<FlSpot> dataSet = [];
  DateTime now = DateTime.now();
  int index = 1;

  getPreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    getPreference();
    box = Hive.box('money');
    fetch();
  }

  List<FlSpot> getPlotPoints(List<TransactionModel> entireData) {
    dataSet = [];
    List<TransactionModel> tempDataSet = [];
    for (TransactionModel item in entireData) {
      if (item.date.month == today.month && item.type == "Expense") {
        tempDataSet.add(item);
      }
    }
    tempDataSet.sort((a, b) => a.date.day.compareTo(b.date.day));

    for (var i = 0; i < tempDataSet.length; i++) {
      dataSet.add(
        FlSpot(tempDataSet[i].date.day.toDouble(),
            tempDataSet[i].amount.toDouble()),
      );
    }
    return dataSet;
  }

  Future<Map<String, double>> addData(int month) async {
    List<TransactionModel> data = await fetch();
    List<TransactionModel> tempDataSet = [];
    Map<String, double> result = {};
    for (TransactionModel item in data) {
      if (item.date.month == month && item.type == "Expense") {
        tempDataSet.add(item);
      }
    }
    tempDataSet.sort((a, b) => a.date.day.compareTo(b.date.day));
    for (int i = 0; i < tempDataSet.length; i++) {
      result.addAll({
        tempDataSet[i].dropdownValue:
            double.parse(tempDataSet[i].amount.toString())
      });
    }
    return result;
  }

  Future<Map<String, double>> addDataIncome(int month) async {
    List<TransactionModel> dataIncome = await fetch();
    List<TransactionModel> tempDataSet = [];
    Map<String, double> result = {};
    for (TransactionModel item in dataIncome) {
      if (item.date.month == month && item.type == "Income") {
        tempDataSet.add(item);
      }
    }
    tempDataSet.sort((a, b) => a.date.day.compareTo(b.date.day));
    for (int i = 0; i < tempDataSet.length; i++) {
      result.addAll({
        tempDataSet[i].dropdownValue:
            double.parse(tempDataSet[i].amount.toString())
      });
    }
    return result;
  }

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

  getTotalBalance(List<TransactionModel> entireData) {
    totalExpense = 0;
    totalIncome = 0;
    totalBalance = 0;

    for (TransactionModel data in entireData) {
      if (data.date.month == today.month) {
        if (data.type == "Income") {
          totalBalance += data.amount;
          totalIncome += data.amount;
        } else {
          totalBalance -= data.amount;
          totalExpense += data.amount;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<List<TransactionModel>>(
          future: fetch(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error  !",
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
                    "You Don't Have Data!",
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                );
              }

              getTotalBalance(snapshot.data);
              getPlotPoints(snapshot.data);
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32.0),
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Static.PrimaryColor,
                                      Colors.blueAccent,
                                    ],
                                  ),
                                ),
                                child: CircleAvatar(
                                  maxRadius: 28.0,
                                  backgroundColor: Colors.white,
                                  child: Image.asset(
                                    "assets/money_1.png",
                                    width: 50.0,
                                  ),
                                )),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "Welcome ${preferences.getString('name')}",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                                color: Static.PrimaryMaterialColor[800],
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              12.0,
                            ),
                            color: Colors.white70,
                          ),
                          padding: EdgeInsets.all(
                            12.0,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) => Settings(),
                                ),
                              )
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            child: Icon(
                              Icons.settings,
                              size: 32.0,
                              color: Color(0xff3E454C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  selectMonth(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: EdgeInsets.all(12.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Static.PrimaryColor,
                          Colors.blueAccent,
                        ]),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            24.0,
                          ),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                          Radius.circular(
                            24.0,
                          ),
                        )),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          vertical: 18.0,
                          horizontal: 8.0,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Total Balance',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            CustomText.TextOperator(
                              totalBalance.toString(),
                              fontSize: 36.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  cardIncome(
                                    totalIncome.toString(),
                                  ),
                                  cardExpense(
                                    totalExpense.toString(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${months[today.month - 1]} ${today.year}",
                          style: TextStyle(
                            fontSize: 32.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            Map<String, double> data =
                                await addData(today.month);
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => ExpansedChart(data: data),
                              ),
                            )
                                .then((value) {
                              setState(() {});
                            });
                          },
                          child: Icon(
                            Icons.arrow_downward,
                            size: 40,
                            color: Colors.red,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            Map<String, double> dataIncome =
                                await addDataIncome(today.month);
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    IncomeChart(dataIncome: dataIncome),
                              ),
                            )
                                .then((value) {
                              setState(() {});
                            });
                          },
                          child: Icon(
                            Icons.arrow_upward,
                            size: 40,
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                  ),
                  dataSet.isEmpty || dataSet.length < 2
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 40.0,
                            horizontal: 20.0,
                          ),
                          margin: EdgeInsets.all(
                            12.0,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                )
                              ]),
                          child: Text(
                            "Expense > 1 Can Show Charts",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        )
                      : Container(
                          height: 400.0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 40.0,
                          ),
                          margin: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 10,
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                )
                              ]),
                          child: LineChart(LineChartData(
                            borderData: FlBorderData(
                              show: false,
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: getPlotPoints(snapshot.data),
                                isCurved: false,
                                barWidth: 2,
                                colors: [
                                  Colors.blue,
                                ],
                                belowBarData: BarAreaData(
                                  show: true,
                                  colors: [Colors.lightBlue.withOpacity(0.5)],
                                  cutOffY: 10.0,
                                  applyCutOffY: true,
                                ),
                                showingIndicators: [200, 200, 90, 10],
                                dotData: FlDotData(
                                  show: true,
                                ),
                              ),
                            ],
                          )),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "History Transaction",
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.length + 1,
                    itemBuilder: (context, index) {
                      TransactionModel dataAtIndex;
                      try {
                        // dataAtIndex = snapshot.data![index];
                        dataAtIndex = snapshot.data[index];
                      } catch (e) {
                        // deleteAt deletes that key and value,
                        // hence makign it null here., as we still build on the length.
                        return Container();
                      }

                      if (dataAtIndex.date.month == today.month) {
                        if (dataAtIndex.type == "Income") {
                          return incomeTile(
                            dataAtIndex.amount,
                            dataAtIndex.dropdownValue,
                            dataAtIndex.date,
                            index,
                          );
                        } else {
                          return expenseTile(
                            dataAtIndex.amount,
                            dataAtIndex.dropdownValue,
                            dataAtIndex.date,
                            index,
                          );
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(
                    height: 60.0,
                  )
                ],
              );
            } else {
              return Center(
                child: Text("Loading ..."),
              );
            }
          }),
    );
  }

  Widget cardIncome(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(
            6.0,
          ),
          child: Icon(
            Icons.arrow_upward,
            size: 28.0,
            color: Colors.green[700],
          ),
          margin: EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Income",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            CustomText.TextX(value),
          ],
        )
      ],
    );
  }

  Widget cardExpense(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(
            6.0,
          ),
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.red[700],
          ),
          margin: EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Expense",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            CustomText.TextX(value),
            // Text(
            //   value,
            //   style: TextStyle(
            //     fontSize: 20.0,
            //     fontWeight: FontWeight.w700,
            //     color: Colors.red,
            //   ),
            // ),
          ],
        )
      ],
    );
  }

  Widget expenseTile(
      int value, String dropdownValue, DateTime date, int index) {
    return InkWell(
      splashColor: Static.PrimaryMaterialColor[400],
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          deleteInfoSnackBar,
        );
      },
      onLongPress: () async {
        bool answer = await showConfirmDialog(
          context,
          "WARNING",
          "This will delete this record. Do you want to continue ?",
        );
        if (answer != null && answer) {
          await dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
        padding: const EdgeInsets.all(18.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color(0xffced4eb),
          borderRadius: BorderRadius.circular(
            8.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_circle_down_outlined,
                          size: 28.0,
                          color: Colors.red[700],
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          "Expense",
                          style: TextStyle(fontSize: 20.0, color: Colors.red),
                        ),
                      ],
                    ),

                    //
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "${date.day} ${months[date.month - 1]} ",
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        CustomText.TextX(value.toString(),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                            operator: '-'),
                      ],
                    ),
                    //
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        dropdownValue,
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget incomeTile(int value, String dropdownValue, DateTime date, int index) {
    return InkWell(
      splashColor: Static.PrimaryMaterialColor[400],
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          deleteInfoSnackBar,
        );
      },
      onLongPress: () async {
        bool answer = await showConfirmDialog(
          context,
          "WARNING",
          "This will delete this record.Do you want to continue ?",
        );

        if (answer != null && answer) {
          await dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
        padding: const EdgeInsets.all(18.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color(0xffced4eb),
          borderRadius: BorderRadius.circular(
            8.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_circle_up_outlined,
                      size: 28.0,
                      color: Colors.green[700],
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "Income",
                      style: TextStyle(fontSize: 20.0, color: Colors.green),
                    ),
                  ],
                ),
                //
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    "${date.day} ${months[date.month - 1]} ",
                    style: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                //
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    CustomText.TextX(value.toString(),
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                        operator: '+'),
                  ],
                ),
                //
                //
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    dropdownValue,
                    style: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget selectMonth() {
    return Padding(
      padding: EdgeInsets.all(
        8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                index = 3;
                today = DateTime(now.year, now.month - 2, today.day);
              });
            },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                color: index == 3 ? Static.PrimaryColor : Colors.white,
              ),
              alignment: Alignment.center,
              child: Text(
                months[now.month - 3],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: index == 3 ? Colors.white : Static.PrimaryColor,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                index = 2;
                today = DateTime(now.year, now.month - 1, today.day);
              });
            },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                color: index == 2 ? Static.PrimaryColor : Colors.white,
              ),
              alignment: Alignment.center,
              child: Text(
                months[now.month - 2],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: index == 2 ? Colors.white : Static.PrimaryColor,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                index = 1;
                today = DateTime.now();
              });
            },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                color: index == 1 ? Static.PrimaryColor : Colors.white,
              ),
              alignment: Alignment.center,
              child: Text(
                months[now.month - 1],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: index == 1 ? Colors.white : Static.PrimaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
