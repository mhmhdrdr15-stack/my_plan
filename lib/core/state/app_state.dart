import 'package:flutter/material.dart';
<<<<<<< HEAD

=======
import 'package:my_plan/core/localization/app_localization.dart';
>>>>>>> aa293c52c23f1846dac6deae987702c1a4c00379
import 'package:my_plan/core/storage/database_helper.dart';
import 'package:my_plan/core/state/controllers/food_log_controller.dart';
import 'package:my_plan/core/state/controllers/hydration_controller.dart';
import 'package:my_plan/core/state/controllers/locale_controller.dart';
import 'package:my_plan/core/state/controllers/planning_controller.dart';

import 'package:my_plan/data/shared/models/food_entry.dart';

class AppState extends ChangeNotifier {
  final AppDatabase _database =
      AppDatabase();

  final HydrationController hydration =
      HydrationController();

  final LocaleController language =
      LocaleController();

  final FoodLogController foodLog =
      FoodLogController();

  final PlanningController planning =
      PlanningController();

  // ============================================================
  // WATER
  // ============================================================

  double get water =>
      hydration.water;

  double get waterGoal =>
      hydration.waterGoal;

  Future<void> addWater(
    double amount,
  ) {
    return hydration.add(
      amount,
    );
  }

  // ============================================================
  // LOCALE
  // ============================================================

  Locale get locale =>
      language.locale;

  set locale(
    Locale value,
  ) {
    language.locale = value;
    appLocale.value = value;
    notifyListeners();
  }

<<<<<<< HEAD
  Future<void> setLocale(
    Locale value,
  ) {
    return language.setLocale(
      value,
    );
  }

  // ============================================================
  // FOOD LOG
  // ============================================================

  int get loggedFoods =>
      foodLog.loggedFoods;

  List<FoodEntry> get foodEntries =>
      foodLog.entries;

  // ============================================================
  // PLANNING
  // ============================================================

  PlanningController get plan =>
      planning;

  // ============================================================
  // LOAD
  // ============================================================

  Future<void> load() async {
    await _database.init();

    hydration.addListener(
      notifyListeners,
    );

    language.addListener(
      notifyListeners,
    );

    foodLog.addListener(
      notifyListeners,
    );

    planning.addListener(
      notifyListeners,
    );

    await Future.wait([
      hydration.load(),
      language.load(),
      foodLog.load(),
      planning.load(),
    ]);

=======
  int get loggedFoods => foodLog.loggedFoods;
  List<FoodEntry> get foodEntries => foodLog.entries;

  Future<void> load() async {
    await _database.init();
    hydration.addListener(notifyListeners);
    language.addListener(notifyListeners);
    foodLog.addListener(notifyListeners);
    await Future.wait([hydration.load(), language.load(), foodLog.load()]);
    appLocale.value = language.locale;
>>>>>>> aa293c52c23f1846dac6deae987702c1a4c00379
    notifyListeners();
  }

  // ============================================================
  // FOOD ENTRIES
  // ============================================================

  Future<List<FoodEntry>>
      loadFoodEntries() async {
    await foodLog.reloadEntries();

    return foodLog.entries;
  }

<<<<<<< HEAD
  // ============================================================
  // ADD FOOD
  // ============================================================
=======
  Future<void> addWater(double amount) => hydration.add(amount);

  Future<void> setLocale(Locale value) async {
    await language.setLocale(value);
    appLocale.value = value;
    notifyListeners();
  }
>>>>>>> aa293c52c23f1846dac6deae987702c1a4c00379

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
      name:
          name,
      mealType:
          mealType,
      amount:
          amount,
      calories:
          calories,
      proteinPer100g:
          proteinPer100g,
      carbsPer100g:
          carbsPer100g,
      fatPer100g:
          fatPer100g,
    );
  }
}

// ================================================================
// GLOBAL APP STATE
// ================================================================

final appState =
    AppState();