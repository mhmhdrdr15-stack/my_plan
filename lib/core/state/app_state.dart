import 'package:flutter/material.dart';

import 'package:my_plan/core/localization/app_localization.dart';
import 'package:my_plan/core/state/controllers/food_log_controller.dart';
import 'package:my_plan/core/state/controllers/hydration_controller.dart';
import 'package:my_plan/core/state/controllers/locale_controller.dart';
import 'package:my_plan/core/state/controllers/planning_controller.dart';
import 'package:my_plan/core/storage/database_helper.dart';
import 'package:my_plan/data/shared/models/food_entry.dart';

class AppState extends ChangeNotifier {
  final AppDatabase _database = AppDatabase();
  final HydrationController hydration = HydrationController();
  final LocaleController language = LocaleController();
  final FoodLogController foodLog = FoodLogController();
  final PlanningController planning = PlanningController();

  double get water => hydration.water;
  double get waterGoal => hydration.waterGoal;

  Locale get locale => language.locale;
  set locale(Locale value) {
    language.locale = value;
    appLocale.value = value;
    notifyListeners();
  }

  int get loggedFoods => foodLog.loggedFoods;
  List<FoodEntry> get foodEntries => foodLog.entries;

  PlanningController get plan => planning;

  Future<void> addWater(double amount) {
    return hydration.add(amount);
  }

  Future<void> setLocale(Locale value) async {
    await language.setLocale(value);
    appLocale.value = value;
    notifyListeners();
  }

  Future<void> load() async {
    await _database.init();

    hydration.addListener(notifyListeners);
    language.addListener(notifyListeners);
    foodLog.addListener(notifyListeners);
    planning.addListener(notifyListeners);

    await Future.wait([
      hydration.load(),
      language.load(),
      foodLog.load(),
      planning.load(),
    ]);

    appLocale.value = language.locale;
    notifyListeners();
  }

  Future<List<FoodEntry>> loadFoodEntries() async {
    await foodLog.reloadEntries();
    return foodLog.entries;
  }

  Future<void> addFood({
    String name = 'Food',
    String mealType = 'Lunch',
    String amount = '100 g',
    String calories = '100 kcal',
    double proteinPer100g = 0.0,
    double carbsPer100g = 0.0,
    double fatPer100g = 0.0,
  }) {
    return foodLog.addFood(
      name: name,
      mealType: mealType,
      amount: amount,
      calories: calories,
      proteinPer100g: proteinPer100g,
      carbsPer100g: carbsPer100g,
      fatPer100g: fatPer100g,
    );
  }
}

final appState = AppState();
