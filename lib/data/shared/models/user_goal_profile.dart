class MealScheduleItem {
  final String name;
  final String time;
  final double calories;

  const MealScheduleItem({
    required this.name,
    required this.time,
    required this.calories,
  });

  MealScheduleItem copyWith({
    String? name,
    String? time,
    double? calories,
  }) {
    return MealScheduleItem(
      name: name ?? this.name,
      time: time ?? this.time,
      calories: calories ?? this.calories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'time': time,
      'calories': calories,
    };
  }

  factory MealScheduleItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return MealScheduleItem(
      name: json['name'] as String? ?? 'وجبة',
      time: json['time'] as String? ?? '12:00 م',
      calories: (json['calories'] as num?)?.toDouble() ?? 0,
    );
  }
}

class UserGoalProfile {
  final String goalTitle;
  final String activityTitle;

  final double dailyCalories;

  final double proteinTarget;
  final double carbsTarget;
  final double fatTarget;

  final int mealsPerDay;

  final List<String> mealNames;
  final List<String> mealTimes;

  final List<MealScheduleItem> mealSchedule;

  const UserGoalProfile({
    this.goalTitle = 'هدف شخصي',
    this.activityTitle = 'متوسط',
    this.dailyCalories = 2000,
    this.proteinTarget = 150,
    this.carbsTarget = 200,
    this.fatTarget = 67,
    this.mealsPerDay = 3,
    this.mealNames = const [
      'الإفطار',
      'الغداء',
      'العشاء',
    ],
    this.mealTimes = const [
      '08:00 ص',
      '02:00 م',
      '08:00 م',
    ],
    this.mealSchedule = const [
      MealScheduleItem(
        name: 'الإفطار',
        time: '08:00 ص',
        calories: 500,
      ),
      MealScheduleItem(
        name: 'الغداء',
        time: '02:00 م',
        calories: 800,
      ),
      MealScheduleItem(
        name: 'العشاء',
        time: '08:00 م',
        calories: 700,
      ),
    ],
  });

  UserGoalProfile copyWith({
    String? goalTitle,
    String? activityTitle,
    double? dailyCalories,
    double? proteinTarget,
    double? carbsTarget,
    double? fatTarget,
    int? mealsPerDay,
    List<String>? mealNames,
    List<String>? mealTimes,
    List<MealScheduleItem>? mealSchedule,
  }) {
    return UserGoalProfile(
      goalTitle:
          goalTitle ?? this.goalTitle,
      activityTitle:
          activityTitle ?? this.activityTitle,
      dailyCalories:
          dailyCalories ?? this.dailyCalories,
      proteinTarget:
          proteinTarget ?? this.proteinTarget,
      carbsTarget:
          carbsTarget ?? this.carbsTarget,
      fatTarget:
          fatTarget ?? this.fatTarget,
      mealsPerDay:
          mealsPerDay ?? this.mealsPerDay,
      mealNames:
          mealNames ?? this.mealNames,
      mealTimes:
          mealTimes ?? this.mealTimes,
      mealSchedule:
          mealSchedule ?? this.mealSchedule,
    );
  }

  MealScheduleItem? scheduleFor(
    String mealName,
  ) {
    for (final item in mealSchedule) {
      if (item.name == mealName) {
        return item;
      }
    }

    return null;
  }

  double caloriesForMeal(
    String mealName,
  ) {
    final item = scheduleFor(mealName);

    if (item != null) {
      return item.calories;
    }

    return 0;
  }

  String timeForMeal(
    String mealName,
  ) {
    final item = scheduleFor(mealName);

    if (item != null) {
      return item.time;
    }

    final index = mealNames.indexOf(mealName);

    if (index >= 0 &&
        index < mealTimes.length) {
      return mealTimes[index];
    }

    return '12:00 م';
  }

  Map<String, dynamic> toJson() {
    return {
      'goalTitle': goalTitle,
      'activityTitle': activityTitle,
      'dailyCalories': dailyCalories,
      'proteinTarget': proteinTarget,
      'carbsTarget': carbsTarget,
      'fatTarget': fatTarget,
      'mealsPerDay': mealsPerDay,
      'mealNames': mealNames,
      'mealTimes': mealTimes,
      'mealSchedule': mealSchedule
          .map(
            (item) => item.toJson(),
          )
          .toList(),
    };
  }

  factory UserGoalProfile.fromJson(
    Map<String, dynamic> json,
  ) {
    final names =
        (json['mealNames'] as List?)
                ?.map(
                  (e) => e.toString(),
                )
                .toList() ??
            const [
              'الإفطار',
              'الغداء',
              'العشاء',
            ];

    final times =
        (json['mealTimes'] as List?)
                ?.map(
                  (e) => e.toString(),
                )
                .toList() ??
            const [
              '08:00 ص',
              '02:00 م',
              '08:00 م',
            ];

    final scheduleRaw =
        json['mealSchedule'] as List?;

    final schedule =
        scheduleRaw
                ?.map(
                  (e) => MealScheduleItem.fromJson(
                    Map<String, dynamic>.from(
                      e as Map,
                    ),
                  ),
                )
                .toList() ??
            _buildDefaultSchedule(
              names,
              times,
              (json['dailyCalories'] as num?)
                      ?.toDouble() ??
                  2000,
            );

    return UserGoalProfile(
      goalTitle:
          json['goalTitle'] as String? ??
              'هدف شخصي',
      activityTitle:
          json['activityTitle'] as String? ??
              'متوسط',
      dailyCalories:
          (json['dailyCalories'] as num?)
                  ?.toDouble() ??
              2000,
      proteinTarget:
          (json['proteinTarget'] as num?)
                  ?.toDouble() ??
              150,
      carbsTarget:
          (json['carbsTarget'] as num?)
                  ?.toDouble() ??
              200,
      fatTarget:
          (json['fatTarget'] as num?)
                  ?.toDouble() ??
              67,
      mealsPerDay:
          (json['mealsPerDay'] as num?)
                  ?.toInt() ??
              names.length,
      mealNames:
          names,
      mealTimes:
          times,
      mealSchedule:
          schedule,
    );
  }

  static List<MealScheduleItem>
      _buildDefaultSchedule(
    List<String> names,
    List<String> times,
    double calories,
  ) {
    if (names.isEmpty) {
      return const [];
    }

    final ratios =
        _defaultRatios(
      names.length,
    );

    return List.generate(
      names.length,
      (index) {
        final time =
            index < times.length
                ? times[index]
                : '12:00 م';

        return MealScheduleItem(
          name:
              names[index],
          time:
              time,
          calories:
              calories * ratios[index],
        );
      },
    );
  }

  static List<double> _defaultRatios(
    int count,
  ) {
    switch (count) {
      case 2:
        return const [
          0.45,
          0.55,
        ];

      case 3:
        return const [
          0.25,
          0.40,
          0.35,
        ];

      case 4:
        return const [
          0.20,
          0.35,
          0.15,
          0.30,
        ];

      case 5:
        return const [
          0.18,
          0.27,
          0.10,
          0.28,
          0.17,
        ];

      default:
        return List<double>.filled(
          count,
          1 / count,
        );
    }
  }
}