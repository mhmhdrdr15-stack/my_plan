import 'package:flutter/foundation.dart';

import 'package:my_plan/core/storage/database_helper.dart';
import 'package:my_plan/data/shared/catalog/food_catalog.dart';

import 'package:my_plan/features/planning/models/meal.dart';
import 'package:my_plan/features/planning/models/meal_template.dart';
import 'package:my_plan/features/planning/models/weekly_plan.dart';

class PlanningController extends ChangeNotifier {
  final AppDatabase _database;

  PlanningController({
    AppDatabase? database,
  }) : _database = database ?? AppDatabase();

  // ============================================================
  // DAILY TARGETS
  // ============================================================

  double _dailyCalories = 2200.0;
  double _dailyProtein = 165.0;
  double _dailyCarbs = 220.0;
  double _dailyFat = 73.0;

  double get dailyCalories => _dailyCalories;

  double get dailyProtein => _dailyProtein;

  double get dailyCarbs => _dailyCarbs;

  double get dailyFat => _dailyFat;

  // ============================================================
  // MEAL SCHEDULE
  // ============================================================

  List<MealScheduleConfig> _mealSchedule = [
    const MealScheduleConfig(
      id: 'breakfast',
      name: 'الإفطار',
      time: '08:00 ص',
      calories: 550.0,
    ),
    const MealScheduleConfig(
      id: 'lunch',
      name: 'الغداء',
      time: '02:00 م',
      calories: 900.0,
    ),
    const MealScheduleConfig(
      id: 'dinner',
      name: 'العشاء',
      time: '08:00 م',
      calories: 750.0,
    ),
  ];

  List<MealScheduleConfig> get mealSchedule =>
      List.unmodifiable(_mealSchedule);

  // ============================================================
  // WEEKLY PLAN
  // ============================================================

  WeeklyPlan _weeklyPlan = const WeeklyPlan(
    days: [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ],
    mealTypes: [
      'الإفطار',
      'الغداء',
      'العشاء',
    ],
    templates: [],
  );

  WeeklyPlan get weeklyPlan => _weeklyPlan;

  List<MealTemplate> get templates =>
      _weeklyPlan.templates;

  // ============================================================
  // LOADING STATE
  // ============================================================

  bool _loaded = false;

  bool get loaded => _loaded;

  // ============================================================
  // LOAD
  // ============================================================

  Future<void> load() async {
    await _database.init();

    await _loadTargets();
    await _loadSchedule();
    await _loadTemplates();

    _loaded = true;

    notifyListeners();
  }

  // ============================================================
  // LOAD DAILY TARGETS
  // ============================================================

  Future<void> _loadTargets() async {
    _dailyCalories =
        await _database.loadPlanningDailyCalories();

    _dailyProtein =
        await _database.loadPlanningDailyProtein();

    _dailyCarbs =
        await _database.loadPlanningDailyCarbs();

    _dailyFat =
        await _database.loadPlanningDailyFat();
  }

  // ============================================================
  // LOAD MEAL SCHEDULE
  // ============================================================

  Future<void> _loadSchedule() async {
    final rows =
        await _database.loadMealSchedules();

    if (rows.isEmpty) {
      return;
    }

    final loadedSchedule =
        <MealScheduleConfig>[];

    for (final row in rows) {
      final id = row['id']?.toString();
      final name = row['name']?.toString();
      final time = row['meal_time']?.toString();

      if (id == null ||
          name == null ||
          time == null) {
        continue;
      }

      loadedSchedule.add(
        MealScheduleConfig(
          id: id,
          name: name,
          time: time,
          calories: _toDouble(
            row['calories'],
          ),
        ),
      );
    }

    if (loadedSchedule.isNotEmpty) {
      _mealSchedule = loadedSchedule;
    }
  }

  // ============================================================
  // LOAD TEMPLATES
  // ============================================================

