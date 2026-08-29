import 'dart:math' as math;

/// نوع الهدف الغذائي.
enum GoalType {
  loseWeight,
  maintainWeight,
  gainWeight,
  custom,
}

/// جنس المستخدم.
enum Gender {
  male,
  female,
}

/// مستوى النشاط اليومي.
enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extraActive,
}

/// سرعة التقدم.
enum ProgressSpeed {
  slow,
  moderate,
  fast,
}

/// نتيجة الحساب.
class GoalCalculationResult {
  final double bmr;
  final double tdee;
  final double suggestedCalories;

  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;

  final String goalTitle;
  final String activityTitle;
  final String progressTitle;

  const GoalCalculationResult({
    required this.bmr,
    required this.tdee,
    required this.suggestedCalories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.goalTitle,
    required this.activityTitle,
    required this.progressTitle,
  });
}

/// حاسبة الهدف.
///
/// الناتج هنا اقتراح مبدئي.
/// المستخدم يستطيع تعديل السعرات لاحقًا.
class GoalCalculator {
  const GoalCalculator();

  // ============================================================
  // MAIN
  // ============================================================

  GoalCalculationResult calculate({
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
    required GoalType goal,
    required ActivityLevel activity,
    required ProgressSpeed progressSpeed,
  }) {
    final double safeWeight =
        math.max(
          weightKg,
          1.0,
        ).toDouble();

    final double safeHeight =
        math.max(
          heightCm,
          50.0,
        ).toDouble();

    final int safeAge =
        math.max(
          age,
          13,
        ).toInt();

    final double bmr =
        _calculateBmr(
      weightKg: safeWeight,
      heightCm: safeHeight,
      age: safeAge,
      gender: gender,
    );

    final double activityMultiplier =
        _activityMultiplier(
      activity,
    );

    final double tdee =
        bmr * activityMultiplier;

    final double calorieAdjustment =
        _calorieAdjustment(
      goal: goal,
      progressSpeed: progressSpeed,
      tdee: tdee,
    );

    final double suggestedCalories =
        math.max(
          1200.0,
          tdee + calorieAdjustment,
        ).toDouble();

    final _MacroResult macros =
        _calculateMacros(
      calories:
          suggestedCalories,
      weightKg:
          safeWeight,
      goal:
          goal,
    );

    return GoalCalculationResult(
      bmr:
          _roundOneDecimal(bmr),
      tdee:
          _roundOneDecimal(tdee),
      suggestedCalories:
          _roundOneDecimal(
        suggestedCalories,
      ),
      proteinGrams:
          _roundOneDecimal(
        macros.protein,
      ),
      carbsGrams:
          _roundOneDecimal(
        macros.carbs,
      ),
      fatGrams:
          _roundOneDecimal(
        macros.fat,
      ),
      goalTitle:
          goalTitle(
        goal,
      ),
      activityTitle:
          activityTitle(
        activity,
      ),
      progressTitle:
          progressTitle(
        progressSpeed,
      ),
    );
  }

  // ============================================================
  // BMR
  // ============================================================

  double _calculateBmr({
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
  }) {
    final double base =
        (10.0 * weightKg) +
            (6.25 * heightCm) -
            (5.0 * age);

    switch (gender) {
      case Gender.male:
        return base + 5.0;

      case Gender.female:
        return base - 161.0;
    }
  }

  // ============================================================
  // ACTIVITY
  // ============================================================

  double _activityMultiplier(
    ActivityLevel activity,
  ) {
    switch (activity) {
      case ActivityLevel.sedentary:
        return 1.20;

      case ActivityLevel.lightlyActive:
        return 1.375;

      case ActivityLevel.moderatelyActive:
        return 1.55;

      case ActivityLevel.veryActive:
        return 1.725;

      case ActivityLevel.extraActive:
        return 1.90;
    }
  }

  // ============================================================
  // CALORIE ADJUSTMENT
  // ============================================================

