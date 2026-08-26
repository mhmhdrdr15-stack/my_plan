import 'package:flutter/material.dart';

import 'plan_header_actions.dart';

class AddMealSnackSheet extends StatefulWidget {
  final void Function(String mealType, TimeOfDay time) onContinue;

  const AddMealSnackSheet({super.key, required this.onContinue});

  @override
  State<AddMealSnackSheet> createState() => _AddMealSnackSheetState();
}

class _AddMealSnackSheetState extends State<AddMealSnackSheet> {
  String selectedMeal = 'Snack';
  TimeOfDay selectedTime = const TimeOfDay(hour: 17, minute: 30);

  static const mealTypes = ['Breakfast', 'Lunch', 'Snack', 'Dinner'];

  Future<void> chooseTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (result != null && mounted) setState(() => selectedTime = result);
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $suffix';
  }

  String emojiForMeal(String meal) => switch (meal) {
    'Breakfast' => '🍳',
    'Lunch' => '🍗',
    'Snack' => '🍎',
    'Dinner' => '🥗',
    _ => '🍽️',
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDE1EA),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Add Meal / Snack',
              style: TextStyle(
                color: PlanColors.text,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Choose the meal type and time',
              style: TextStyle(color: PlanColors.muted, fontSize: 11),
            ),
            const SizedBox(height: 18),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Meal Type',
                style: TextStyle(
                  color: PlanColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 9),
            for (final meal in mealTypes) _mealOption(meal),
            const SizedBox(height: 7),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Time',
                style: TextStyle(
                  color: PlanColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: chooseTime,
              child: Container(
                width: double.infinity,
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFEEF0F5)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      color: PlanColors.primary,
                      size: 21,
                    ),
                    const SizedBox(width: 9),
                    Text(
                      formatTime(selectedTime),
                      style: const TextStyle(
                        color: PlanColors.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: PlanColors.muted,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 51,
              child: FilledButton(
                onPressed: () => widget.onContinue(selectedMeal, selectedTime),
                style: FilledButton.styleFrom(
                  backgroundColor: PlanColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mealOption(String meal) {
    final active = selectedMeal == meal;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => selectedMeal = meal),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFF2EEFF) : const Color(0xFFF8F9FC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: active ? PlanColors.primary : const Color(0xFFEEF0F5),
            ),
          ),
          child: Row(
            children: [
              Text(emojiForMeal(meal), style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  meal,
                  style: TextStyle(
                    color: active ? PlanColors.primary : PlanColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                width: 21,
                height: 21,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: active
                        ? PlanColors.primary
                        : const Color(0xFFC9CED9),
                    width: 2,
                  ),
                ),
                child: active
                    ? Center(
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: PlanColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
