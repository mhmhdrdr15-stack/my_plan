import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'app/app.dart';
import 'core/localization/app_localization.dart';
import 'core/state/app_state.dart';

export 'app/app.dart';
export 'features/home/pages/home_screen.dart';
export 'features/home/widgets/next_meal_card.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    databaseFactory = databaseFactoryFfi;
  }

  await appState.load();
  appLocale.value = appState.locale;
  runApp(const NutritionApp());
}
