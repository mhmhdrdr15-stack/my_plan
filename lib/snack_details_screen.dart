import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_food_screen.dart';
import 'app_bottom_nav.dart';
import 'log_screen.dart';
import 'plan_screen.dart';
import 'progress_screen.dart';
import 'reusable_widgets.dart';

class SnackDetailsScreen extends StatelessWidget {
  const SnackDetailsScreen({super.key});

  static const purple = Color(0xFF5B35F5);
  static const blue = Color(0xFF4478FF);
  static const green = Color(0xFF2CAE62);
  static const orange = Color(0xFFFF7900);
  static const pink = Color(0xFFE73572);
  static const text = Color(0xFF111827);
  static const secondary = Color(0xFF626976);
  static const line = Color(0xFFE5E7EC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: _SnackHeader()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const _SnackOverview(),
                  const SizedBox(height: 12),
                  const _FoodsCard(),
                  const SizedBox(height: 12),
                  const _NutritionCard(),
                  const SizedBox(height: 12),
                  const _ImpactCard(),
                  const SizedBox(height: 12),
                  _PrimaryButton(
                    icon: Icons.check_circle_outline,
                    label: 'Log Meal',
                    onTap: () {},
                  ),
                  const SizedBox(height: 14),
                  const _EditSkipButtons(),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onItemSelected: (index) {
          if (index == 0) {
            Navigator.of(context).pop();
            return;
          }
          final destination = switch (index) {
            1 => const PlanScreen(),
            2 => const LogFoodScreen(),
            3 => const ProgressScreen(),
            _ => null,
          };
          if (destination != null) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => destination));
          }
        },
        onAdd: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const AddFoodScreen())),
      ),
    );
  }
}

class _SnackHeader extends StatelessWidget {
  const _SnackHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        8,
        MediaQuery.paddingOf(context).top + 2,
        8,
        0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(CupertinoIcons.back, size: 24),
              ),
              const Expanded(
                child: Column(
                  children: [
                    Text(
                      'Snack',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: SnackDetailsScreen.text,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '5:30 PM',
                      style: TextStyle(
                        fontSize: 14,
                        color: SnackDetailsScreen.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'More',
                onPressed: () {},
                icon: const Icon(CupertinoIcons.ellipsis, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF0E8FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.calendar,
                  color: SnackDetailsScreen.purple,
                  size: 19,
                ),
                SizedBox(width: 8),
                Text(
                  'Planned',
                  style: TextStyle(
                    fontSize: 12,
                    color: SnackDetailsScreen.purple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final double radius;

  const _Card({required this.child, this.radius = 20});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
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

class _SnackOverview extends StatelessWidget {
  const _SnackOverview();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final image = const AppNetworkImage(
              url:
                  'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=640&q=85',
              fallback: Icons.restaurant_rounded,
              width: 132,
              height: 106,
              radius: 16,
            );
            final title = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Snack',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: SnackDetailsScreen.text,
                  ),
                ),
                const SizedBox(height: 8),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '🔥  ', style: TextStyle(fontSize: 18)),
                      TextSpan(
                        text: '200',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: SnackDetailsScreen.purple,
                        ),
                      ),
                      TextSpan(
                        text: ' kcal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: SnackDetailsScreen.purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
            final macros = const Row(
              children: [
                Expanded(
                  child: _MacroStat(
                    Icons.fitness_center_rounded,
                    '5 g',
                    'Protein',
                    SnackDetailsScreen.green,
                  ),
                ),
                _MacroLine(),
                Expanded(
                  child: _MacroStat(
                    Icons.grain_rounded,
                    '25 g',
                    'Carbs',
                    SnackDetailsScreen.blue,
                  ),
                ),
                _MacroLine(),
                Expanded(
                  child: _MacroStat(
                    Icons.water_drop_outlined,
                    '8 g',
                    'Fat',
                    SnackDetailsScreen.orange,
                  ),
                ),
              ],
            );
            final details = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                const SizedBox(height: 10),
                macros,
                const SizedBox(height: 10),
                const _InfoText(CupertinoIcons.clock, 'Planned for 5:30 PM'),
                const SizedBox(height: 5),
                const _InfoText(
                  CupertinoIcons.bolt,
                  '600 kcal remaining',
                  accent: SnackDetailsScreen.purple,
                ),
              ],
            );
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: details),
                const SizedBox(width: 10),
                image,
              ],
            );
          },
        ),
      ],
    );
  }
}

