import 'food.dart';

class MealItem {
  final Food food;
  final double amountInGrams;

  const MealItem({
    required this.food,
    required this.amountInGrams,
  });

  double get calories {
    return food.caloriesPer100g * amountInGrams / 100;
  }

  double get protein {
    return food.proteinPer100g * amountInGrams / 100;
  }

  double get carbs {
    return food.carbsPer100g * amountInGrams / 100;
  }

  double get fat {
    return food.fatPer100g * amountInGrams / 100;
  }

  double get fiber {
    return food.fiberPer100g * amountInGrams / 100;
  }

  double get cost {
    return food.pricePer100g * amountInGrams / 100;
  }

  MealItem copyWith({
    Food? food,
    double? amountInGrams,
  }) {
    return MealItem(
      food: food ?? this.food,
      amountInGrams: amountInGrams ?? this.amountInGrams,
    );
  }
}

class Meal {
  final String id;
  final String name;
  final String time;
  final List<MealItem> items;

  const Meal({
    required this.id,
    required this.name,
    required this.time,
    required this.items,
  });

  double get calories {
    return items.fold(
      0,
      (sum, item) => sum + item.calories,
    );
  }

  double get protein {
    return items.fold(
      0,
      (sum, item) => sum + item.protein,
    );
  }

  double get carbs {
    return items.fold(
      0,
      (sum, item) => sum + item.carbs,
    );
  }

  double get fat {
    return items.fold(
      0,
      (sum, item) => sum + item.fat,
    );
  }

  double get fiber {
    return items.fold(
      0,
      (sum, item) => sum + item.fiber,
    );
  }

  double get cost {
    return items.fold(
      0,
      (sum, item) => sum + item.cost,
    );
  }

  Meal copyWith({
    String? id,
    String? name,
    String? time,
    List<MealItem>? items,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      items: items ?? this.items,
    );
  }
}