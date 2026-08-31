import 'package:flutter/material.dart';

import 'package:my_plan/features/home/pages/home_screen.dart';
import 'package:my_plan/features/nutrition/pages/progress_screen.dart';
import 'package:my_plan/features/plan/pages/plan_screen.dart';
<<<<<<< HEAD
import 'package:my_plan/features/planning/pages/planning_home_page.dart';
=======
import 'package:my_plan/features/planning/pages/planning_screen.dart';
>>>>>>> aa293c52c23f1846dac6deae987702c1a4c00379

class AppRouter {
  const AppRouter._();

  static Widget screenForTab(
    int index,
  ) {
    return switch (index) {
      0 => const HomeScreen(),
const (<<<<)<<< HEAD

      1 => const PlanScreen(
          showBottomNav: false,
        ),

      2 => const PlanningHomePage(),

      3 => const ProgressScreen(
          showBottomNav: false,
        ),

===const (===)=
      1 => const PlanScreen(showBottomNav: false),
      2 => const PlanningScreen(),
      3 => const ProgressScreen(showBottomNav: false),
const (>>>>>>)> aa293c52c23f1846dac6deae987702c1a4c00379
      _ => const HomeScreen(),
    };
  }
}