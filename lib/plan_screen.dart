import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'add_food_screen.dart';
import 'add_meal_snack_sheet.dart';
import 'app_bottom_nav.dart';
import 'app_localization.dart';
import 'log_screen.dart';
import 'edit_plan_screen.dart';
import 'edit_daily_targets_page.dart';
import 'plan_header_actions.dart';
import 'progress_screen.dart';
import 'reusable_widgets.dart';

enum MealStatus { planned, logged, skipped, overdue }

class PlannedMeal {
  final String id;
  String name;
  String time;
  MealStatus status;
  List<String> foodIds;
  int calories;
  int protein;

  PlannedMeal({
    required this.id,
    required this.name,
    required this.time,
    required this.status,
    required this.foodIds,
    required this.calories,
    required this.protein,
  });
}

class PlanScreen extends StatefulWidget {
  final bool showBottomNav;
  final bool editMode;

  const PlanScreen({
    super.key,
    this.showBottomNav = true,
    this.editMode = false,
  });

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  int selectedDay = 4;
  int selectedTab = 1;
  DateTime selectedDate = DateTime.now();
  bool hasPlan = true;
  int dailyCalories = 1800;
  int dailyProtein = 130;
  int dailyCarbs = 180;
  int dailyFat = 60;
  double dailyWater = 2.5;
  final List<PlannedMeal> meals = [];

