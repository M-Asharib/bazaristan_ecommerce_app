import 'package:flutter/material.dart';

class EcommercAppBarTheme {
  EcommercAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    color: Colors.white,
    elevation: 4,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
  );

  static AppBarTheme darkAppBarTheme = AppBarTheme(
    color: Colors.black,
    elevation: 4,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  );
}
