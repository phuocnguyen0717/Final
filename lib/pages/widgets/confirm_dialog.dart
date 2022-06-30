import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bottom_selected.dart';

showConfirmDialog(BuildContext context, String title , String content) async{
  return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
              onPressed: (){
                Navigator.of(context).pop(true);
                IndexNavigationBar indexNavigationBar = Get.put(IndexNavigationBar());
                indexNavigationBar.updateIndex(1);
                indexNavigationBar.updateIndex(0);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.red,
                ),
              ),
              child: Text(
               "YES",
              ),
          ),
          ElevatedButton(
              onPressed: (){
                Navigator.of(context).pop(false);
              },
              child: Text(
              "NO",
              ),
          ),
        ],
      )
  );
}