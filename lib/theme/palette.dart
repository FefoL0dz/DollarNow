import 'package:flutter/material.dart';
class Palette {
  Palette._();

  // Generate swatch from http://mcg.mbitson.com

  static const Color white = MaterialColor(
    _whitePrimaryValue,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(_whitePrimaryValue),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );
  static const int _whitePrimaryValue = 0xFFFFFFFF;

  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  static const Color facebookColor = Color(0xFF305293);

  static const Color lightOrange = Color(_lightOrangeValue);

  static const Color ultraLightGrey = MaterialColor(
    _ultraLightGreyPrimaryValue,
    <int, Color>{
      50: Color(0xFFFDFDFD),
      100: Color(0xFFFBFBFB),
      200: Color(0xFFF8F8F8),
      300: Color(0xFFF5F5F5),
      400: Color(0xFFF2F2F2),
      500: Color(_ultraLightGreyPrimaryValue),
      600: Color(0xFFEEEEEE),
      700: Color(0xFFECECEC),
      800: Color(0xFFE9E9E9),
      900: Color(0xFFE5E5E5),
    },
  );
  static const int _ultraLightGreyPrimaryValue = 0xFFF0F0F0;

  static const Color lightGrey = MaterialColor(
    _lightGreyPrimaryValue,
    <int, Color>{
      50: Color(0xFFF3F3F3),
      100: Color(0xFFE0E0E0),
      200: Color(0xFFCBCBCB),
      300: Color(0xFFB6B6B6),
      400: Color(0xFFA7A7A7),
      500: Color(_lightGreyPrimaryValue),
      600: Color(0xFF8F8F8F),
      700: Color(0xFF848484),
      800: Color(0xFF7A7A7A),
      900: Color(0xFF696969),
    },
  );
  static const int _lightGreyPrimaryValue = 0xFF979797;

  static const MaterialColor grey = MaterialColor(
    _greyPrimaryValue,
    <int, Color>{
      50: Color(0xFFEEEEEE),
      100: Color(0xFFD4D4D4),
      200: Color(0xFFB8B8B8),
      300: Color(0xFF9B9B9B),
      400: Color(0xFF858585),
      500: Color(_greyPrimaryValue),
      600: Color(0xFF686868),
      700: Color(0xFF5D5D5D),
      800: Color(0xFF535353),
      900: Color(0xFF414141),
    },
  );
  static const int _greyPrimaryValue = 0xFF707070;

  static const MaterialColor darkGrey = MaterialColor(
    _darkGreyPrimaryValue,
    <int, Color>{
      50: Color(0xFFE7E8E8),
      100: Color(0xFFC4C5C6),
      200: Color(0xFF9C9FA0),
      300: Color(0xFF747879),
      400: Color(0xFF575B5D),
      500: Color(_darkGreyPrimaryValue),
      600: Color(0xFF33383A),
      700: Color(0xFF2C3032),
      800: Color(0xFF24282A),
      900: Color(0xFF171B1C),
    },
  );
  static const int _darkGreyPrimaryValue = 0xFF393E40;

  static const MaterialColor green = MaterialColor(
    _greenPrimaryValue,
    <int, Color>{
      50: Color(0xFFECF9F4),
      100: Color(0xFFCFF1E3),
      200: Color(0xFFAFE7D0),
      300: Color(0xFF8FDDBD),
      400: Color(0xFF77D6AF),
      500: Color(_greenPrimaryValue),
      600: Color(0xFF57CA99),
      700: Color(0xFF4DC38F),
      800: Color(0xFF43BD85),
      900: Color(0xFF32B274),
    },
  );
  static const int _greenPrimaryValue = 0xFF5FCFA1;

  static const MaterialColor orange = MaterialColor(
    _orangePrimaryValue,
    <int, Color>{
      50: Color(0xFFFEEFE1),
      100: Color(0xFFFDD7B5),
      200: Color(0xFFFCBC83),
      300: Color(0xFFFBA151),
      400: Color(0xFFFA8C2C),
      500: Color(_orangePrimaryValue),
      600: Color(0xFFF87006),
      700: Color(0xFFF76505),
      800: Color(0xFFF65B04),
      900: Color(0xFFF54802),
    },
  );
  static const int _orangePrimaryValue = 0xFFF97807;

  static const int _lightOrangeValue = 0xFFFCBC83;

  static const MaterialColor yellow = MaterialColor(
    _yellowPrimaryValue,
    <int, Color>{
      50: Color(0xFFFDF8EA),
      100: Color(0xFFFBEECB),
      200: Color(0xFFF8E3A8),
      300: Color(0xFFF5D785),
      400: Color(0xFFF2CF6B),
      500: Color(_yellowPrimaryValue),
      600: Color(0xFFEEC04A),
      700: Color(0xFFECB940),
      800: Color(0xFFE9B137),
      900: Color(0xFFE5A427),
    },
  );
  static const int _yellowPrimaryValue = 0xFFF0C651;

  static const MaterialColor red = MaterialColor(
    _redPrimaryValue,
    <int, Color>{
      50: Color(0xFFFDEEEC),
      100: Color(0xFFFAD5D0),
      200: Color(0xFFF7B9B1),
      300: Color(0xFFF49C92),
      400: Color(0xFFF1877A),
      500: Color(_redPrimaryValue),
      600: Color(0xFFED6A5B),
      700: Color(0xFFEB5F51),
      800: Color(0xFFE85547),
      900: Color(0xFFE44235),
    },
  );
  static const int _redPrimaryValue = 0xFFEF7263;

  static const MaterialColor blue = MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
      50: Color(0xFFE5F7FD),
      100: Color(0xFFBEEBFA),
      200: Color(0xFF93DDF7),
      300: Color(0xFF68CFF3),
      400: Color(0xFF47C5F1),
      500: Color(_bluePrimaryValue),
      600: Color(0xFF23B5EC),
      700: Color(0xFF1DACE9),
      800: Color(0xFF17A4E7),
      900: Color(0xFF0E96E2),
    },
  );
  static const int _bluePrimaryValue = 0xFF27BBEE;

  static const MaterialColor gold = MaterialColor(
    _goldPrimaryValue,
    <int, Color>{
      50: Color(0xFFFDF8EA),
      100: Color(0xFFFBEECB),
      200: Color(0xFFF8E3A8),
      300: Color(0xFFF5D785),
      400: Color(0xFFF2CF6B),
      500: Color(_goldPrimaryValue),
      600: Color(0xFFEEC04A),
      700: Color(0xFFECB940),
      800: Color(0xFFE9B137),
      900: Color(0xFFE5A427),
    },
  );
  static const int _goldPrimaryValue = 0xFFF0C651;

  static const MaterialColor darkGold = MaterialColor(
    _darkGoldPrimaryValue,
    <int, Color>{
      50: Color(0xFFF8F2E0),
      100: Color(0xFFEEDEB3),
      200: Color(0xFFE3C880),
      300: Color(0xFFD7B24D),
      400: Color(0xFFCFA226),
      500: Color(_darkGoldPrimaryValue),
      600: Color(0xFFC08900),
      700: Color(0xFFB97E00),
      800: Color(0xFFB17400),
      900: Color(0xFFA46200),
    },
  );
  static const int _darkGoldPrimaryValue = 0xFFC69100;

}