  static const purple = Color(0xFF5B36F4);
  static const text = Color(0xFF13182B);
  static const secondary = Color(0xFF64708E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    if (widget.editMode) ...[
                      const SizedBox(height: 8),
                      _dateSelector(),
                      const SizedBox(height: 16),
                    ] else ...[
                      const SizedBox(height: 16),
                      _dayStrip(),
                      const SizedBox(height: 22),
                    ],
                    _dailyTargets(),
                    if (!widget.editMode) ...[
                      const SizedBox(height: 20),
                      _tabs(),
                    ],
                    if (selectedTab == 0 || widget.editMode) ...[
                      const SizedBox(height: 18),
                      _mealPlanContent(),
                    ] else ...[
                      const SizedBox(height: 18),
                      _foodListContent(),
                    ],
                  ],
                ),
              ),
            ),
            if (widget.showBottomNav)
              AppBottomNav(
                currentIndex: 1,
                onItemSelected: _navigateTo,
                onAdd: _openAddFood,
              ),
          ],
        ),
      ),
    );
  }

  Widget _mealPlanContent() {
    return Column(
      children: [
        _mealsHeader(),
        const SizedBox(height: 14),
        _timelineMeal(
          time: '08:00',
          period: 'AM',
          icon: Icons.egg_alt_outlined,
          accent: const Color(0xFFFFB11A),
          imageUrl:
              'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=500&q=80',
          title: 'Breakfast',
          details: const ['Egg 100g', 'Bread 60g'],
          kcal: '420 kcal',
          protein: '28g protein',
        ),
        _timelineMeal(
          time: '02:00',
          period: 'PM',
          icon: Icons.restaurant_outlined,
          accent: const Color(0xFFFF9F81),
          imageUrl:
              'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=500&q=80',
          title: 'Lunch',
          details: const ['Chicken 200g', 'Rice 150g', 'Salad 100g', 'Oil 10g'],
          kcal: '620 kcal',
          protein: '52g protein',
          compact: true,
        ),
        _timelineMeal(
          time: '05:30',
          period: 'PM',
          icon: Icons.apple_rounded,
          accent: const Color(0xFF8D63FF),
          imageUrl:
              'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=500&q=80',
          title: 'Snack',
          details: const ['Apple 150g', 'Almonds 20g'],
          kcal: '200 kcal',
          protein: '5g protein',
        ),
        _timelineMeal(
          time: '08:30',
          period: 'PM',
          icon: Icons.energy_savings_leaf_outlined,
          accent: const Color(0xFF73C99A),
          imageUrl:
              'https://images.unsplash.com/photo-1547592180-85f173990554?w=500&q=80',
          title: 'Dinner',
          details: const ['Tuna 120g', 'Bread 80g'],
          kcal: '450 kcal',
          protein: '40g protein',
        ),
        for (final meal in meals)
          _timelineMeal(
            time: meal.time.split(' ').first,
            period: meal.time.split(' ').last,
            icon: Icons.restaurant_outlined,
            accent: purple,
            imageUrl:
                'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=500&q=80',
            title: meal.name,
            details: const [],
            kcal: '${meal.calories} kcal',
            protein: '${meal.protein}g protein',
          ),
        const SizedBox(height: 8),
        _addMealButton(),
        const SizedBox(height: 18),
        _nutritionSummary(),
        const SizedBox(height: 16),
        _tipCard(),
      ],
    );
  }

  Widget _foodListContent() {
    const foods = [
      ('Egg', 'Breakfast', '100 g', '143 kcal', Icons.egg_alt_rounded),
      ('Bread', 'Breakfast', '60 g', '150 kcal', Icons.bakery_dining_rounded),
      ('Chicken', 'Lunch', '200 g', '330 kcal', Icons.restaurant_rounded),
      ('Rice', 'Lunch', '150 g', '195 kcal', Icons.rice_bowl_rounded),
      ('Salad', 'Lunch', '100 g', '35 kcal', Icons.eco_rounded),
      ('Apple', 'Snack', '150 g', '78 kcal', Icons.apple_rounded),
      ('Almonds', 'Snack', '20 g', '120 kcal', Icons.spa_rounded),
      ('Tuna', 'Dinner', '120 g', '140 kcal', Icons.set_meal_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Planned Foods',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: text,
                ),
              ),
            ),
            Text(
              '${foods.length} items',
              style: TextStyle(fontSize: 12, color: secondary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search planned food...',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _card(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            children: [
              for (final food in foods)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: purple.withValues(alpha: .10),
                    child: Icon(food.$5, color: purple, size: 19),
                  ),
                  title: Text(
                    food.$1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    '${food.$2} • ${food.$3}',
                    style: TextStyle(color: secondary, fontSize: 11),
                  ),
                  trailing: Text(
                    food.$4,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _addMealButton(),
      ],
    );
  }

  void _openAddFood() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AddFoodScreen()));
  }

  void addMealOrSnack() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AddMealSnackSheet(
        onContinue: (mealType, time) {
          Navigator.pop(context);
          createNewMeal(mealType: mealType, time: time);
        },
      ),
    );
  }

  void createNewMeal({required String mealType, required TimeOfDay time}) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.period == DayPeriod.am ? 'AM' : 'PM';
    final formattedTime = '$hour:$minute $suffix';
    final id =
        '${mealType.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}';

    setState(() {
      meals.add(
        PlannedMeal(
          id: id,
          name: mealType,
          time: formattedTime,
          status: MealStatus.planned,
          foodIds: [],
          calories: 0,
          protein: 0,
        ),
      );
    });

    _showPlanMessage('$mealType created. Now add food.');
  }

  void _navigateTo(int index) {
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }
    if (index == 1) return;
    final destination = index == 2
        ? const LogFoodScreen()
        : const ProgressScreen();
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => destination));
  }

  Widget _header() {
    return PlanPageHeader(
      selectedDate: selectedDate,
      hasPlan: hasPlan,
      onDateChanged: (date) => setState(() => selectedDate = date),
      onEditPlan: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const EditTodayPlanPage()),
      ),
      onCopyPlan: () => _showPlanMessage('Plan copied.'),
      onApplyToAnotherDay: () => PlanDialogs.showChooseTargetDay(
        context,
        onSelected: (date) =>
            _showPlanMessage('Plan applied to ${date.day}/${date.month}.'),
      ),
      onResetPlan: () => PlanDialogs.showResetConfirmation(
        context,
        onConfirm: () => _showPlanMessage('Plan reset.'),
      ),
      onClearPlan: () => PlanDialogs.showClearConfirmation(
        context,
        onConfirm: () {
          setState(() => hasPlan = false);
          _showPlanMessage("Today's plan cleared.");
        },
      ),
      onCreatePlan: () {
        setState(() => hasPlan = true);
        _showPlanMessage("Today's plan created.");
      },
      onCopyFromAnotherDay: () => PlanDialogs.showChooseSourceDay(
        context,
        onSelected: (date) {
          setState(() => hasPlan = true);
          _showPlanMessage('Plan copied from ${date.day}/${date.month}.');
        },
      ),
    );
  }

  void _showPlanMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _dateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.chevron_left_rounded, size: 22),
        const SizedBox(width: 18),
        const Icon(Icons.calendar_today_outlined, size: 17),
        const SizedBox(width: 9),
        Text(
          'Sunday, 23 August',
          style: TextStyle(fontSize: 16, color: secondary),
        ),
        const SizedBox(width: 18),
        const Icon(Icons.chevron_right_rounded, size: 22),
      ],
    );
  }

  Widget _dayStrip() {
    const days = [
      ['Mon', '19'],
      ['Tue', '20'],
      ['Wed', '21'],
      ['Thu', '22'],
      ['Fri', '23'],
      ['Sat', '24'],
      ['Sun', '25'],
    ];
    return SizedBox(
      height: 82,
      child: Row(
        children: [
          for (var i = 0; i < days.length; i++) ...[
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedDay = i),
                child: Container(
                  margin: EdgeInsets.only(right: i == 4 ? 0 : 8),
                  decoration: BoxDecoration(
                    color: i == selectedDay ? purple : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: i == selectedDay
                          ? purple
                          : const Color(0xFFE8E9F0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        translateText(context, days[i][0]),
                        style: TextStyle(
                          color: i == selectedDay ? Colors.white70 : secondary,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        days[i][1],
                        style: TextStyle(
                          color: i == selectedDay ? Colors.white : text,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _dailyTargets() {
    return _card(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Daily Target',
                style: TextStyle(
                  color: Color(0xFF17203A),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () async {
                  final result = await Navigator.of(context).push<DailyTargets>(
                    MaterialPageRoute<DailyTargets>(
                      builder: (_) => EditDailyTargetsPage(
                        initialCalories: dailyCalories,
                        initialProtein: dailyProtein,
                        initialCarbs: dailyCarbs,
                        initialFat: dailyFat,
                        initialWater: dailyWater,
                      ),
                    ),
                  );

                  if (result != null && mounted) {
                    setState(() {
                      dailyCalories = result.calories;
                      dailyProtein = result.protein;
                      dailyCarbs = result.carbs;
                      dailyFat = result.fat;
                      dailyWater = result.water;
                    });
                  }
                },
                icon: const Icon(Icons.edit_outlined, size: 15),
                label: const Text('Edit Target'),
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF5B35F5),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TargetValue(
                  icon: Icons.local_fire_department_rounded,
                  color: const Color(0xFFFF8A16),
                  value: '$dailyCalories',
                  unit: 'kcal',
                  label: 'Calories',
                ),
              ),
              Expanded(
                child: TargetValue(
                  icon: Icons.favorite_rounded,
                  color: const Color(0xFFFF3E4B),
                  value: '$dailyProtein',
                  unit: 'g',
                  label: 'Protein',
                ),
              ),
              Expanded(
                child: TargetValue(
                  icon: Icons.rice_bowl_rounded,
                  color: const Color(0xFF467BFF),
                  value: '$dailyCarbs',
                  unit: 'g',
                  label: 'Carbs',
                ),
              ),
              Expanded(
                child: TargetValue(
                  icon: Icons.eco_rounded,
                  color: const Color(0xFF2DAA61),
                  value: '$dailyFat',
                  unit: 'g',
                  label: 'Fat',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    return Row(
      children: [
        Expanded(child: _tab(Icons.view_list_rounded, 'Meal Plan', 0)),
        Expanded(child: _tab(Icons.list_alt_rounded, 'Food List', 1)),
      ],
    );
  }

  Widget _tab(IconData icon, String label, int index) {
    final selected = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? purple : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 19, color: selected ? purple : secondary),
            const SizedBox(width: 6),
            Text(
              translateText(context, label),
              style: TextStyle(
                fontSize: 14,
                color: selected ? purple : secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mealsHeader() => Row(
    children: [
      Expanded(
        child: Text(
          translateText(context, 'Meals'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: text,
          ),
        ),
      ),
      Text(
        translateText(context, '4 meals  •  1 snack'),
        style: TextStyle(fontSize: 12, color: secondary),
      ),
    ],
  );

  Widget _timelineMeal({
    required String time,
    required String period,
    required IconData icon,
    required Color accent,
    required String imageUrl,
    required String title,
    required List<String> details,
    required String kcal,
    required String protein,
    bool compact = false,
  }) {
    return SizedBox(
      height: compact ? 154 : 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 66,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: secondary,
                  ),
                ),
                Text(
                  period,
                  style: const TextStyle(fontSize: 12, color: secondary),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withValues(alpha: .09),
                    border: Border.all(color: accent.withValues(alpha: .60)),
                  ),
                  child: Icon(icon, color: accent, size: 22),
                ),
              ],
            ),
          ),
          Container(
            width: 2,
            margin: const EdgeInsets.only(top: 42),
            color: const Color(0xFFE8EBF2),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _card(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  AppNetworkImage(
                    url: imageUrl,
                    fallback: icon,
                    width: 82,
                    height: 92,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                translateText(context, title),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: text,
                                ),
                              ),
                            ),
                            _status(purple),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          details
                              .map((detail) => translateText(context, detail))
                              .join('  •  '),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: secondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${translateText(context, kcal)}  •  ${translateText(context, protein)}',
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF43506E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.more_horiz_rounded, size: 18, color: text),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _status(Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .09),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      translateText(context, 'Planned'),
      style: TextStyle(fontSize: 8, color: color, fontWeight: FontWeight.w600),
    ),
  );

  Widget _addMealButton() {
    return InkWell(
      onTap: addMealOrSnack,
      borderRadius: BorderRadius.circular(12),
      child: CustomPaint(
        painter: _DashedRRectPainter(
          color: const Color(0xFF7A63F9),
          radius: 12,
          dash: 7,
          gap: 5,
        ),
        child: SizedBox(
          height: 52,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: purple,
                  child: Icon(Icons.add, color: Colors.white, size: 19),
                ),
                SizedBox(width: 8),
                Text(
                  translateText(context, 'Add Meal / Snack'),
                  style: TextStyle(
                    fontSize: 15,
                    color: purple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _nutritionSummary() {
    return _card(
      padding: const EdgeInsets.fromLTRB(14, 15, 14, 13),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  translateText(context, 'Nutrition Summary'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: text,
                  ),
                ),
              ),
              _legend(purple, translateText(context, 'Planned')),
              const SizedBox(width: 8),
              _legend(
                const Color(0xFF9AA2B5),
                translateText(context, 'Target'),
              ),
              const Icon(Icons.chevron_right, color: secondary, size: 20),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  '🔥',
                  'Calories',
                  '1,600 / 1,800',
                  .89,
                  const Color(0xFFFF7B19),
                ),
              ),
              _smallDivider(),
              Expanded(
                child: _summaryItem(
                  '🥩',
                  'Protein',
                  '125 / 130',
                  .96,
                  const Color(0xFFFF383E),
                ),
              ),
              _smallDivider(),
              Expanded(
                child: _summaryItem(
                  '🍚',
                  'Carbs',
                  '175 / 180',
                  .97,
                  const Color(0xFF397BFF),
                ),
              ),
              _smallDivider(),
              Expanded(
                child: _summaryItem(
                  '🥑',
                  'Fats',
                  '58 / 60',
                  .97,
                  const Color(0xFF40B46B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) => Row(
    children: [
      Container(width: 14, height: 4, color: color),
      const SizedBox(width: 4),
      Text(
        translateText(context, label),
        style: const TextStyle(fontSize: 9, color: secondary),
      ),
    ],
  );

  Widget _summaryItem(
    String emoji,
    String title,
    String value,
    double progress,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 17)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                translateText(context, title),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: text,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 9,
            color: text,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        LinearProgressIndicator(
          value: progress,
          minHeight: 4,
          color: color,
          backgroundColor: const Color(0xFFE8EAF0),
        ),
      ],
    );
  }

  Widget _smallDivider() => Container(
    width: 1,
    height: 48,
    color: const Color(0xFFE9EAF0),
    margin: const EdgeInsets.symmetric(horizontal: 5),
  );

  Widget _tipCard() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0FF),
        borderRadius: BorderRadius.circular(11),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text('💡', style: TextStyle(fontSize: 20)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              translateText(context, 'Try adding a high-protein snack.'),
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF4B4A86),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: Color(0xFF4A3CC2)),
        ],
      ),
    );
  }

  Widget _card({
    required Widget child,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120D1737),
            blurRadius: 19,
            offset: Offset(0, 6),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F2F6)),
      ),
      padding: padding,
      child: child,
    );
  }
}

class TargetValue extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String unit;
  final String label;

  const TargetValue({
    super.key,
    required this.icon,
    required this.color,
    required this.value,
    required this.unit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF17203A),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(color: Color(0xFF64708E), fontSize: 9),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Color(0xFF9AA2B5), fontSize: 9),
        ),
      ],
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double dash;
  final double gap;

  _DashedRRectPainter({
    required this.color,
    required this.radius,
    required this.dash,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final length = math.min(dash, metric.length - distance);
        canvas.drawPath(metric.extractPath(distance, distance + length), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) => false;
}
