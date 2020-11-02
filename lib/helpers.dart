import 'package:flutter/material.dart';

DateTime _snackCallTime;
void showSnackBar(BuildContext context, String text,
    {int duration = 1, Color color, double textScaleFactor = 1}) {
  if (_snackCallTime != null &&
      (DateTime.now().millisecondsSinceEpoch -
              _snackCallTime.millisecondsSinceEpoch) <
          1000) {
    return;
  }
  _snackCallTime = DateTime.now();
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(
      text,
      textScaleFactor: textScaleFactor,
    ),
    duration: Duration(seconds: duration),
    backgroundColor: color != null ? color : Theme.of(context).primaryColor,
  ));
}
