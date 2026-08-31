import 'meal_template.dart';

class WeeklyPlan {
  final List<String> days;
  final List<String> mealTypes;
  final List<MealTemplate> templates;

  const WeeklyPlan({
    required this.days,
    required this.mealTypes,
    required this.templates,
  });

  WeeklyPlan copyWith({
    List<String>? days,
    List<String>? mealTypes,
    List<MealTemplate>? templates,
  }) {
    return WeeklyPlan(
      days:
          days ?? this.days,
      mealTypes:
          mealTypes ?? this.mealTypes,
      templates:
          templates ?? this.templates,
    );
  }

  List<MealTemplate> templatesForMealType(
    String mealType,
  ) {
    return templates
        .where(
          (template) =>
              template.mealType ==
              mealType,
        )
        .toList();
  }

  List<MealTemplate> templatesForDay(
    String day,
  ) {
    return templates
        .where(
          (template) =>
              template.assignedTo(day),
        )
        .toList();
  }

  List<MealTemplate> templatesForDayAndMeal(
    String day,
    String mealType,
  ) {
    return templates
        .where(
          (template) =>
              template.mealType ==
                  mealType &&
              template.assignedTo(day),
        )
        .toList();
  }

  int countForMealType(
    String mealType,
  ) {
    return templatesForMealType(
      mealType,
    ).length;
  }

  WeeklyPlan addTemplate(
    MealTemplate template,
  ) {
    final updated =
        List<MealTemplate>.from(
      templates,
    );

    updated.add(
      template,
    );

    return copyWith(
      templates:
          updated,
    );
  }

  WeeklyPlan updateTemplate(
    MealTemplate template,
  ) {
    final updated =
        List<MealTemplate>.from(
      templates,
    );

    final index =
        updated.indexWhere(
      (item) =>
          item.id ==
          template.id,
    );

    if (index == -1) {
      return addTemplate(
        template,
      );
    }

    updated[index] =
        template;

    return copyWith(
      templates:
          updated,
    );
  }

  WeeklyPlan removeTemplate(
    String templateId,
  ) {
    final updated =
        templates
            .where(
              (template) =>
                  template.id !=
                  templateId,
            )
            .toList();

    return copyWith(
      templates:
          updated,
    );
  }

  WeeklyPlan assignTemplateToDay({
    required String templateId,
    required String day,
  }) {
    final updated =
        templates.map(
      (template) {
        if (template.id !=
            templateId) {
          return template;
        }

        return template.assignTo(
          day,
        );
      },
    ).toList();

    return copyWith(
      templates:
          updated,
    );
  }

  WeeklyPlan removeTemplateFromDay({
    required String templateId,
    required String day,
  }) {
    final updated =
        templates.map(
      (template) {
        if (template.id !=
            templateId) {
          return template;
        }

        return template.removeFrom(
          day,
        );
      },
    ).toList();

    return copyWith(
      templates:
          updated,
    );
  }

  WeeklyPlan clearDay(
    String day,
  ) {
    final updated =
        templates.map(
      (template) {
        if (!template.assignedTo(
          day,
        )) {
          return template;
        }

        return template.removeFrom(
          day,
        );
      },
    ).toList();

    return copyWith(
      templates:
          updated,
    );
  }
}