import 'package:flutter/material.dart';

import '../custom/chuyen_doi_tien_te.dart';

Widget CardIncome(String value) {
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
            "Thu",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white70,
              fontFamily: 'DM_Sans',
            ),
          ),
          CustomText.TextX(value),
        ],
      )
    ],
  );
}