  Future<void> _loadTemplates() async {
    final rows =
        await _database.loadMealTemplates();

    if (rows.isEmpty) {
      _weeklyPlan =
          _weeklyPlan.copyWith(
        templates: const [],
      );
      return;
    }

    final loadedTemplates =
        <MealTemplate>[];

    for (final row in rows) {
      final template =
          await _buildTemplateFromDatabase(
        row,
      );

      if (template != null) {
        loadedTemplates.add(
          template,
        );
      }
    }

    _weeklyPlan =
        _weeklyPlan.copyWith(
      templates:
          loadedTemplates,
    );
  }

  Future<MealTemplate?>
      _buildTemplateFromDatabase(
    Map<String, dynamic> row,
  ) async {
    final id = row['id']?.toString();
    final name = row['name']?.toString();
    final mealType =
        row['meal_type']?.toString();
    final mealTime =
        row['meal_time']?.toString();

    if (id == null ||
        name == null ||
        mealType == null ||
        mealTime == null) {
      return null;
    }

    final itemRows =
        await _database.loadMealTemplateItems(
      id,
    );

    final mealItems =
        <MealItem>[];

    for (final itemRow in itemRows) {
      final foodId =
          itemRow['food_id']?.toString();

      final grams =
          _toDouble(
        itemRow['grams'],
      );

      if (foodId == null ||
          grams <= 0) {
        continue;
      }

      final food =
          FoodCatalog.findById(
        foodId,
      );

      if (food == null) {
        continue;
      }

      mealItems.add(
        MealItem(
          food: food,
          grams: grams,
        ),
      );
    }

    final assignedDays =
        await _database.loadMealTemplateDays(
      id,
    );

    final meal = Meal(
      id: id,
      name: name,
      mealType: mealType,
      time: mealTime,
      items: mealItems,
    );

    return MealTemplate(
      id: id,
      name: name,
      mealType: mealType,
      meal: meal,
      assignedDays: assignedDays,
      isFavorite:
          _toBool(
        row['is_favorite'],
      ),
    );
  }

  // ============================================================
  // DAILY TARGETS
  // ============================================================

  Future<void> updateDailyTargets({
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
  }) async {
    if (calories <= 0) {
      return;
    }

    if (protein < 0 ||
        carbs < 0 ||
        fat < 0) {
      return;
    }

    _dailyCalories = calories;
    _dailyProtein = protein;
    _dailyCarbs = carbs;
    _dailyFat = fat;

    notifyListeners();

    await _database.savePlanningDailyTargets(
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
    );
  }

  Future<void> updateDailyCalories(
    double calories,
  ) async {
    if (calories <= 0) {
      return;
    }

    _dailyCalories = calories;

    notifyListeners();

    await _database.savePlanningDailyTargets(
      calories: _dailyCalories,
      protein: _dailyProtein,
      carbs: _dailyCarbs,
      fat: _dailyFat,
    );
  }

  // ============================================================
  // MEAL SCHEDULE
  // ============================================================

  Future<void> updateMealSchedule(
    List<MealScheduleConfig> schedule,
  ) async {
    if (schedule.length < 2) {
      return;
    }

    final valid =
        schedule.every(
      (meal) =>
          meal.name.trim().isNotEmpty &&
          meal.time.trim().isNotEmpty &&
          meal.calories >= 100,
    );

    if (!valid) {
      return;
    }

    _mealSchedule =
        List<MealScheduleConfig>.from(
      schedule,
    );

    notifyListeners();

    await _persistMealSchedule();
  }

  Future<void> updateMeal(
    MealScheduleConfig updated,
  ) async {
    final index =
        _mealSchedule.indexWhere(
      (meal) => meal.id == updated.id,
    );

    if (index == -1) {
      _mealSchedule.add(updated);
    } else {
      _mealSchedule[index] = updated;
    }

    notifyListeners();

    await _persistMealSchedule();
  }

  Future<void> removeMeal(
    String id,
  ) async {
    if (_mealSchedule.length <= 2) {
      return;
    }

    _mealSchedule.removeWhere(
      (meal) => meal.id == id,
    );

    notifyListeners();

    await _persistMealSchedule();
  }

