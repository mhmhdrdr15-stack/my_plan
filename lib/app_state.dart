import 'package:flutter/material.dart';
import 'database_helper.dart';

class AppState extends ChangeNotifier {
  final AppDatabase _database = AppDatabase();

  double water = 1.4;
  double waterGoal = 2.5;
  Locale locale = const Locale('ar');
  int loggedFoods = 4;

  Future<void> load() async {
    await _database.init();

    water = await _database.loadWater();
    waterGoal = await _database.loadWaterGoal();

    final savedLocale = await _database.loadLocale();
    if (savedLocale != null) {
      locale = Locale(savedLocale);
    }

    loggedFoods = await _database.loadLoggedFoods();
    notifyListeners();
  }

  Future<void> addWater(double amount) async {
    water = (water + amount).clamp(0, waterGoal).toDouble();
    await _database.saveWater(water);
    notifyListeners();
  }

  Future<void> setLocale(Locale value) async {
    locale = value;
    await _database.saveLocale(value.languageCode);
    notifyListeners();
  }

  Future<void> addFood({
    String name = 'Food',
    String mealType = 'Lunch',
    String amount = '100 g',
    String calories = '100 kcal',
  }) async {
    loggedFoods++;
    await _database.saveFoodEntry(
      name: name,
      mealType: mealType,
      amount: amount,
      calories: calories,
    );
    await _database.saveLoggedFoods(loggedFoods);
    notifyListeners();
  }
}

final appState = AppState();
