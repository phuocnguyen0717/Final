import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:endgame/controllers/db_helper.dart';
import 'package:endgame/pages/bottom_selected.dart';
import 'package:flutter/material.dart';
import 'package:endgame/static.dart' as Static;
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key key}) : super(key: key);

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
    locale: 'en_US',
    decimalDigits: 0,
    symbol: '',
  );
  int amount;

  String note = "Cái gì đó";
  String type = "Thu";
  DateTime selectedDate = DateTime.now();
  String dropdownValue = 'Siêu thị/chợ';
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 12),
      lastDate: DateTime(2100, 01),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  TextEditingController textEdit = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
        ),
        backgroundColor: Color(0xffe2e7ef),
        body: ListView(
          padding: EdgeInsets.all(
            12.0,
          ),
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Thêm Giao Dịch",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 32.0,
                  fontFamily: 'DM_Sans',
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Static.PrimaryColor,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: EdgeInsets.all(
                      12.0,
                    ),
                    child: Icon(
                      Icons.money,
                      size: 24.0,
                      color: Colors.white,
                    )),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: TextField(
                    maxLength: 14,
                    controller: textEdit,
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: "0",
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: 'DM_Sans',
                    ),
                    onChanged: (val) {
                      try {
                        amount = int.parse(val);
                        setState(() {
                          textEdit.value = TextEditingValue(
                              text: formatter.format(amount.toString()),
                              selection: TextSelection.collapsed(
                                  offset: formatter
                                      .format(amount.toString())
                                      .length));
                        });
                      } catch (e) {
                        // print(e.toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            duration: Duration(
                              seconds: 2,
                            ),
                            content: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 6.0,
                                ),
                                Text(
                                  "Vui lòng chỉ nhập số",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'DM_Sans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Static.PrimaryColor,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: EdgeInsets.all(
                      12.0,
                    ),
                    child: Icon(
                      Icons.description,
                      size: 24.0,
                      color: Colors.white,
                    )),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                    child: DropdownButton<String>(
                  value: dropdownValue,
                  elevation: 16,
                  style: const TextStyle(
                      fontFamily: 'DM_Sans', color: Color(0xff004eeb)),
                  underline: Container(
                    height: 2,
                    color: Color(0xff004eeb),
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>[
                    'Xăng',
                    'Siêu thị/chợ',
                    'Thể thao',
                    'Du lịch',
                    'Giải trí',
                    'Thú Cưng',
                    'Mỹ phẩm',
                    'Thức ăn',
                    'Đồ uống',
                    'Lương',
                    'Khác',
                    'Đầu tư',
                    'Mua bán',
                    'Cho Thuê'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Static.PrimaryColor,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: EdgeInsets.all(
                      12.0,
                    ),
                    child: Icon(
                      Icons.moving_sharp,
                      size: 24.0,
                      color: Colors.white,
                    )),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Thu",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'DM_Sans',
                      color: type == "Thu" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Static.PrimaryColor,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        type = "Thu";
                        if (dropdownValue.isEmpty || dropdownValue == "Chi") {
                          dropdownValue = 'Thu';
                        }
                      });
                    }
                  },
                  selected: type == "Thu" ? true : false,
                ),
                SizedBox(
                  width: 12.0,
                ),
                ChoiceChip(
                  label: Text(
                    "Chi",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'DM_Sans',
                      color: type == "Chi" ? Colors.white : Colors.black,
                    ),
                  ),
                  selectedColor: Static.PrimaryColor,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        type = "Chi";

                        if (dropdownValue.isEmpty || dropdownValue == "Thu") {
                          dropdownValue = 'Chi';
                        }
                      });
                    }
                  },
                  selected: type == "Chi" ? true : false,
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 50.0,
              child: TextButton(
                  onPressed: () {
                    _selectDate(context);

                    FocusScope.of(context).unfocus();
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.zero,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Static.PrimaryColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: EdgeInsets.all(
                          12.0,
                        ),
                        child: Icon(
                          Icons.date_range,
                          size: 24.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Text(
                        "${selectedDate.day}${months[selectedDate.month - 1]}",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'DM_Sans',
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 50.0,
              child: ElevatedButton(
                onPressed: () async {
                  if (amount != null) {
                    DbHelper dbHelper = DbHelper();
                    await dbHelper.addData(
                        amount, selectedDate, dropdownValue, type);
                    setState(() {
                      IndexNavigationBar indexNavigationBar =
                          Get.put(IndexNavigationBar());
                      indexNavigationBar.updateIndex(0);
                    });
                  } //Z2
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red[700],
                        content: Text(
                          "Vui lòng nhập số tiền !",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'DM_Sans',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  "Thêm",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'DM_Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