  Future<void> _persistMealSchedule() async {
    await _database.replaceMealSchedules(
      _mealSchedule
          .asMap()
          .entries
          .map(
            (entry) {
              final meal = entry.value;

              return <String, dynamic>{
                'id': meal.id,
                'name': meal.name,
                'meal_time': meal.time,
                'calories': meal.calories,
                'position': entry.key,
              };
            },
          )
          .toList(),
    );
  }

  // ============================================================
  // TEMPLATE
  // ============================================================

  Future<void> addTemplate(
    MealTemplate template,
  ) async {
    final exists =
        _weeklyPlan.templates.any(
      (item) => item.id == template.id,
    );

    if (exists) {
      await updateTemplate(template);
      return;
    }

    _weeklyPlan =
        _weeklyPlan.addTemplate(
      template,
    );

    notifyListeners();

    await _persistTemplate(
      template,
    );
  }

  Future<void> updateTemplate(
    MealTemplate template,
  ) async {
    _weeklyPlan =
        _weeklyPlan.updateTemplate(
      template,
    );

    notifyListeners();

    await _persistTemplate(
      template,
    );
  }

  Future<void> removeTemplate(
    String templateId,
  ) async {
    _weeklyPlan =
        _weeklyPlan.removeTemplate(
      templateId,
    );

    notifyListeners();

    await _database.deleteMealTemplate(
      templateId,
    );
  }

  // ============================================================
  // FAVORITE
  // ============================================================

  Future<void> toggleFavorite(
    String templateId,
  ) async {
    final current =
        _findTemplate(
      templateId,
    );

    if (current == null) {
      return;
    }

    final updated =
        current.copyWith(
      isFavorite:
          !current.isFavorite,
    );

    _weeklyPlan =
        _weeklyPlan.updateTemplate(
      updated,
    );

    notifyListeners();

    await _persistTemplate(
      updated,
    );
  }

  // ============================================================
  // ASSIGN TEMPLATE TO DAY
  // ============================================================

  Future<void> assignTemplate({
    required String templateId,
    required String day,
  }) async {
    final template =
        _findTemplate(
      templateId,
    );

    if (template == null) {
      return;
    }

    _weeklyPlan =
        _weeklyPlan.assignTemplateToDay(
      templateId: templateId,
      day: day,
    );

    notifyListeners();

    await _database.addMealTemplateDay(
      templateId: templateId,
      day: day,
    );
  }

  // ============================================================
  // REMOVE TEMPLATE FROM DAY
  // ============================================================

  Future<void> removeTemplateAssignment({
    required String templateId,
    required String day,
  }) async {
    final template =
        _findTemplate(
      templateId,
    );

    if (template == null) {
      return;
    }

    _weeklyPlan =
        _weeklyPlan
            .removeTemplateFromDay(
      templateId: templateId,
      day: day,
    );

    notifyListeners();

    await _database.removeMealTemplateDay(
      templateId: templateId,
      day: day,
    );
  }

  // ============================================================
  // CLEAR DAY
  // ============================================================

  Future<void> clearDay(
    String day,
  ) async {
    final assignedTemplates =
        _weeklyPlan.templates
            .where(
              (template) =>
                  template.assignedTo(day),
            )
            .toList();

    if (assignedTemplates.isEmpty) {
      return;
    }

    _weeklyPlan =
        _weeklyPlan.clearDay(
      day,
    );

    notifyListeners();

    for (final template
        in assignedTemplates) {
      await _database.removeMealTemplateDay(
        templateId: template.id,
        day: day,
      );
    }
  }

  // ============================================================
  // QUERIES
  // ============================================================

  List<MealTemplate> templatesForMeal(
    String mealType,
  ) {
    return _weeklyPlan.templatesForMealType(
      mealType,
    );
  }

  List<MealTemplate> templatesForDay(
    String day,
  ) {
    return _weeklyPlan.templatesForDay(
      day,
    );
  }

  List<MealTemplate> templatesForDayAndMeal({
    required String day,
    required String mealType,
  }) {
    return _weeklyPlan.templatesForDayAndMeal(
      day,
      mealType,
    );
  }

