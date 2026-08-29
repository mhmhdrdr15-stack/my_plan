class Food {
  final String id;
  final String name;
  final String category;

  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final double fiberPer100g;

  final double pricePer100g;

  final String imageUrl;

  const Food({
    required this.id,
    required this.name,
    required this.category,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    required this.fiberPer100g,
    required this.pricePer100g,
    required this.imageUrl,
  });
}