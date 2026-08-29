import 'package:flutter/material.dart';
import 'package:my_plan/core/localization/app_localization.dart';
import 'package:my_plan/core/state/app_state.dart';
import 'package:my_plan/core/theme/app_colors.dart';
import 'package:my_plan/features/home/widgets/home_header.dart';
import 'package:my_plan/features/home/widgets/insight_water_section.dart';
import 'package:my_plan/features/home/widgets/next_meal_card.dart';
import 'package:my_plan/features/home/widgets/today_plan_card.dart';
import 'package:my_plan/features/home/widgets/today_progress_card.dart';
import 'package:my_plan/features/nutrition/pages/snack_details_screen.dart';

export '../widgets/home_header.dart';
export '../widgets/insight_water_section.dart';
export '../widgets/next_meal_card.dart';
export '../widgets/today_plan_card.dart';
export '../widgets/today_progress_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void addWater(double amount) {
    appState.addWater(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const HomeHeader(),
                  const SizedBox(height: 14),
                  const TodayProgressCard(),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      translateText(context, 'Daily Insight'),
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  NextMealCard(
                    mealName: 'Snack',
                    time: '5:30 PM',
                    foods: const [
                      MealFood(name: 'Apple', grams: 150),
                      MealFood(name: 'Almonds', grams: 20),
                    ],
                    calories: 200,
                    protein: 5,
                    remainingCalories: 600,
                    status: NextMealStatus.planned,
                    imageAsset: 'assets/food/apple.jpg',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SnackDetailsScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedBuilder(
                    animation: appState,
                    builder: (context, _) => InsightWaterSection(
                      water: appState.water,
                      waterGoal: appState.waterGoal,
                      onAddWater: addWater,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const TodayPlanCard(),
                  const SizedBox(height: 180),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
