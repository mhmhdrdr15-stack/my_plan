import 'package:flutter/material.dart';
import 'reusable_widgets.dart';

class EditPlanScreen extends StatelessWidget {
  const EditPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFD),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopBar(),
                    const SizedBox(height: 10),
                    const _DateSelector(),
                    const SizedBox(height: 14),
                    const _PlannedNutritionCard(),
                    const SizedBox(height: 20),
                    const _MealsHeader(),
                    const SizedBox(height: 10),
                    for (final meal in _meals) ...[
                      _MealCard(meal: meal),
                      const SizedBox(height: 8),
                    ],
                    const _AddMealButton(),
                    const SizedBox(height: 14),
                    const _PlanSummaryCard(),
                    const SizedBox(height: 14),
                    const _SaveButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _meals = [
  _Meal(
    'Breakfast',
    '08:00 AM',
    '420',
    '28g protein',
    Icons.egg_alt_outlined,
    ['Egg  100g', 'Whole Wheat Bread  60g'],
    Color(0xFFF0E9FF),
  ),
  _Meal('Lunch', '02:00 PM', '620', '52g protein', Icons.wb_sunny_outlined, [
    'Grilled Chicken  200g',
    'White Rice  150g',
    'Mixed Salad  100g',
    'Olive Oil  10g',
  ], Color(0xFFEAF8EC)),
  _Meal(
    'Snack',
    '05:30 PM',
    '200',
    '5g protein',
    Icons.local_drink_outlined,
    ['Apple  150g', 'Almonds  20g'],
    Color(0xFFFFF0E1),
  ),
  _Meal(
    'Dinner',
    '08:30 PM',
    '450',
    '40g protein',
    Icons.nightlight_outlined,
    ['Tuna  120g', 'Whole Wheat Bread  80g', 'Cucumber  100g'],
    Color(0xFFEAF2FF),
  ),
];

class _Meal {
  final String title, time, kcal, protein;
  final IconData icon;
  final List<String> items;
  final Color background;

  const _Meal(
    this.title,
    this.time,
    this.kcal,
    this.protein,
    this.icon,
    this.items,
    this.background,
  );
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 21),
      ),
      const Expanded(
        child: Center(
          child: Text(
            "Edit Today's Plan",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(
          'Save',
          style: TextStyle(
            color: Color(0xFF5B35F5),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ],
  );
}

class _DateSelector extends StatelessWidget {
  const _DateSelector();

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Icon(Icons.chevron_left_rounded, size: 22),
      SizedBox(width: 14),
      Icon(Icons.calendar_month_outlined, size: 18),
      SizedBox(width: 8),
      Text(
        'Sunday, 23 August',
        style: TextStyle(color: Color(0xFF667085), fontSize: 15),
      ),
      SizedBox(width: 14),
      Icon(Icons.chevron_right_rounded, size: 22),
    ],
  );
}

class _PlannedNutritionCard extends StatelessWidget {
  const _PlannedNutritionCard();

  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Planned Nutrition',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: _NutritionItem(
                '🔥',
                '1,690',
                '/ 1,800 kcal',
                '110 kcal remaining',
                Color(0xFF5B35F5),
                .94,
              ),
            ),
            _nutritionDivider(),
            const Expanded(
              child: _NutritionItem(
                '💪',
                '125',
                '/ 130 g',
                'Protein',
                Color(0xFF2CAE62),
                .96,
              ),
            ),
            _nutritionDivider(),
            const Expanded(
              child: _NutritionItem(
                '🌾',
                '175',
                '/ 180 g',
                'Carbs',
                Color(0xFF4478FF),
                .97,
              ),
            ),
            _nutritionDivider(),
            const Expanded(
              child: _NutritionItem(
                '💧',
                '58',
                '/ 60 g',
                'Fat',
                Color(0xFFFF7900),
                .97,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _nutritionDivider() => Container(
    width: 1,
    height: 58,
    margin: const EdgeInsets.symmetric(horizontal: 5),
    color: const Color(0xFFE7E9EF),
  );
}

class _NutritionItem extends StatelessWidget {
  final String icon, value, target, label;
  final Color color;
  final double progress;

  const _NutritionItem(
    this.icon,
    this.value,
    this.target,
    this.label,
    this.color,
    this.progress,
  );

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$icon  $value',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      Text(
        target,
        style: const TextStyle(fontSize: 10, color: Color(0xFF667085)),
      ),
      const SizedBox(height: 3),
      Text(
        label,
        style: const TextStyle(fontSize: 10, color: Color(0xFF667085)),
      ),
      const SizedBox(height: 5),
      LinearProgressIndicator(
        value: progress,
        minHeight: 4,
        color: color,
        backgroundColor: const Color(0xFFE5E7EE),
      ),
    ],
  );
}

