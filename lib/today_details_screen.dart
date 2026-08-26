import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'reusable_widgets.dart';

class TodayDetailsScreen extends StatelessWidget {
  const TodayDetailsScreen({super.key});

  static const purple = Color(0xFF5B35F5);
  static const blue = Color(0xFF4478FF);
  static const green = Color(0xFF2CAE62);
  static const orange = Color(0xFFFF7900);
  static const background = Color(0xFFF7F8FC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: _Header()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const _CaloriesCard(),
                  const SizedBox(height: 16),
                  const _MacrosCard(),
                  const SizedBox(height: 16),
                  const _OtherNutrientsCard(),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 300) {
                        return const Column(
                          children: [
                            _CaloriesByMealCard(),
                            SizedBox(height: 16),
                            _HydrationCard(),
                          ],
                        );
                      }
                      return const IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: _CaloriesByMealCard()),
                            SizedBox(width: 16),
                            Expanded(child: _HydrationCard()),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const _RemainingBudgetCard(),
                  const SizedBox(height: 16),
                  const _InsightCard(),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomActions(),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        8,
        MediaQuery.paddingOf(context).top + 2,
        8,
        10,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 44,
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(CupertinoIcons.back, size: 24),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Today's Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Calendar',
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.calendar, size: 22),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.chevron_left, size: 17),
              SizedBox(width: 12),
              Icon(CupertinoIcons.calendar, size: 17, color: Color(0xFF424852)),
              SizedBox(width: 7),
              Flexible(
                child: Text(
                  'Sunday, 23 August',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF565D68),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Icon(CupertinoIcons.chevron_right, size: 17),
            ],
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _Card({required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0D1020),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CaloriesCard extends StatelessWidget {
  const _CaloriesCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 320;
          final summary = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Calories',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '1,200',
                        style: TextStyle(
                          fontSize: 24,
                          height: 1,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111318),
                        ),
                      ),
                      TextSpan(
                        text: ' / 1,800 kcal',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF606773),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 9),
              const Text(
                '600 kcal remaining',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: TodayDetailsScreen.purple,
                ),
              ),
              const SizedBox(height: 19),
              const FractionallySizedBox(
                widthFactor: .86,
                alignment: AlignmentDirectional.centerStart,
                child: _ProgressBar(
                  value: 1200 / 1800,
                  color: TodayDetailsScreen.purple,
                ),
              ),
              const SizedBox(height: 9),
              const Text(
                '67% of daily goal',
                style: TextStyle(fontSize: 11, color: Color(0xFF616874)),
              ),
            ],
          );
          const metrics = Row(
            children: [
              Expanded(
                child: _Metric(label: 'Consumed', value: '1,200 kcal'),
              ),
              _Divider(),
              Expanded(
                child: _Metric(label: 'Goal', value: '1,800 kcal'),
              ),
              _Divider(),
              Expanded(
                child: _Metric(
                  label: 'Remaining',
                  value: '600 kcal',
                  color: TodayDetailsScreen.purple,
                ),
              ),
            ],
          );
          final ring = SizedBox(
            width: compact ? 100 : 104,
            height: compact ? 100 : 104,
            child: CustomPaint(
              painter: const _RingPainter(),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _FireIcon(),
                    SizedBox(height: 2),
                    Text(
                      '67%',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'of goal',
                      style: TextStyle(
                        fontSize: 8,
                        height: 1.1,
                        color: Color(0xFF6A707A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          final topContent = compact
              ? Column(children: [summary, const SizedBox(height: 16), ring])
              : SizedBox(
                  height: 149,
                  child: Stack(
                    children: [
                      PositionedDirectional(
                        top: 0,
                        start: 0,
                        end: 112,
                        child: summary,
                      ),
                      PositionedDirectional(top: 45, end: 0, child: ring),
                    ],
                  ),
                );
          return Column(
            children: [topContent, const SizedBox(height: 16), metrics],
          );
        },
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _Metric({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 16,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            maxLines: 1,
            softWrap: false,
            style: const TextStyle(fontSize: 10, color: Color(0xFF414852)),
          ),
        ),
      ),
      const SizedBox(height: 5),
      FittedBox(
        alignment: Alignment.centerLeft,
        child: Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color ?? const Color(0xFF15191F),
          ),
        ),
      ),
    ],
  );
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => Container(
    height: 42,
    width: 1,
    margin: const EdgeInsets.symmetric(horizontal: 5),
    color: const Color(0xFFE3E6EC),
  );
}