  double _calorieAdjustment({
    required GoalType goal,
    required ProgressSpeed progressSpeed,
    required double tdee,
  }) {
    switch (goal) {
      case GoalType.loseWeight:
        return -_lossAdjustment(
          progressSpeed,
          tdee,
        );

      case GoalType.maintainWeight:
        return 0.0;

      case GoalType.gainWeight:
        return _gainAdjustment(
          progressSpeed,
          tdee,
        );

      case GoalType.custom:
        return 0.0;
    }
  }

  double _lossAdjustment(
    ProgressSpeed speed,
    double tdee,
  ) {
    switch (speed) {
      case ProgressSpeed.slow:
        return math
            .min(
              250.0,
              tdee * 0.08,
            )
            .toDouble();

      case ProgressSpeed.moderate:
        return math
            .min(
              450.0,
              tdee * 0.15,
            )
            .toDouble();

      case ProgressSpeed.fast:
        return math
            .min(
              650.0,
              tdee * 0.22,
            )
            .toDouble();
    }
  }

  double _gainAdjustment(
    ProgressSpeed speed,
    double tdee,
  ) {
    switch (speed) {
      case ProgressSpeed.slow:
        return math
            .min(
              180.0,
              tdee * 0.06,
            )
            .toDouble();

      case ProgressSpeed.moderate:
        return math
            .min(
              300.0,
              tdee * 0.10,
            )
            .toDouble();

      case ProgressSpeed.fast:
        return math
            .min(
              450.0,
              tdee * 0.15,
            )
            .toDouble();
    }
  }

  // ============================================================
  // MACROS
  // ============================================================

  _MacroResult _calculateMacros({
    required double calories,
    required double weightKg,
    required GoalType goal,
  }) {
    final double proteinMultiplier;

    switch (goal) {
      case GoalType.loseWeight:
        proteinMultiplier = 2.0;
        break;

      case GoalType.maintainWeight:
        proteinMultiplier = 1.6;
        break;

      case GoalType.gainWeight:
        proteinMultiplier = 1.8;
        break;

      case GoalType.custom:
        proteinMultiplier = 1.6;
        break;
    }

    final double protein =
        weightKg *
            proteinMultiplier;

    final double proteinCalories =
        protein * 4.0;

    final double remainingCalories =
        math
            .max(
              0.0,
              calories -
                  proteinCalories,
            )
            .toDouble();

    final double carbsCalories =
        remainingCalories * 0.40;

    final double fatCalories =
        remainingCalories * 0.60;

    final double carbs =
        carbsCalories / 4.0;

    final double fat =
        fatCalories / 9.0;

    return _MacroResult(
      protein:
          protein,
      carbs:
          carbs,
      fat:
          fat,
    );
  }

  // ============================================================
  // TITLES
  // ============================================================

  String goalTitle(
    GoalType goal,
  ) {
    switch (goal) {
      case GoalType.loseWeight:
        return 'خسارة الوزن';

      case GoalType.maintainWeight:
        return 'الحفاظ على الوزن';

      case GoalType.gainWeight:
        return 'زيادة الوزن';

      case GoalType.custom:
        return 'هدف مخصص';
    }
  }

  String activityTitle(
    ActivityLevel activity,
  ) {
    switch (activity) {
      case ActivityLevel.sedentary:
        return 'قليل جدًا';

      case ActivityLevel.lightlyActive:
        return 'خفيف';

      case ActivityLevel.moderatelyActive:
        return 'متوسط';

      case ActivityLevel.veryActive:
        return 'عالي';

      case ActivityLevel.extraActive:
        return 'عالي جدًا';
    }
  }

  String progressTitle(
    ProgressSpeed speed,
  ) {
    switch (speed) {
      case ProgressSpeed.slow:
        return 'تقدم هادئ';

      case ProgressSpeed.moderate:
        return 'تقدم متوسط';

      case ProgressSpeed.fast:
        return 'تقدم سريع';
    }
  }

  // ============================================================
  // ROUNDING
  // ============================================================

  double _roundOneDecimal(
    double value,
  ) {
    return double.parse(
      value.toStringAsFixed(1),
    );
  }
}

// ================================================================
// INTERNAL RESULT
// ================================================================

class _MacroResult {
  final double protein;
  final double carbs;
  final double fat;

  const _MacroResult({
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}