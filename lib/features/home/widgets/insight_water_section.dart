import 'package:flutter/material.dart';
import 'package:my_plan/core/localization/app_localization.dart';
import 'package:my_plan/core/theme/app_colors.dart';
import 'package:my_plan/core/widgets/reusable_widgets.dart';

class InsightWaterSection extends StatelessWidget {
  final double water;
  final double waterGoal;
  final ValueChanged<double> onAddWater;

  const InsightWaterSection({
    super.key,
    required this.water,
    required this.waterGoal,
    required this.onAddWater,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(child: _InsightCard()),
          const SizedBox(width: 12),
          Expanded(
            child: _WaterCard(
              current: water,
              goal: waterGoal,
              onAddWater: onAddWater,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.insightBg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.smart_toy_outlined,
                  size: 17,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 6),
              const Expanded(child: SizedBox.shrink()),
              const Icon(
                Icons.more_horiz_rounded,
                color: Color(0xFF777F93),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: translateText(context, 'You need '),
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                TextSpan(
                  text: translateText(context, '~45g more protein'),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1.45,
                  ),
                ),
                TextSpan(
                  text:
                      '\n${translateText(context, 'to reach your daily goal.')}',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              translateText(context, 'See suggestions'),
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterCard extends StatelessWidget {
  final double current;
  final double goal;
  final ValueChanged<double> onAddWater;

  const _WaterCard({
    required this.current,
    required this.goal,
    required this.onAddWater,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal == 0 ? 0.0 : (current / goal).clamp(0, 1).toDouble();
    return AppCard(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.water_drop_rounded,
                color: Color(0xFF3587ED),
                size: 21,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  translateText(context, 'Hydration'),
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            '${current.toStringAsFixed(1)} L / ${goal.toStringAsFixed(1)} L',
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: const Color(0xFFE7F0FC),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF3587ED),
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _WaterButton(
                label: translateText(context, '+250 ml'),
                onTap: () => onAddWater(.25),
              ),
              const SizedBox(width: 4),
              _WaterButton(
                label: translateText(context, '+500 ml'),
                onTap: () => onAddWater(.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaterButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _WaterButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF3587ED),
          padding: const EdgeInsets.symmetric(vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: const BorderSide(color: Color(0xFFD7E6FA)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
