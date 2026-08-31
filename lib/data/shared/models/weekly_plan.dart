import 'meal_assignment.dart';
import 'meal_template.dart';

class WeeklyPlan {
  final List<String> days;
  final List<String> mealTypes;
  final List<MealTemplate> templates;
  final List<MealAssignment> assignments;

  const WeeklyPlan({
    required this.days,
    required this.mealTypes,
    required this.templates,
    required this.assignments,
  });

  int get totalSlots {
    return days.length * mealTypes.length;
  }

  int get filledSlots {
    return assignments.length;
  }

  double get completion {
    if (totalSlots == 0) {
      return 0;
    }

    return (filledSlots / totalSlots).clamp(0.0, 1.0);
  }

  bool get isComplete {
    return filledSlots >= totalSlots;
  }

  int assignedCountForMealType(String mealType) {
    return assignments
        .where(
          (assignment) => assignment.mealType == mealType,
        )
        .map(
          (assignment) => assignment.dayIndex,
        )
        .toSet()
        .length;
  }

  List<MealAssignment> assignmentsForDay(int dayIndex) {
    return assignments
        .where(
          (assignment) => assignment.dayIndex == dayIndex,
        )
        .toList();
  }

  MealAssignment? findAssignment({
    required int dayIndex,
    required String mealType,
  }) {
    for (final assignment in assignments) {
      if (assignment.dayIndex == dayIndex &&
          assignment.mealType == mealType) {
        return assignment;
      }
    }

    return null;
  }

  List<MapEntry<int, String>> get emptySlots {
    final result = <MapEntry<int, String>>[];

    for (var day = 0; day < days.length; day++) {
      for (final mealType in mealTypes) {
        if (findAssignment(
              dayIndex: day,
              mealType: mealType,
            ) ==
            null) {
          result.add(
            MapEntry(day, mealType),
          );
        }
      }
    }

    return result;
  }

  WeeklyPlan copyWith({
    List<String>? days,
    List<String>? mealTypes,
    List<MealTemplate>? templates,
    List<MealAssignment>? assignments,
  }) {
    return WeeklyPlan(
      days: days ?? this.days,
      mealTypes: mealTypes ?? this.mealTypes,
      templates: templates ?? this.templates,
      assignments: assignments ?? this.assignments,
    );
  }
}