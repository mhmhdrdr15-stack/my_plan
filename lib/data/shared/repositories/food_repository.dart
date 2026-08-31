import 'package:my_plan/core/storage/database_helper.dart';
import 'package:my_plan/data/shared/models/food_entry.dart';

class FoodRepository {
  final AppDatabase _database;

  FoodRepository({
    AppDatabase? database,
  }) : _database =
            database ?? AppDatabase();

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
  }) {
    return _database.saveFoodEntry(
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
  }

  // ============================================================
  // GET FOODS
  // ============================================================

  Future<List<FoodEntry>>
      getEntries() {
    return _database
        .loadFoodEntries();
  }
}