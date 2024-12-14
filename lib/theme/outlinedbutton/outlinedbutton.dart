import 'package:flutter/material.dart';

class EcommercOutlinedButtonTheme {
  EcommercOutlinedButtonTheme._();

  static OutlinedButtonThemeData lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: ButtonStyle(
      side: MaterialStateProperty.all(BorderSide(color: Colors.blue)),
      foregroundColor: MaterialStateProperty.all(Colors.blue),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    ),
  );

  static OutlinedButtonThemeData darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: ButtonStyle(
      side: MaterialStateProperty.all(BorderSide(color: Colors.blue)),
      foregroundColor: MaterialStateProperty.all(Colors.blue),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    ),
  );
}
