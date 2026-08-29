import 'package:my_plan/data/shared/models/meal_assignment.dart';
import 'package:my_plan/data/shared/models/meal_template.dart';
import 'package:my_plan/data/shared/models/weekly_plan.dart';

class WeeklyPlanService {
  const WeeklyPlanService();

  WeeklyPlan addTemplate({
    required WeeklyPlan plan,
    required MealTemplate template,
  }) {
    final exists = plan.templates.any((item) => item.id == template.id);

    if (exists) {
      return plan;
    }

    return plan.copyWith(templates: [...plan.templates, template]);
  }

  WeeklyPlan assignTemplate({
    required WeeklyPlan plan,
    required MealTemplate template,
    required String mealType,
    required List<int> days,
  }) {
    var updatedPlan = addTemplate(plan: plan, template: template);

    final assignments = List<MealAssignment>.from(updatedPlan.assignments);

    for (final dayIndex in days) {
      final existingIndex = assignments.indexWhere(
        (assignment) =>
            assignment.dayIndex == dayIndex && assignment.mealType == mealType,
      );

      final newAssignment = MealAssignment(
        dayIndex: dayIndex,
        mealType: mealType,
        template: template,
      );

      if (existingIndex == -1) {
        assignments.add(newAssignment);
      } else {
        assignments[existingIndex] = newAssignment;
      }
    }

    updatedPlan = updatedPlan.copyWith(assignments: assignments);

    return updatedPlan;
  }

  WeeklyPlan removeAssignment({
    required WeeklyPlan plan,
    required int dayIndex,
    required String mealType,
  }) {
    final assignments = plan.assignments
        .where(
          (assignment) =>
              !(assignment.dayIndex == dayIndex &&
                  assignment.mealType == mealType),
        )
        .toList();

    return plan.copyWith(assignments: assignments);
  }

  WeeklyPlan moveAssignment({
    required WeeklyPlan plan,
    required int fromDay,
    required int toDay,
    required String mealType,
  }) {
    if (fromDay == toDay) {
      return plan;
    }

    final assignment = plan.findAssignment(
      dayIndex: fromDay,
      mealType: mealType,
    );

    if (assignment == null) {
      return plan;
    }

    var updatedPlan = removeAssignment(
      plan: plan,
      dayIndex: fromDay,
      mealType: mealType,
    );

    updatedPlan = assignTemplate(
      plan: updatedPlan,
      template: assignment.template,
      mealType: mealType,
      days: [toDay],
    );

    return updatedPlan;
  }

  WeeklyPlan replaceAssignment({
    required WeeklyPlan plan,
    required int dayIndex,
    required String mealType,
    required MealTemplate template,
  }) {
    return assignTemplate(
      plan: plan,
      template: template,
      mealType: mealType,
      days: [dayIndex],
    );
  }

  WeeklyPlan removeTemplate({
    required WeeklyPlan plan,
    required String templateId,
  }) {
    final templates = plan.templates
        .where((template) => template.id != templateId)
        .toList();

    final assignments = plan.assignments
        .where((assignment) => assignment.template.id != templateId)
        .toList();

    return plan.copyWith(templates: templates, assignments: assignments);
  }
}