class _MacroStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MacroStat(this.icon, this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color.withValues(alpha: .09),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
      const SizedBox(width: 8),
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: SnackDetailsScreen.secondary,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _MacroLine extends StatelessWidget {
  const _MacroLine();

  @override
  Widget build(BuildContext context) => Container(
    height: 38,
    width: 1,
    margin: const EdgeInsets.symmetric(horizontal: 6),
    color: SnackDetailsScreen.line,
  );
}

class _InfoText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color accent;

  const _InfoText(
    this.icon,
    this.text, {
    this.accent = SnackDetailsScreen.text,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: const Color(0xFF555D68)),
      const SizedBox(width: 7),
      Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: accent,
          fontWeight: accent == SnackDetailsScreen.purple
              ? FontWeight.w600
              : FontWeight.normal,
        ),
      ),
    ],
  );
}

class _FoodsCard extends StatelessWidget {
  const _FoodsCard();

  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      children: [
        const Row(
          children: [
            Text(
              'Foods in this meal',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Spacer(),
            Text(
              'Edit meal',
              style: TextStyle(
                fontSize: 10,
                color: SnackDetailsScreen.purple,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 7),
            Icon(
              Icons.edit_outlined,
              color: SnackDetailsScreen.purple,
              size: 15,
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _FoodItem('Apple', '150 g', '78 kcal', FoodType.apple),
        const SizedBox(height: 10),
        const _FoodItem('Almonds', '20 g', '120 kcal', FoodType.almonds),
        const SizedBox(height: 19),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: SnackDetailsScreen.purple,
              size: 23,
            ),
            SizedBox(width: 8),
            Text(
              'Add food',
              style: TextStyle(
                color: SnackDetailsScreen.purple,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

enum FoodType { apple, almonds }

class _FoodItem extends StatelessWidget {
  final String name;
  final String grams;
  final String calories;
  final FoodType type;

  const _FoodItem(this.name, this.grams, this.calories, this.type);

  @override
  Widget build(BuildContext context) => Container(
    height: 82,
    padding: const EdgeInsets.all(7),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFE8EAF0)),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 76,
          height: 62,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: AppNetworkImage(
              url: type == FoodType.apple
                  ? 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=320&q=85'
                  : 'https://images.unsplash.com/photo-1508061253366-f7da158b6d46?auto=format&fit=crop&w=320&q=85',
              fallback: type == FoodType.apple
                  ? Icons.apple
                  : Icons.grain_rounded,
              width: 76,
              height: 62,
              radius: 15,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(grams, style: const TextStyle(fontSize: 11)),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0E8FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  calories,
                  style: const TextStyle(
                    color: SnackDetailsScreen.purple,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.remove_circle_outline,
          color: SnackDetailsScreen.purple,
          size: 18,
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.add_circle_outline,
          color: SnackDetailsScreen.purple,
          size: 18,
        ),
      ],
    ),
  );
}

class _NutritionCard extends StatelessWidget {
  const _NutritionCard();

  @override
  Widget build(BuildContext context) => _Card(
    radius: 10,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutrition Summary',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final rows = const [
              _NutritionData(
                Icons.local_fire_department_rounded,
                'Calories',
                '200 kcal',
                Color(0xFFFF6D4D),
              ),
              _NutritionData(
                Icons.fitness_center_rounded,
                'Protein',
                '5 g',
                SnackDetailsScreen.green,
              ),
              _NutritionData(
                Icons.grain_rounded,
                'Carbs',
                '25 g',
                SnackDetailsScreen.blue,
              ),
              _NutritionData(
                Icons.water_drop_outlined,
                'Fat',
                '8 g',
                SnackDetailsScreen.orange,
              ),
              _NutritionData(
                Icons.spa_outlined,
                'Fiber',
                '4 g',
                SnackDetailsScreen.green,
              ),
            ];
            final list = Column(
              children: [
                for (var index = 0; index < rows.length; index++) ...[
                  _NutritionRow(rows[index]),
                  if (index < rows.length - 1)
                    const Divider(height: 1, color: Color(0xFFE8EAF0)),
                ],
              ],
            );
            final donut = const SizedBox(
              width: 112,
              height: 112,
              child: CustomPaint(
                painter: _NutritionDonut(),
                child: Center(
                  child: Text(
                    '200\nkcal',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            );
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: list),
                const SizedBox(width: 12),
                Container(width: 1, height: 166, color: Color(0xFFE3E6EC)),
                const SizedBox(width: 12),
                donut,
              ],
            );
          },
        ),
      ],
    ),
  );
}

