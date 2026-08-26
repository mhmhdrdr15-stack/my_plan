// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:my_plan/app_localization.dart';
import 'package:my_plan/app_state.dart';
import 'package:my_plan/main.dart';

void main() {
  testWidgets('opens today details from the dashboard', (
    WidgetTester tester,
  ) async {
    appLocale.value = const Locale('en');
    await tester.pumpWidget(const NutritionApp());

    await tester.tap(find.text('Details'));
    await tester.pumpAndSettle();

    expect(find.text("Today's Details"), findsOneWidget);
    expect(find.text('Macronutrients'), findsOneWidget);
  });

  testWidgets('opens snack details from the next meal card', (
    WidgetTester tester,
  ) async {
    appLocale.value = const Locale('en');
    await tester.pumpWidget(const NutritionApp());

    await tester.scrollUntilVisible(
      find.text('Next Meal'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byType(NextMealCard));
    await tester.pumpAndSettle();

    expect(find.text('Foods in this meal'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Nutrition Summary'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Nutrition Summary'), findsOneWidget);
  });

  testWidgets('displays the health dashboard', (WidgetTester tester) async {
    appLocale.value = const Locale('en');
    await tester.pumpWidget(const NutritionApp());

    expect(find.text('Good morning, Mahmoud 👋'), findsOneWidget);
    expect(find.text("Today's Progress"), findsOneWidget);
    expect(find.text('Daily Insight'), findsOneWidget);
    expect(find.text('Search for food'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('open-settings')));
    await tester.pumpAndSettle();
    expect(find.text('Manage your account and preferences.'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text("Today's Plan"),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text("Today's Plan"), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('app-nav-1')));
    await tester.pumpAndSettle();
    expect(find.text('Plan your meals. Stay on track.'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('app-nav-2')));
    await tester.pumpAndSettle();
    expect(find.text('Log Food'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('app-nav-3')));
    await tester.pumpAndSettle();
    expect(
      find.text('Track your journey. See how far you have come.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('app-nav-add')));
    await tester.pumpAndSettle();
    expect(find.text('Add Food'), findsOneWidget);
    expect(find.byKey(const ValueKey('app-nav-0')), findsOneWidget);
  });

  testWidgets('persists a food entry and toggles language', (
    WidgetTester tester,
  ) async {
    final startingFoodCount = appState.loggedFoods;
    await tester.pumpWidget(const NutritionApp());

    await tester.tap(find.byKey(const ValueKey('app-nav-add')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to Lunch'));
    await tester.pumpAndSettle();
    expect(appState.loggedFoods, startingFoodCount + 1);

    await appState.setLocale(const Locale('ar'));
    appLocale.value = const Locale('ar');
    await tester.pump();
    expect(appState.locale.languageCode, 'ar');
    expect(find.text('صباح الخير، محمود 👋'), findsOneWidget);
    appLocale.value = const Locale('en');
    appState.locale = const Locale('en');
  });
}
