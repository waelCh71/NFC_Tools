import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData appTheme = ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(5),
        padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
        backgroundColor: MaterialStateProperty.all(myWhite),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ),
    
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: gradiantColor[2]),
    textTheme: const TextTheme(
      //bodyText1: TextStyle(color: myWhite, fontSize: 25),
      bodyText2:
          TextStyle(color: myWhite, fontSize: 25, fontWeight: FontWeight.bold),
    ).apply(fontFamily: "Allan"),
  );
}
