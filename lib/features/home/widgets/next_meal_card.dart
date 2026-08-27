import 'package:flutter/material.dart';
import 'package:my_plan/core/state/app_state.dart';
import 'package:my_plan/core/theme/app_colors.dart';
import 'package:my_plan/core/localization/app_localization.dart';
import 'package:my_plan/core/widgets/reusable_widgets.dart';

enum NextMealStatus { planned, logged, skipped, overdue }

class MealFood {
  final String name;
  final int grams;

  const MealFood({required this.name, required this.grams});
}

class NextMealCard extends StatefulWidget {
  final String mealName;
  final String time;
  final List<MealFood> foods;
  final int calories;
  final int protein;
  final int remainingCalories;
  final NextMealStatus status;
  final String imageAsset;
  final VoidCallback? onTap;

  const NextMealCard({
    super.key,
    required this.mealName,
    required this.time,
    required this.foods,
    required this.calories,
    required this.protein,
    required this.remainingCalories,
    required this.status,
    required this.imageAsset,
    this.onTap,
  });

  @override
  State<NextMealCard> createState() => _NextMealCardState();
}

class _NextMealCardState extends State<NextMealCard> {
  bool logged = false;

  Future<void> _markAsEaten() async {
    if (logged || widget.status == NextMealStatus.logged) return;
    setState(() => logged = true);
    await appState.addFood(
      name: widget.mealName,
      mealType: widget.mealName,
      amount: '1 serving',
      calories: '${widget.calories} kcal',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLogged = logged || widget.status == NextMealStatus.logged;
    final foodsSummary = widget.foods
      .map((food) => '${translateText(context, food.name)} ${food.grams}g')
      .join(' • ');
    return GestureDetector(
      onTap: widget.onTap,
      child: AppCard(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          translateText(context, 'Next Meal'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '•',
                        style: TextStyle(color: AppColors.muted2, fontSize: 13),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.time,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 22),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translateText(context, widget.mealName),
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        foodsSummary,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${widget.calories} kcal • ${widget.protein} g protein',
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 7),
                      SmallStatus(
                        text: translateText(context, isLogged ? 'Logged' : 'Planned'),
                        background: isLogged ? const Color(0xFFEAF8EF) : const Color(0xFFF0EEFF),
                        foreground: isLogged ? const Color(0xFF2DAA61) : const Color(0xFF6B5CE7),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    widget.imageAsset,
                    width: 132,
                    height: 132,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 132,
                      height: 132,
                      color: AppColors.background,
                      child: const Icon(Icons.restaurant_rounded, size: 34),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: FilledButton.icon(
                key: const ValueKey('next-meal-mark-eaten'),
                onPressed: isLogged ? null : _markAsEaten,
                icon: Icon(
                  isLogged ? Icons.check_circle_rounded : Icons.check_rounded,
                  size: 17,
                ),
                label: Text(translateText(context, isLogged ? 'Eaten' : 'Mark as eaten')),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFECE9FF),
                  disabledForegroundColor: AppColors.primary,
                  elevation: 1,
                  shadowColor: const Color(0x335B35F5),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: AppColors.primary2, width: 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
