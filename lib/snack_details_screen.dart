import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_food_screen.dart';
import 'app_bottom_nav.dart';
import 'log_screen.dart';
import 'plan_screen.dart';
import 'progress_screen.dart';

class SnackDetailsScreen extends StatelessWidget {
  const SnackDetailsScreen({super.key});

  static const purple = Color(0xFF6D35E8);
  static const blue = Color(0xFF2376E8);
  static const green = Color(0xFF3BAF4A);
  static const orange = Color(0xFFFF9416);
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const _SnackOverview(),
                  const SizedBox(height: 18),
                  const _FoodsCard(),
                  const SizedBox(height: 18),
                  const _NutritionCard(),
                  const SizedBox(height: 18),
                  const _ImpactCard(),
                  const SizedBox(height: 18),
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
        MediaQuery.paddingOf(context).top + 4,
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
                icon: const Icon(CupertinoIcons.back, size: 29),
              ),
              const Expanded(
                child: Column(
                  children: [
                    Text(
                      'Snack',
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w700,
                        color: SnackDetailsScreen.text,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '5:30 PM',
                      style: TextStyle(
                        fontSize: 20,
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
                icon: const Icon(CupertinoIcons.ellipsis, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF0E8FF),
              borderRadius: BorderRadius.circular(22),
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
                    fontSize: 16,
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

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: const [
        BoxShadow(
          color: Color(0x15000000),
          blurRadius: 22,
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
            final image = const SizedBox(
              width: 210,
              height: 170,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: CustomPaint(painter: _FoodPainter()),
              ),
            );
            final title = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Snack',
                  style: TextStyle(
                    fontSize: 39,
                    fontWeight: FontWeight.w700,
                    color: SnackDetailsScreen.text,
                  ),
                ),
                const SizedBox(height: 12),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '🔥  ', style: TextStyle(fontSize: 28)),
                      TextSpan(
                        text: '200',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          color: SnackDetailsScreen.purple,
                        ),
                      ),
                      TextSpan(
                        text: ' kcal',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: SnackDetailsScreen.purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
            return constraints.maxWidth < 500
                ? Column(children: [title, const SizedBox(height: 18), image])
                : Row(
                    children: [
                      Expanded(child: title),
                      const SizedBox(width: 12),
                      image,
                    ],
                  );
          },
        ),
        const SizedBox(height: 20),
        const Row(
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
        ),
        const SizedBox(height: 21),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 14,
          runSpacing: 8,
          children: const [
            _InfoText(CupertinoIcons.clock, 'Planned for 5:30 PM'),
            _InfoText(
              CupertinoIcons.bolt,
              '600 kcal remaining',
              accent: SnackDetailsScreen.purple,
            ),
          ],
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
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(.09),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 24, color: color),
      ),
      const SizedBox(width: 8),
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
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
    height: 50,
    width: 1,
    margin: const EdgeInsets.symmetric(horizontal: 10),
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
      Icon(icon, size: 21, color: const Color(0xFF555D68)),
      const SizedBox(width: 7),
      Text(
        text,
        style: TextStyle(
          fontSize: 16,
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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            Spacer(),
            Text(
              'Edit meal',
              style: TextStyle(
                fontSize: 16,
                color: SnackDetailsScreen.purple,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 7),
            Icon(
              Icons.edit_outlined,
              color: SnackDetailsScreen.purple,
              size: 21,
            ),
          ],
        ),
        const SizedBox(height: 19),
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
                fontSize: 17,
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
    height: 112,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFE8EAF0)),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 105,
          height: 90,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CustomPaint(painter: _SmallFoodPainter(type)),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(grams, style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0E8FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  calories,
                  style: const TextStyle(
                    color: SnackDetailsScreen.purple,
                    fontSize: 13,
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
          size: 22,
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.add_circle_outline,
          color: SnackDetailsScreen.purple,
          size: 22,
        ),
      ],
    ),
  );
}

