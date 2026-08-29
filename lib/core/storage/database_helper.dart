import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_plan/data/shared/models/food_entry.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Database? _database;

  final Map<String, String> _webSettings = {
    'water': '1.4',
    'water_goal': '2.5',
    'locale': 'en',
    'logged_foods': '4',
  };

  final List<FoodEntry> _webFoodEntries = <FoodEntry>[];

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError(
        'SQLite is unavailable on web. Using in-memory fallback.',
      );
    }

    _database ??= await _openDatabase();
    return _database!;
  }

  Future<void> init() async {
    if (kIsWeb) {
      _webSettings['water'] ??= '1.4';
      _webSettings['water_goal'] ??= '2.5';
      _webSettings['locale'] ??= 'en';
      _webSettings['logged_foods'] ??= '4';
      return;
    }

    _database ??= await _openDatabase();
    await _ensureDefaults();
  }

  Future<Database> _openDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'my_plan.db');

    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE app_settings (
            key TEXT PRIMARY KEY,
            value TEXT
          )
        ''');

        await database.execute('''
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

    return db;
  }

  Future<void> _ensureDefaults() async {
    if (kIsWeb) {
      _webSettings['water'] ??= '1.4';
      _webSettings['water_goal'] ??= '2.5';
      _webSettings['locale'] ??= 'en';
      _webSettings['logged_foods'] ??= '4';
      return;
    }

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
    if (kIsWeb) {
      return double.tryParse(_webSettings['water'] ?? '1.4') ?? 1.4;
    }

    final value = await _loadString('water');
    return value == null ? 1.4 : double.tryParse(value) ?? 1.4;
  }

  Future<double> loadWaterGoal() async {
    if (kIsWeb) {
      return double.tryParse(_webSettings['water_goal'] ?? '2.5') ?? 2.5;
    }

    final value = await _loadString('water_goal');
    return value == null ? 2.5 : double.tryParse(value) ?? 2.5;
  }

  Future<String?> loadLocale() async {
    if (kIsWeb) {
      return _webSettings['locale'];
    }

    return _loadString('locale');
  }

  Future<int> loadLoggedFoods() async {
    if (kIsWeb) {
      return int.tryParse(_webSettings['logged_foods'] ?? '4') ?? 4;
    }

    final value = await _loadString('logged_foods');
    return value == null ? 4 : int.tryParse(value) ?? 4;
  }

  Future<void> saveWater(double value) async {
    if (kIsWeb) {
      _webSettings['water'] = value.toString();
      return;
    }

    await _saveString('water', value.toString());
  }

  Future<void> saveWaterGoal(double value) async {
    if (kIsWeb) {
      _webSettings['water_goal'] = value.toString();
      return;
    }

    await _saveString('water_goal', value.toString());
  }

  Future<void> saveLocale(String value) async {
    if (kIsWeb) {
      _webSettings['locale'] = value;
      return;
    }

    await _saveString('locale', value);
  }

  Future<void> saveLoggedFoods(int value) async {
    if (kIsWeb) {
      _webSettings['logged_foods'] = value.toString();
      return;
    }

    await _saveString('logged_foods', value.toString());
  }

  Future<void> saveFoodEntry({
    required String name,
    required String mealType,
    required String amount,
    required String calories,
  }) async {
    if (kIsWeb) {
      _webFoodEntries.add(
        FoodEntry(
          id: _webFoodEntries.length + 1,
          name: name,
          mealType: mealType,
          amount: amount,
          calories: calories,
          createdAt: DateTime.now(),
        ),
      );
      return;
    }

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
    if (kIsWeb) {
      return List<FoodEntry>.from(_webFoodEntries.reversed);
    }

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

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> deleteDatabase() async {
    if (kIsWeb) {
      _webSettings.clear();
      _webFoodEntries.clear();
      _webSettings.addAll({
        'water': '1.4',
        'water_goal': '2.5',
        'locale': 'en',
        'logged_foods': '4',
      });
      return;
    }

    await close();
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_plan.db');
    await databaseFactory.deleteDatabase(path);
  }
}
