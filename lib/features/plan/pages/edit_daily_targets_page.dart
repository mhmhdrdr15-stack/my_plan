import 'package:flutter/material.dart';
import 'package:my_plan/core/localization/app_localization.dart';

class EditDailyTargetsPage extends StatefulWidget {
  final int initialCalories;
  final int initialProtein;
  final int initialCarbs;
  final int initialFat;
  final double initialWater;

  const EditDailyTargetsPage({
    super.key,
    this.initialCalories = 1800,
    this.initialProtein = 130,
    this.initialCarbs = 180,
    this.initialFat = 60,
    this.initialWater = 2.5,
  });

  @override
  State<EditDailyTargetsPage> createState() => _EditDailyTargetsPageState();
}

class _EditDailyTargetsPageState extends State<EditDailyTargetsPage> {
  late int calories;
  late int protein;
  late int carbs;
  late int fat;
  late double water;
  bool autoCalculate = true;

  @override
  void initState() {
    super.initState();
    calories = widget.initialCalories;
    protein = widget.initialProtein;
    carbs = widget.initialCarbs;
    fat = widget.initialFat;
    water = widget.initialWater;
  }

  void recalculateMacros() {
    if (!autoCalculate) return;
    protein = (calories * .29 / 4).round();
    fat = (calories * .30 / 9).round();
    carbs = ((calories - protein * 4 - fat * 9) / 4).round();
  }

  void changeCalories(int amount) {
    setState(() {
      calories = (calories + amount).clamp(1000, 5000);
      recalculateMacros();
    });
  }

  void changeProtein(int amount) {
    if (autoCalculate) return;
    setState(() => protein = (protein + amount).clamp(20, 400));
  }

  void changeCarbs(int amount) {
    if (autoCalculate) return;
    setState(() => carbs = (carbs + amount).clamp(20, 600));
  }

  void changeFat(int amount) {
    if (autoCalculate) return;
    setState(() => fat = (fat + amount).clamp(10, 250));
  }

  void changeWater(double amount) {
    setState(() => water = (water + amount).clamp(.5, 6.0));
  }

