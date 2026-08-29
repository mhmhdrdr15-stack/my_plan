import 'package:flutter/material.dart';

import '../models/user_goal_profile.dart';

class MealScheduleScreen extends StatefulWidget {
  final UserGoalProfile profile;

  const MealScheduleScreen({
    super.key,
    required this.profile,
  });

  @override
  State<MealScheduleScreen> createState() =>
      _MealScheduleScreenState();
}

class _MealScheduleScreenState
    extends State<MealScheduleScreen> {
  static const Color primary =
      Color(0xFF5B35F5);

  static const Color background =
      Color(0xFFF7F7FB);

  static const Color textPrimary =
      Color(0xFF18182B);

  static const Color textSecondary =
      Color(0xFF85899D);

  static const Color borderColor =
      Color(0xFFE7E7EF);

  late double _dailyCalories;

  late List<MealScheduleItem> _meals;

  @override
  void initState() {
    super.initState();

    _dailyCalories =
        widget.profile.dailyCalories;

    if (widget.profile.mealSchedule.isNotEmpty) {
      _meals = widget.profile.mealSchedule
          .map(
            (item) => item.copyWith(),
          )
          .toList();
    } else {
      _meals = _createDefaultMeals();
    }
  }

  // ============================================================
  // CALCULATIONS
  // ============================================================

  double get _totalMealCalories {
    return _meals.fold(
      0,
      (
        sum,
        meal,
      ) =>
          sum + meal.calories,
    );
  }

  double get _difference {
    return _dailyCalories -
        _totalMealCalories;
  }

  bool get _caloriesBalanced {
    return _difference.abs() < 0.5;
  }

  bool get _timesValid {
    if (_meals.length < 2) {
      return true;
    }

    for (int i = 0;
        i < _meals.length - 1;
        i++) {
      if (_toMinutes(
            _meals[i].time,
          ) >=
          _toMinutes(
            _meals[i + 1].time,
          )) {
        return false;
      }
    }

    return true;
  }

  bool get _isValid {
    return _dailyCalories > 0 &&
        _meals.isNotEmpty &&
        _caloriesBalanced &&
        _timesValid;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,
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
                    _buildCaloriesCard(),

                    const SizedBox(
                      height: 18,
                    ),

                    _buildSectionTitle(
                      'وجبات يومك',
                      'حدد وقت وسعرات كل وجبة بنفسك.',
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    ..._meals.asMap().entries.map(
                      (
                        entry,
                      ) {
                        return _buildMealCard(
                          entry.key,
                          entry.value,
                        );
                      },
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    _buildAddMealButton(),

                    const SizedBox(
                      height: 15,
                    ),

                    _buildAutoDistributionCard(),

                    const SizedBox(
                      height: 15,
                    ),

                    _buildSummaryCard(),
                  ],
                ),
              ),

              _buildBottomBar(),
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
        20,
        10,
        20,
        8,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed:
                () =>
                    Navigator.pop(
              context,
            ),
            icon:
                const Icon(
              Icons.arrow_forward_ios_rounded,
              size:
                  18,
            ),
          ),

          const SizedBox(
              width:
                  4),

          const Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  'توزيع وجباتك',
                  style:
                      TextStyle(
                    fontSize:
                        21,
                    fontWeight:
                        FontWeight.w900,
                    color:
                        textPrimary,
                  ),
                ),
                SizedBox(
                    height:
                        3),
                Text(
                  'أنت صاحب القرار في السعرات والأوقات.',
                  style:
                      TextStyle(
                    color:
                        textSecondary,
                    fontSize:
                        9,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal:
                  10,
              vertical:
                  7,
            ),
            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFFF0ECFF,
              ),
              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),
            child:
                Text(
                  '${_meals.length} وجبات',
                  style:
                      const TextStyle(
                    color:
                        primary,
                    fontSize:
                        8.5,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DAILY CALORIES
  // ============================================================

  Widget _buildCaloriesCard() {
    final progress =
        _dailyCalories <= 0
            ? 0.0
            : (_totalMealCalories /
                    _dailyCalories)
                .clamp(
              0.0,
              1.0,
            );

    return Container(
      padding:
          const EdgeInsets.all(
        18,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        border:
            Border.all(
          color:
              borderColor,
        ),
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      'السعرات اليومية',
                      style:
                          TextStyle(
                        color:
                            textSecondary,
                        fontSize:
                            9,
                      ),
                    ),
                    SizedBox(
                        height:
                            4),
                    Text(
                      'هذا الرقم اقتراح ويمكنك تغييره',
                      style:
                          TextStyle(
                        color:
                            textPrimary,
                        fontSize:
                            13,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap:
                    _editDailyCalories,
                child:
                    Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal:
                        11,
                    vertical:
                        7,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFFF0ECFF,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      11,
                    ),
                  ),
                  child:
                      const Text(
                    'تعديل',
                    style:
                        TextStyle(
                      color:
                          primary,
                      fontSize:
                          8,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
              height:
                  16),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                _dailyCalories
                    .round()
                    .toString(),
                style:
                    const TextStyle(
                  fontSize:
                      36,
                  height:
                      1,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(
                  width:
                      7),

              const Padding(
                padding:
                    EdgeInsets.only(
                  bottom:
                      2,
                ),
                child:
                    Text(
                  'kcal / يوم',
                  style:
                      TextStyle(
                    color:
                        textSecondary,
                    fontSize:
                        9,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
              height:
                  13),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            child:
                LinearProgressIndicator(
              value:
                  progress,
              minHeight:
                  8,
              backgroundColor:
                  const Color(
                0xFFF0EEF7,
              ),
              valueColor:
                  const AlwaysStoppedAnimation<
                      Color>(
                primary,
              ),
            ),
          ),

          const SizedBox(
              height:
                  9),

          Row(
            children: [
              Text(
                'موزع ${_totalMealCalories.round()}',
                style:
                    const TextStyle(
                  color:
                      textSecondary,
                  fontSize:
                      8,
                ),
              ),
              const Spacer(),
              Text(
                _caloriesBalanced
                    ? 'متوازن ✓'
                    : _difference > 0
                        ? 'باقي ${_difference.round()}'
                        : 'أعلى ${_difference.abs().round()}',
                style:
                    TextStyle(
                  color:
                      _caloriesBalanced
                          ? const Color(
                              0xFF2FA66A,
                            )
                          : const Color(
                              0xFFD27A1F,
                            ),
                  fontSize:
                      8.5,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              const TextStyle(
            fontSize:
                17,
            fontWeight:
                FontWeight.w900,
            color:
                textPrimary,
          ),
        ),
        const SizedBox(
            height:
                3),
        Text(
          subtitle,
          style:
              const TextStyle(
            color:
                textSecondary,
            fontSize:
                8.5,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MEAL CARD
  // ============================================================

  Widget _buildMealCard(
    int index,
    MealScheduleItem meal,
  ) {
    final percentage =
        _dailyCalories <= 0
            ? 0.0
            : meal.calories /
                _dailyCalories;

    final icon =
        _mealIcon(index);

    return Container(
      margin:
          const EdgeInsets.only(
        bottom:
            10,
      ),
      padding:
          const EdgeInsets.all(
        14,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          21,
        ),
        border:
            Border.all(
          color:
              borderColor,
        ),
      ),
      child:
          Column(
        children: [
          Row(
            children: [
              Container(
                width:
                    46,
                height:
                    46,
                decoration:
                    const BoxDecoration(
                  color:
                      Color(
                    0xFFF0ECFF,
                  ),
                  shape:
                      BoxShape.circle,
                ),
                child:
                    Icon(
                  icon,
                  color:
                      primary,
                ),
              ),

              const SizedBox(
                  width:
                      10),

              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      meal.name,
                      style:
                          const TextStyle(
                        fontSize:
                            13,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                        height:
                            4),
                    Text(
                      'الوجبة رقم ${index + 1}',
                      style:
                          const TextStyle(
                        color:
                            textSecondary,
                        fontSize:
                            8,
                      ),
                    ),
                  ],
                ),
              ),

              if (_meals.length >
                  2)
                IconButton(
                  tooltip:
                      'حذف',
                  visualDensity:
                      VisualDensity.compact,
                  onPressed:
                      () =>
                          _removeMeal(
                    index,
                  ),
                  icon:
                      const Icon(
                    Icons
                        .delete_outline_rounded,
                    color:
                        Color(
                      0xFFE16B6B,
                    ),
                    size:
                        19,
                  ),
                ),
            ],
          ),

          const SizedBox(
              height:
                  11),

          Row(
            children: [
              Expanded(
                child:
                    _editTile(
                  icon:
                      Icons.schedule_rounded,
                  label:
                      'وقت الوجبة',
                  value:
                      meal.time,
                  onTap:
                      () =>
                          _editMealTime(
                    index,
                  ),
                ),
              ),

              const SizedBox(
                  width:
                      7),

              Expanded(
                child:
                    _editTile(
                  icon:
                      Icons.local_fire_department_outlined,
                  label:
                      'السعرات',
                  value:
                      '${meal.calories.round()} kcal',
                  onTap:
                      () =>
                          _editMealCalories(
                    index,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
              height:
                  9),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            child:
                LinearProgressIndicator(
              value:
                  percentage.clamp(
                0.0,
                1.0,
              ),
              minHeight:
                  5,
              backgroundColor:
                  const Color(
                0xFFF0EEF7,
              ),
              valueColor:
                  const AlwaysStoppedAnimation<
                      Color>(
                primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap:
          onTap,
      child:
          Container(
        padding:
            const EdgeInsets.all(
          10,
        ),
        decoration:
            BoxDecoration(
          color:
              const Color(
            0xFFFAFAFD,
          ),
          borderRadius:
              BorderRadius.circular(
            13,
          ),
        ),
        child:
            Row(
          children: [
            Icon(
              icon,
              size:
                  16,
              color:
                  primary,
            ),

            const SizedBox(
                width:
                    7),

            Expanded(
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    label,
                    style:
                        const TextStyle(
                      color:
                          textSecondary,
                      fontSize:
                          7,
                    ),
                  ),
                  const SizedBox(
                      height:
                          3),
                  Text(
                    value,
                    maxLines:
                        1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      color:
                          textPrimary,
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
              Icons
                  .chevron_left_rounded,
              color:
                  textSecondary,
              size:
                  16,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ADD MEAL
  // ============================================================

  Widget _buildAddMealButton() {
    final enabled =
        _meals.length < 5;

    return SizedBox(
      width:
          double.infinity,
      height:
          50,
      child:
          OutlinedButton.icon(
        onPressed:
            enabled
                ? _addMeal
                : null,
        style:
            OutlinedButton.styleFrom(
          foregroundColor:
              primary,
          side:
              const BorderSide(
            color:
                Color(
              0xFFDCD6FA,
            ),
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),
        ),
        icon:
            const Icon(
          Icons.add_rounded,
        ),
        label:
            Text(
          enabled
              ? 'إضافة وجبة'
              : 'الحد الأقصى 5 وجبات',
          style:
              const TextStyle(
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // AUTO DISTRIBUTION
  // ============================================================

  Widget _buildAutoDistributionCard() {
    return Container(
      padding:
          const EdgeInsets.all(
        14,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFFF4F0FF,
        ),
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),
      child:
          Row(
        children: [
          Container(
            width:
                36,
            height:
                36,
            decoration:
                const BoxDecoration(
              color:
                  Colors.white,
              shape:
                  BoxShape.circle,
            ),
            child:
                const Icon(
              Icons
                  .auto_awesome_rounded,
              color:
                  primary,
              size:
                  18,
            ),
          ),

          const SizedBox(
              width:
                  9),

          const Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  'توزيع تلقائي',
                  style:
                      TextStyle(
                    color:
                        primary,
                    fontSize:
                        10,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                SizedBox(
                    height:
                        3),
                Text(
                  'يعيد توزيع السعرات حسب عدد الوجبات الحالي.',
                  style:
                      TextStyle(
                    color:
                        textSecondary,
                    fontSize:
                        7.8,
                  ),
                ),
              ],
            ),
          ),

          TextButton(
            onPressed:
                _autoDistribute,
            child:
                const Text(
              'تطبيق',
              style:
                  TextStyle(
                color:
                    primary,
                fontWeight:
                    FontWeight.w900,
                fontSize:
                    8.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUMMARY
  // ============================================================

  Widget _buildSummaryCard() {
    Color color;
    String title;
    String message;

    if (!_timesValid) {
      color =
          const Color(
        0xFFD27A1F,
      );
      title =
          'راجع أوقات الوجبات';
      message =
          'رتب الأوقات من الأسبق إلى الأحدث.';
    } else if (_caloriesBalanced) {
      color =
          const Color(
        0xFF2FA66A,
      );
      title =
          'كل شيء متوازن';
      message =
          'مجموع سعرات الوجبات يساوي هدفك اليومي.';
    } else if (_difference > 0) {
      color =
          primary;
      title =
          'هناك سعرات لم توزع';
      message =
          'بقي ${_difference.round()} سعرة لتصل إلى هدفك.';
    } else {
      color =
          const Color(
        0xFFD27A1F,
      );
      title =
          'التوزيع أعلى من الهدف';
      message =
          'تجاوزت هدفك بـ${_difference.abs().round()} سعرة.';
    }

    return Container(
      padding:
          const EdgeInsets.all(
        14,
      ),
      decoration:
          BoxDecoration(
        color:
            color.withValues(
          alpha:
              0.07,
        ),
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),
      child:
          Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            _isValid
                ? Icons.check_circle_outline_rounded
                : Icons.info_outline_rounded,
            color:
                color,
            size:
                19,
          ),
          const SizedBox(
              width:
                  8),
          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  title,
                  style:
                      TextStyle(
                    color:
                        color,
                    fontSize:
                        10,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(
                    height:
                        4),
                Text(
                  message,
                  style:
                      const TextStyle(
                    color:
                        textSecondary,
                    fontSize:
                        8.5,
                    height:
                        1.4,
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
  // BOTTOM
  // ============================================================

  Widget _buildBottomBar() {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        9,
        20,
        12,
      ),
      decoration:
          const BoxDecoration(
        color:
            Colors.white,
        boxShadow: [
          BoxShadow(
            color:
                Color(0x12000000),
            blurRadius:
                15,
            offset:
                Offset(
              0,
              -4,
            ),
          ),
        ],
      ),
      child:
          SafeArea(
        top:
            false,
        child:
            Row(
          children: [
            Expanded(
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    '${_dailyCalories.round()} kcal / يوم',
                    style:
                        const TextStyle(
                      fontSize:
                          10.5,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                      height:
                          2),
                  Text(
                    _isValid
                        ? 'التوزيع جاهز'
                        : 'أكمل التوزيع قبل الحفظ',
                    style:
                        const TextStyle(
                      color:
                          textSecondary,
                      fontSize:
                          7.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
                width:
                    10),

            SizedBox(
              height:
                  50,
              child:
                  FilledButton(
                onPressed:
                    _isValid
                        ? _save
                        : null,
                style:
                    FilledButton.styleFrom(
                  backgroundColor:
                      primary,
                  disabledBackgroundColor:
                      const Color(
                    0xFFDCD9ED,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
                child:
                    const Text(
                  'حفظ التوزيع',
                  style:
                      TextStyle(
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EDIT DAILY CALORIES
  // ============================================================

  Future<void> _editDailyCalories() async {
    final controller =
        TextEditingController(
      text:
          _dailyCalories.round().toString(),
    );

    final result =
        await showDialog<double>(
      context:
          context,
      builder:
          (
        context,
      ) {
        return AlertDialog(
          title:
              const Text(
            'تعديل السعرات اليومية',
          ),
          content:
              TextField(
            controller:
                controller,
            autofocus:
                true,
            keyboardType:
                const TextInputType
                    .numberWithOptions(
              decimal:
                  true,
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
                  () =>
                      Navigator.pop(
                context,
              ),
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
                  controller.text
                      .trim(),
                );

                Navigator.pop(
                  context,
                  value,
                );
              },
              child:
                  const Text(
                'تطبيق',
              ),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result == null ||
        result <= 0) {
      return;
    }

    setState(() {
      _dailyCalories =
          result;
    });
  }

  // ============================================================
  // EDIT MEAL CALORIES
  // ============================================================

  Future<void> _editMealCalories(
    int index,
  ) async {
    final controller =
        TextEditingController(
      text:
          _meals[index]
              .calories
              .round()
              .toString(),
    );

    final result =
        await showDialog<double>(
      context:
          context,
      builder:
          (
        context,
      ) {
        return AlertDialog(
          title:
              Text(
            'سعرات ${_meals[index].name}',
          ),
          content:
              TextField(
            controller:
                controller,
            autofocus:
                true,
            keyboardType:
                const TextInputType
                    .numberWithOptions(
              decimal:
                  true,
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
                  () =>
                      Navigator.pop(
                context,
              ),
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

                Navigator.pop(
                  context,
                  value,
                );
              },
              child:
                  const Text(
                'تطبيق',
              ),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result == null ||
        result <= 0) {
      return;
    }

    setState(() {
      _meals[index] =
          _meals[index].copyWith(
        calories:
            result,
      );
    });
  }

  // ============================================================
  // EDIT TIME
  // ============================================================

  Future<void> _editMealTime(
    int index,
  ) async {
    final current =
        _parseTime(
      _meals[index].time,
    );

    final picked =
        await showTimePicker(
      context:
          context,
      initialTime:
          current,
      helpText:
          'اختر وقت الوجبة',
      cancelText:
          'إلغاء',
      confirmText:
          'اختيار',
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _meals[index] =
          _meals[index].copyWith(
        time:
            _formatTime(
          picked,
        ),
      );
    });
  }

  // ============================================================
  // ADD MEAL
  // ============================================================

  void _addMeal() {
    if (_meals.length >= 5) {
      return;
    }

    final index =
        _meals.length;

    final defaults = [
      (
        'وجبة خفيفة',
        '05:00 م',
      ),
      (
        'وجبة خفيفة 2',
        '10:00 م',
      ),
    ];

    final defaultData =
        index - 3 <
                defaults.length
            ? defaults[index - 3]
            : (
                'وجبة ${index + 1}',
                '06:00 م',
              );

    setState(() {
      _meals.add(
        MealScheduleItem(
          name:
              defaultData.$1,
          time:
              defaultData.$2,
          calories:
              0,
        ),
      );
    });
  }

  void _removeMeal(
    int index,
  ) {
    if (_meals.length <= 2) {
      return;
    }

    setState(() {
      _meals.removeAt(
        index,
      );
    });
  }

  // ============================================================
  // AUTO DISTRIBUTION
  // ============================================================

  void _autoDistribute() {
    final ratios =
        _ratiosFor(
      _meals.length,
    );

    setState(() {
      for (int i = 0;
          i < _meals.length;
          i++) {
        _meals[i] =
            _meals[i].copyWith(
          calories:
              _dailyCalories *
                  ratios[i],
        );
      }
    });
  }

  List<double> _ratiosFor(
    int count,
  ) {
    switch (count) {
      case 2:
        return const [
          0.45,
          0.55,
        ];

      case 3:
        return const [
          0.25,
          0.40,
          0.35,
        ];

      case 4:
        return const [
          0.20,
          0.35,
          0.15,
          0.30,
        ];

      case 5:
        return const [
          0.18,
          0.27,
          0.10,
          0.28,
          0.17,
        ];

      default:
        return List<double>.filled(
          count,
          1 / count,
        );
    }
  }

  // ============================================================
  // SAVE
  // ============================================================

  void _save() {
    if (!_isValid) {
      _showSnack(
        'راجع السعرات والأوقات أولًا.',
      );
      return;
    }

    final profile =
        widget.profile.copyWith(
      dailyCalories:
          _dailyCalories,
      mealsPerDay:
          _meals.length,
      mealNames:
          _meals
              .map(
                (meal) =>
                    meal.name,
              )
              .toList(),
      mealTimes:
          _meals
              .map(
                (meal) =>
                    meal.time,
              )
              .toList(),
      mealSchedule:
          _meals
              .map(
                (meal) =>
                    meal.copyWith(),
              )
              .toList(),
    );

    Navigator.pop<
        UserGoalProfile>(
      context,
      profile,
    );
  }

  // ============================================================
  // DEFAULT DATA
  // ============================================================

  List<MealScheduleItem>
      _createDefaultMeals() {
    final names =
        widget.profile.mealNames;

    final times =
        widget.profile.mealTimes;

    final ratios =
        _ratiosFor(
      names.isEmpty
          ? 3
          : names.length,
    );

    final result =
        <MealScheduleItem>[];

    for (int i = 0;
        i < names.length;
        i++) {
      result.add(
        MealScheduleItem(
          name:
              names[i],
          time:
              i < times.length
                  ? times[i]
                  : '12:00 م',
          calories:
              _dailyCalories *
                  ratios[i],
        ),
      );
    }

    return result;
  }

  // ============================================================
  // TIME HELPERS
  // ============================================================

  TimeOfDay _parseTime(
    String value,
  ) {
    final normalized =
        value.trim();

    final isPm =
        normalized.endsWith('م');

    final clean =
        normalized
            .replaceAll(
              'ص',
              '',
            )
            .replaceAll(
              'م',
              '',
            )
            .trim();

    final parts =
        clean.split(':');

    if (parts.length != 2) {
      return const TimeOfDay(
        hour:
            8,
        minute:
            0,
      );
    }

    var hour =
        int.tryParse(
              parts[0],
            ) ??
            8;

    final minute =
        int.tryParse(
              parts[1],
            ) ??
            0;

    if (isPm && hour < 12) {
      hour += 12;
    }

    if (!isPm &&
        hour == 12) {
      hour = 0;
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

  int _toMinutes(
    String value,
  ) {
    final time =
        _parseTime(
      value,
    );

    return time.hour * 60 +
        time.minute;
  }

  String _formatTime(
    TimeOfDay time,
  ) {
    final hour =
        time.hourOfPeriod == 0
            ? 12
            : time.hourOfPeriod;

    final minute =
        time.minute
            .toString()
            .padLeft(
          2,
          '0',
        );

    final period =
        time.period ==
                DayPeriod.am
            ? 'ص'
            : 'م';

    return '$hour:$minute $period';
  }

  // ============================================================
  // ICON
  // ============================================================

  IconData _mealIcon(
    int index,
  ) {
    if (index == 0) {
      return Icons.wb_sunny_outlined;
    }

    if (index ==
        _meals.length - 1) {
      return Icons.dinner_dining_outlined;
    }

    return Icons.restaurant_outlined;
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showSnack(
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