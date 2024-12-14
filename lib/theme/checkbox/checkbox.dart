import 'package:flutter/material.dart';

class EcommercCheckboxTheme {
  EcommercCheckboxTheme._();

  static CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    fillColor: MaterialStateProperty.all(Colors.blue),
    checkColor: MaterialStateProperty.all(Colors.white),
    side: BorderSide(color: Colors.black),
  );

  static CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
    fillColor: MaterialStateProperty.all(Colors.blue),
    checkColor: MaterialStateProperty.all(Colors.black),
    side: BorderSide(color: Colors.white),
  );
}
