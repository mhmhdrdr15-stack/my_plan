import 'package:my_plan/data/shared/models/user_goal_profile.dart';

class MealTarget {
  final String mealType;
  final String time;

  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  const MealTarget({
    required this.mealType,
    required this.time,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}

class MealTargetCalculator {
  const MealTargetCalculator();

  List<MealTarget> calculate(UserGoalProfile profile) {
    final mealCount = profile.mealsPerDay;

    if (mealCount <= 0) {
      return const [];
    }

    final dailyCalories = profile.dailyCalories;

    final dailyProtein = profile.proteinTarget;

    final dailyCarbs = profile.carbsTarget;

    final dailyFat = profile.fatTarget;

    final names = List<String>.from(profile.mealNames);

    final times = List<String>.from(profile.mealTimes);

    final caloriesRatios = _calorieRatios(mealCount, names);

    final proteinRatios = _proteinRatios(mealCount, names);

    return List.generate(mealCount, (index) {
      final mealType = index < names.length
          ? names[index]
          : 'وجبة ${index + 1}';

      final time = index < times.length ? times[index] : '';

      final calorieRatio = caloriesRatios[index];

      final proteinRatio = proteinRatios[index];

      return MealTarget(
        mealType: mealType,
        time: time,
        calories: dailyCalories * calorieRatio,
        protein: dailyProtein * proteinRatio,
        carbs: dailyCarbs * calorieRatio,
        fat: dailyFat * calorieRatio,
      );
    });
  }

  List<double> _calorieRatios(int count, List<String> names) {
    if (count == 2) {
      return const [0.45, 0.55];
    }

    if (count == 3) {
      return const [0.25, 0.40, 0.35];
    }

    if (count == 4) {
      return const [0.25, 0.35, 0.15, 0.25];
    }

    if (count == 5) {
      return const [0.20, 0.30, 0.15, 0.20, 0.15];
    }

    return List.filled(count, 1 / count);
  }

  List<double> _proteinRatios(int count, List<String> names) {
    if (count == 2) {
      return const [0.45, 0.55];
    }

    if (count == 3) {
      return const [0.25, 0.40, 0.35];
    }

    if (count == 4) {
      return const [0.25, 0.35, 0.15, 0.25];
    }

    if (count == 5) {
      return const [0.20, 0.30, 0.15, 0.20, 0.15];
    }

    return List.filled(count, 1 / count);
  }
}
