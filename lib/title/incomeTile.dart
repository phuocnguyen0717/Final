import 'package:flutter/material.dart';

import '../controllers/db_helper.dart';
import '../custom/chuyen_doi_tien_te.dart';
import '../pages/widgets/confirm_dialog.dart';
import '../pages/widgets/info_snackbar.dart';
import 'package:endgame/static.dart' as Static;

class IncomeTile extends StatefulWidget {
  final int value;

  final String dropdownValue;
  final DateTime date;
  final int index;

  const IncomeTile(
      {Key key,
      @required this.value,
      @required this.dropdownValue,
      @required this.date,
      @required this.index})
      : super();

  @override
  State<IncomeTile> createState() => _IncomeTileState();
}

class _IncomeTileState extends State<IncomeTile> {
  DbHelper dbHelper = DbHelper();
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

  @override
  Widget build(BuildContext context) {
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
          "THÔNG BÁO",
          "Dữ liệu của bạn sẽ bị mất ?",
        );

        if (answer != null && answer) {
          await dbHelper.deleteData(widget.index);
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
                      "Thu",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'DM_Sans',
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                //
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    "${widget.date.day} ${months[widget.date.month - 1]} ",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: 'DM_Sans',
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
                    CustomText.TextX(widget.value.toString(),
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
                    widget.dropdownValue,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontFamily: 'DM_Sans',
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
}
