import 'package:flutter/foundation.dart';
import 'package:my_plan/core/storage/database_helper.dart';
import 'package:my_plan/data/shared/models/food_entry.dart';
import 'package:my_plan/data/shared/repositories/food_repository.dart';

class FoodLogController extends ChangeNotifier {
  final AppDatabase _database;
  final FoodRepository _repository;

  FoodLogController({AppDatabase? database, FoodRepository? repository})
      : _database = database ?? AppDatabase(),
        _repository = repository ?? FoodRepository(database: database);

  int loggedFoods = 4;
  List<FoodEntry> entries = const [];

  Future<void> load() async {
    loggedFoods = await _database.loadLoggedFoods();
    entries = await _repository.getEntries();
    notifyListeners();
  }

  Future<void> reloadEntries() async {
    entries = await _repository.getEntries();
    notifyListeners();
  }

  Future<void> addFood({
    required String name,
    required String mealType,
    required String amount,
    required String calories,
  }) async {
    loggedFoods++;
    notifyListeners();
    await _repository.addFood(
      name: name,
      mealType: mealType,
      amount: amount,
      calories: calories,
    );
    entries = await _repository.getEntries();
    await _database.saveLoggedFoods(loggedFoods);
    notifyListeners();
  }
}
