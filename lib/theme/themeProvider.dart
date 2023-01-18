import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";
  SharedPreferences prefs;
  setDarkTheme(bool value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}

class Styles {
  static MaterialColor primaryColor = MaterialColor(
    0xffe40613,
    <int, Color>{
      50: Color(0xffe40613).withOpacity(0.1),
      100: Color(0xffe40613).withOpacity(0.2),
      200: Color(0xffe40613).withOpacity(0.3),
      300: Color(0xffe40613).withOpacity(0.4),
      400: Color(0xffe40613).withOpacity(0.5),
      500: Color(0xffe40613).withOpacity(0.6),
      600: Color(0xffe40613).withOpacity(0.7),
      700: Color(0xffe40613).withOpacity(0.8),
      800: Color(0xffe40613).withOpacity(0.9),
      900: Color(0xffe40613).withOpacity(1),
    },
  );
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: primaryColor,
      primaryColor: primaryColor,
      primaryColorLight: primaryColor.withOpacity(0.6),
      backgroundColor: isDarkTheme ? Color(0xffe7ebee) : Color(0xffe7ebee),
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xff515F65),
      highlightColor: isDarkTheme ? Color(0xffffffff) : Color(0xff153E73),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      // textSelectionColor: isDarkTheme ? Colors.white : Colors.white,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.white : Colors.black,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      secondaryHeaderColor: isDarkTheme ? Colors.white : Color(0xffEC3237),
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      fontFamily: 'OpenSans',
      textTheme: GoogleFonts.openSansTextTheme(),
      appBarTheme: AppBarTheme(elevation: 0.0),
      splashColor: Colors.white,
    );
  }
}
