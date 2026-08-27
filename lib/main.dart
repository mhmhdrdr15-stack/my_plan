import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/localization/app_localization.dart';
import 'core/state/app_state.dart';

export 'app/app.dart';
export 'features/home/pages/home_screen.dart';
export 'features/home/widgets/next_meal_card.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appState.load();
  appLocale.value = appState.locale;
  runApp(const NutritionApp());
}


