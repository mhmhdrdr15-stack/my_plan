import 'package:flutter/material.dart';
import 'package:my_plan/core/localization/app_localization.dart';
import 'package:my_plan/core/theme/app_colors.dart';
import 'package:my_plan/core/widgets/reusable_widgets.dart';
import 'package:my_plan/features/plan/pages/edit_plan_screen.dart';
import 'package:my_plan/features/nutrition/pages/meal_details_screen.dart';
import 'package:my_plan/meal_actions_sheet.dart';

class TodayPlanCard extends StatelessWidget {
  const TodayPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 9),
      child: Column(
        children: [
            Row(
              children: [
                Text(translateText(context, "Today's Plan"), style: const TextStyle(color: AppColors.text, fontSize: 17, fontWeight: FontWeight.w800)),
                const Spacer(),
                GestureDetector(
                  key: const ValueKey('today-plan-edit'),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const EditPlanScreen()),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit_rounded, size: 15, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(translateText(context, 'Edit Plan'), style: const TextStyle(color: AppColors.primary, fontSize: 12.5, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
          ),
          const SizedBox(height: 6),
          const _MealRow(icon: Icons.egg_alt_outlined, imageUrl: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=240&q=80', title: 'Breakfast', time: '08:00 AM', items: 'Egg 100g • Bread 60g', nutrition: '420 kcal • 28g protein', status: _MealStatus.logged),
          const _MealRow(icon: Icons.restaurant_rounded, imageUrl: 'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=240&q=80', title: 'Lunch', time: '02:00 PM', items: 'Chicken 200g • Rice 150g • Salad 100g', nutrition: '620 kcal • 52g protein', status: _MealStatus.logged),
          const _MealRow(icon: Icons.apple_rounded, imageUrl: 'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=240&q=80', title: 'Snack', time: '05:30 PM', items: 'Apple 150g • Almonds 20g', nutrition: '200 kcal • 5g protein', status: _MealStatus.planned),
          const _MealRow(icon: Icons.eco_outlined, imageUrl: 'https://images.unsplash.com/photo-1547592180-85f173990554?w=240&q=80', title: 'Dinner', time: '08:30 PM', items: 'Tuna 120g • Bread 80g', nutrition: '450 kcal • 40g protein', status: _MealStatus.skipped),
        ],
      ),
    );
  }
}

enum _MealStatus { logged, planned, skipped }

class _MealRow extends StatelessWidget {
  final IconData icon;
  final String imageUrl;
  final String title;
  final String time;
  final String items;
  final String nutrition;
  final _MealStatus status;

  const _MealRow({required this.icon, required this.imageUrl, required this.title, required this.time, required this.items, required this.nutrition, required this.status});

  @override
  Widget build(BuildContext context) {
    final (background, label, foreground, sheetStatus) = switch (status) {
      _MealStatus.logged => (AppColors.greenTrack, 'Logged', AppColors.green, MealActionStatus.logged),
      _MealStatus.planned => (Color(0xFFF0EFFF), 'Planned', Color(0xFF5B5AE8), MealActionStatus.planned),
      _MealStatus.skipped => (AppColors.redTrack, 'Skipped', AppColors.red, MealActionStatus.skipped),
    };
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => MealDetailsScreen(
            mealName: title,
            mealTime: time,
            ingredients: items.split(' • '),
            calories: _nutritionValue(nutrition, 0),
            protein: _nutritionValue(nutrition, 1),
            imageUrl: imageUrl,
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE9ECF3)),
        ),
        child: Row(
        children: [
          AppNetworkImage(url: imageUrl, fallback: icon, width: 78, height: 78, radius: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(translateText(context, title), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(items.split(' • ').map((item) => translateText(context, item)).join(' • '), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 11, height: 1.35, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(nutrition, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 11, height: 1.35, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(width: 62, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(time, style: const TextStyle(color: AppColors.muted, fontSize: 10.5, fontWeight: FontWeight.w700)), const SizedBox(height: 8), Align(alignment: Alignment.centerRight, child: SmallStatus(text: translateText(context, label), background: background, foreground: foreground))])),
          IconButton(
            key: ValueKey('meal-actions-$title'),
            tooltip: translateText(context, 'More options'),
            onPressed: () => MealActionsSheet.show(context: context, mealName: translateText(context, title), mealTime: time, nutrition: nutrition, status: sheetStatus),
            icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF727A8B), size: 19),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          ),
          ],
        ),
      ),
    );
  }

  String _nutritionValue(String value, int index) {
    final values = value.split(' • ');
    if (index >= values.length) return '0';
    return values[index].replaceAll(RegExp(r'[^0-9]'), '');
  }
}
