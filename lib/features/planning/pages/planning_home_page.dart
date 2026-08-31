import 'package:flutter/material.dart';
<<<<<<< HEAD

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
=======
import 'package:my_plan/data/shared/models/meal_template.dart';
import 'package:my_plan/data/shared/models/user_goal_profile.dart';
import 'package:my_plan/data/shared/models/weekly_plan.dart';

import 'package:my_plan/features/planning/pages/meal_options_screen.dart';
import 'package:my_plan/features/planning/pages/week_board_screen.dart';

class PlanningHomeScreen extends StatefulWidget {
  final UserGoalProfile goalProfile;

  const PlanningHomeScreen({super.key, required this.goalProfile});

  @override
  State<PlanningHomeScreen> createState() => _PlanningHomeScreenState();
}

class _PlanningHomeScreenState extends State<PlanningHomeScreen> {
  static const Color primary = Color(0xFF5B35F5);

  static const Color background = Color(0xFFF7F7FB);

  static const Color textPrimary = Color(0xFF18182B);

  static const Color textSecondary = Color(0xFF85899D);

  static const Color borderColor = Color(0xFFE7E7EF);

  late WeeklyPlan plan;

  @override
  void initState() {
    super.initState();

    plan = _createInitialPlan();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
            children: [
              _buildHeader(),

              const SizedBox(height: 22),

              _buildGoalCard(),

              const SizedBox(height: 25),

              _buildMealsHeader(),

              const SizedBox(height: 11),

              ...plan.mealTypes.map((mealType) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildMealCard(mealType),
                );
              }),

              const SizedBox(height: 13),

              _buildWeekBoardCard(),

              const SizedBox(height: 12),

              _buildPlanningHint(),
            ],
          ),
        ),
      ),
>>>>>>> aa293c52c23f1846dac6deae987702c1a4c00379
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
<<<<<<< HEAD
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
=======
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'بناء أسبوعك',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w900,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'أنشئ خيارات وجباتك أولًا، ثم سنساعدك في توزيعها على الأسبوع.',
          style: TextStyle(color: textSecondary, fontSize: 11, height: 1.5),
>>>>>>> aa293c52c23f1846dac6deae987702c1a4c00379
        ),
      ],
    );
  }

  // ============================================================
<<<<<<< HEAD
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
=======
  // GOAL CARD
  // ============================================================

  Widget _buildGoalCard() {
    final profile = widget.goalProfile;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0ECFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flag_rounded, color: primary, size: 21),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'هدفك اليومي',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      profile.goalTitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              TextButton(
                onPressed: _showGoalSummary,
                style: TextButton.styleFrom(
                  foregroundColor: primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: const Text(
                  'التفاصيل',
                  style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                profile.dailyCalories.round().toString(),
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: textPrimary,
                  height: 1,
                ),
              ),
              const SizedBox(width: 7),
              const Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Text(
                  'سعرة / يوم',
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
>>>>>>> aa293c52c23f1846dac6deae987702c1a4c00379
                  ),
                ),
              ),
            ],
          ),
<<<<<<< HEAD
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
=======

          const SizedBox(height: 13),

          Row(
            children: [
              _macroSummary(
                value: '${profile.proteinTarget.round()}غ',
                label: 'بروتين',
              ),
              const SizedBox(width: 7),
              _macroSummary(
                value: '${profile.carbsTarget.round()}غ',
                label: 'كارب',
              ),
              const SizedBox(width: 7),
              _macroSummary(
                value: '${profile.fatTarget.round()}غ',
                label: 'دهون',
              ),
            ],
          ),

          const SizedBox(height: 13),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F7FC),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.restaurant_menu_rounded,
                  size: 16,
                  color: primary,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    '${profile.mealsPerDay} وجبات يوميًا • ${profile.mealTimes.join(' • ')}',
                    style: const TextStyle(
                      color: textSecondary,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
>>>>>>> aa293c52c23f1846dac6deae987702c1a4c00379
                    ),
                  ),
                ),
              ],
            ),
