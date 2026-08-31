<<<<<<< HEAD
import 'package:my_plan/features/planning/models/meal.dart';

class MealTemplate {
  final String id;
  final String name;
  final String mealType;
  final Meal meal;

  /// الأيام التي تم توزيع القالب عليها.
  final Set<String> assignedDays;

  /// هل هذا القالب هو المفضل للمستخدم؟
  final bool isFavorite;

  const MealTemplate({
    required this.id,
    required this.name,
    required this.mealType,
    required this.meal,
    this.assignedDays = const <String>{},
    this.isFavorite = false,
  });

  MealTemplate copyWith({
    String? id,
    String? name,
    String? mealType,
    Meal? meal,
    Set<String>? assignedDays,
    bool? isFavorite,
  }) {
    return MealTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      mealType: mealType ?? this.mealType,
      meal: meal ?? this.meal,
      assignedDays:
          assignedDays ?? this.assignedDays,
      isFavorite:
          isFavorite ?? this.isFavorite,
    );
  }

  double get calories {
    return meal.calories;
  }

  double get protein {
    return meal.protein;
  }

  double get carbs {
    return meal.carbs;
  }

  double get fat {
    return meal.fat;
  }

  bool get isAssigned {
    return assignedDays.isNotEmpty;
  }

  bool assignedTo(
    String day,
  ) {
    return assignedDays.contains(day);
  }

  MealTemplate assignTo(
    String day,
  ) {
    final days =
        Set<String>.from(
      assignedDays,
    );

    days.add(day);

    return copyWith(
      assignedDays:
          days,
    );
  }

  MealTemplate removeFrom(
    String day,
  ) {
    final days =
        Set<String>.from(
      assignedDays,
    );

    days.remove(day);

    return copyWith(
      assignedDays:
          days,
    );
  }
}
=======
export 'package:my_plan/data/shared/models/meal_template.dart';
>>>>>>> aa293c52c23f1846dac6deae987702c1a4c00379