  void saveTargets() {
    final macroCalories = protein * 4 + carbs * 4 + fat * 9;
    if (!autoCalculate && (macroCalories - calories).abs() > 100) {
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Targets need adjustment',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: TargetColors.text,
            ),
          ),
          content: Text(
            'Your macro targets represent approximately $macroCalories kcal, while your daily calorie target is $calories kcal.',
            style: const TextStyle(color: TargetColors.muted, height: 1.45),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _returnTargets();
              },
              style: FilledButton.styleFrom(
                backgroundColor: TargetColors.primary,
              ),
              child: const Text('Save Anyway'),
            ),
          ],
        ),
      );
      return;
    }
    _confirmSave();
  }

  Future<void> _confirmSave() async {
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(translateText(context, 'Save calorie changes?')),
        content: Text(
          translateText(
            context,
            'Your daily calorie target will be updated after saving.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(translateText(context, 'Cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(translateText(context, 'Save')),
          ),
        ],
      ),
    );
    if (shouldSave == true && mounted) _returnTargets();
  }

  void _returnTargets() {
    Navigator.pop(
      context,
      DailyTargets(
        calories: calories,
        protein: protein,
        carbs: carbs,
        fat: fat,
        water: water,
        autoCalculate: autoCalculate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TargetColors.background,
      appBar: AppBar(
        backgroundColor: TargetColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          color: TargetColors.text,
        ),
        title: const Text(
          'Edit Daily Targets',
          style: TextStyle(
            color: TargetColors.text,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          TextButton(
            onPressed: saveTargets,
            child: const Text(
              'Save',
              style: TextStyle(
                color: TargetColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        children: [
          const Text(
            'Set your daily nutrition goals',
            style: TextStyle(
              color: TargetColors.text,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'These targets are used across your Home, Plan and Progress screens.',
            style: TextStyle(
              color: TargetColors.muted,
              fontSize: 12,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          TargetCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Target Mode',
                  style: TextStyle(
                    color: TargetColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                ModeSelector(
                  title: 'Auto calculate',
                  subtitle: 'Based on your goal, activity and profile',
                  icon: Icons.auto_awesome_rounded,
                  active: autoCalculate,
                  onTap: () {
                    setState(() {
                      autoCalculate = true;
                      recalculateMacros();
                    });
                  },
                ),
                const SizedBox(height: 8),
                ModeSelector(
                  title: 'Custom',
                  subtitle: 'Set your calorie and macro targets manually',
                  icon: Icons.tune_rounded,
                  active: !autoCalculate,
                  onTap: () => setState(() => autoCalculate = false),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TargetCard(
            child: TargetEditor(
              icon: Icons.local_fire_department_rounded,
              iconColor: TargetColors.orange,
              title: 'Daily Calories',
              value: '$calories',
              unit: 'kcal',
              description: 'Your total daily energy target',
              onMinus: () => changeCalories(-50),
              onPlus: () => changeCalories(50),
            ),
          ),
          const SizedBox(height: 12),
          TargetCard(
            child: TargetEditor(
              icon: Icons.favorite_rounded,
              iconColor: TargetColors.red,
              title: 'Protein',
              value: '$protein',
              unit: 'g',
              description: 'Daily protein target',
              enabled: !autoCalculate,
              onMinus: () => changeProtein(-5),
              onPlus: () => changeProtein(5),
            ),
          ),
          const SizedBox(height: 12),
          TargetCard(
            child: TargetEditor(
              icon: Icons.rice_bowl_rounded,
              iconColor: TargetColors.blue,
              title: 'Carbohydrates',
              value: '$carbs',
              unit: 'g',
              description: 'Daily carbohydrate target',
              enabled: !autoCalculate,
              onMinus: () => changeCarbs(-5),
              onPlus: () => changeCarbs(5),
            ),
          ),
          const SizedBox(height: 12),
          TargetCard(
            child: TargetEditor(
              icon: Icons.eco_rounded,
              iconColor: TargetColors.green,
              title: 'Fat',
              value: '$fat',
              unit: 'g',
              description: 'Daily fat target',
              enabled: !autoCalculate,
              onMinus: () => changeFat(-5),
              onPlus: () => changeFat(5),
            ),
          ),
          const SizedBox(height: 12),
          TargetCard(
            child: TargetEditor(
              icon: Icons.water_drop_rounded,
              iconColor: TargetColors.water,
              title: 'Water',
              value: water.toStringAsFixed(1),
              unit: 'L',
              description: 'Daily hydration target',
              onMinus: () => changeWater(-.1),
              onPlus: () => changeWater(.1),
            ),
          ),
          const SizedBox(height: 12),
          const TargetCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      color: TargetColors.primary,
                      size: 21,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Based on your profile',
                      style: TextStyle(
                        color: TargetColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                ProfileInfoRow(title: 'Goal', value: 'Lose Weight'),
                ProfileDivider(),
                ProfileInfoRow(title: 'Current weight', value: '78 kg'),
                ProfileDivider(),
                ProfileInfoRow(title: 'Target weight', value: '72 kg'),
                ProfileDivider(),
                ProfileInfoRow(title: 'Activity', value: 'Moderately Active'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: saveTargets,
              style: FilledButton.styleFrom(
                backgroundColor: TargetColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Save Targets',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Changes will update your daily plan and progress targets.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TargetColors.muted2,
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class DailyTargets {
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final double water;
  final bool autoCalculate;

  const DailyTargets({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.water,
    required this.autoCalculate,
  });
}

class TargetEditor extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String unit;
  final String description;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final bool enabled;

  const TargetEditor({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.unit,
    required this.description,
    required this.onMinus,
    required this.onPlus,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: enabled ? 1 : .48,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 21),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: TargetColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: TargetColors.muted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TargetRoundButton(
              icon: Icons.remove_rounded,
              enabled: enabled,
              onTap: onMinus,
            ),
            const SizedBox(width: 22),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: TargetColors.text,
                    fontSize: 31,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    unit,
                    style: const TextStyle(
                      color: TargetColors.muted,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 22),
            TargetRoundButton(
              icon: Icons.add_rounded,
              enabled: enabled,
              filled: true,
              onTap: onPlus,
            ),
          ],
        ),
      ],
    ),
  );
}

class ModeSelector extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const ModeSelector({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(15),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFF3F0FF) : const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: active ? TargetColors.primary : const Color(0xFFEEF0F5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: active
                  ? TargetColors.primary.withValues(alpha: 0.10)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: active ? TargetColors.primary : TargetColors.muted,
              size: 21,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: active ? TargetColors.primary : TargetColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: TargetColors.muted,
                    fontSize: 10.5,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: active ? TargetColors.primary : const Color(0xFFC9CED9),
                width: 2,
              ),
            ),
            child: active
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: TargetColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    ),
  );
}

class ProfileInfoRow extends StatelessWidget {
  final String title;
  final String value;
  const ProfileInfoRow({super.key, required this.title, required this.value});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 38,
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: TargetColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: TargetColors.text,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class ProfileDivider extends StatelessWidget {
  const ProfileDivider({super.key});
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, color: Color(0xFFF0F1F5));
}

class TargetRoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  final bool enabled;
  const TargetRoundButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.filled = false,
    this.enabled = true,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: enabled ? onTap : null,
    child: Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled && enabled ? TargetColors.primary : Colors.white,
        border: Border.all(
          color: enabled ? TargetColors.primary : const Color(0xFFE1E4EB),
          width: 1.4,
        ),
      ),
      child: Icon(
        icon,
        size: 21,
        color: filled && enabled
            ? Colors.white
            : enabled
            ? TargetColors.primary
            : TargetColors.muted2,
      ),
    ),
  );
}

class TargetCard extends StatelessWidget {
  final Widget child;
  const TargetCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFEFF1F5)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0B000000),
          blurRadius: 18,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: child,
  );
}

class TargetColors {
  static const background = Color(0xFFF7F8FC);
  static const text = Color(0xFF17203A);
  static const muted = Color(0xFF7B849A);
  static const muted2 = Color(0xFFA0A8B8);
  static const primary = Color(0xFF5B35F5);
  static const orange = Color(0xFFFF8A16);
  static const red = Color(0xFFFF3E4B);
  static const blue = Color(0xFF467BFF);
  static const green = Color(0xFF2DAA61);
  static const water = Color(0xFF317BFF);
}