class _FireIcon extends StatelessWidget {
  const _FireIcon();

  @override
  Widget build(BuildContext context) => Container(
    width: 42,
    height: 42,
    decoration: const BoxDecoration(
      color: Color(0xFFFFF0EC),
      shape: BoxShape.circle,
    ),
    child: const Icon(
      Icons.local_fire_department_rounded,
      color: Color(0xFFFF725E),
      size: 23,
    ),
  );
}

class _ProgressBar extends StatelessWidget {
  final double value;
  final Color color;

  const _ProgressBar({required this.value, required this.color});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(100),
    child: SizedBox(
      height: 10,
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: const Color(0xFFE2E5EB),
        color: color,
      ),
    ),
  );
}

class _MacrosCard extends StatelessWidget {
  const _MacrosCard();

  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      children: [
        const Row(
          children: [
            Text(
              'Macronutrients',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            Spacer(),
            Text(
              'View targets',
              style: TextStyle(
                fontSize: 11,
                color: TodayDetailsScreen.purple,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: TodayDetailsScreen.purple,
            ),
          ],
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final items = const [
              _MacroData(
                'Protein',
                '85 / 130 g',
                '65%',
                '45 g remaining',
                .65,
                TodayDetailsScreen.green,
                Icons.fitness_center_rounded,
              ),
              _MacroData(
                'Carbs',
                '120 / 180 g',
                '67%',
                '60 g remaining',
                .67,
                TodayDetailsScreen.blue,
                Icons.grain_rounded,
              ),
              _MacroData(
                'Fat',
                '40 / 60 g',
                '67%',
                '20 g remaining',
                .67,
                TodayDetailsScreen.orange,
                Icons.water_drop_outlined,
              ),
            ];
            return constraints.maxWidth < 320
                ? Column(
                    children: [
                      for (var i = 0; i < items.length; i++) ...[
                        if (i > 0) const Divider(height: 25),
                        _MacroItem(data: items[i]),
                      ],
                    ],
                  )
                : Row(
                    children: [
                      for (var i = 0; i < items.length; i++) ...[
                        if (i > 0) const _MacroDivider(),
                        Expanded(child: _MacroItem(data: items[i])),
                      ],
                    ],
                  );
          },
        ),
      ],
    ),
  );
}

class _MacroData {
  final String title, value, percent, remaining;
  final double progress;
  final Color color;
  final IconData icon;

  const _MacroData(
    this.title,
    this.value,
    this.percent,
    this.remaining,
    this.progress,
    this.color,
    this.icon,
  );
}

class _MacroItem extends StatelessWidget {
  final _MacroData data;

  const _MacroItem({required this.data});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        data.title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 7),
      Row(
        children: [
          Expanded(
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(
                data.value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: data.color.withValues(alpha: .11),
            ),
            child: Icon(data.icon, color: data.color, size: 16),
          ),
        ],
      ),
      const SizedBox(height: 4),
      Text(
        data.percent,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: data.color,
        ),
      ),
      const SizedBox(height: 9),
      _ProgressBar(value: data.progress, color: data.color),
      const SizedBox(height: 7),
      Text(
        data.remaining,
        style: const TextStyle(fontSize: 9, color: Color(0xFF757B85)),
      ),
    ],
  );
}

class _MacroDivider extends StatelessWidget {
  const _MacroDivider();

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 110,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    color: const Color(0xFFE4E6EC),
  );
}

class _OtherNutrientsCard extends StatelessWidget {
  const _OtherNutrientsCard();

