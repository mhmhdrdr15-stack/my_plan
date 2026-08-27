import 'package:flutter/material.dart';
import 'package:my_plan/core/localization/app_localization.dart';
import 'package:my_plan/core/theme/app_colors.dart';
import 'package:my_plan/core/widgets/reusable_widgets.dart';
import 'package:my_plan/features/nutrition/pages/today_details_screen.dart';

class TodayProgressCard extends StatelessWidget {
  const TodayProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                translateText(context, "Today's Progress"),
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              GestureDetector(
                key: const ValueKey('today-progress-details'),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const TodayDetailsScreen()),
                ),
                child: Row(
                  children: [
                    Text(
                      translateText(context, 'Details'),
                      style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 19),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 5, child: _CalorieSummary()),
              SizedBox(width: 12),
              SizedBox(
                height: 235,
                child: VerticalDivider(width: 1, thickness: 1, color: Color(0xFFEFF1F5)),
              ),
              SizedBox(width: 12),
              Expanded(flex: 6, child: _MacroProgressList()),
            ],
          ),
          const SizedBox(height: 9),
          SizedBox(
            height: 43,
            width: double.infinity,
            child: Material(
              color: const Color(0xFFF6F7FB),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      translateText(context, 'View all nutrients'),
                      style: const TextStyle(color: Color(0xFF343A4E), fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 19),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalorieSummary extends StatelessWidget {
  const _CalorieSummary();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 132,
          height: 132,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(
                width: 132,
                height: 132,
                child: CircularProgressIndicator(
                  value: .67,
                  strokeWidth: 9,
                  backgroundColor: AppColors.orangeTrack,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 3),
                  const Text('1,200', style: TextStyle(color: AppColors.text, fontSize: 24, fontWeight: FontWeight.w800, height: 1)),
                  const SizedBox(height: 3),
                  Text(translateText(context, 'of 1,800 kcal'), style: const TextStyle(color: Color(0xFF8B93A5), fontSize: 10, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '600', style: TextStyle(color: Color(0xFF1EA55A), fontSize: 20, fontWeight: FontWeight.w800)),
              TextSpan(text: ' kcal', style: TextStyle(color: Color(0xFF31384D), fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        const SizedBox(height: 1),
        Text(translateText(context, 'remaining'), style: const TextStyle(color: Color(0xFF939AAC), fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 9),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFFEFF9F3), borderRadius: BorderRadius.circular(18)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF1F9D58)),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  translateText(context, "You're on track! 🎉"),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF209757), fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MacroProgressList extends StatelessWidget {
  const _MacroProgressList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MacroRow(icon: Icons.local_fire_department_rounded, title: 'Calories', current: '1,200', goal: '1,800 kcal', percent: 67, color: AppColors.orange),
        const SizedBox(height: 12),
        _MacroRow(icon: Icons.spa_rounded, title: 'Protein', current: '85', goal: '130 g', percent: 65, color: AppColors.red),
        const SizedBox(height: 12),
        _MacroRow(icon: Icons.rice_bowl_rounded, title: 'Carbohydrates', current: '120', goal: '180 g', percent: 67, color: AppColors.blue),
        const SizedBox(height: 12),
        _MacroRow(icon: Icons.eco_rounded, title: 'Fats', current: '40', goal: '60 g', percent: 67, color: AppColors.green),
      ],
    );
  }
}

class _MacroRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String current;
  final String goal;
  final int percent;
  final Color color;

  const _MacroRow({required this.icon, required this.title, required this.current, required this.goal, required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    final track = color == AppColors.orange
        ? AppColors.orangeTrack
        : color == AppColors.red
            ? AppColors.redTrack
            : color == AppColors.blue
                ? AppColors.blueTrack
                : AppColors.greenTrack;
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: track, shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 21),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(translateText(context, title), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.text, fontSize: 12.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: current, style: const TextStyle(color: AppColors.text, fontSize: 13, fontWeight: FontWeight.w800)),
                        TextSpan(text: ' / $goal', style: const TextStyle(color: AppColors.muted2, fontSize: 11.5, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text('$percent%', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(value: percent / 100, minHeight: 6, backgroundColor: track, valueColor: AlwaysStoppedAnimation<Color>(color)),
        ),
      ],
    );
  }
}
