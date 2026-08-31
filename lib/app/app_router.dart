import 'package:flutter/material.dart';

import 'package:my_plan/features/home/pages/home_screen.dart';
import 'package:my_plan/features/nutrition/pages/progress_screen.dart';
import 'package:my_plan/features/plan/pages/plan_screen.dart';
import 'package:my_plan/features/planning/pages/planning_home_page.dart';

class AppRouter {
  const AppRouter._();

  static Widget screenForTab(int index) {
    return switch (index) {
      0 => const HomeScreen(),
      1 => const PlanScreen(showBottomNav: false),
      2 => const PlanningHomePage(),
      3 => const ProgressScreen(showBottomNav: false),
      _ => const HomeScreen(),
    };
  }
}