  // ============================================================
  // MEAL TARGET
  // ============================================================

  double caloriesForMeal(
    String mealName,
  ) {
    for (final meal
        in _mealSchedule) {
      if (meal.name == mealName) {
        return meal.calories;
      }
    }

    return 0.0;
  }

  String timeForMeal(
    String mealName,
  ) {
    for (final meal
        in _mealSchedule) {
      if (meal.name == mealName) {
        return meal.time;
      }
    }

    return '12:00 م';
  }

  // ============================================================
  // TEMPLATE PERSISTENCE
  // ============================================================

  Future<void> _persistTemplate(
    MealTemplate template,
  ) async {
    await _database.saveMealTemplate(
      template: <String, dynamic>{
        'id': template.id,
        'name': template.name,
        'meal_type': template.mealType,
        'meal_time': template.meal.time,
        'is_favorite':
            template.isFavorite ? 1 : 0,
        'created_at':
            DateTime.now().toIso8601String(),
      },
      items:
          template.meal.items
              .asMap()
              .entries
              .map(
                (entry) {
                  final item =
                      entry.value;

                  return <String, dynamic>{
                    'food_id':
                        item.food.id,
                    'grams':
                        item.grams,
                    'position':
                        entry.key,
                  };
                },
              )
              .toList(),
      assignedDays:
          template.assignedDays,
    );
  }

  // ============================================================
  // RESET
  // ============================================================

  Future<void> reset() async {
    _dailyCalories = 2200.0;
    _dailyProtein = 165.0;
    _dailyCarbs = 220.0;
    _dailyFat = 73.0;

    _mealSchedule = [
      const MealScheduleConfig(
        id: 'breakfast',
        name: 'الإفطار',
        time: '08:00 ص',
        calories: 550.0,
      ),
      const MealScheduleConfig(
        id: 'lunch',
        name: 'الغداء',
        time: '02:00 م',
        calories: 900.0,
      ),
      const MealScheduleConfig(
        id: 'dinner',
        name: 'العشاء',
        time: '08:00 م',
        calories: 750.0,
      ),
    ];

    final oldTemplates =
        List<MealTemplate>.from(
      _weeklyPlan.templates,
    );

    _weeklyPlan =
        const WeeklyPlan(
      days: [
        'الاثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد',
      ],
      mealTypes: [
        'الإفطار',
        'الغداء',
        'العشاء',
      ],
      templates: [],
    );

    _loaded = true;

    notifyListeners();

    await _database.savePlanningDailyTargets(
      calories:
          _dailyCalories,
      protein:
          _dailyProtein,
      carbs:
          _dailyCarbs,
      fat:
          _dailyFat,
    );

    await _persistMealSchedule();

    for (final template
        in oldTemplates) {
      await _database.deleteMealTemplate(
        template.id,
      );
    }
  }

  // ============================================================
  // HELPERS
  // ============================================================

  MealTemplate? _findTemplate(
    String id,
  ) {
    for (final template
        in _weeklyPlan.templates) {
      if (template.id == id) {
        return template;
      }
    }

    return null;
  }

  double _toDouble(
    dynamic value,
  ) {
    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0.0;
  }

  bool _toBool(
    dynamic value,
  ) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    return value?.toString() == '1';
  }
}

// ================================================================
// MEAL SCHEDULE CONFIG
// ================================================================

class MealScheduleConfig {
  final String id;
  final String name;
  final String time;
  final double calories;

  const MealScheduleConfig({
    required this.id,
    required this.name,
    required this.time,
    required this.calories,
  });

  MealScheduleConfig copyWith({
    String? id,
    String? name,
    String? time,
    double? calories,
  }) {
    return MealScheduleConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      calories: calories ?? this.calories,
    );
  }

  @override
  String toString() {
    return 'MealScheduleConfig('
        'id: $id, '
        'name: $name, '
        'time: $time, '
        'calories: $calories'
        ')';
  }
}