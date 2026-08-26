import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'app_localization.dart';
import 'reusable_widgets.dart';

class MealDetailsScreen extends StatefulWidget {
  const MealDetailsScreen({super.key});

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  static const purple = Color(0xFF5A24F5);
  static const navy = Color(0xFF15213B);
  static const muted = Color(0xFF62708B);
  static const line = Color(0xFFE8EAF0);

  int portion = 450;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              children: [
                _topBar(),
                const SizedBox(height: 12),
                _hero(),
                const SizedBox(height: 14),
                _macros(),
                const SizedBox(height: 14),
                _portion(),
                const SizedBox(height: 14),
                _ingredients(),
                const SizedBox(height: 14),
                _nutrition(),
                const SizedBox(height: 14),
                _actions(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String action) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$action is coming soon'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _iconButton(
          Icons.arrow_back_ios_new_rounded,
          () => Navigator.pop(context),
        ),
        Row(
          children: [
            _iconButton(Icons.edit_outlined, () => _showComingSoon('Edit')),
            const SizedBox(width: 10),
            _iconButton(Icons.copy_rounded, () => _showComingSoon('Duplicate')),
            const SizedBox(width: 10),
            _iconButton(
              Icons.more_horiz_rounded,
              () => _showComingSoon('More'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _hero() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 22, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _pill(
                  Icons.wb_sunny_outlined,
                  translateText(context, 'Lunch  •  02:00 PM'),
                  const Color(0xFFF0EBFF),
                  purple,
                ),
                const SizedBox(height: 18),
                Text(
                  translateText(context, 'Grilled Chicken\nwith Rice & Salad'),
                  style: TextStyle(
                    color: navy,
                    fontSize: 25,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                _pill(
                  Icons.check_circle_outline_rounded,
                  translateText(context, 'Logged'),
                  const Color(0xFFEAF9EF),
                  const Color(0xFF24A45A),
                ),
              ],
            ),
          ),
        ),
        AppNetworkImage(
          url:
              'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=700&q=85',
          fallback: Icons.restaurant_rounded,
          width: 148,
          height: 196,
          radius: 28,
        ),
      ],
    );
  }

  Widget _macros() {
    return _card(
      child: Row(
        children: [
          Expanded(child: _macro('Total', '620', 'kcal', navy)),
          Container(width: 1, height: 64, color: line),
          Expanded(
            child: _macro(
              'Protein',
              '52',
              'g',
              const Color(0xFFFF313A),
              icon: Icons.restaurant_rounded,
            ),
          ),
          Expanded(
            child: _macro(
              'Carbs',
              '58',
              'g',
              const Color(0xFF2A64FF),
              icon: Icons.cake_rounded,
            ),
          ),
          Expanded(
            child: _macro(
              'Fats',
              '18',
              'g',
              const Color(0xFF1FA65A),
              icon: Icons.spa_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _macro(
    String label,
    String value,
    String unit,
    Color color, {
    IconData? icon,
  }) {
    return Column(
      children: [
        if (icon != null) Icon(icon, color: color, size: 22),
        if (icon != null) const SizedBox(height: 5),
        Text(
          translateText(context, label),
          style: const TextStyle(
            color: muted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        RichText(
          text: TextSpan(
            text: value,
            style: const TextStyle(
              color: navy,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
            children: [
              TextSpan(
                text: ' $unit',
                style: const TextStyle(
                  color: muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _portion() {
    return _card(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                translateText(context, 'Portion Size'),
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '$portion g',
                style: const TextStyle(
                  color: purple,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _roundAction(
                Icons.remove_rounded,
                false,
                () => setState(() => portion = math.max(50, portion - 50)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$portion',
                    style: const TextStyle(
                      color: navy,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    translateText(context, 'grams'),
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              _roundAction(
                Icons.add_rounded,
                true,
                () => setState(() => portion += 50),
              ),
              const SizedBox(width: 14),
              Container(width: 1, height: 52, color: line),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${(portion / 300).toStringAsFixed(1)} servings',
                    style: const TextStyle(
                      color: navy,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    translateText(context, '1 serving = 300 g'),
                    style: TextStyle(color: muted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ingredients() {
    const items = [
      (
        'Grilled Chicken Breast',
        '200 g',
        '330 kcal',
        'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=180&q=80',
      ),
      (
        'Brown Rice (Cooked)',
        '150 g',
        '165 kcal',
        'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=180&q=80',
      ),
      (
        'Mixed Salad',
        '100 g',
        '80 kcal',
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=180&q=80',
      ),
      (
        'Olive Oil',
        '10 g (1 tbsp)',
        '90 kcal',
        'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=180&q=80',
      ),
    ];
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            translateText(context, 'Ingredients'),
            translateText(context, '4 items'),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  AppNetworkImage(
                    url: item.$4,
                    fallback: Icons.restaurant_rounded,
                    width: 58,
                    height: 48,
                    radius: 10,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translateText(context, item.$1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: navy,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          translateText(context, item.$2),
                          style: const TextStyle(color: muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    translateText(context, item.$3),
                    style: const TextStyle(
                      color: navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nutrition() {
    const values = [
      ('Calories', '620 kcal', '31%'),
      ('Total Fat', '18 g', '23%'),
      ('Saturated Fat', '3 g', '15%'),
      ('Cholesterol', '65 mg', '22%'),
      ('Sodium', '560 mg', '24%'),
      ('Carbohydrate', '58 g', '21%'),
      ('Dietary Fiber', '6 g', '21%'),
      ('Total Sugars', '4 g', '--'),
      ('Protein', '52 g', '104%'),
    ];
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            translateText(context, 'Nutrition Details'),
            translateText(context, '% Daily Value*'),
          ),
          const SizedBox(height: 10),
          ...values.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      translateText(context, item.$1),
                      style: const TextStyle(color: navy, fontSize: 12),
                    ),
                  ),
                  Text(
                    item.$2,
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                  const SizedBox(width: 14),
                  SizedBox(
                    width: 34,
                    child: Text(
                      item.$3,
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: muted, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: line),
          Text(
            translateText(
              context,
              '* Percent Daily Values are based on a 2,000 calorie diet.',
            ),
            style: TextStyle(color: muted, fontSize: 10.5),
          ),
        ],
      ),
    );
  }

  Widget _actions() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translateText(context, 'What would you like to do?'),
            style: TextStyle(
              color: navy,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _action(Icons.edit_outlined, 'Edit'),
              _action(Icons.copy_rounded, 'Duplicate'),
              _action(Icons.swap_horiz_rounded, 'Swap'),
              _action(Icons.star_border_rounded, 'Favorite'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _action(IconData icon, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: InkWell(
          onTap: () => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('$label is coming soon'),
                behavior: SnackBarBehavior.floating,
              ),
            ),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 82,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F7FC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: line),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: purple, size: 22),
                const SizedBox(height: 7),
                Text(
                  translateText(context, label),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, String trailing) => Row(
    children: [
      Text(
        title,
        style: const TextStyle(
          color: navy,
          fontSize: 17,
          fontWeight: FontWeight.w800,
        ),
      ),
      const Spacer(),
      Text(
        translateText(context, trailing),
        style: const TextStyle(
          color: purple,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );

  Widget _iconButton(IconData icon, VoidCallback onTap) => Material(
    color: Colors.white,
    shape: const CircleBorder(),
    elevation: 1,
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 46,
        height: 46,
        child: Icon(icon, color: navy, size: 20),
      ),
    ),
  );

  Widget _roundAction(IconData icon, bool active, VoidCallback onTap) =>
      Material(
        color: active ? purple : const Color(0xFFF1EDFF),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 46,
            height: 46,
            child: Icon(icon, color: active ? Colors.white : purple, size: 22),
          ),
        ),
      );

  Widget _pill(
    IconData icon,
    String text,
    Color background,
    Color foreground,
  ) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: foreground, size: 16),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: foreground,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
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
