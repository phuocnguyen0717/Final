import 'package:flutter/material.dart';
import 'package:money_converter/Currency.dart';
import 'package:money_converter/money_converter.dart';



class MoneyConvert extends StatefulWidget {
  @override
  _MoneyConvertState createState() => _MoneyConvertState();
}

class _MoneyConvertState extends State<MoneyConvert> {
  //def varebile
  String usdToEgp;

  @override
  void initState() {
    super.initState();
// add in initState
    getAmounts();
  }

// call function to convert
  void getAmounts() async {
    var usdConvert = await MoneyConverter.convert(
        Currency(Currency.USD, amount: 1), Currency(Currency.RUB));
    setState(() {
      usdToEgp = usdConvert.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Money Convertor Example'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "1 USD = ",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    Text(
                      "$usdToEgp ${Currency.EGP}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}