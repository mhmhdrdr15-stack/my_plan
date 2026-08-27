import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_plan/data/shared/models/food_entry.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await init();
    return _database!;
  }

  Future<Database> init() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'my_plan.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE app_settings (
            key TEXT PRIMARY KEY,
            value TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE food_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            meal_type TEXT NOT NULL,
            amount TEXT NOT NULL,
            calories TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );

    await _ensureDefaults();

    return _database!;
  }

  Future<void> _ensureDefaults() async {
    final db = await database;

    final defaults = {
      'water': '1.4',
      'water_goal': '2.5',
      'locale': 'en',
      'logged_foods': '4',
    };

    for (final entry in defaults.entries) {
      await db.insert('app_settings', {
        'key': entry.key,
        'value': entry.value,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  Future<double> loadWater() async {
    final value = await _loadString('water');
    return value == null ? 1.4 : double.tryParse(value) ?? 1.4;
  }

  Future<double> loadWaterGoal() async {
    final value = await _loadString('water_goal');
    return value == null ? 2.5 : double.tryParse(value) ?? 2.5;
  }

  Future<String?> loadLocale() async {
    return _loadString('locale');
  }

  Future<int> loadLoggedFoods() async {
    final value = await _loadString('logged_foods');
    return value == null ? 4 : int.tryParse(value) ?? 4;
  }

  Future<void> saveWater(double value) async {
    await _saveString('water', value.toString());
  }

  Future<void> saveWaterGoal(double value) async {
    await _saveString('water_goal', value.toString());
  }

  Future<void> saveLocale(String value) async {
    await _saveString('locale', value);
  }

  Future<void> saveLoggedFoods(int value) async {
    await _saveString('logged_foods', value.toString());
  }

  Future<void> saveFoodEntry({
    required String name,
    required String mealType,
    required String amount,
    required String calories,
  }) async {
    final db = await database;
    await db.insert('food_entries', {
      'name': name,
      'meal_type': mealType,
      'amount': amount,
      'calories': calories,
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<FoodEntry>> loadFoodEntries() async {
    final db = await database;
    final result = await db.query('food_entries', orderBy: 'created_at DESC');
    return result.map(FoodEntry.fromMap).toList();
  }

  Future<String?> _loadString(String key) async {
    final db = await database;
    final result = await db.query(
      'app_settings',
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isEmpty) return null;
    return result.first['value'] as String?;
  }

  Future<void> _saveString(String key, String value) async {
    final db = await database;
    await db.insert('app_settings', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_plan.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
