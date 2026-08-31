import 'package:flutter/material.dart';

class MacroSummaryCard extends StatelessWidget {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double targetMin;
  final double targetMax;

  const MacroSummaryCard({
    super.key,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.targetMin,
    required this.targetMax,
  });

  static const Color primary = Color(0xFF5B35F5);

  @override
  Widget build(BuildContext context) {
    final progress = (calories / targetMax).clamp(0.0, 1.0);

    final within =
        calories >= targetMin && calories <= targetMax;

    final message = within
        ? '✓ الوجبة ضمن النطاق المستهدف'
        : calories < targetMin
            ? 'بقي ${(targetMin - calories).round()} سعرة تقريبًا'
            : 'الوجبة أعلى من النطاق المستهدف';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF704EFF),
            Color(0xFF542FE8),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.15),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'إجمالي الوجبة',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            calories.round().toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              height: 1,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'سعرة',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor:
                  Colors.white.withValues(alpha: 0.16),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _stat('${protein.round()}غ', 'بروتين'),
              _stat('${carbs.round()}غ', 'كربوهيدرات'),
              _stat('${fat.round()}غ', 'دهون'),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(
    String value,
    String title,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}