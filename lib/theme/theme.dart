
import 'package:ecommerce/theme/appbartheme/appbar.dart';
import 'package:ecommerce/theme/buttomsheettheme/buttomsheet.dart';
import 'package:ecommerce/theme/checkbox/checkbox.dart';
import 'package:ecommerce/theme/customtext.dart/text.dart';
import 'package:ecommerce/theme/elevatedbutton/elevatedbutton.dart';
import 'package:ecommerce/theme/inputdecoration/inputdecoration.dart';
import 'package:ecommerce/theme/outlinedbutton/outlinedbutton.dart';
import 'package:flutter/material.dart';


class Ecommercetheme {
  Ecommercetheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: eTexttheme.lightTextTheme,
    appBarTheme: EcommercAppBarTheme.lightAppBarTheme,
    checkboxTheme: EcommercCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: EcommercBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: EcommercElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: EcommercOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: EcommercInputDecorationTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: eTexttheme.darkTextTheme,
    appBarTheme: EcommercAppBarTheme.darkAppBarTheme,
    checkboxTheme: EcommercCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: EcommercBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: EcommercElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: EcommercOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: EcommercInputDecorationTheme.darkInputDecorationTheme,
  );
}
