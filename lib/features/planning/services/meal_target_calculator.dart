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
      return const <MealTarget>[];
    }

    final names = List<String>.from(profile.mealNames);

    final times = List<String>.from(profile.mealTimes);

    final calorieRatios = _calorieRatios(mealCount, names);

    final proteinRatios = _proteinRatios(mealCount, names);

    final results = <MealTarget>[];

    for (var index = 0; index < mealCount; index++) {
      final mealType = index < names.length
          ? names[index]
          : 'وجبة ${index + 1}';

      final time = index < times.length ? times[index] : '';

      final calorieRatio = calorieRatios[index];

      final proteinRatio = proteinRatios[index];

      results.add(
        MealTarget(
          mealType: mealType,
          time: time,
          calories: profile.dailyCalories * calorieRatio,
          protein: profile.proteinTarget * proteinRatio,
          carbs: profile.carbsTarget * calorieRatio,
          fat: profile.fatTarget * calorieRatio,
        ),
      );
    }

    return results;
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

    return List<double>.filled(count, 1 / count);
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

    return List<double>.filled(count, 1 / count);
  }
}