<<<<<<< HEAD

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
=======
          ),
        ],
      ),
    );
  }

  Widget _macroSummary({required String value, required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F7FC),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(color: textSecondary, fontSize: 7.5),
>>>>>>> aa293c52c23f1846dac6deae987702c1a4c00379
            ),
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
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
=======
  // ============================================================
  // MEALS HEADER
  // ============================================================

  Widget _buildMealsHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'وجباتك',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: textPrimary,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'أنشئ خيارات متعددة ثم استخدمها لبناء أسبوع متنوع.',
                style: TextStyle(color: textSecondary, fontSize: 8.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MEAL CARD
  // ============================================================

  Widget _buildMealCard(String mealType) {
    final templates = _templatesForMeal(mealType);

    final target = _mealTarget(mealType);

    final time = _mealTime(mealType);

    final hasOptions = templates.isNotEmpty;

    final favorites = templates.where((template) => template.isFavorite);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: () => _openMealOptions(mealType),
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _mealIcon(mealType),

                  const SizedBox(width: 11),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mealType,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasOptions
                              ? '${templates.length} ${templates.length == 1 ? 'خيار' : 'خيارات'} جاهزة'
                              : 'لم تنشئ خيارات بعد',
                          style: const TextStyle(
                            color: textSecondary,
                            fontSize: 8.8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F7FC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      time,
                      style: const TextStyle(
                        color: textSecondary,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  const SizedBox(width: 5),

                  const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 13,
                    color: Color(0xFF9A9CAB),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'هدف الوجبة',
                          style: TextStyle(color: textSecondary, fontSize: 7.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${target.round()} سعرة تقريبًا',
                          style: const TextStyle(
                            color: textPrimary,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (favorites.isNotEmpty)
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFB52E),
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${favorites.length} مفضل',
                          style: const TextStyle(
                            color: textSecondary,
                            fontSize: 7.5,
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 11),

              if (hasOptions)
                _buildOptionPreview(templates)
              else
                _buildEmptyMealPrompt(mealType),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mealIcon(String mealType) {
    IconData icon;

    switch (mealType) {
      case 'الإفطار':
        icon = Icons.wb_sunny_outlined;
        break;

      case 'الغداء':
        icon = Icons.restaurant_outlined;
        break;

      case 'العشاء':
        icon = Icons.dinner_dining_outlined;
        break;

      case 'وجبة خفيفة':
        icon = Icons.local_cafe_outlined;
        break;

      default:
        icon = Icons.restaurant_rounded;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0xFFF0ECFF),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: primary, size: 22),
    );
  }

  Widget _buildOptionPreview(List<MealTemplate> templates) {
    final preview = templates.take(3).toList();

    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: preview.map((template) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F7FC),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  template.name,
                  style: const TextStyle(
                    color: Color(0xFF65687A),
                    fontSize: 7.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        if (templates.length > 3)
          Text(
            '+${templates.length - 3}',
            style: const TextStyle(
              color: primary,
              fontSize: 8,
              fontWeight: FontWeight.w900,
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyMealPrompt(String mealType) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFD),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.add_circle_outline_rounded,
            color: primary,
            size: 18,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              'أنشئ أول $mealType واستخدمه أكثر من مرة خلال الأسبوع.',
              style: const TextStyle(color: textSecondary, fontSize: 8),
>>>>>>> aa293c52c23f1846dac6deae987702c1a4c00379
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
<<<<<<< HEAD
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
=======
  // WEEK BOARD
  // ============================================================

  Widget _buildWeekBoardCard() {
    final totalOptions = plan.templates.length;

    final hasEnoughToPlan = totalOptions > 0;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: _openWeekBoard,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 49,
                height: 49,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0ECFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: primary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'لوحة الأسبوع',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasEnoughToPlan
                          ? '$totalOptions خيارات جاهزة للتوزيع على أيام الأسبوع'
                          : 'أنشئ خيارات وجباتك أولًا ثم ابنِ أسبوعك',
                      style: const TextStyle(
                        color: textSecondary,
                        fontSize: 8.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14,
                color: Color(0xFF9A9CAB),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanningHint() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F0FF),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_outlined, color: primary, size: 18),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'فكرة Calory بسيطة: أنشئ الوجبة مرة، ويمكنك استخدامها عدة مرات أو إنشاء بدائل لها. بعد ذلك سنساعدك على توزيعها بطريقة مناسبة لأسبوعك.',
              style: TextStyle(
                color: Color(0xFF696B7D),
                fontSize: 8.5,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
>>>>>>> aa293c52c23f1846dac6deae987702c1a4c00379
  }

  // ============================================================
  // MEAL OPTIONS
  // ============================================================

<<<<<<< HEAD
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
=======
  Future<void> _openMealOptions(String mealType) async {
    final templates = _templatesForMeal(mealType);

    final result = await Navigator.push<List<MealTemplate>>(
      context,
      MaterialPageRoute(
        builder: (_) => MealOptionsScreen(
          mealType: mealType,
          time: _mealTime(mealType),
          plan: plan,
          goalProfile: widget.goalProfile,
          templates: templates,
>>>>>>> aa293c52c23f1846dac6deae987702c1a4c00379
        ),
      ),
    );

<<<<<<< HEAD
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
=======
    if (!mounted || result == null) {
      return;
    }

    _replaceTemplatesForMeal(mealType, result);
  }

  List<MealTemplate> _templatesForMeal(String mealType) {
    return plan.templates
        .where((template) => template.mealType == mealType)
        .toList();
  }

  void _replaceTemplatesForMeal(
    String mealType,
    List<MealTemplate> updatedTemplates,
  ) {
    plan.templates.removeWhere((template) => template.mealType == mealType);

    plan.templates.addAll(updatedTemplates);

    setState(() {});
  }

  // ============================================================
  // WEEK BOARD
  // ============================================================

  Future<void> _openWeekBoard() async {
    if (plan.templates.isEmpty) {
      _showMessage('أنشئ خيار وجبة واحدًا على الأقل قبل بناء الأسبوع.');
      return;
    }

    final updatedPlan = await Navigator.push<WeeklyPlan>(
      context,
      MaterialPageRoute(builder: (_) => WeekBoardScreen(initialPlan: plan)),
    );

    if (!mounted || updatedPlan == null) {
      return;
    }

    setState(() {
      plan = updatedPlan;
    });
  }

  // ============================================================
  // TARGET
  // ============================================================

  double _mealTarget(String mealType) {
    final daily = widget.goalProfile.dailyCalories;

    final count = widget.goalProfile.mealsPerDay;

    if (count <= 0) {
      return daily;
    }

    if (count == 2) {
      return daily * 0.5;
    }

    if (count == 3) {
      switch (mealType) {
        case 'الإفطار':
          return daily * 0.25;

        case 'الغداء':
          return daily * 0.40;

        case 'العشاء':
          return daily * 0.35;

        default:
          return daily / count;
      }
    }

    if (count == 4) {
      switch (mealType) {
        case 'الإفطار':
          return daily * 0.25;

        case 'الغداء':
          return daily * 0.35;

        case 'العشاء':
          return daily * 0.25;

        default:
          return daily * 0.15;
      }
    }

    if (count == 5) {
      switch (mealType) {
        case 'الإفطار':
          return daily * 0.20;

        case 'الغداء':
          return daily * 0.30;

        case 'العشاء':
          return daily * 0.28;

        default:
          return daily * 0.11;
      }
    }

    return daily / count;
  }

  String _mealTime(String mealType) {
    final index = plan.mealTypes.indexOf(mealType);

    if (index >= 0 && index < widget.goalProfile.mealTimes.length) {
      return widget.goalProfile.mealTimes[index];
    }

    switch (mealType) {
      case 'الإفطار':
        return '08:00 ص';

      case 'الغداء':
        return '02:00 م';

      case 'العشاء':
        return '08:00 م';

      case 'وجبة خفيفة':
        return '05:00 م';

      default:
        return '12:00 م';
    }
  }

  // ============================================================
  // GOAL DETAILS
  // ============================================================

  void _showGoalSummary() {
    final profile = widget.goalProfile;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 25),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E2E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'هدفك الغذائي',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 15),
                _goalDetailRow('الهدف', profile.goalTitle),
                _goalDetailRow(
                  'السعرات',
                  '${profile.dailyCalories.round()} سعرة / يوم',
                ),
                _goalDetailRow('البروتين', '${profile.proteinTarget.round()}غ'),
                _goalDetailRow(
                  'الكربوهيدرات',
                  '${profile.carbsTarget.round()}غ',
                ),
                _goalDetailRow('الدهون', '${profile.fatTarget.round()}غ'),
                _goalDetailRow('الوجبات', '${profile.mealsPerDay} يوميًا'),
                _goalDetailRow('النشاط', profile.activityTitle),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _goalDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: textSecondary, fontSize: 9),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
>>>>>>> aa293c52c23f1846dac6deae987702c1a4c00379
          ),
        ],
      ),
    );
  }

  // ============================================================
<<<<<<< HEAD
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
=======
  // INITIAL PLAN
  // ============================================================

  WeeklyPlan _createInitialPlan() {
    return WeeklyPlan(
      days: const [
        'الاثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد',
      ],
      mealTypes: List<String>.from(widget.goalProfile.mealNames),
      templates: <MealTemplate>[],
      assignments: const [],
>>>>>>> aa293c52c23f1846dac6deae987702c1a4c00379
    );
  }

  // ============================================================
<<<<<<< HEAD
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
=======
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(behavior: SnackBarBehavior.floating, content: Text(message)),
      );
  }
}
>>>>>>> aa293c52c23f1846dac6deae987702c1a4c00379