class _MealsHeader extends StatelessWidget {
  const _MealsHeader();

  @override
  Widget build(BuildContext context) => Row(
    children: const [
      Text(
        'Meals',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
      Spacer(),
      Text(
        'Reorder meals  ⓘ',
        style: TextStyle(fontSize: 12, color: Color(0xFF5B35F5)),
      ),
    ],
  );
}

class _MealCard extends StatelessWidget {
  final _Meal meal;
  const _MealCard({required this.meal});

  String get imageUrl => switch (meal.title) {
    'Breakfast' =>
      'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=240&q=80',
    'Lunch' =>
      'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=240&q=80',
    'Snack' =>
      'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=240&q=80',
    'Dinner' =>
      'https://images.unsplash.com/photo-1547592180-85f173990554?w=240&q=80',
    _ => '',
  };

  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 22,
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Icon(
              Icons.drag_handle_rounded,
              color: Color(0xFF667085),
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: 7),
        AppNetworkImage(
          url: imageUrl,
          fallback: meal.icon,
          width: 48,
          height: 48,
          radius: 14,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meal.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                meal.time,
                style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
              ),
              const SizedBox(height: 4),
              for (final item in meal.items)
                Text(
                  '• $item',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11.5),
                ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${meal.kcal} kcal',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 5),
            Text(
              meal.protein,
              style: const TextStyle(fontSize: 10.5, color: Color(0xFF667085)),
            ),
            const SizedBox(height: 8),
            const Icon(Icons.more_horiz_rounded, size: 20),
          ],
        ),
      ],
    ),
  );
}

class _AddMealButton extends StatelessWidget {
  const _AddMealButton();
  @override
  Widget build(BuildContext context) => Container(
    height: 46,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFBFAEFF)),
      borderRadius: BorderRadius.circular(11),
    ),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_circle_outline_rounded,
          color: Color(0xFF5B35F5),
          size: 24,
        ),
        SizedBox(width: 8),
        Text(
          'Add Meal',
          style: TextStyle(
            color: Color(0xFF5B35F5),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _PlanSummaryCard extends StatelessWidget {
  const _PlanSummaryCard();
  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                "Today's Plan Summary",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
            _SummaryLegend(color: const Color(0xFF6938EF), label: 'Planned'),
            const SizedBox(width: 13),
            _SummaryLegend(color: const Color(0xFFBFC3CD), label: 'Target'),
          ],
        ),
        const SizedBox(height: 9),
        const _SummaryRow(
          icon: '🔥',
          label: 'Calories',
          value: '1,690',
          unit: 'kcal',
          target: '1,800 kcal',
          progress: .94,
          color: Color(0xFF6938EF),
        ),
        const _SummaryRow(
          icon: '💪',
          label: 'Protein',
          value: '125',
          unit: 'g',
          target: '130 g',
          progress: .96,
          color: Color(0xFF2CAE62),
        ),
        const _SummaryRow(
          icon: '🌾',
          label: 'Carbs',
          value: '175',
          unit: 'g',
          target: '180 g',
          progress: .97,
          color: Color(0xFF4478FF),
        ),
        const _SummaryRow(
          icon: '💧',
          label: 'Fat',
          value: '58',
          unit: 'g',
          target: '60 g',
          progress: .97,
          color: Color(0xFFFF7900),
        ),
      ],
    ),
  );
}

class _SummaryLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _SummaryLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

class _SummaryRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final String unit;
  final String target;
  final double progress;
  final Color color;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.target,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        SizedBox(
          width: 25,
          child: Text(icon, style: const TextStyle(fontSize: 15)),
        ),
        SizedBox(
          width: 67,
          child: Text(
            label,
            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: Color(0xFF17203A),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: ' $unit',
                        style: const TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    color: color,
                    backgroundColor: const Color(0xFFE1E4EA),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 76,
          child: Text(
            target,
            textAlign: TextAlign.right,
            style: const TextStyle(color: Color(0xFF667085), fontSize: 10.5),
          ),
        ),
      ],
    ),
  );
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 52,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Color(0xFF6E30E8), Color(0xFF6330E6)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x286E30E8),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(15),
          child: const Center(
            child: Text(
              'Save Changes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