  @override
  Widget build(BuildContext context) => _Card(
    padding: const EdgeInsets.fromLTRB(16, 14, 12, 8),
    child: Column(
      children: [
        const Row(
          children: [
            Text(
              'Other Nutrients',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            Spacer(),
            Text(
              'Learn more',
              style: TextStyle(fontSize: 11, color: TodayDetailsScreen.purple),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: TodayDetailsScreen.purple,
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final nutrient in const [
          (
            'Fiber',
            '18 / 30 g',
            .60,
            TodayDetailsScreen.green,
            Icons.spa_outlined,
            'Good',
          ),
          (
            'Sugar',
            '42 / 50 g',
            .84,
            TodayDetailsScreen.purple,
            Icons.hexagon_outlined,
            'Moderate',
          ),
          (
            'Saturated Fat',
            '12 / 20 g',
            .60,
            Color(0xFF7042F1),
            Icons.water_drop_outlined,
            'Moderate',
          ),
          (
            'Sodium',
            '1,450 / 2,300 mg',
            .63,
            TodayDetailsScreen.blue,
            Icons.science_outlined,
            'Good',
          ),
        ]) ...[_NutrientRow(nutrient: nutrient), const Divider(height: 1)],
      ],
    ),
  );
}

class _NutrientRow extends StatelessWidget {
  final (String, String, double, Color, IconData, String) nutrient;

  const _NutrientRow({required this.nutrient});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: nutrient.$4.withValues(alpha: .1),
            shape: BoxShape.circle,
          ),
          child: Icon(nutrient.$5, size: 15, color: nutrient.$4),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Text(
            nutrient.$1,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 3,
          child: _ProgressBar(value: nutrient.$3, color: nutrient.$4),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            nutrient.$2,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 64,
          padding: const EdgeInsets.symmetric(vertical: 7),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: nutrient.$6 == 'Good'
                ? const Color(0xFFEFF9F0)
                : const Color(0xFFFFF6E6),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Text(
            nutrient.$6,
            style: TextStyle(
              fontSize: 10,
              color: nutrient.$6 == 'Good'
                  ? TodayDetailsScreen.green
                  : TodayDetailsScreen.orange,
            ),
          ),
        ),
      ],
    ),
  );
}

class _CaloriesByMealCard extends StatelessWidget {
  const _CaloriesByMealCard();

  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Calories by Meal',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const SizedBox(
              width: 58,
              height: 58,
              child: CustomPaint(painter: _DonutPainter()),
            ),
            const SizedBox(width: 5),
            const Expanded(
              child: Column(
                children: [
                  _Legend(Color(0xFF49B94E), 'Breakfast', '420 kcal'),
                  SizedBox(height: 4),
                  _Legend(Color(0xFF2B72DD), 'Lunch', '620 kcal'),
                  SizedBox(height: 4),
                  _Legend(Color(0xFFFF9917), 'Snack', '160 kcal'),
                  SizedBox(height: 4),
                  _Legend(Color(0xFF8C47E5), 'Dinner', '0 kcal'),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 28),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(fontSize: 14, color: Color(0xFF5B626D)),
            ),
            Text(
              '1,200 kcal',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    ),
  );
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label, value;

  const _Legend(this.color, this.label, this.value);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
      const SizedBox(width: 7),
      Expanded(child: Text(label, style: const TextStyle(fontSize: 10))),
      Text(
        value,
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500),
      ),
    ],
  );
}

class _HydrationCard extends StatelessWidget {
  const _HydrationCard();

  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hydration',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFF0F6FF),
              child: Icon(
                Icons.water_drop_outlined,
                size: 22,
                color: TodayDetailsScreen.blue,
              ),
            ),
            SizedBox(width: 8),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '1.4',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111419),
                    ),
                  ),
                  TextSpan(
                    text: ' / 2.5 L',
                    style: TextStyle(fontSize: 12, color: Color(0xFF4E5661)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const _ProgressBar(value: 1.4 / 2.5, color: TodayDetailsScreen.blue),
        const SizedBox(height: 6),
        const Text(
          '1.1 L remaining',
          style: TextStyle(
            color: TodayDetailsScreen.blue,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (final label in const [
              '+250 ml',
              '+500 ml',
              '+1 L',
              'Log Water',
            ]) ...[
              if (label != '+250 ml') const SizedBox(width: 4),
              Expanded(child: _WaterAction(label)),
            ],
          ],
        ),
      ],
    ),
  );
}

class _WaterAction extends StatelessWidget {
  final String label;

