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
        .take(2)
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
                Text(
                  translateText(context, 'Next Meal'),
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 22),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.imageAsset,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(
                      width: 72,
                      height: 72,
                      child: Icon(Icons.restaurant_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              translateText(context, widget.mealName),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                            ),
                          ),
                          Text(widget.time, style: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(foodsSummary, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                      const SizedBox(height: 6),
                      Text('${widget.calories} kcal • ${widget.protein} g protein', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 7),
                      SmallStatus(
                        text: translateText(context, isLogged ? 'Logged' : 'Planned'),
                        background: isLogged ? const Color(0xFFEAF8EF) : const Color(0xFFF0EEFF),
                        foreground: isLogged ? const Color(0xFF2DAA61) : const Color(0xFF6B5CE7),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            Container(
              padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
              decoration: BoxDecoration(color: const Color(0xFFF6F3FF), borderRadius: BorderRadius.circular(13)),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bolt_rounded, color: AppColors.primary, size: 19),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          '${widget.remainingCalories} kcal ${translateText(context, 'remaining')}',
                          style: const TextStyle(color: AppColors.text, fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                      ),
                      Text('${((widget.remainingCalories / 1800) * 100).round()}%', style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 9),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: FilledButton.icon(
                      key: const ValueKey('next-meal-mark-eaten'),
                      onPressed: isLogged ? null : _markAsEaten,
                      icon: Icon(isLogged ? Icons.check_circle_outline_rounded : Icons.check_rounded, size: 16),
                      label: Text(translateText(context, isLogged ? 'Eaten' : 'Mark as eaten')),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2DAA61),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
