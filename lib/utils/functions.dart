import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

///////////////////////
// 日付フォーマット（PDF用）
///////////////////////
String formatDate(String language, DateTime dateTime){

  if(language == 'ja'){
    // YYYY年MM月DD日 10:00
    return DateFormat.yMMMEd('ja').format(dateTime) + ' ' + DateFormat('H:mm').format(dateTime);
  } else {
    // 海外仕様：MMM dd, yyyy
    return DateFormat.yMMMEd('en').format(dateTime) + ' ' + DateFormat('H:mm').format(dateTime);
  }
}


RegExp regex = RegExp(r'([.]*0)(?!.*\d)');


String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1000)).floor();

  if(i == 0 || i == 1){
    return ((bytes / pow(1000, i)).toStringAsFixed(0)) +
        ' ' +
        suffixes[i];
  }
  else {
    return ((bytes / pow(1000, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }
}

double getBaseFontSize(BuildContext context, Size screenSize){
  if(screenSize.width > 700 && screenSize.height > 700){
    return 24;
  }
  else {
    return 16;
  }
}