  const _WaterAction(this.label);

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 42,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F6FF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.local_drink_outlined,
            size: 16,
            color: TodayDetailsScreen.blue,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 7,
              color: TodayDetailsScreen.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

class _RemainingBudgetCard extends StatelessWidget {
  const _RemainingBudgetCard();

  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Remaining Budget',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: _BudgetBox(
                '600',
                'kcal',
                Icons.local_fire_department_rounded,
                Color(0xFFFF725E),
              ),
            ),
            const SizedBox(width: 5),
            const Expanded(
              child: _BudgetBox(
                '45 g',
                'protein',
                Icons.fitness_center_rounded,
                TodayDetailsScreen.green,
              ),
            ),
            const SizedBox(width: 5),
            const Expanded(
              child: _BudgetBox(
                '60 g',
                'carbs',
                Icons.grain_rounded,
                TodayDetailsScreen.blue,
              ),
            ),
            const SizedBox(width: 5),
            const Expanded(
              child: _BudgetBox(
                '20 g',
                'fat',
                Icons.water_drop_outlined,
                TodayDetailsScreen.orange,
              ),
            ),
            const SizedBox(width: 5),
            const Expanded(
              child: _BudgetBox(
                '1.1 L',
                'water',
                Icons.water_drop_outlined,
                TodayDetailsScreen.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFFF8F1FF), Color(0xFFF0E8FF)],
            ),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFFE5D6FF),
                child: Icon(
                  Icons.auto_awesome,
                  color: TodayDetailsScreen.purple,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suggested next meal',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'You can still have a ~500-600 kcal dinner.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF50465A)),
                    ),
                  ],
                ),
              ),
              Icon(CupertinoIcons.chevron_right, color: Color(0xFF482777)),
            ],
          ),
        ),
      ],
    ),
  );
}

class _BudgetBox extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;

  const _BudgetBox(this.value, this.label, this.icon, this.color);

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 52,
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E5EB)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 3),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                FittedBox(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF626973),
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

class _InsightCard extends StatelessWidget {
  const _InsightCard();

  @override
  Widget build(BuildContext context) => _Card(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: TodayDetailsScreen.purple,
                    size: 24,
                  ),
                  SizedBox(width: 9),
                  Text(
                    "Today's Insight",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                "You're doing well on calories, but you're still 45g short on protein. Consider a high-protein dinner.",
                style: TextStyle(
                  fontSize: 12,
                  height: 1.38,
                  color: Color(0xFF2A3037),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        AppNetworkImage(
          url:
              'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=240&q=80',
          fallback: Icons.restaurant_rounded,
          width: 68,
          height: 68,
          radius: 14,
        ),
      ],
    ),
  );
}

class _BottomActions extends StatelessWidget {
  const _BottomActions();

  @override
  Widget build(BuildContext context) => Container(
    color: TodayDetailsScreen.background,
    padding: EdgeInsets.fromLTRB(
      16,
      6,
      16,
      8 + MediaQuery.paddingOf(context).bottom,
    ),
    child: Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: 'Add Food',
            icon: Icons.add,
            filled: true,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            label: 'Log Water',
            icon: Icons.water_drop_outlined,
            onTap: () {},
          ),
        ),
      ],
    ),
  );
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: filled ? TodayDetailsScreen.purple : Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
      side: filled
          ? BorderSide.none
          : const BorderSide(color: Color(0xFFE7E9F0)),
    ),
    elevation: filled ? 2 : 1,
    shadowColor: const Color(0x22000000),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: filled ? Colors.white : TodayDetailsScreen.purple,
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: filled ? Colors.white : TodayDetailsScreen.purple,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _RingPainter extends CustomPainter {
  const _RingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - 6;
    final background = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = const Color(0xFFE8EAF0);
    final foreground = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = TodayDetailsScreen.purple;
    canvas.drawCircle(center, radius, background);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * .67,
      false,
      foreground,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - 9;
    var start = -math.pi / 2;
    for (final segment in const [
      (0.35, Color(0xFF49B94E)),
      (0.52, Color(0xFF2B72DD)),
      (0.13, Color(0xFFFF9917)),
    ]) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..color = segment.$2;
      final sweep = segment.$1 * math.pi * 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
