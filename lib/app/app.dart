import 'package:flutter/material.dart';
import 'package:my_plan/core/localization/app_localization.dart';
import 'app_shell.dart';

class NutritionApp extends StatelessWidget {
  const NutritionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLanguageScope(child: AppShell());
  }
}
