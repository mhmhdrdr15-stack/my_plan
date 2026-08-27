import 'package:flutter/material.dart';
import 'package:my_plan/features/food_log/pages/add_food_screen.dart';
import 'package:my_plan/core/localization/app_localization.dart';
import 'package:my_plan/core/widgets/reusable_widgets.dart';

class EditBreakfastPage extends StatefulWidget {
  const EditBreakfastPage({super.key});

  @override
  State<EditBreakfastPage> createState() => _EditBreakfastPageState();
}

class _EditBreakfastPageState extends State<EditBreakfastPage> {
  TimeOfDay mealTime = const TimeOfDay(hour: 8, minute: 0);
  final List<_BreakfastFood> foods = [
    const _BreakfastFood(
      name: 'Egg',
      grams: 100,
      calories: 143,
      protein: 13,
      carbs: 1,
      fat: 10,
      icon: Icons.egg_alt_rounded,
      color: Color(0xFFFF8A16),
      image: 'assets/food/egg.jpg',
    ),
    const _BreakfastFood(
      name: 'Whole Wheat Bread',
      grams: 60,
      calories: 150,
      protein: 6,
      carbs: 25,
      fat: 2,
      icon: Icons.bakery_dining_rounded,
      color: Color(0xFFB8793D),
      image: 'assets/food/bread.jpg',
    ),
  ];

  int get totalCalories => foods.fold(0, (sum, food) => sum + food.calories);
  int get totalProtein => foods.fold(0, (sum, food) => sum + food.protein);
  int get totalCarbs => foods.fold(0, (sum, food) => sum + food.carbs);
  int get totalFat => foods.fold(0, (sum, food) => sum + food.fat);

