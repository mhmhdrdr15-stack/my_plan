import 'meal.dart';

class MealTemplate {
  final String id;
  final String name;
  final String mealType;
  final Meal meal;
  final bool isFavorite;

  const MealTemplate({
    required this.id,
    required this.name,
    required this.mealType,
    required this.meal,
    this.isFavorite = false,
  });

  MealTemplate copyWith({
    String? id,
    String? name,
    String? mealType,
    Meal? meal,
    bool? isFavorite,
  }) {
    return MealTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      mealType: mealType ?? this.mealType,
      meal: meal ?? this.meal,
      isFavorite:
          isFavorite ?? this.isFavorite,
    );
  }
}