import 'package:my_plan/data/shared/models/food_entry.dart';

class FoodCatalogItem {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String imageAsset;

  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;

  const FoodCatalogItem({
    required this.id,
    required this.name,
    this.brand = 'Generic',
    required this.category,
    required this.imageAsset,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
  });

  FoodNutrition nutritionFor(
    double grams,
  ) {
    final double factor =
        grams / 100.0;

    return FoodNutrition(
      calories:
          caloriesPer100g * factor,
      protein:
          proteinPer100g * factor,
      carbs:
          carbsPer100g * factor,
      fat:
          fatPer100g * factor,
    );
  }

  FoodEntry toFoodEntry({
    required int id,
    required double grams,
    String mealType = 'Food',
  }) {
    final nutrition =
        nutritionFor(grams);

    return FoodEntry(
      id: id,
      name: name,
      mealType: mealType,
      amount:
          '${_formatNumber(grams)} g',
      calories:
          '${_formatNumber(nutrition.calories)} kcal',
      proteinPer100g:
          proteinPer100g,
      carbsPer100g:
          carbsPer100g,
      fatPer100g:
          fatPer100g,
      createdAt:
          DateTime.now(),
    );
  }

  static String _formatNumber(
    double value,
  ) {
    if (value ==
        value.roundToDouble()) {
      return value
          .round()
          .toString();
    }

    return value.toStringAsFixed(1);
  }
}

class FoodNutrition {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  const FoodNutrition({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  FoodNutrition operator +(
    FoodNutrition other,
  ) {
    return FoodNutrition(
      calories:
          calories +
              other.calories,
      protein:
          protein +
              other.protein,
      carbs:
          carbs +
              other.carbs,
      fat:
          fat +
              other.fat,
    );
  }
}

class FoodCatalog {
  const FoodCatalog._();

  static const List<FoodCatalogItem>
      all = [
    FoodCatalogItem(
      id: 'chicken_breast',
      name: 'Chicken Breast',
      brand: 'Generic',
      category: 'Protein',
      imageAsset:
          'assets/food/chicken.jpg',
      caloriesPer100g:
          165.0,
      proteinPer100g:
          31.0,
      carbsPer100g:
          0.0,
      fatPer100g:
          3.6,
    ),

    FoodCatalogItem(
      id: 'brown_rice',
      name: 'Brown Rice',
      brand: 'Generic',
      category: 'Carbs',
      imageAsset:
          'assets/food/rice.jpg',
      caloriesPer100g:
          112.0,
      proteinPer100g:
          2.6,
      carbsPer100g:
          23.0,
      fatPer100g:
          0.9,
    ),

    FoodCatalogItem(
      id: 'egg',
      name: 'Egg',
      brand: 'Generic',
      category: 'Protein',
      imageAsset:
          'assets/food/egg.jpg',
      caloriesPer100g:
          143.0,
      proteinPer100g:
          12.6,
      carbsPer100g:
          0.7,
      fatPer100g:
          9.5,
    ),

    FoodCatalogItem(
      id: 'apple',
      name: 'Apple',
      brand: 'Generic',
      category: 'Fruits',
      imageAsset:
          'assets/food/apple.jpg',
      caloriesPer100g:
          52.0,
      proteinPer100g:
          0.3,
      carbsPer100g:
          13.8,
      fatPer100g:
          0.2,
    ),

    FoodCatalogItem(
      id: 'bread',
      name: 'Bread',
      brand: 'Generic',
      category: 'Carbs',
      imageAsset:
          'assets/food/bread.jpg',
      caloriesPer100g:
          250.0,
      proteinPer100g:
          9.0,
      carbsPer100g:
          49.0,
      fatPer100g:
          3.2,
    ),

    FoodCatalogItem(
      id: 'salad',
      name: 'Salad',
      brand: 'Generic',
      category: 'Vegetables',
      imageAsset:
          'assets/food/salad.jpg',
      caloriesPer100g:
          35.0,
      proteinPer100g:
          1.5,
      carbsPer100g:
          6.0,
      fatPer100g:
          0.4,
    ),
  ];

  static FoodCatalogItem? findById(
    String id,
  ) {
    for (final food in all) {
      if (food.id == id) {
        return food;
      }
    }

    return null;
  }

  static List<FoodCatalogItem> search(
    String query,
  ) {
    final normalized =
        query.trim().toLowerCase();

    if (normalized.isEmpty) {
      return List<
          FoodCatalogItem>.from(
        all,
      );
    }

    return all.where(
      (food) {
        return '${food.name} ${food.brand}'
            .toLowerCase()
            .contains(
              normalized,
            );
      },
    ).toList();
  }

  static List<FoodCatalogItem>
      byCategory(
    String category,
  ) {
    return all
        .where(
          (food) =>
              food.category ==
              category,
        )
        .toList();
  }

  static List<String>
      get categories {
    return all
        .map(
          (food) =>
              food.category,
        )
        .toSet()
        .toList();
  }
}