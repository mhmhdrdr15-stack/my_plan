import 'package:my_plan/features/planning/models/meal.dart';

class MealTemplate {
  final String id;
  final String name;
  final String mealType;
  final Meal meal;
  final Set<String> assignedDays;
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
      assignedDays: assignedDays ?? this.assignedDays,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  double get calories => meal.calories;
  double get protein => meal.protein;
  double get carbs => meal.carbs;
  double get fat => meal.fat;
  bool get isAssigned => assignedDays.isNotEmpty;

  bool assignedTo(String day) => assignedDays.contains(day);

  MealTemplate assignTo(String day) {
    final days = Set<String>.from(assignedDays)..add(day);
    return copyWith(assignedDays: days);
  }

  MealTemplate removeFrom(String day) {
    final days = Set<String>.from(assignedDays)..remove(day);
    return copyWith(assignedDays: days);
  }
}
