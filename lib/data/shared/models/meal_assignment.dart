import 'meal_template.dart';

class MealAssignment {
  final int dayIndex;
  final String mealType;
  final MealTemplate template;

  const MealAssignment({
    required this.dayIndex,
    required this.mealType,
    required this.template,
  });

  MealAssignment copyWith({
    int? dayIndex,
    String? mealType,
    MealTemplate? template,
  }) {
    return MealAssignment(
      dayIndex: dayIndex ?? this.dayIndex,
      mealType: mealType ?? this.mealType,
      template: template ?? this.template,
    );
  }
}