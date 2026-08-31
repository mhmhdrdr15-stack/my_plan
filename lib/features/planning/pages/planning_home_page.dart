import 'package:flutter/material.dart';

import 'package:my_plan/core/state/app_state.dart';
import 'package:my_plan/core/state/controllers/planning_controller.dart';
import 'package:my_plan/features/planning/models/meal_template.dart';
import 'package:my_plan/features/planning/models/weekly_plan.dart';
import 'package:my_plan/features/planning/pages/meal_builder_page.dart';
import 'package:my_plan/features/planning/pages/meal_schedule_page.dart';

class PlanningHomePage extends StatefulWidget {
  const PlanningHomePage({
    super.key,
  });

  @override
  State<PlanningHomePage> createState() =>
      _PlanningHomePageState();
}

class _PlanningHomePageState
    extends State<PlanningHomePage> {
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

  @override
  Widget build(
    BuildContext context,
  ) {
    return AnimatedBuilder(
      animation: appState.planning,
      builder: (
        context,
        child,
      ) {
        final planning =
            appState.planning;

        return Scaffold(
          backgroundColor:
              background,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await planning.load();
              },
              child: ListView(
                physics:
                    const BouncingScrollPhysics(
                  parent:
                      AlwaysScrollableScrollPhysics(),
                ),
                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  35,
                ),
                children: [
                  _buildHeader(),
                  const SizedBox(
                    height: 18,
                  ),
                  _buildCaloriesCard(
                    planning,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildMealScheduleCard(
                    planning,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildMealOptionsSection(
                    planning,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildWeeklyPlanCard(
                    planning,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildInfoCard(),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildContinueButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'تخطيط وجباتك',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight:
                      FontWeight.w900,
                  color: text,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'أنشئ عدة خيارات لوجباتك ثم وزّعها على أيام الأسبوع.',
                style: TextStyle(
                  fontSize: 9.5,
                  color: secondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 8,
          ),
          decoration:
              BoxDecoration(
            color:
                const Color(0xFFF0ECFF),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: primary,
                size: 15,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                'Planning',
                style: TextStyle(
                  color: primary,
                  fontSize: 8,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DAILY TARGET
  // ============================================================

  Widget _buildCaloriesCard(
    dynamic planning,
  ) {
    final double calories =
        (planning.dailyCalories as num)
            .toDouble();

    final double protein =
        (planning.dailyProtein as num)
            .toDouble();

    final double carbs =
        (planning.dailyCarbs as num)
            .toDouble();

    final double fat =
        (planning.dailyFat as num)
            .toDouble();

    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration:
          BoxDecoration(
        borderRadius:
            BorderRadius.circular(25),
        gradient:
            const LinearGradient(
          begin:
              Alignment.topRight,
          end:
              Alignment.bottomLeft,
          colors: [
            Color(0xFF704EFF),
            Color(0xFF542FE8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color:
                primary.withValues(
              alpha: 0.16,
            ),
            blurRadius:
                24,
            offset:
                const Offset(0, 9),
          ),
        ],
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'هدفك اليومي',
            style:
                TextStyle(
              color:
                  Colors.white70,
              fontSize:
                  9,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                calories.round().toString(),
                style:
                    const TextStyle(
                  color:
                      Colors.white,
                  fontSize:
                      38,
                  height:
                      1,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              const Padding(
                padding:
                    EdgeInsets.only(
                  bottom: 2,
                ),
                child:
                    Text(
                  'kcal / يوم',
                  style:
                      TextStyle(
                    color:
                        Colors.white70,
                    fontSize:
                        9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 14,
          ),
          Row(
            children: [
              Expanded(
                child:
                    _macroStat(
                  '${protein.round()}g',
                  'Protein',
                ),
              ),
              Expanded(
                child:
                    _macroStat(
                  '${carbs.round()}g',
                  'Carbs',
                ),
              ),
              Expanded(
                child:
                    _macroStat(
                  '${fat.round()}g',
                  'Fat',
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 14,
          ),
          Container(
            width:
                double.infinity,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9,
            ),
            decoration:
                BoxDecoration(
              color:
                  Colors.white.withValues(
                alpha: 0.10,
              ),
              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),
            child:
                const Text(
              'السعرات المقترحة ليست إلزامية، ويمكن للمستخدم تعديل هدفه اليومي.',
              style:
                  TextStyle(
                color:
                    Colors.white70,
                fontSize:
                    8,
                height:
                    1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _macroStat(
    String value,
    String label,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style:
              const TextStyle(
            color:
                Colors.white,
            fontSize:
                14,
            fontWeight:
                FontWeight.w900,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          label,
          style:
              const TextStyle(
            color:
                Colors.white70,
            fontSize:
                7,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MEAL SCHEDULE
  // ============================================================

  Widget _buildMealScheduleCard(
    dynamic planning,
  ) {
    final List<MealScheduleConfig> schedule =
        List<MealScheduleConfig>.from(
      planning.mealSchedule
          as List<MealScheduleConfig>,
    );

    final double total =
        schedule.fold<double>(
      0.0,
      (
        double sum,
        MealScheduleConfig meal,
      ) {
        return sum + meal.calories;
      },
    );

    final double target =
        (planning.dailyCalories as num)
            .toDouble();

    final bool balanced =
        (total - target).abs() < 1;

    return _card(
      child:
          Padding(
        padding:
            const EdgeInsets.all(16),
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
                        'جدول الوجبات',
                        style:
                            TextStyle(
                          fontSize:
                              15,
                          fontWeight:
                              FontWeight.w900,
                          color:
                              text,
                        ),
                      ),
                      SizedBox(
                        height:
                            3,
                      ),
                      Text(
                        'الوقت والسعرات المخصصة لكل وجبة.',
                        style:
                            TextStyle(
                          color:
                              secondary,
                          fontSize:
                              8,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed:
                      _openMealSchedule,
                  child:
                      const Text(
                    'تعديل',
                    style:
                        TextStyle(
                      color:
                          primary,
                      fontSize:
                          9,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            if (schedule.isEmpty)
              Container(
                width:
                    double.infinity,
                padding:
                    const EdgeInsets.all(
                  14,
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
                    const Text(
                  'لم يتم إعداد جدول الوجبات بعد.',
                  style:
                      TextStyle(
                    color:
                        secondary,
                    fontSize:
                        8,
                  ),
                ),
              )
            else
              ...schedule.map(
                (
                  MealScheduleConfig meal,
                ) {
                  return _buildScheduleRow(
                    meal,
                  );
                },
              ),

            const SizedBox(
              height: 5,
            ),

            Container(
              width:
                  double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 9,
              ),
              decoration:
                  BoxDecoration(
                color:
                    balanced
                        ? const Color(
                            0xFFEEF9F3,
                          )
                        : const Color(
                            0xFFFFF4E8,
                          ),
                borderRadius:
                    BorderRadius.circular(
                  11,
                ),
              ),
              child:
                  Row(
                children: [
                  Icon(
                    balanced
                        ? Icons
                            .check_circle_outline_rounded
                        : Icons
                            .info_outline_rounded,
                    color:
                        balanced
                            ? const Color(
                                0xFF2FA66A,
                              )
                            : const Color(
                                0xFFD17A20,
                              ),
                    size:
                        16,
                  ),
                  const SizedBox(
                    width:
                        6,
                  ),
                  Expanded(
                    child:
                        Text(
                      balanced
                          ? 'مجموع الوجبات يطابق هدفك اليومي.'
                          : 'مجموع الوجبات ${total.round()} من ${target.round()} kcal.',
                      style:
                          TextStyle(
                        color:
                            balanced
                                ? const Color(
                                    0xFF2FA66A,
                                  )
                                : const Color(
                                    0xFFD17A20,
                                  ),
                        fontSize:
                            7.5,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleRow(
    MealScheduleConfig meal,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 8,
      ),
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
      ),
      child:
          Row(
        children: [
          Icon(
            _mealIcon(
              meal.name,
            ),
            color:
                primary,
            size:
                17,
          ),
          const SizedBox(
            width:
                8,
          ),
          Expanded(
            child:
                Text(
              meal.name,
              style:
                  const TextStyle(
                fontSize:
                    10,
                fontWeight:
                    FontWeight.w900,
                color:
                    text,
              ),
            ),
          ),
          Text(
            meal.time,
            style:
                const TextStyle(
              color:
                  secondary,
              fontSize:
                  8.5,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
          const SizedBox(
            width:
                10,
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal:
                  8,
              vertical:
                  5,
            ),
            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFFF0ECFF,
              ),
              borderRadius:
                  BorderRadius.circular(
                8,
              ),
            ),
            child:
                Text(
              '${meal.calories.round()} kcal',
              style:
                  const TextStyle(
                color:
                    primary,
                fontSize:
                    7.5,
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
  // OPEN MEAL SCHEDULE
  // ============================================================

  Future<void> _openMealSchedule() async {
    await Navigator.of(
      context,
    ).push(
      MaterialPageRoute<void>(
        builder:
            (_) =>
                const MealSchedulePage(),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ============================================================
  // MEAL OPTIONS
  // ============================================================

  Widget _buildMealOptionsSection(
    dynamic planning,
  ) {
    const List<String> mealTypes = [
      'الإفطار',
      'الغداء',
      'العشاء',
    ];

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'خيارات الوجبات',
          style:
              TextStyle(
            fontSize:
                17,
            fontWeight:
                FontWeight.w900,
            color:
                text,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        const Text(
          'أنشئ أكثر من خيار لكل وجبة حتى تتمكن من التنويع.',
          style:
              TextStyle(
            color:
                secondary,
            fontSize:
                8.5,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ...mealTypes.map(
          (
            mealType,
          ) {
            final List<MealTemplate> options =
                List<MealTemplate>.from(
              planning.templatesForMeal(
                mealType,
              ),
            );

            return _mealOptionCard(
              planning,
              mealType,
              options,
            );
          },
        ),
      ],
    );
  }

  Widget _mealOptionCard(
    dynamic planning,
    String mealType,
    List<MealTemplate> options,
  ) {
    final double target =
        (planning.caloriesForMeal(
              mealType,
            ) as num)
            .toDouble();

    return Container(
      margin:
          const EdgeInsets.only(
        bottom:
            10,
      ),
      padding:
          const EdgeInsets.all(14),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border:
            Border.all(
          color:
              border,
        ),
      ),
      child:
          Column(
        children: [
          Row(
            children: [
              Container(
                width:
                    42,
                height:
                    42,
                decoration:
                    const BoxDecoration(
                  color:
                      Color(0xFFF0ECFF),
                  shape:
                      BoxShape.circle,
                ),
                child:
                    Icon(
                  _mealIcon(
                    mealType,
                  ),
                  color:
                      primary,
                  size:
                      19,
                ),
              ),
              const SizedBox(
                width:
                    9,
              ),
              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealType,
                      style:
                          const TextStyle(
                        fontSize:
                            12.5,
                        fontWeight:
                            FontWeight.w900,
                        color:
                            text,
                      ),
                    ),
                    const SizedBox(
                      height:
                          3,
                    ),
                    Text(
                      'هدف الوجبة: ${target.round()} kcal',
                      style:
                          const TextStyle(
                        color:
                            secondary,
                        fontSize:
                            7.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal:
                      8,
                  vertical:
                      5,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      options.isEmpty
                          ? const Color(
                              0xFFFFF3E8,
                            )
                          : const Color(
                              0xFFEEF9F3,
                            ),
                  borderRadius:
                      BorderRadius.circular(
                    8,
                  ),
                ),
                child:
                    Text(
                  options.isEmpty
                      ? 'لا توجد خيارات'
                      : '${options.length} خيارات',
                  style:
                      TextStyle(
                    color:
                        options.isEmpty
                            ? const Color(
                                0xFFD17A20,
                              )
                            : const Color(
                                0xFF2FA66A,
                              ),
                    fontSize:
                        7,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height:
                9,
          ),

          if (options.isEmpty)
            _buildEmptyMealOption(
              target,
            )
          else
            ...options
                .take(5)
                .map(
                  (
                    option,
                  ) =>
                      _buildOptionRow(
                    option,
                    target,
                  ),
                ),

          const SizedBox(
            height:
                9,
          ),

          SizedBox(
            width:
                double.infinity,
            height:
                44,
            child:
                OutlinedButton.icon(
              onPressed:
                  () =>
                      _openMealBuilder(
                mealType,
                target,
              ),
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
                    13,
                  ),
                ),
              ),
              icon:
                  const Icon(
                Icons.add_rounded,
                size:
                    18,
              ),
              label:
                  Text(
                'إنشاء خيار $mealType جديد',
                style:
                    const TextStyle(
                  fontSize:
                      9,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OPEN BUILDER
  // ============================================================

  Future<void> _openMealBuilder(
    String mealType,
    double target,
  ) async {
    final String time =
        appState.planning.timeForMeal(
      mealType,
    );

    final MealTemplate? result =
        await Navigator.of(
      context,
    ).push<MealTemplate>(
      MaterialPageRoute<MealTemplate>(
        builder:
            (_) =>
                MealBuilderPage(
          mealType:
              mealType,
          mealTime:
              time,
          targetCalories:
              target,
        ),
      ),
    );

    if (!mounted ||
        result == null) {
      return;
    }

    await appState.planning
        .addTemplate(
      result,
    );

    if (!mounted) {
      return;
    }

    setState(() {});

    _showMessage(
      'تم حفظ ${result.name} بنجاح.',
    );
  }

  // ============================================================
  // EMPTY OPTION
  // ============================================================

  Widget _buildEmptyMealOption(
    double target,
  ) {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(11),
      decoration:
          BoxDecoration(
        color:
            const Color(0xFFFAFAFD),
        borderRadius:
            BorderRadius.circular(12),
      ),
      child:
          Row(
        children: [
          const Icon(
            Icons.restaurant_menu_outlined,
            color:
                secondary,
            size:
                17,
          ),
          const SizedBox(
            width:
                7,
          ),
          const Expanded(
            child:
                Text(
              'لم يتم إنشاء خيار لهذه الوجبة بعد.',
              style:
                  TextStyle(
                color:
                    secondary,
                fontSize:
                    8,
              ),
            ),
          ),
          Text(
            '${target.round()} kcal',
            style:
                const TextStyle(
              color:
                  primary,
              fontSize:
                  7.5,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // OPTION ROW
  // ============================================================

  Widget _buildOptionRow(
    MealTemplate option,
    double target,
  ) {
    final double difference =
        (option.calories -
                target)
            .abs();

    final bool close =
        difference <= 60;

    return Container(
      margin:
          const EdgeInsets.only(
        bottom:
            7,
      ),
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            9,
        vertical:
            8,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(0xFFFAFAFD),
        borderRadius:
            BorderRadius.circular(12),
      ),
      child:
          Row(
        children: [
          Container(
            width:
                32,
            height:
                32,
            decoration:
                const BoxDecoration(
              color:
                  Color(0xFFF0ECFF),
              shape:
                  BoxShape.circle,
            ),
            child:
                const Icon(
              Icons.restaurant_outlined,
              color:
                  primary,
              size:
                  16,
            ),
          ),
          const SizedBox(
            width:
                8,
          ),
          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  option.name,
                  maxLines:
                      1,
                  overflow:
                      TextOverflow.ellipsis,
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
                const SizedBox(
                  height:
                      2,
                ),
                Text(
                  '${option.protein.round()}g P • '
                  '${option.carbs.round()}g C • '
                  '${option.fat.round()}g F',
                  style:
                      const TextStyle(
                    color:
                        secondary,
                    fontSize:
                        7,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                '${option.calories.round()} kcal',
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
              const SizedBox(
                height:
                    2,
              ),
              Text(
                close
                    ? 'قريب من الهدف'
                    : '${difference.round()} kcal فرق',
                style:
                    TextStyle(
                  color:
                      close
                          ? const Color(
                              0xFF2FA66A,
                            )
                          : secondary,
                  fontSize:
                      6.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // WEEKLY PLAN
  // ============================================================

  Widget _buildWeeklyPlanCard(
    dynamic planning,
  ) {
    final WeeklyPlan plan =
        planning.weeklyPlan;

    final int assignedCount =
        plan.templates
            .where(
              (
                template,
              ) =>
                  template.assignedDays
                      .isNotEmpty,
            )
            .length;

    return _card(
      child:
          Padding(
        padding:
            const EdgeInsets.all(16),
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
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'خطة الأسبوع',
                        style:
                            TextStyle(
                          fontSize:
                              15,
                          fontWeight:
                              FontWeight.w900,
                          color:
                              text,
                        ),
                      ),
                      SizedBox(
                        height:
                            3,
                      ),
                      Text(
                        'بعد إنشاء الخيارات يمكنك توزيعها على أيام الأسبوع.',
                        style:
                            TextStyle(
                          color:
                              secondary,
                          fontSize:
                              8,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${plan.templates.length} قوالب',
                  style:
                      const TextStyle(
                    color:
                        primary,
                    fontSize:
                        8,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height:
                  12,
            ),

            Row(
              children: [
                Expanded(
                  child:
                      _weekStat(
                    '${plan.templates.length}',
                    'القوالب',
                  ),
                ),
                const SizedBox(
                  width:
                      8,
                ),
                Expanded(
                  child:
                      _weekStat(
                    '$assignedCount',
                    'الموزعة',
                  ),
                ),
                const SizedBox(
                  width:
                      8,
                ),
                Expanded(
                  child:
                      _weekStat(
                    '${plan.days.length}',
                    'أيام',
                  ),
                ),
              ],
            ),

            const SizedBox(
              height:
                  12,
            ),

            Container(
              width:
                  double.infinity,
              padding:
                  const EdgeInsets.all(
                11,
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
                  const Row(
                children: [
                  Icon(
                    Icons
                        .tips_and_updates_outlined,
                    color:
                        primary,
                    size:
                        18,
                  ),
                  SizedBox(
                    width:
                        7,
                  ),
                  Expanded(
                    child:
                        Text(
                      'أنشئ 2–3 خيارات لكل وجبة لتحصل على مرونة أكبر خلال الأسبوع.',
                      style:
                          TextStyle(
                        color:
                            secondary,
                        fontSize:
                            8,
                        height:
                            1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _weekStat(
    String value,
    String label,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical:
            10,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(0xFFF0ECFF),
        borderRadius:
            BorderRadius.circular(
          12,
        ),
      ),
      child:
          Column(
        children: [
          Text(
            value,
            style:
                const TextStyle(
              color:
                  primary,
              fontSize:
                  15,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
          const SizedBox(
            height:
                2,
          ),
          Text(
            label,
            style:
                const TextStyle(
              color:
                  secondary,
              fontSize:
                  7,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO
  // ============================================================

  Widget _buildInfoCard() {
    return Container(
      padding:
          const EdgeInsets.all(14),
      decoration:
          BoxDecoration(
        color:
            const Color(0xFFF4F0FF),
        borderRadius:
            BorderRadius.circular(18),
      ),
      child:
          const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color:
                primary,
            size:
                19,
          ),
          SizedBox(
            width:
                8,
          ),
          Expanded(
            child:
                Text(
              'السعرات التي يقترحها التطبيق قابلة للتعديل. المستخدم يحدد السعرات اليومية وأوقات الوجبات وسعرات كل وجبة.',
              style:
                  TextStyle(
                color:
                    secondary,
                fontSize:
                    8.5,
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
  // CONTINUE
  // ============================================================

  Widget _buildContinueButton() {
    final bool hasTemplates =
        appState.planning.templates.isNotEmpty;

    return SizedBox(
      width:
          double.infinity,
      height:
          54,
      child:
          FilledButton.icon(
        onPressed:
            hasTemplates
                ? () {
                    _showMessage(
                      'الخطوة التالية ستكون توزيع خيارات الوجبات على أيام الأسبوع.',
                    );
                  }
                : null,
        style:
            FilledButton.styleFrom(
          backgroundColor:
              primary,
          disabledBackgroundColor:
              const Color(
            0xFFD8D5E5,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(17),
          ),
        ),
        icon:
            const Icon(
          Icons.arrow_back_rounded,
        ),
        label:
            const Text(
          'متابعة إلى توزيع الأسبوع',
          style:
              TextStyle(
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CARD
  // ============================================================

  Widget _card({
    required Widget child,
  }) {
    return Container(
      width:
          double.infinity,
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(21),
        border:
            Border.all(
          color:
              border,
        ),
        boxShadow:
            const [
          BoxShadow(
            color:
                Color(0x08000000),
            blurRadius:
                14,
            offset:
                Offset(0, 5),
          ),
        ],
      ),
      child:
          child,
    );
  }

  // ============================================================
  // ICON
  // ============================================================

  IconData _mealIcon(
    String type,
  ) {
    if (type.contains(
      'إفطار',
    )) {
      return Icons
          .wb_sunny_outlined;
    }

    if (type.contains(
      'غداء',
    )) {
      return Icons
          .restaurant_outlined;
    }

    if (type.contains(
      'عشاء',
    )) {
      return Icons
          .dinner_dining_outlined;
    }

    return Icons
        .restaurant_menu_outlined;
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