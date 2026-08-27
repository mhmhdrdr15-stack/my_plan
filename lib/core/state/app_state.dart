import 'package:flutter/material.dart';
import 'package:my_plan/core/storage/database_helper.dart';
import 'package:my_plan/core/state/controllers/food_log_controller.dart';
import 'package:my_plan/core/state/controllers/hydration_controller.dart';
import 'package:my_plan/core/state/controllers/locale_controller.dart';
import 'package:my_plan/data/shared/models/food_entry.dart';

class AppState extends ChangeNotifier {
  final AppDatabase _database = AppDatabase();
  final HydrationController hydration = HydrationController();
  final LocaleController language = LocaleController();
  final FoodLogController foodLog = FoodLogController();

  double get water => hydration.water;
  double get waterGoal => hydration.waterGoal;
  Locale get locale => language.locale;
  set locale(Locale value) {
    language.locale = value;
    notifyListeners();
  }
  int get loggedFoods => foodLog.loggedFoods;
  List<FoodEntry> get foodEntries => foodLog.entries;

  Future<void> load() async {
    await _database.init();
    hydration.addListener(notifyListeners);
    language.addListener(notifyListeners);
    foodLog.addListener(notifyListeners);
    await Future.wait([hydration.load(), language.load(), foodLog.load()]);
    notifyListeners();
  }

  Future<List<FoodEntry>> loadFoodEntries() async {
    await foodLog.reloadEntries();
    return foodLog.entries;
  }

  Future<void> addWater(double amount) => hydration.add(amount);

  Future<void> setLocale(Locale value) => language.setLocale(value);

  Future<void> addFood({
    String name = 'Food',
    String mealType = 'Lunch',
    String amount = '100 g',
    String calories = '100 kcal',
  }) async {
    await foodLog.addFood(
      name: name,
      mealType: mealType,
      amount: amount,
      calories: calories,
    );
  }
}

final appState = AppState();