class _NutritionData {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _NutritionData(this.icon, this.title, this.value, this.color);
}

class _NutritionRow extends StatelessWidget {
  final _NutritionData data;

  const _NutritionRow(this.data);

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 32,
    child: Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: data.color.withValues(alpha: .1),
            shape: BoxShape.circle,
          ),
          child: Icon(data.icon, size: 15, color: data.color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            data.title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          data.value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

class _ImpactCard extends StatelessWidget {
  const _ImpactCard();

  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Impact on your day',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final values = const [
              ('You have remaining', '600', SnackDetailsScreen.purple, .52),
              ('This meal uses', '200', SnackDetailsScreen.orange, .32),
              ('After this meal', '400', SnackDetailsScreen.green, .48),
            ];
            return Row(
              children: [
                for (var i = 0; i < values.length; i++) ...[
                  if (i > 0) const _ImpactDivider(),
                  Expanded(child: _ImpactColumn(values[i])),
                ],
              ],
            );
          },
        ),
      ],
    ),
  );
}

class _ImpactColumn extends StatelessWidget {
  final (String, String, Color, double) data;

  const _ImpactColumn(this.data);

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        data.$1,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 8),
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: data.$2,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: data.$3,
              ),
            ),
            TextSpan(
              text: ' kcal',
              style: TextStyle(fontSize: 12, color: data.$3),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: SizedBox(
          height: 7,
          width: double.infinity,
          child: LinearProgressIndicator(
            value: data.$4,
            color: data.$3,
            backgroundColor: const Color(0xFFE3E6ED),
          ),
        ),
      ),
    ],
  );
}

class _ImpactDivider extends StatelessWidget {
  const _ImpactDivider();

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 100,
    margin: const EdgeInsets.symmetric(horizontal: 18),
    color: SnackDetailsScreen.line,
  );
}

class _PrimaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: SnackDetailsScreen.purple,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 2,
    shadowColor: const Color(0x22000000),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 46,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _EditSkipButtons extends StatelessWidget {
  const _EditSkipButtons();

  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Expanded(
        child: _SecondaryButton(
          Icons.edit_outlined,
          'Edit Meal',
          SnackDetailsScreen.purple,
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: _SecondaryButton(
          Icons.close,
          'Skip Meal',
          SnackDetailsScreen.pink,
        ),
      ),
    ],
  );
}

class _SecondaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SecondaryButton(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 46,
    child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE7E9F0)),
      ),
      elevation: 1,
      shadowColor: const Color(0x16000000),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _NutritionDonut extends CustomPainter {
  const _NutritionDonut();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - 10;
    var start = -math.pi / 2;
    for (final section in const [
      (0.47, SnackDetailsScreen.blue),
      (0.34, SnackDetailsScreen.orange),
      (0.19, SnackDetailsScreen.green),
    ]) {
      final sweep = section.$1 * math.pi * 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..color = section.$2,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
