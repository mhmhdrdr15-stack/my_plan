import 'package:flutter/foundation.dart';

import 'package:my_plan/core/storage/database_helper.dart';
import 'package:my_plan/data/shared/models/food_entry.dart';
import 'package:my_plan/data/shared/repositories/food_repository.dart';

class FoodLogController extends ChangeNotifier {
  final AppDatabase _database;
  final FoodRepository _repository;

  FoodLogController({
    AppDatabase? database,
    FoodRepository? repository,
  })  : _database =
            database ?? AppDatabase(),
        _repository =
            repository ??
                FoodRepository(
                  database:
                      database,
                );

  // ============================================================
  // STATE
  // ============================================================

  int loggedFoods = 4;

  List<FoodEntry> entries =
      const <FoodEntry>[];

  // ============================================================
  // LOAD
  // ============================================================

  Future<void> load() async {
    loggedFoods =
        await _database.loadLoggedFoods();

    entries =
        await _repository.getEntries();

    notifyListeners();
  }

  // ============================================================
  // RELOAD
  // ============================================================

  Future<void> reloadEntries() async {
    entries =
        await _repository.getEntries();

    notifyListeners();
  }

  // ============================================================
  // ADD FOOD
  // ============================================================

  Future<void> addFood({
    required String name,
    required String mealType,
    required String amount,
    required String calories,
    double proteinPer100g = 0.0,
    double carbsPer100g = 0.0,
    double fatPer100g = 0.0,
  }) async {
    await _repository.addFood(
      name: name,
      mealType: mealType,
      amount: amount,
      calories: calories,
      proteinPer100g:
          proteinPer100g,
      carbsPer100g:
          carbsPer100g,
      fatPer100g:
          fatPer100g,
    );

    entries =
        await _repository.getEntries();

    loggedFoods++;

    await _database.saveLoggedFoods(
      loggedFoods,
    );

    notifyListeners();
  }

  // ============================================================
  // ADD FOOD ENTRY OBJECT
  // ============================================================

  Future<void> addFoodEntry(
    FoodEntry food,
  ) async {
    await addFood(
      name: food.name,
      mealType:
          food.mealType,
      amount:
          food.amount,
      calories:
          food.calories,
      proteinPer100g:
          food.proteinPer100g,
      carbsPer100g:
          food.carbsPer100g,
      fatPer100g:
          food.fatPer100g,
    );
  }

  // ============================================================
  // COUNTS
  // ============================================================

  int get foodCount {
    return entries.length;
  }

  // ============================================================
  // FOOD FILTER
  // ============================================================

  List<FoodEntry> byMealType(
    String mealType,
  ) {
    return entries
        .where(
          (food) =>
              food.mealType ==
              mealType,
        )
        .toList();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  List<FoodEntry> search(
    String query,
  ) {
    final normalized =
        query.trim().toLowerCase();

    if (normalized.isEmpty) {
      return List<FoodEntry>.from(
        entries,
      );
    }

    return entries
        .where(
          (food) =>
              food.name
                  .toLowerCase()
                  .contains(
                    normalized,
                  ),
        )
        .toList();
  }
}