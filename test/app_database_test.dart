import 'package:flutter_test/flutter_test.dart';
import 'package:my_plan/app_state.dart';
import 'package:my_plan/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('AppDatabase stores local app data', () async {
    final db = AppDatabase();
    await db.deleteDatabase();
    await db.init();

    await db.saveWater(1.8);
    await db.saveWaterGoal(2.5);
    await db.saveLocale('en');
    await db.saveLoggedFoods(7);

    expect(await db.loadWater(), 1.8);
    expect(await db.loadWaterGoal(), 2.5);
    expect(await db.loadLocale(), 'en');
    expect(await db.loadLoggedFoods(), 7);
  });

  test('AppState loads persisted values from the local database', () async {
    final db = AppDatabase();
    await db.deleteDatabase();
    await db.init();
    await db.saveWater(1.2);
    await db.saveLocale('ar');
    await db.saveLoggedFoods(3);

    final state = AppState();
    await state.load();

    expect(state.water, 1.2);
    expect(state.locale.languageCode, 'ar');
    expect(state.loggedFoods, 3);
  });

  test('Food entries are persisted locally and can be reloaded', () async {
    final db = AppDatabase();
    await db.deleteDatabase();
    await db.init();

    await db.saveFoodEntry(
      name: 'Chicken Breast',
      mealType: 'Lunch',
      amount: '200 g',
      calories: '330 kcal',
    );

    final entries = await db.loadFoodEntries();
    expect(entries.length, 1);
    expect(entries.first.name, 'Chicken Breast');
    expect(entries.first.mealType, 'Lunch');
    expect(entries.first.amount, '200 g');
  });
}
