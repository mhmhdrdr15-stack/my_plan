import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:my_plan/data/shared/models/food_entry.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Database? _database;
  static const int _databaseVersion = 2;

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
        'SQLite is unavailable on web. Using in-memory fallback for non-SQLite paths.',
      );
    }

    _database ??= await _openDatabase();
    return _database!;
  }

  Future<Database> init() async {
    if (kIsWeb) {
      _webSettings['water'] ??= '1.4';
      _webSettings['water_goal'] ??= '2.5';
      _webSettings['locale'] ??= 'en';
      _webSettings['logged_foods'] ??= '4';
      return _openInMemoryDatabase();
    }

    _database ??= await _openDatabase();
    await _ensureDefaults();
    return _database!;
  }

  Future<Database> _openInMemoryDatabase() async {
    return openDatabase(
      inMemoryDatabasePath,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<Database> _openDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'my_plan.db');

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createAppSettingsTable(db);
    await _createFoodEntriesTable(db);
    await _createMealSchedulesTable(db);
    await _createMealTemplatesTable(db);
    await _createMealTemplateItemsTable(db);
    await _createMealDayAssignmentsTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createMealSchedulesTable(db);
      await _createMealTemplatesTable(db);
      await _createMealTemplateItemsTable(db);
      await _createMealDayAssignmentsTable(db);
    }
  }

  Future<void> _createAppSettingsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS app_settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  Future<void> _createFoodEntriesTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS food_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        meal_type TEXT NOT NULL,
        amount TEXT NOT NULL,
        calories TEXT NOT NULL,
        protein_per_100g REAL NOT NULL DEFAULT 0,
        carbs_per_100g REAL NOT NULL DEFAULT 0,
        fat_per_100g REAL NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    await _ensureFoodEntryColumn(db, 'protein_per_100g');
    await _ensureFoodEntryColumn(db, 'carbs_per_100g');
    await _ensureFoodEntryColumn(db, 'fat_per_100g');
  }

  Future<void> _ensureFoodEntryColumn(Database db, String column) async {
    final columns = await db.rawQuery('PRAGMA table_info(food_entries)');
    final exists = columns.any((item) => item['name'] == column);

    if (!exists) {
      await db.execute(
        'ALTER TABLE food_entries ADD COLUMN $column REAL NOT NULL DEFAULT 0',
      );
    }
  }

  Future<void> _createMealSchedulesTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meal_schedules (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        meal_time TEXT NOT NULL,
        calories REAL NOT NULL,
        position INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> _createMealTemplatesTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meal_templates (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        meal_type TEXT NOT NULL,
        meal_time TEXT NOT NULL,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createMealTemplateItemsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meal_template_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        template_id TEXT NOT NULL,
        food_id TEXT NOT NULL,
        grams REAL NOT NULL,
        position INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(template_id) REFERENCES meal_templates(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_meal_template_items_template
      ON meal_template_items(template_id)
    ''');
  }

  Future<void> _createMealDayAssignmentsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS meal_day_assignments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        template_id TEXT NOT NULL,
        day TEXT NOT NULL,
        UNIQUE(template_id, day),
        FOREIGN KEY(template_id) REFERENCES meal_templates(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_meal_day_assignments_day
      ON meal_day_assignments(day)
    ''');
  }

  Future<void> _ensureDefaults() async {
    final db = await database;
    const defaults = {
      'water': '1.4',
      'water_goal': '2.5',
      'locale': 'en',
      'logged_foods': '4',
      'planning_daily_calories': '2200',
      'planning_daily_protein': '165',
      'planning_daily_carbs': '220',
      'planning_daily_fat': '73',
    };

    for (final entry in defaults.entries) {
      await db.insert(
        'app_settings',
        {'key': entry.key, 'value': entry.value},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
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

  Future<double> loadPlanningDailyCalories() async {
    final value = await _loadString('planning_daily_calories');
    return value == null ? 2200.0 : double.tryParse(value) ?? 2200.0;
  }

  Future<double> loadPlanningDailyProtein() async {
    final value = await _loadString('planning_daily_protein');
    return value == null ? 165.0 : double.tryParse(value) ?? 165.0;
  }

  Future<double> loadPlanningDailyCarbs() async {
    final value = await _loadString('planning_daily_carbs');
    return value == null ? 220.0 : double.tryParse(value) ?? 220.0;
  }

  Future<double> loadPlanningDailyFat() async {
    final value = await _loadString('planning_daily_fat');
    return value == null ? 73.0 : double.tryParse(value) ?? 73.0;
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

  Future<void> savePlanningDailyTargets({
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
  }) async {
    await _saveString('planning_daily_calories', calories.toString());
    await _saveString('planning_daily_protein', protein.toString());
    await _saveString('planning_daily_carbs', carbs.toString());
    await _saveString('planning_daily_fat', fat.toString());
  }

  Future<void> saveFoodEntry({
    required String name,
    required String mealType,
    required String amount,
    required String calories,
    double proteinPer100g = 0.0,
    double carbsPer100g = 0.0,
    double fatPer100g = 0.0,
  }) async {
    if (kIsWeb) {
      _webFoodEntries.add(
        FoodEntry(
          id: _webFoodEntries.length + 1,
          name: name,
          mealType: mealType,
          amount: amount,
          calories: calories,
          proteinPer100g: proteinPer100g,
          carbsPer100g: carbsPer100g,
          fatPer100g: fatPer100g,
          createdAt: DateTime.now(),
        ),
      );
      return;
    }

    final db = await database;
    await db.insert(
      'food_entries',
      {
        'name': name,
        'meal_type': mealType,
        'amount': amount,
        'calories': calories,
        'protein_per_100g': proteinPer100g,
        'carbs_per_100g': carbsPer100g,
        'fat_per_100g': fatPer100g,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FoodEntry>> loadFoodEntries() async {
    if (kIsWeb) {
      return List<FoodEntry>.from(_webFoodEntries.reversed);
    }

    final db = await database;
    final result = await db.query(
      'food_entries',
      orderBy: 'created_at DESC',
    );
    return result.map(FoodEntry.fromMap).toList();
  }

  Future<void> replaceMealSchedules(List<Map<String, dynamic>> schedules) async {
    final db = await database;

    await db.transaction((transaction) async {
      await transaction.delete('meal_schedules');

      for (var i = 0; i < schedules.length; i++) {
        final schedule = Map<String, dynamic>.from(schedules[i]);
        schedule['position'] = i;
        await transaction.insert('meal_schedules', schedule);
      }
    });
  }

  Future<List<Map<String, dynamic>>> loadMealSchedules() async {
    final db = await database;
    return db.query('meal_schedules', orderBy: 'position ASC');
  }

  Future<void> saveMealTemplate({
    required Map<String, dynamic> template,
    required List<Map<String, dynamic>> items,
    required Set<String> assignedDays,
  }) async {
    final db = await database;

    await db.transaction((transaction) async {
      final templateId = template['id'] as String;

      await transaction.insert(
        'meal_templates',
        {
          ...template,
          'created_at': template['created_at'] ?? DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await transaction.delete(
        'meal_template_items',
        where: 'template_id = ?',
        whereArgs: [templateId],
      );

      await transaction.delete(
        'meal_day_assignments',
        where: 'template_id = ?',
        whereArgs: [templateId],
      );

      for (var i = 0; i < items.length; i++) {
        await transaction.insert('meal_template_items', {
          ...items[i],
          'template_id': templateId,
          'position': i,
        });
      }

      for (final day in assignedDays) {
        await transaction.insert(
          'meal_day_assignments',
          {'template_id': templateId, 'day': day},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    });
  }

  Future<List<Map<String, dynamic>>> loadMealTemplates() async {
    final db = await database;
    return db.query('meal_templates', orderBy: 'created_at ASC');
  }

  Future<List<Map<String, dynamic>>> loadMealTemplateItems(String templateId) async {
    final db = await database;
    return db.query(
      'meal_template_items',
      where: 'template_id = ?',
      whereArgs: [templateId],
      orderBy: 'position ASC',
    );
  }

  Future<Set<String>> loadMealTemplateDays(String templateId) async {
    final db = await database;
    final result = await db.query(
      'meal_day_assignments',
      columns: ['day'],
      where: 'template_id = ?',
      whereArgs: [templateId],
    );

    return result.map((row) => row['day'] as String).toSet();
  }

  Future<void> deleteMealTemplate(String templateId) async {
    final db = await database;

    await db.transaction((transaction) async {
      await transaction.delete(
        'meal_template_items',
        where: 'template_id = ?',
        whereArgs: [templateId],
      );

      await transaction.delete(
        'meal_day_assignments',
        where: 'template_id = ?',
        whereArgs: [templateId],
      );

      await transaction.delete(
        'meal_templates',
        where: 'id = ?',
        whereArgs: [templateId],
      );
    });
  }

  Future<void> removeMealTemplateDay({
    required String templateId,
    required String day,
  }) async {
    final db = await database;
    await db.delete(
      'meal_day_assignments',
      where: 'template_id = ? AND day = ?',
      whereArgs: [templateId, day],
    );
  }

  Future<void> addMealTemplateDay({
    required String templateId,
    required String day,
  }) async {
    final db = await database;
    await db.insert(
      'meal_day_assignments',
      {'template_id': templateId, 'day': day},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
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
      _webSettings.addAll({
        'water': '1.4',
        'water_goal': '2.5',
        'locale': 'en',
        'logged_foods': '4',
      });
      _webFoodEntries.clear();
      return;
    }

    await close();
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_plan.db');
    await databaseFactory.deleteDatabase(path);
  }

  Future<String?> _loadString(String key) async {
    final db = await database;
    final result = await db.query(
      'app_settings',
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [key],
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first['value'] as String?;
  }

  Future<void> _saveString(String key, String value) async {
    final db = await database;
    await db.insert(
      'app_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}