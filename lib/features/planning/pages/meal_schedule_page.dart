import 'package:flutter/material.dart';

import 'package:my_plan/core/state/app_state.dart';
import 'package:my_plan/core/state/controllers/planning_controller.dart';

class MealSchedulePage extends StatefulWidget {
  const MealSchedulePage({
    super.key,
  });

  @override
  State<MealSchedulePage> createState() =>
      _MealSchedulePageState();
}

class _MealSchedulePageState
    extends State<MealSchedulePage> {
  static const Color primary =
      Color(0xFF5B35F5);

  static const Color background =
      Color(0xFFF7F7FB);

  static const Color text =
      Color(0xFF18182B);

  static const Color secondary =
      Color(0xFF85899D);

  static const Color border =
      Color(0xFFE7E7EF);

  late List<_EditableMeal> _meals;

  @override
  void initState() {
    super.initState();

    _meals = appState.planning.mealSchedule
        .map(
          (meal) => _EditableMeal.fromConfig(
            meal,
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    for (final meal in _meals) {
      meal.dispose();
    }

    super.dispose();
  }

  // ============================================================
  // CALCULATIONS
  // ============================================================

  double get dailyTarget {
    return appState.planning.dailyCalories;
  }

  double get scheduledCalories {
    return _meals.fold<double>(
      0.0,
      (
        total,
        meal,
      ) =>
          total + meal.calories,
    );
  }

  double get difference {
    return scheduledCalories - dailyTarget;
  }

  bool get isBalanced {
    return difference.abs() < 1;
  }

  double get completion {
    if (dailyTarget <= 0) {
      return 0.0;
    }

    return (scheduledCalories / dailyTarget)
        .clamp(
      0.0,
      1.0,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Directionality(
      textDirection:
          TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            background,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),

              Expanded(
                child: ListView(
                  physics:
                      const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    30,
                  ),
                  children: [
                    _buildDailyTargetCard(),

                    const SizedBox(
                      height: 16,
                    ),

                    _buildMealCountSection(),

                    const SizedBox(
                      height: 12,
                    ),

                    ..._meals
                        .asMap()
                        .entries
                        .map(
                          (entry) =>
                              _buildMealCard(
                            entry.key,
                            entry.value,
                          ),
                        ),

                    const SizedBox(
                      height: 4,
                    ),

                    _buildAddMealButton(),

                    const SizedBox(
                      height: 16,
                    ),

                    _buildDistributionHint(),

                    const SizedBox(
                      height: 22,
                    ),

                    _buildSaveButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        18,
        8,
        18,
        8,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: text,
            ),
          ),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'جدول الوجبات',
                  style: TextStyle(
                    color: text,
                    fontSize: 23,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'حدد عدد الوجبات ووقت كل وجبة وسعراتها.',
                  style: TextStyle(
                    color: secondary,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DAILY TARGET CARD
  // ============================================================

  Widget _buildDailyTargetCard() {
    final Color stateColor =
        isBalanced
            ? const Color(0xFF2FA66A)
            : difference > 0
                ? const Color(0xFFD17A20)
                : primary;

    final String statusText =
        isBalanced
            ? 'توزيع متوازن'
            : difference > 0
                ? 'تجاوزت الهدف بـ ${difference.abs().round()} kcal'
                : 'متبقي ${difference.abs().round()} kcal';

    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        border:
            Border.all(
          color: border,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'السعرات اليومية',
                      style: TextStyle(
                        color: secondary,
                        fontSize: 8.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'وزّع هدفك اليومي على الوجبات',
                      style: TextStyle(
                        color: text,
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${dailyTarget.round()} kcal',
                style: const TextStyle(
                  color: primary,
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                scheduledCalories
                    .round()
                    .toString(),
                style: const TextStyle(
                  color: text,
                  fontSize: 32,
                  height: 1,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
              const SizedBox(width: 6),
              const Padding(
                padding:
                    EdgeInsets.only(
                  bottom: 2,
                ),
                child: Text(
                  'موزعة',
                  style: TextStyle(
                    color: secondary,
                    fontSize: 8,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                statusText,
                style: TextStyle(
                  color: stateColor,
                  fontSize: 8,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(30),
            child:
                LinearProgressIndicator(
              value: completion,
              minHeight: 8,
              backgroundColor:
                  const Color(0xFFEDECF4),
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                stateColor,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Text(
                '${scheduledCalories.round()} kcal',
                style: const TextStyle(
                  color: secondary,
                  fontSize: 7,
                ),
              ),
              const Spacer(),
              Text(
                '${dailyTarget.round()} kcal هدف',
                style: const TextStyle(
                  color: secondary,
                  fontSize: 7,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MEAL COUNT
  // ============================================================

  Widget _buildMealCountSection() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border:
            Border.all(
          color: border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration:
                const BoxDecoration(
              color: Color(0xFFF0ECFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.restaurant_menu_rounded,
              color: primary,
              size: 19,
            ),
          ),

          const SizedBox(width: 9),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'عدد الوجبات',
                  style: TextStyle(
                    color: text,
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'يمكنك إعداد من وجبتين إلى ثماني وجبات.',
                  style: TextStyle(
                    color: secondary,
                    fontSize: 7.5,
                  ),
                ),
              ],
            ),
          ),

          _circleButton(
            icon:
                Icons.remove_rounded,
            onTap:
                _meals.length > 2
                    ? _removeLastMeal
                    : null,
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Text(
              '${_meals.length}',
              style: const TextStyle(
                color: text,
                fontSize: 19,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ),

          _circleButton(
            icon:
                Icons.add_rounded,
            filled: true,
            onTap:
                _meals.length < 8
                    ? _addMeal
                    : null,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MEAL CARD
  // ============================================================

  Widget _buildMealCard(
    int index,
    _EditableMeal meal,
  ) {
    final icon =
        _mealIcon(meal.name);

    final color =
        _mealColor(index);

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
          const EdgeInsets.all(15),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border:
            Border.all(
          color: border,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration:
                    BoxDecoration(
                  color:
                      color.withValues(
                    alpha: 0.10,
                  ),
                  shape:
                      BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller:
                          meal.nameController,
                      onChanged:
                          (value) {
                        meal.name =
                            value;
                        setState(() {});
                      },
                      style:
                          const TextStyle(
                        color: text,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w900,
                      ),
                      decoration:
                          const InputDecoration(
                        isDense: true,
                        border:
                            InputBorder.none,
                        hintText:
                            'اسم الوجبة',
                        hintStyle:
                            TextStyle(
                          color:
                              secondary,
                          fontSize:
                              11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meal.timeText,
                      style:
                          const TextStyle(
                        color: secondary,
                        fontSize: 7.5,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                visualDensity:
                    VisualDensity.compact,
                onPressed:
                    _meals.length > 2
                        ? () =>
                            _removeMealAt(
                              index,
                            )
                        : null,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color:
                      _meals.length > 2
                          ? const Color(
                              0xFFE16C6C,
                            )
                          : const Color(
                              0xFFD5D7DF,
                            ),
                  size: 19,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _valueBox(
                  title:
                      'الوقت',
                  value:
                      meal.timeText,
                  icon:
                      Icons.schedule_rounded,
                  onTap:
                      () =>
                          _pickTime(index),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _valueBox(
                  title:
                      'السعرات',
                  value:
                      '${meal.calories.round()} kcal',
                  icon:
                      Icons
                          .local_fire_department_rounded,
                  onTap:
                      () =>
                          _editCalories(
                            index,
                          ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          _calorieSlider(
            index,
            meal,
          ),
        ],
      ),
    );
  }

  Widget _valueBox({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap:
          onTap,
      borderRadius:
          BorderRadius.circular(13),
      child:
          Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 10,
        ),
        decoration:
            BoxDecoration(
          color:
              const Color(0xFFFAFAFD),
          borderRadius:
              BorderRadius.circular(13),
          border:
              Border.all(
            color:
                const Color(0xFFE9E9F0),
          ),
        ),
        child:
            Row(
          children: [
            Icon(
              icon,
              color: primary,
              size: 16,
            ),
            const SizedBox(width: 7),
            Expanded(
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      color:
                          secondary,
                      fontSize:
                          6.5,
                    ),
                  ),
                  const SizedBox(
                      height: 3),
                  Text(
                    value,
                    style:
                        const TextStyle(
                      color:
                          text,
                      fontSize:
                          9,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.edit_outlined,
              color:
                  secondary,
              size:
                  14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _calorieSlider(
    int index,
    _EditableMeal meal,
  ) {
    final maxCalories =
        _maxCalories();

    final sliderValue =
        meal.calories.clamp(
      100.0,
      maxCalories,
    );

    final divisions =
        ((maxCalories - 100) /
                25)
            .round();

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'السعرات',
              style:
                  TextStyle(
                color:
                    secondary,
                fontSize:
                    7,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '${meal.calories.round()} kcal',
              style:
                  const TextStyle(
                color:
                    text,
                fontSize:
                    8,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ],
        ),

        SliderTheme(
          data:
              SliderTheme.of(context)
                  .copyWith(
            trackHeight:
                5,
            thumbShape:
                const RoundSliderThumbShape(
              enabledThumbRadius:
                  7,
            ),
            overlayShape:
                const RoundSliderOverlayShape(
              overlayRadius:
                  15,
            ),
            activeTrackColor:
                primary,
            inactiveTrackColor:
                const Color(
              0xFFE9E8F0,
            ),
            thumbColor:
                primary,
          ),
          child:
              Slider(
            min:
                100,
            max:
                maxCalories,
            divisions:
                divisions <=
                        0
                    ? 1
                    : divisions,
            value:
                sliderValue,
            onChanged:
                (
              value,
            ) {
              setState(
                () {
                  meal.calories =
                      (value /
                                  25)
                              .round() *
                          25.0;

                  _fixRoundingDifference(
                    exceptIndex:
                        index,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  double _maxCalories() {
    final value =
        dailyTarget;

    if (value < 500) {
      return 500;
    }

    return value.clamp(
      500.0,
      4000.0,
    );
  }

  // ============================================================
  // ADD MEAL BUTTON
  // ============================================================

  Widget _buildAddMealButton() {
    return SizedBox(
      width:
          double.infinity,
      height:
          48,
      child:
          OutlinedButton.icon(
        onPressed:
            _meals.length <
                    8
                ? _addMeal
                : null,
        style:
            OutlinedButton.styleFrom(
          foregroundColor:
              primary,
          side:
              const BorderSide(
            color:
                Color(0xFFDCD6FA),
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
        ),
        icon:
            const Icon(
          Icons.add_rounded,
          size:
              19,
        ),
        label:
            const Text(
          'إضافة وجبة أخرى',
          style:
              TextStyle(
            fontSize:
                10,
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HINT
  // ============================================================

  Widget _buildDistributionHint() {
    final remaining =
        difference.abs();

    return Container(
      padding:
          const EdgeInsets.all(
        13,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFFF4F0FF,
        ),
        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),
      child:
          Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color:
                primary,
            size:
                18,
          ),

          const SizedBox(
              width:
                  8),

          Expanded(
            child:
                Text(
              isBalanced
                  ? 'ممتاز. مجموع سعرات الوجبات يساوي هدفك اليومي.'
                  : 'يمكنك تعديل سعرات أي وجبة حتى يتطابق مجموعها مع هدفك اليومي. الفرق الحالي ${remaining.round()} kcal.',
              style:
                  const TextStyle(
                color:
                    secondary,
                fontSize:
                    8,
                height:
                    1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SAVE BUTTON
  // ============================================================

  Widget _buildSaveButton() {
    final enabled =
        isBalanced &&
        _meals.isNotEmpty;

    return SizedBox(
      width:
          double.infinity,
      height:
          54,
      child:
          FilledButton(
        onPressed:
            enabled
                ? _save
                : null,
        style:
            FilledButton.styleFrom(
          backgroundColor:
              primary,
          disabledBackgroundColor:
              const Color(
            0xFFD9D7E3,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              17,
            ),
          ),
        ),
        child:
            Text(
          enabled
              ? 'حفظ جدول الوجبات'
              : 'طابق السعرات قبل الحفظ',
          style:
              const TextStyle(
            fontSize:
                13,
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ),
    );
  }

  void _save() {
    if (_meals.length <
        2) {
      _showMessage(
        'يجب أن يكون لديك وجبتان على الأقل.',
      );
      return;
    }

    if (!isBalanced) {
      _showMessage(
        'يجب أن يتساوى مجموع سعرات الوجبات مع هدفك اليومي قبل الحفظ.',
      );
      return;
    }

    final schedule =
        _meals.map(
      (
        meal,
      ) {
        final name =
            meal.name.trim();

        return MealScheduleConfig(
          id:
              meal.id,
          name:
              name.isEmpty
                  ? 'وجبة'
                  : name,
          time:
              meal.timeText,
          calories:
              meal.calories,
        );
      },
    ).toList();

    appState.planning
        .updateMealSchedule(
      schedule,
    );

    Navigator.pop(
      context,
    );
  }

  // ============================================================
  // ADD / REMOVE MEALS
  // ============================================================

  void _addMeal() {
    if (_meals.length >=
        8) {
      return;
    }

    final index =
        _meals.length + 1;

    final meal =
        _EditableMeal(
      id:
          'meal_${index}_${DateTime.now().millisecondsSinceEpoch}',
      name:
          _defaultMealName(
        index,
      ),
      time:
          const TimeOfDay(
        hour: 12,
        minute: 0,
      ),
      calories:
          0.0,
    );

    setState(
      () {
        _meals.add(
          meal,
        );

        _autoRebalance();
      },
    );
  }

  void _removeLastMeal() {
    if (_meals.length <=
        2) {
      return;
    }

    setState(
      () {
        final removed =
            _meals.removeLast();

        removed.dispose();

        _autoRebalance();
      },
    );
  }

  void _removeMealAt(
    int index,
  ) {
    if (_meals.length <=
        2) {
      return;
    }

    if (index < 0 ||
        index >= _meals.length) {
      return;
    }

    setState(
      () {
        final removed =
            _meals.removeAt(
          index,
        );

        removed.dispose();

        _autoRebalance();
      },
    );
  }

  String _defaultMealName(
    int index,
  ) {
    const names = [
      'الإفطار',
      'الغداء',
      'العشاء',
      'وجبة خفيفة',
      'وجبة إضافية',
      'وجبة إضافية 2',
      'وجبة إضافية 3',
      'وجبة إضافية 4',
    ];

    if (index >= 1 &&
        index <=
            names.length) {
      return names[index - 1];
    }

    return 'وجبة $index';
  }

  // ============================================================
  // AUTO BALANCE
  // ============================================================

  void _autoRebalance() {
    if (_meals.isEmpty ||
        dailyTarget <=
            0) {
      return;
    }

    final base =
        dailyTarget /
            _meals.length;

    for (final meal
        in _meals) {
      meal.calories =
          (base / 25)
                  .round() *
              25.0;
    }

    _fixRoundingDifference();
  }

  void _fixRoundingDifference({
    int? exceptIndex,
  }) {
    if (_meals.isEmpty) {
      return;
    }

    final currentDifference =
        dailyTarget -
            scheduledCalories;

    if (currentDifference.abs() <
        0.5) {
      return;
    }

    int targetIndex =
        _meals.length - 1;

    if (exceptIndex !=
            null &&
        targetIndex ==
            exceptIndex &&
        _meals.length >
            1) {
      targetIndex =
          _meals.length - 2;
    }

    final meal =
        _meals[targetIndex];

    final corrected =
        meal.calories +
            currentDifference;

    if (corrected >=
            100 &&
        corrected <=
            4000) {
      meal.calories =
          corrected;
    }
  }

  // ============================================================
  // TIME PICKER
  // ============================================================

  Future<void> _pickTime(
    int index,
  ) async {
    if (index < 0 ||
        index >=
            _meals.length) {
      return;
    }

    final meal =
        _meals[index];

    final TimeOfDay?
        picked =
        await showTimePicker(
      context:
          context,
      initialTime:
          meal.time,
      builder:
          (
        context,
        child,
      ) {
        return Directionality(
          textDirection:
              TextDirection.rtl,
          child:
              child ??
                  const SizedBox(),
        );
      },
    );

    if (picked ==
            null ||
        !mounted) {
      return;
    }

    setState(
      () {
        meal.time =
            picked;
      },
    );
  }

  // ============================================================
  // CALORIE EDIT
  // ============================================================

  Future<void>
      _editCalories(
    int index,
  ) async {
    if (index < 0 ||
        index >=
            _meals.length) {
      return;
    }

    final meal =
        _meals[index];

    final controller =
        TextEditingController(
      text:
          meal.calories.round().toString(),
    );

    final double?
        result =
        await showDialog<double>(
      context:
          context,
      builder:
          (
        context,
      ) {
        return Directionality(
          textDirection:
              TextDirection.rtl,
          child:
              AlertDialog(
            title:
                const Text(
              'تعديل سعرات الوجبة',
              style:
                  TextStyle(
                fontWeight:
                    FontWeight.w900,
              ),
            ),
            content:
                TextField(
              controller:
                  controller,
              autofocus:
                  true,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal:
                    false,
              ),
              decoration:
                  const InputDecoration(
                labelText:
                    'السعرات',
                suffixText:
                    'kcal',
              ),
            ),
            actions: [
              TextButton(
                onPressed:
                    () {
                  Navigator.pop(
                    context,
                  );
                },
                child:
                    const Text(
                  'إلغاء',
                ),
              ),
              FilledButton(
                onPressed:
                    () {
                  final value =
                      double.tryParse(
                    controller
                        .text
                        .trim(),
                  );

                  if (value ==
                          null ||
                      value <
                          100) {
                    return;
                  }

                  Navigator.pop(
                    context,
                    value,
                  );
                },
                child:
                    const Text(
                  'تأكيد',
                ),
              ),
            ],
          ),
        );
      },
    );

    controller.dispose();

    if (result ==
            null ||
        !mounted) {
      return;
    }

    setState(
      () {
        meal.calories =
            (result /
                        25)
                    .round() *
                25.0;

        _fixRoundingDifference(
          exceptIndex:
              index,
        );
      },
    );
  }

  // ============================================================
  // BUTTON
  // ============================================================

  Widget _circleButton({
    required IconData icon,
    required VoidCallback? onTap,
    bool filled = false,
  }) {
    final enabled =
        onTap != null;

    return InkWell(
      onTap:
          onTap,
      customBorder:
          const CircleBorder(),
      child:
          Container(
        width:
            31,
        height:
            31,
        decoration:
            BoxDecoration(
          shape:
              BoxShape.circle,
          color:
              filled &&
                      enabled
                  ? primary
                  : const Color(
                      0xFFF0ECFF,
                    ),
          border:
              Border.all(
            color:
                enabled
                    ? primary
                    : const Color(
                        0xFFE0E1E8,
                      ),
          ),
        ),
        child:
            Icon(
          icon,
          size:
              16,
          color:
              filled &&
                      enabled
                  ? Colors.white
                  : enabled
                      ? primary
                      : secondary,
        ),
      ),
    );
  }

  // ============================================================
  // ICON
  // ============================================================

  IconData _mealIcon(
    String name,
  ) {
    if (name.contains(
      'إفطار',
    )) {
      return Icons
          .wb_sunny_outlined;
    }

    if (name.contains(
      'غداء',
    )) {
      return Icons
          .restaurant_outlined;
    }

    if (name.contains(
      'عشاء',
    )) {
      return Icons
          .dinner_dining_outlined;
    }

    if (name.contains(
      'خفيفة',
    )) {
      return Icons
          .local_cafe_outlined;
    }

    return Icons
        .restaurant_menu_outlined;
  }

  Color _mealColor(
    int index,
  ) {
    const colors = [
      Color(0xFFFFA130),
      Color(0xFF487EFF),
      Color(0xFF6A55E8),
      Color(0xFF3AA86B),
      Color(0xFFDB6591),
    ];

    return colors[
      index %
          colors.length
    ];
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(
      context,
    )
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior:
              SnackBarBehavior.floating,
          content:
              Text(
            message,
          ),
        ),
      );
  }
}

// ================================================================
// EDITABLE MEAL
// ================================================================

class _EditableMeal {
  final String id;

  String name;

  TimeOfDay time;

  double calories;

  late final TextEditingController
      nameController;

  _EditableMeal({
    required this.id,
    required this.name,
    required this.time,
    required this.calories,
  }) {
    nameController =
        TextEditingController(
      text:
          name,
    );
  }

  factory _EditableMeal.fromConfig(
    MealScheduleConfig config,
  ) {
    return _EditableMeal(
      id:
          config.id,
      name:
          config.name,
      time:
          _parseTime(
        config.time,
      ),
      calories:
          config.calories,
    );
  }

  String get timeText {
    final int hour =
        time.hourOfPeriod ==
                0
            ? 12
            : time.hourOfPeriod;

    final String minute =
        time.minute
            .toString()
            .padLeft(
          2,
          '0',
        );

    final String suffix =
        time.period ==
                DayPeriod.am
            ? 'ص'
            : 'م';

    return '$hour:$minute $suffix';
  }

  void dispose() {
    nameController.dispose();
  }

  static TimeOfDay _parseTime(
    String value,
  ) {
    final normalized =
        value.trim();

    final match =
        RegExp(
      r'^(\d{1,2}):(\d{2})\s*([صم]|AM|PM)$',
      caseSensitive:
          false,
    ).firstMatch(
      normalized,
    );

    if (match !=
        null) {
      int hour =
          int.tryParse(
                match.group(
                      1,
                    ) ??
                    '12',
              ) ??
              12;

      final int minute =
          int.tryParse(
                match.group(
                      2,
                    ) ??
                    '0',
              ) ??
              0;

      final String suffix =
          (match.group(
                    3,
                  ) ??
                  'م')
              .toLowerCase();

      final bool isPm =
          suffix == 'م' ||
          suffix == 'pm';

      if (hour ==
          12) {
        hour = 0;
      }

      if (isPm) {
        hour += 12;
      }

      return TimeOfDay(
        hour:
            hour.clamp(
          0,
          23,
        ),
        minute:
            minute.clamp(
          0,
          59,
        ),
      );
    }

    return const TimeOfDay(
      hour: 12,
      minute: 0,
    );
  }
}