  Future<void> removeMeal() async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(translateText(context, 'Remove Breakfast?'), style: _titleStyle),
        content: Text(
          translateText(context, "This meal will be removed from today's plan."),
          style: _mutedStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(translateText(context, 'Cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFF3E4B),
            ),
            child: Text(translateText(context, 'Remove')),
          ),
        ],
      ),
    );
    if (shouldRemove == true && mounted) Navigator.pop(context);
  }

  Future<void> selectMealTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: mealTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF5B35F5)),
        ),
        child: child!,
      ),
    );
    if (selected != null) setState(() => mealTime = selected);
  }

  void editFoodQuantity(int index) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _QuantitySheet(
        food: foods[index],
        onSave: (food) => setState(() => foods[index] = food),
      ),
    );
  }

  void showFoodActions(int index) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SheetHandle(),
              const SizedBox(height: 18),
              Text(foods[index].name, style: _titleStyle),
              const SizedBox(height: 12),
              _ActionTile(
                icon: Icons.tune_rounded,
                title: translateText(context, 'Edit serving'),
                onTap: () {
                  Navigator.pop(context);
                  editFoodQuantity(index);
                },
              ),
              _ActionTile(
                icon: Icons.delete_outline_rounded,
                title: translateText(context, 'Remove from meal'),
                color: const Color(0xFFFF3E4B),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => foods.removeAt(index));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${time.period == DayPeriod.am ? 'AM' : 'PM'}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: Text(
          translateText(context, 'Edit Meal'),
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              translateText(context, 'Save'),
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Row(
            children: [
              const _IconBox(
                icon: Icons.egg_alt_outlined,
                color: Color(0xFFFF8A16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(translateText(context, 'Breakfast'), style: _headingStyle),
                    SizedBox(height: 4),
                    Text(translateText(context, 'Plan this meal for your day'), style: _mutedStyle),
                  ],
                ),
              ),
              _Pill(label: 'Planned'),
            ],
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(translateText(context, 'Meal Time'), style: _sectionStyle),
                const SizedBox(height: 12),
                InkWell(
                  onTap: selectMealTime,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: 54,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FC),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          color: Color(0xFF5B35F5),
                        ),
                        const SizedBox(width: 10),
                        Text(formatTime(mealTime), style: _valueStyle),
                        const Spacer(),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF7B849A),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(translateText(context, 'Foods in this meal'), style: _sectionStyle),
                    Spacer(),
                  ],
                ),
                const SizedBox(height: 10),
                ...List.generate(
                  foods.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: _FoodEditRow(
                      food: foods[index],
                      onEdit: () => editFoodQuantity(index),
                      onMore: () => showFoodActions(index),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AddFoodScreen(),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text(
                      'Add Food',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF5B35F5),
                      backgroundColor: const Color(0xFFFBFAFF),
                      side: const BorderSide(color: Color(0xFFE1D9FF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nutrition Summary', style: _sectionStyle),
                const SizedBox(height: 12),
                _NutritionLine(
                  icon: Icons.local_fire_department_rounded,
                  color: const Color(0xFFFF8A16),
                  label: 'Calories',
                  value: '$totalCalories kcal',
                ),
                const _SoftDivider(),
                _NutritionLine(
                  icon: Icons.favorite_rounded,
                  color: const Color(0xFF2DAA61),
                  label: 'Protein',
                  value: '$totalProtein g',
                ),
                const _SoftDivider(),
                _NutritionLine(
                  icon: Icons.grass_rounded,
                  color: const Color(0xFF467BFF),
                  label: 'Carbs',
                  value: '$totalCarbs g',
                ),
                const _SoftDivider(),
                _NutritionLine(
                  icon: Icons.water_drop_rounded,
                  color: const Color(0xFFFF8A16),
                  label: 'Fat',
                  value: '$totalFat g',
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: (totalCalories / 1800).clamp(0, 1).toDouble(),
                    minHeight: 7,
                    backgroundColor: const Color(0xFFEDEEF3),
                    color: const Color(0xFF5B35F5),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '${((totalCalories / 1800) * 100).round()}% of your daily calories',
                  style: _mutedStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Meal Status', style: _sectionStyle),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _StatusOption(
                      title: 'Planned',
                      color: const Color(0xFF5B35F5),
                      active: true,
                    ),
                    const SizedBox(width: 8),
                    _StatusOption(
                      title: 'Logged',
                      color: const Color(0xFF2DAA61),
                    ),
                    const SizedBox(width: 8),
                    _StatusOption(
                      title: 'Skipped',
                      color: const Color(0xFFFF3E4B),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'This meal is planned. Changes here update the plan, not your recorded intake.',
                  style: TextStyle(
                    color: Color(0xFF7B849A),
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF5B35F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: removeMeal,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF3E4B),
              backgroundColor: const Color(0xFFFFF1F2),
              minimumSize: const Size(double.infinity, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
                side: const BorderSide(color: Color(0xFFFFD5D9)),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_outline_rounded, size: 19),
                SizedBox(width: 7),
                Text(
                  'Remove from Plan',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakfastFood {
  final String name;
  final int grams, calories, protein, carbs, fat;
  final IconData icon;
  final Color color;
  final String image;

  const _BreakfastFood({
    required this.name,
    required this.grams,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.icon,
    required this.color,
    required this.image,
  });

  _BreakfastFood copyWith({
    int? grams,
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
  }) => _BreakfastFood(
    name: name,
    grams: grams ?? this.grams,
    calories: calories ?? this.calories,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fat: fat ?? this.fat,
    icon: icon,
    color: color,
    image: image,
  );
}

class _FoodEditRow extends StatelessWidget {
  final _BreakfastFood food;
  final VoidCallback onEdit, onMore;
  const _FoodEditRow({
    required this.food,
    required this.onEdit,
    required this.onMore,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFFBFBFD),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFF0F1F5)),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Image.asset(
            food.image,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _IconBox(
              icon: food.icon,
              color: food.color,
              size: 48,
              radius: 13,
            ),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                food.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text('${food.grams} g', style: _mutedStyle),
              const SizedBox(height: 4),
              Text(
                '${food.calories} kcal',
                style: const TextStyle(
                  color: Color(0xFF5B35F5),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        _RoundButton(icon: Icons.remove_rounded, onTap: onEdit),
        SizedBox(
          width: 40,
          child: Text(
            '${food.grams}g',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
          ),
        ),
        _RoundButton(icon: Icons.add_rounded, filled: true, onTap: onEdit),
        IconButton(
          onPressed: onMore,
          icon: const Icon(Icons.more_vert_rounded, size: 19),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 28),
        ),
      ],
    ),
  );
}

class _QuantitySheet extends StatefulWidget {
  final _BreakfastFood food;
  final ValueChanged<_BreakfastFood> onSave;
  const _QuantitySheet({required this.food, required this.onSave});
  @override
  State<_QuantitySheet> createState() => _QuantitySheetState();
}

class _QuantitySheetState extends State<_QuantitySheet> {
  late double grams = widget.food.grams.toDouble();
  @override
  Widget build(BuildContext context) {
    final factor = grams / 100;
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 18),
            Text(widget.food.name, style: _titleStyle),
            const SizedBox(height: 6),
            const Text('Serving size', style: _mutedStyle),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RoundButton(
                  icon: Icons.remove_rounded,
                  onTap: () =>
                      setState(() => grams = (grams - 25).clamp(25, 1000)),
                ),
                const SizedBox(width: 18),
                Column(
                  children: [
                    Text(
                      '${grams.round()}',
                      style: const TextStyle(
                        fontSize: 31,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text('grams', style: _mutedStyle),
                  ],
                ),
                const SizedBox(width: 18),
                _RoundButton(
                  icon: Icons.add_rounded,
                  filled: true,
                  onTap: () =>
                      setState(() => grams = (grams + 25).clamp(25, 1000)),
                ),
              ],
            ),
            const SizedBox(height: 17),
            Row(
              children: [
                _MiniStat(
                  label: 'Calories',
                  value: '${(widget.food.calories * factor).round()}',
                  color: const Color(0xFFFF8A16),
                ),
                const SizedBox(width: 8),
                _MiniStat(
                  label: 'Protein',
                  value: '${(widget.food.protein * factor).round()}g',
                  color: const Color(0xFF2DAA61),
                ),
                const SizedBox(width: 8),
                _MiniStat(
                  label: 'Carbs',
                  value: '${(widget.food.carbs * factor).round()}g',
                  color: const Color(0xFF467BFF),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () {
                  widget.onSave(
                    widget.food.copyWith(
                      grams: grams.round(),
                      calories: (widget.food.calories * factor).round(),
                      protein: (widget.food.protein * factor).round(),
                      carbs: (widget.food.carbs * factor).round(),
                      fat: (widget.food.fat * factor).round(),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Save Serving'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size, radius;
  const _IconBox({
    required this.icon,
    required this.color,
    this.size = 46,
    this.radius = 23,
  });
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(radius),
    ),
    child: Icon(icon, color: color, size: size * .52),
  );
}

class _Pill extends StatelessWidget {
  final String label;
  const _Pill({required this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFF1EEFF),
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Text(
      'Planned',
      style: TextStyle(
        color: Color(0xFF5B35F5),
        fontSize: 10,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  const _RoundButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? const Color(0xFF5B35F5) : Colors.white,
        border: Border.all(
          color: filled ? const Color(0xFF5B35F5) : const Color(0xFFE1E4EB),
        ),
      ),
      child: Icon(
        icon,
        size: 17,
        color: filled ? Colors.white : const Color(0xFF5B35F5),
      ),
    ),
  );
}

class _NutritionLine extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label, value;
  const _NutritionLine({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 39,
    child: Row(
      children: [
        _IconBox(icon: icon, color: color, size: 29, radius: 15),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
        ),
      ],
    ),
  );
}

class _StatusOption extends StatelessWidget {
  final String title;
  final Color color;
  final bool active;
  const _StatusOption({
    required this.title,
    required this.color,
    this.active = false,
  });
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      height: 44,
      decoration: BoxDecoration(
        color: active ? color.withValues(alpha: 0.09) : const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: active ? color : const Color(0xFFEEF0F5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.circle_outlined, size: 17, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: active ? color : const Color(0xFF7B849A),
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(label, style: _smallStyle),
        ],
      ),
    ),
  );
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color = const Color(0xFF17203A),
  });
  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    contentPadding: EdgeInsets.zero,
    leading: _IconBox(icon: icon, color: color, size: 38, radius: 11),
    title: Text(
      title,
      style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700),
    ),
    trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFA0A8B8)),
  );
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();
  @override
  Widget build(BuildContext context) => Container(
    width: 38,
    height: 4,
    decoration: BoxDecoration(
      color: const Color(0xFFDDE1EA),
      borderRadius: BorderRadius.circular(20),
    ),
  );
}

class _SoftDivider extends StatelessWidget {
  const _SoftDivider();
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: Color(0xFFF0F1F5));
}

const _headingStyle = TextStyle(
  color: Color(0xFF17203A),
  fontSize: 20,
  fontWeight: FontWeight.w800,
);
const _sectionStyle = TextStyle(
  color: Color(0xFF17203A),
  fontSize: 16,
  fontWeight: FontWeight.w800,
);
const _titleStyle = TextStyle(
  color: Color(0xFF17203A),
  fontSize: 18,
  fontWeight: FontWeight.w800,
);
const _valueStyle = TextStyle(
  color: Color(0xFF17203A),
  fontSize: 15,
  fontWeight: FontWeight.w700,
);
const _mutedStyle = TextStyle(
  color: Color(0xFF7B849A),
  fontSize: 11,
  fontWeight: FontWeight.w500,
);
const _smallStyle = TextStyle(
  color: Color(0xFF7B849A),
  fontSize: 9,
  fontWeight: FontWeight.w600,
);
