import 'package:flutter/material.dart';
import 'package:my_plan/core/localization/app_localization.dart';
import 'package:my_plan/core/theme/app_colors.dart';
import 'package:my_plan/core/widgets/reusable_widgets.dart';

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
              Icon(Icons.edit_rounded, size: 15, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(translateText(context, 'Edit Plan'), style: const TextStyle(color: AppColors.primary, fontSize: 12.5, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          const _MealRow(icon: Icons.egg_alt_outlined, imageUrl: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=240&q=80', title: 'Breakfast', time: '08:00 AM', items: 'Egg 100g • Bread 60g', nutrition: '420 kcal • 28g protein', status: _MealStatus.logged),
          const _MealDivider(),
          const _MealRow(icon: Icons.restaurant_rounded, imageUrl: 'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=240&q=80', title: 'Lunch', time: '02:00 PM', items: 'Chicken 200g • Rice 150g • Salad 100g', nutrition: '620 kcal • 52g protein', status: _MealStatus.logged),
          const _MealDivider(),
          const _MealRow(icon: Icons.apple_rounded, imageUrl: 'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=240&q=80', title: 'Snack', time: '05:30 PM', items: 'Apple 150g • Almonds 20g', nutrition: '200 kcal • 5g protein', status: _MealStatus.planned),
          const _MealDivider(),
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
    final (accent, background, label, foreground, statusIcon) = switch (status) {
      _MealStatus.logged => (AppColors.green, AppColors.greenTrack, 'Logged', AppColors.green, Icons.check_rounded),
      _MealStatus.planned => (Color(0xFF6C62FF), Color(0xFFF0EFFF), 'Planned', Color(0xFF5B5AE8), Icons.circle_outlined),
      _MealStatus.skipped => (AppColors.red, AppColors.redTrack, 'Skipped', AppColors.red, Icons.close_rounded),
    };
    return SizedBox(
      height: 77,
      child: Row(
        children: [
          AppNetworkImage(url: imageUrl, fallback: icon, width: 51, height: 51, radius: 14),
          const SizedBox(width: 9),
          Container(width: 29, height: 29, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: accent, width: 2)), child: Icon(statusIcon, size: 16, color: accent)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(translateText(context, title), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(items.split(' • ').map((item) => translateText(context, item)).join(' • '), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 10.5, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(nutrition, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF6C7488), fontSize: 10.5, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(width: 62, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(time, style: const TextStyle(color: AppColors.muted, fontSize: 10.5, fontWeight: FontWeight.w700)), const SizedBox(height: 8), Align(alignment: Alignment.centerRight, child: SmallStatus(text: translateText(context, label), background: background, foreground: foreground))])),
          const SizedBox(width: 3),
          const Icon(Icons.more_horiz_rounded, color: Color(0xFF727A8B), size: 19),
        ],
      ),
    );
  }
}

class _MealDivider extends StatelessWidget {
  const _MealDivider();

  @override
  Widget build(BuildContext context) => const Padding(padding: EdgeInsets.only(left: 71), child: Divider(height: 1, color: Color(0xFFEEF0F4)));
}
