import 'package:my_plan/core/storage/database_helper.dart';
import 'package:my_plan/data/shared/models/food_entry.dart';

class FoodRepository {
  final AppDatabase _database;

  FoodRepository({AppDatabase? database}) : _database = database ?? AppDatabase();

  Future<void> addFood({
    required String name,
    required String mealType,
    required String amount,
    required String calories,
  }) {
    return _database.saveFoodEntry(
      name: name,
      mealType: mealType,
      amount: amount,
      calories: calories,
    );
  }

  Future<List<FoodEntry>> getEntries() => _database.loadFoodEntries();
}
