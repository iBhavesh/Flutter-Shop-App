import 'package:flutter/material.dart';

import '../theme/theme.dart';

void showSnackBar(BuildContext context, String text,
    {int duration = 1, Color color, double textScaleFactor = 1}) {
  Scaffold.of(context).hideCurrentSnackBar();
  
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(
      text,
      textScaleFactor: textScaleFactor,
    ),
    duration: Duration(seconds: duration),
    backgroundColor: color != null ? color : theme.primaryColor,
  ));
}
