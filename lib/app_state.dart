import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static const _waterKey = 'water_litres';
  static const _localeKey = 'locale';
  static const _loggedFoodsKey = 'logged_foods';

  double water = 1.4;
  double waterGoal = 2.5;
  Locale locale = const Locale('ar');
  int loggedFoods = 4;
  SharedPreferences? _preferences;

  Future<void> load() async {
    _preferences = await SharedPreferences.getInstance();

    final savedWater = _preferences?.getDouble(_waterKey);
    if (savedWater != null) water = savedWater;

    final savedLocale = _preferences?.getString(_localeKey);
    if (savedLocale != null) locale = Locale(savedLocale);

    final savedLoggedFoods = _preferences?.getInt(_loggedFoodsKey);
    if (savedLoggedFoods != null) loggedFoods = savedLoggedFoods;

    notifyListeners();
  }

  void addWater(double amount) {
    water = (water + amount).clamp(0, waterGoal).toDouble();
    _preferences?.setDouble(_waterKey, water);
    notifyListeners();
  }

  Future<void> setLocale(Locale value) async {
    locale = value;
    await _preferences?.setString(_localeKey, value.languageCode);
    notifyListeners();
  }

  Future<void> addFood() async {
    loggedFoods++;
    await _preferences?.setInt(_loggedFoodsKey, loggedFoods);
    notifyListeners();
  }
}

final appState = AppState();
