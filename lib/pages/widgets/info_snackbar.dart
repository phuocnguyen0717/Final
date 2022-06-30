import 'package:flutter/material.dart';

SnackBar deleteInfoSnackBar = SnackBar(
  backgroundColor: Colors.red[700],
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
        "Giữ đề xóa",
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    ],
  ),
);