class _NutritionCard extends StatelessWidget {
  const _NutritionCard();

  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutrition Summary',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
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
              children: [for (final row in rows) _NutritionRow(row)],
            );
            final donut = const SizedBox(
              width: 150,
              height: 150,
              child: CustomPaint(
                painter: _NutritionDonut(),
                child: Center(
                  child: Text(
                    '200\nkcal',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            );
            return constraints.maxWidth < 530
                ? Column(children: [list, const SizedBox(height: 18), donut])
                : Row(
                    children: [
                      Expanded(child: list),
                      const SizedBox(width: 25),
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
    height: 42,
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: data.color.withOpacity(.1),
            shape: BoxShape.circle,
          ),
          child: Icon(data.icon, size: 18, color: data.color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            data.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          data.value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
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
            return constraints.maxWidth < 500
                ? Column(
                    children: [
                      for (final item in values)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _ImpactColumn(item),
                        ),
                    ],
                  )
                : Row(
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
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 8),
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: data.$2,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: data.$3,
              ),
            ),
            TextSpan(
              text: ' kcal',
              style: TextStyle(fontSize: 15, color: data.$3),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: SizedBox(
          height: 9,
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
    borderRadius: BorderRadius.circular(25),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        height: 68,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(width: 11),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
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
      SizedBox(width: 14),
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
  Widget build(BuildContext context) => Container(
    height: 68,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 18,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

class _FoodPainter extends CustomPainter {
  const _FoodPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFF1F1F3),
    );
    final apple = Paint()..color = const Color(0xFFE5292E);
    canvas.drawCircle(
      Offset(size.width * .68, size.height * .28),
      size.width * .15,
      apple,
    );
    canvas.drawCircle(
      Offset(size.width * .62, size.height * .32),
      size.width * .12,
      apple,
    );
    canvas.drawCircle(
      Offset(size.width * .74, size.height * .32),
      size.width * .12,
      apple,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .42, size.height * .68),
        width: size.width * .56,
        height: size.height * .22,
      ),
      Paint()..color = const Color(0xFFEFEFF0),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .42, size.height * .54),
        width: size.width * .57,
        height: size.height * .24,
      ),
      Paint()..color = Colors.white,
    );
    final almond = Paint()..color = const Color(0xFFAD642A);
    for (var i = 0; i < 16; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(
            size.width * (.22 + (i % 4) * .095),
            size.height * (.48 + (i ~/ 4) * .055),
          ),
          width: 15,
          height: 8,
        ),
        almond,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SmallFoodPainter extends CustomPainter {
  final FoodType type;

  const _SmallFoodPainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFF8F8F9),
    );
    if (type == FoodType.apple) {
      final apple = Paint()..color = const Color(0xFFE32930);
      canvas.drawCircle(Offset(size.width * .47, size.height * .46), 27, apple);
      canvas.drawCircle(Offset(size.width * .38, size.height * .46), 20, apple);
      canvas.drawCircle(Offset(size.width * .56, size.height * .46), 20, apple);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(size.width * .64, size.height * .24),
          width: 25,
          height: 12,
        ),
        Paint()..color = const Color(0xFF5CA33C),
      );
    } else {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(size.width * .5, size.height * .68),
          width: 82,
          height: 28,
        ),
        Paint()..color = const Color(0xFFF0F0F0),
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(size.width * .5, size.height * .48),
          width: 88,
          height: 35,
        ),
        Paint()..color = Colors.white,
      );
      final almond = Paint()..color = const Color(0xFFA96632);
      for (var i = 0; i < 12; i++) {
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(
              size.width * (.25 + (i % 4) * .14),
              size.height * (.38 + (i ~/ 4) * .08),
            ),
            width: 16,
            height: 9,
          ),
          almond,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NutritionDonut extends CustomPainter {
  const _NutritionDonut();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - 8;
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
          ..strokeWidth = 14
          ..color = section.$2,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
