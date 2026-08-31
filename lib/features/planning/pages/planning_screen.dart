import 'package:flutter/material.dart';
import 'package:my_plan/data/shared/models/user_goal_profile.dart';
import 'package:my_plan/features/planning/pages/planning_home_page.dart';

class PlanningScreen extends StatelessWidget {
  const PlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlanningHomeScreen(goalProfile: UserGoalProfile());
  }
}
