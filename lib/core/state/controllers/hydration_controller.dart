import 'package:flutter/foundation.dart';
import 'package:my_plan/core/storage/database_helper.dart';

class HydrationController extends ChangeNotifier {
  final AppDatabase _database;

  HydrationController({AppDatabase? database}) : _database = database ?? AppDatabase();

  double water = 1.4;
  double waterGoal = 2.5;

  Future<void> load() async {
    water = await _database.loadWater();
    waterGoal = await _database.loadWaterGoal();
    notifyListeners();
  }

  Future<void> add(double amount) async {
    water = (water + amount).clamp(0, waterGoal).toDouble();
    await _database.saveWater(water);
    notifyListeners();
  }
}
