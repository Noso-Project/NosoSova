import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings with ChangeNotifier {
  final String _isDarkThemePref = "isDarkTheme";
  final String _languagePref = "languageSelected";
  bool _isDarkTheme = false;
  String _selectLanguage = "en";
  String _appVersion = "";

  bool get isDarkTheme => _isDarkTheme;

  String get selectLanguage => _selectLanguage;

  String get getSelectLanguage => localeList[_selectLanguage] ?? "English";
  String get getAppVersion => _appVersion;

  final Map<String, String> localeList = {
    'de': 'Deutsch',
    'en': 'English',
    'es': 'Español',
    'pt': 'Português',
    'ru': 'Русский',
    'uk': 'Українська',
  };

  AppSettings() {
    _loadSettings();
  }

  void setThemeMode() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
    _saveThemeDark();
  }

  String _getKeyByValue(String value) {
    for (var entry in localeList.entries) {
      if (entry.key == value) {
        return entry.key;
      }
    }
    return 'en';
  }

  void setLanguage(String value) {
    var locale = _getKeyByValue(value);
    _selectLanguage = locale;
    notifyListeners();
    _saveLanguage(locale);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _isDarkTheme = prefs.getBool(_isDarkThemePref) ?? false;
    _selectLanguage =
        prefs.getString(_languagePref) ?? Platform.localeName.split("_")[0];
    _appVersion = packageInfo.version;
    notifyListeners();
  }

  Future<void> _saveThemeDark() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isDarkThemePref, _isDarkTheme);
  }

  Future<void> _saveLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_languagePref, value);
  }
}
