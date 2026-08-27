class FoodEntry {
  final int id;
  final String name;
  final String mealType;
  final String amount;
  final String calories;
  final DateTime createdAt;

  const FoodEntry({
    required this.id,
    required this.name,
    required this.mealType,
    required this.amount,
    required this.calories,
    required this.createdAt,
  });

  factory FoodEntry.fromMap(Map<String, dynamic> map) {
    return FoodEntry(
      id: map['id'] as int,
      name: map['name'] as String,
      mealType: map['meal_type'] as String,
      amount: map['amount'] as String,
      calories: map['calories'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
