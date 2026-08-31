import 'package:my_plan/data/shared/catalog/food_catalog.dart';

class MealItem {
  final FoodCatalogItem food;
  final double grams;

  const MealItem({
    required this.food,
    required this.grams,
  });

  MealItem copyWith({
    FoodCatalogItem? food,
    double? grams,
  }) {
    return MealItem(
      food:
          food ?? this.food,
      grams:
          grams ?? this.grams,
    );
  }

  FoodNutrition get nutrition {
    return food.nutritionFor(
      grams,
    );
  }

  double get calories {
    return nutrition.calories;
  }

  double get protein {
    return nutrition.protein;
  }

  double get carbs {
    return nutrition.carbs;
  }

  double get fat {
    return nutrition.fat;
  }
}

class Meal {
  final String id;
  final String name;
  final String mealType;
  final String time;
  final List<MealItem> items;

  const Meal({
    required this.id,
    required this.name,
    required this.mealType,
    required this.time,
    required this.items,
  });

  Meal copyWith({
    String? id,
    String? name,
    String? mealType,
    String? time,
    List<MealItem>? items,
  }) {
    return Meal(
      id:
          id ?? this.id,
      name:
          name ?? this.name,
      mealType:
          mealType ?? this.mealType,
      time:
          time ?? this.time,
      items:
          items ?? this.items,
    );
  }

  double get calories {
    return items.fold(
      0.0,
      (
        total,
        item,
      ) =>
          total +
          item.calories,
    );
  }

  double get protein {
    return items.fold(
      0.0,
      (
        total,
        item,
      ) =>
          total +
          item.protein,
    );
  }

  double get carbs {
    return items.fold(
      0.0,
      (
        total,
        item,
      ) =>
          total +
          item.carbs,
    );
  }

  double get fat {
    return items.fold(
      0.0,
      (
        total,
        item,
      ) =>
          total +
          item.fat,
    );
  }

  int get itemCount {
    return items.length;
  }

  bool get isEmpty {
    return items.isEmpty;
  }

  Meal addItem(
    MealItem item,
  ) {
    return copyWith(
      items: [
        ...items,
        item,
      ],
    );
  }

  Meal removeItemAt(
    int index,
  ) {
    if (index < 0 ||
        index >= items.length) {
      return this;
    }

    final updated =
        List<MealItem>.from(
      items,
    );

    updated.removeAt(
      index,
    );

    return copyWith(
      items:
          updated,
    );
  }

  Meal updateItem(
    int index,
    MealItem item,
  ) {
    if (index < 0 ||
        index >= items.length) {
      return this;
    }

    final updated =
        List<MealItem>.from(
      items,
    );

    updated[index] =
        item;

    return copyWith(
      items:
          updated,
    );
  }
}