import 'package:flutter/material.dart';
import 'package:my_plan/core/localization/app_localization.dart';
import 'package:my_plan/core/storage/database_helper.dart';

class LocaleController extends ChangeNotifier {
  final AppDatabase _database;

  LocaleController({AppDatabase? database})
    : _database = database ?? AppDatabase();

  Locale locale = const Locale('en');

  Future<void> load() async {
    final savedLocale = await _database.loadLocale();
    if (savedLocale != null) {
      locale = Locale(savedLocale);
    }
    appLocale.value = locale;
    notifyListeners();
  }

  Future<void> setLocale(Locale value) async {
    locale = value;
    appLocale.value = value;
    await _database.saveLocale(value.languageCode);
    notifyListeners();
  }
}
