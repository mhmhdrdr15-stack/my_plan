class FoodEntry {
  final int id;
  final String name;
  final String mealType;
  final String amount;
  final String calories;

  /// القيم الغذائية لكل 100 غرام.
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;

  final DateTime createdAt;

  const FoodEntry({
    required this.id,
    required this.name,
    required this.mealType,
    required this.amount,
    required this.calories,
    this.proteinPer100g = 0.0,
    this.carbsPer100g = 0.0,
    this.fatPer100g = 0.0,
    required this.createdAt,
  });

  factory FoodEntry.fromMap(
    Map<String, dynamic> map,
  ) {
    return FoodEntry(
      id: _toInt(map['id']),
      name:
          map['name'] as String? ??
              'Food',
      mealType:
          map['meal_type'] as String? ??
              'Lunch',
      amount:
          map['amount'] as String? ??
              '100 g',
      calories:
          map['calories'] as String? ??
              '100 kcal',

      proteinPer100g:
          _toDouble(
        map['protein_per_100g'],
      ),

      carbsPer100g:
          _toDouble(
        map['carbs_per_100g'],
      ),

      fatPer100g:
          _toDouble(
        map['fat_per_100g'],
      ),

      createdAt:
          DateTime.tryParse(
                map['created_at']
                        as String? ??
                    '',
              ) ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'meal_type': mealType,
      'amount': amount,
      'calories': calories,
      'protein_per_100g':
          proteinPer100g,
      'carbs_per_100g':
          carbsPer100g,
      'fat_per_100g':
          fatPer100g,
      'created_at':
          createdAt.toIso8601String(),
    };
  }

  FoodEntry copyWith({
    int? id,
    String? name,
    String? mealType,
    String? amount,
    String? calories,
    double? proteinPer100g,
    double? carbsPer100g,
    double? fatPer100g,
    DateTime? createdAt,
  }) {
    return FoodEntry(
      id:
          id ?? this.id,
      name:
          name ?? this.name,
      mealType:
          mealType ?? this.mealType,
      amount:
          amount ?? this.amount,
      calories:
          calories ?? this.calories,
      proteinPer100g:
          proteinPer100g ??
              this.proteinPer100g,
      carbsPer100g:
          carbsPer100g ??
              this.carbsPer100g,
      fatPer100g:
          fatPer100g ??
              this.fatPer100g,
      createdAt:
          createdAt ??
              this.createdAt,
    );
  }

  double get caloriesValue {
    return _extractNumber(
      calories,
    );
  }

  double get caloriesPer100g {
    return caloriesValue;
  }

  double get protein {
    return proteinPer100g;
  }

  double get carbs {
    return carbsPer100g;
  }

  double get fat {
    return fatPer100g;
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(
            value.trim(),
          ) ??
          0;
    }

    return 0;
  }

  static double _toDouble(
    dynamic value,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(
            value.trim(),
          ) ??
          0.0;
    }

    return 0.0;
  }

  static double _extractNumber(
    String value,
  ) {
    final cleaned =
        value
            .replaceAll(
              RegExp(
                r'[^0-9.\-]',
              ),
              '',
            )
            .trim();

    return double.tryParse(
          cleaned,
        ) ??
        0.0;
  }
}