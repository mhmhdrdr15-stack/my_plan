import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'add_food_screen.dart';
import 'app_bottom_nav.dart';
import 'app_localization.dart';
import 'log_screen.dart';
import 'plan_screen.dart';

class ProgressScreen extends StatefulWidget {
  final bool showBottomNav;

  const ProgressScreen({super.key, this.showBottomNav = true});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  static const primary = Color(0xFF4B2BFF);
  static const dark = Color(0xFF17203A);
  static const muted = Color(0xFF64708B);
  static const border = Color(0xFFEFEFF5);

  int selectedTab = 0;
  int selectedRange = 0;

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$feature is coming soon'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBFBFD),
        elevation: 0,
        title: Text(
          translateText(context, 'Progress'),
          style: TextStyle(
            color: dark,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showComingSoon('Calendar'),
            icon: const Icon(Icons.calendar_month_outlined, color: dark),
            tooltip: translateText(context, 'Calendar'),
          ),
          IconButton(
            onPressed: () => _showComingSoon('Filters'),
            icon: const Icon(Icons.tune_rounded, color: primary),
            tooltip: translateText(context, 'Filters'),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Text(
            translateText(
              context,
              'Track your journey. See how far you have come.',
            ),
            style: TextStyle(color: muted, fontSize: 13),
          ),
          const SizedBox(height: 18),
          _tabs(),
          const SizedBox(height: 14),
          _ranges(),
          const SizedBox(height: 14),
          _macroCards(),
          const SizedBox(height: 10),
          _consistencyBanner(),
          const SizedBox(height: 12),
          _caloriesCard(),
          const SizedBox(height: 12),
          _nutritionCards(),
          const SizedBox(height: 12),
          _weightCard(),
          const SizedBox(height: 12),
          _insightsCard(),
        ],
      ),
      bottomNavigationBar: widget.showBottomNav
          ? AppBottomNav(
              currentIndex: 3,
              onItemSelected: _navigateTo,
              onAdd: _openAddFood,
            )
          : null,
    );
  }

  void _openAddFood() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AddFoodScreen()));
  }

  void _navigateTo(int index) {
    if (index == 3) return;
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }
    final destination = switch (index) {
      1 => const PlanScreen(),
      2 => const LogFoodScreen(),
      _ => null,
    };
    if (destination != null) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => destination));
    }
  }

  Widget _tabs() {
    const labels = ['Overview', 'Nutrition', 'Meals', 'Trends'];
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: InkWell(
                onTap: () => setState(() => selectedTab = i),
                child: Center(
                  child: Text(
                    translateText(context, labels[i]),
                    style: TextStyle(
                      color: selectedTab == i ? primary : muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _ranges() {
    const ranges = ['7 Days', '30 Days', '3 Months', '6 Months', '1 Year'];
    return Row(
      children: [
        for (var i = 0; i < ranges.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == ranges.length - 1 ? 0 : 5),
              child: InkWell(
                onTap: () => setState(() => selectedRange = i),
                child: Container(
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedRange == i
                        ? const Color(0xFFF5F2FF)
                        : const Color(0xFFF4F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selectedRange == i
                          ? const Color(0xFFE6DFFF)
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    translateText(context, ranges[i]),
                    style: TextStyle(
                      color: selectedRange == i ? primary : muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _macroCards() {
    const data = [
      (
        'Calories',
        '1,620',
        '90%',
        Icons.local_fire_department_rounded,
        Color(0xFFFF741A),
        .90,
      ),
      (
        'Protein',
        '95 g',
        '73%',
        Icons.set_meal_rounded,
        Color(0xFFFF5261),
        .73,
      ),
      (
        'Carbs',
        '158 g',
        '88%',
        Icons.rice_bowl_rounded,
        Color(0xFF3587ED),
        .88,
      ),
      ('Fats', '52 g', '87%', Icons.eco_rounded, Color(0xFF32B965), .87),
    ];
    return Row(
      children: [
        for (var i = 0; i < data.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == data.length - 1 ? 0 : 6),
              child: _metricCard(
                data[i].$1,
                data[i].$2,
                data[i].$3,
                data[i].$4,
                data[i].$5,
                data[i].$6,
              ),
            ),
          ),
      ],
    );
  }

  Widget _metricCard(
    String title,
    String value,
    String percent,
    IconData icon,
    Color color,
    double progress,
  ) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 15, color: color),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              color: dark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: dark,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            color: color,
            backgroundColor: const Color(0xFFE9E9EC),
          ),
          const SizedBox(height: 3),
          Center(
            child: Text(
              '$percent of goal',
              style: const TextStyle(fontSize: 7, color: muted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _consistencyBanner() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.stars_rounded, size: 22, color: primary),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Great job! You were consistent with your goals this week.',
              style: TextStyle(
                color: Color(0xFF2D208C),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: primary),
        ],
      ),
    );
  }

  Widget _caloriesCard() {
    return _card(
      title: translateText(context, 'Calories'),
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: Row(
              children: [
                const SizedBox(
                  width: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('2,400', style: _axisStyle),
                      Text('1,800', style: _axisStyle),
                      Text('1,200', style: _axisStyle),
                      Text('600', style: _axisStyle),
                      Text('0', style: _axisStyle),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomPaint(
                          painter: _CaloriesChartPainter(),
                          child: const SizedBox.expand(),
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Mon', style: _axisStyle),
                          Text('Tue', style: _axisStyle),
                          Text('Wed', style: _axisStyle),
                          Text('Thu', style: _axisStyle),
                          Text('Fri', style: _axisStyle),
                          Text('Sat', style: _axisStyle),
                          Text('Sun', style: _axisStyle),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _stat('Total Consumed', '11,340 kcal'),
              _stat('Daily Average', '1,620 kcal', active: true),
              _stat('Goal Average', '1,800 kcal'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nutritionCards() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _card(
            title: translateText(context, 'Nutrition Distribution'),
            child: SizedBox(
              height: 108,
              child: Row(
                children: [
                  SizedBox(
                    width: 82,
                    height: 82,
                    child: CustomPaint(painter: _DonutPainter()),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Bullet('Protein', '23%', Color(0xFFFF4B55)),
                        _Bullet('Carbs', '43%', Color(0xFF3989F0)),
                        _Bullet('Fats', '29%', Color(0xFF31B964)),
                        _Bullet('Other', '5%', Color(0xFFB7BDC8)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _card(
            title: translateText(context, 'Macronutrients'),
            child: SizedBox(
              height: 108,
              child: CustomPaint(painter: _BarChartPainter()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _weightCard() {
    return _card(
      title: translateText(context, 'Weight  |  Last 30 days'),
      child: SizedBox(
        height: 105,
        child: Row(
          children: [
            Expanded(child: CustomPaint(painter: _WeightChartPainter())),
            const SizedBox(width: 10),
            const SizedBox(
              width: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Current', style: TextStyle(fontSize: 9, color: muted)),
                  Text(
                    '72.4 kg',
                    style: TextStyle(
                      fontSize: 14,
                      color: primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Change', style: TextStyle(fontSize: 9, color: muted)),
                  Text(
                    '-2.3 kg',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF29A95E),
                      fontWeight: FontWeight.w700,
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

  Widget _insightsCard() {
    return _card(
      title: translateText(context, 'Insights'),
      child: const Row(
        children: [
          Expanded(
            child: _Insight(
              icon: Icons.trending_up_rounded,
              color: Color(0xFF31B765),
              text: '2,340 kcal more than last week',
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _Insight(
              icon: Icons.timer_outlined,
              color: Color(0xFF3488ED),
              text: 'Protein intake is improving',
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _Insight(
              icon: Icons.star_rounded,
              color: Color(0xFFF1AE11),
              text: 'Goal hit 5 of 7 days',
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translateText(context, title),
          style: const TextStyle(
            fontSize: 11,
            color: dark,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    ),
  );

  Widget _stat(String label, String value, {bool active = false}) => Expanded(
    child: Container(
      height: 42,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Color(0xFFFAF9FD)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            translateText(context, label),
            style: const TextStyle(fontSize: 7, color: muted),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 9,
              color: active ? primary : dark,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    ),
  );
}

const _axisStyle = TextStyle(fontSize: 7, color: Color(0xFF63708B));

class _Bullet extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _Bullet(this.title, this.value, this.color);
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 4),
      Expanded(
        child: Text(
          translateText(context, title),
          style: const TextStyle(
            fontSize: 8,
            color: _ProgressScreenState.muted,
          ),
        ),
      ),
      Text(
        value,
        style: const TextStyle(fontSize: 8, color: _ProgressScreenState.dark),
      ),
    ],
  );
}

class _Insight extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _Insight({required this.icon, required this.color, required this.text});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(height: 5),
      Text(
        translateText(context, text),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 8, color: _ProgressScreenState.dark),
      ),
    ],
  );
}

class _CaloriesChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = [1450.0, 1720, 1380, 1910, 1620, 1480, 1680];
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = i * size.width / (points.length - 1);
      final y = size.height - (points[i] / 2400) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(
        Offset(x, y),
        2.5,
        Paint()..color = _ProgressScreenState.primary,
      );
    }
    final grid = Paint()
      ..color = const Color(0xFFEDEEF3)
      ..strokeWidth = .7;
    for (var i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(0, i * size.height / 4),
        Offset(size.width, i * size.height / 4),
        grid,
      );
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _ProgressScreenState.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var start = -math.pi / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    for (final item in [
      (0.23, const Color(0xFFFF4B55)),
      (0.43, const Color(0xFF3989F0)),
      (0.29, const Color(0xFF31B964)),
      (0.05, const Color(0xFFB7BDC8)),
    ]) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        item.$1 * math.pi * 2,
        false,
        Paint()
          ..color = item.$2
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10,
      );
      start += item.$1 * math.pi * 2;
    }
    canvas.drawCircle(center, radius - 6, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final values = [0.48, 0.79, 0.26];
    final colors = [
      const Color(0xFFFF4250),
      const Color(0xFF2F82ED),
      const Color(0xFF31B964),
    ];
    final width = size.width / 6;
    for (var i = 0; i < values.length; i++) {
      final height = size.height * values[i];
      final rect = Rect.fromLTWH(
        (i * 2 + 1) * width,
        size.height - height,
        width,
        height,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        Paint()..color = colors[i],
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WeightChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final values = [
      75.2,
      74.8,
      74.9,
      74.7,
      74.6,
      74.5,
      74.1,
      73.8,
      73.1,
      72.9,
      72.7,
      72.4,
    ];
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = i * size.width / (values.length - 1);
      final y = size.height - ((values[i] - 70) / 6) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _ProgressScreenState.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
