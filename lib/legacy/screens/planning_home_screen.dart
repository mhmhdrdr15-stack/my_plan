import 'package:flutter/material.dart';

import '../models/meal_template.dart';
import '../models/user_goal_profile.dart';
import '../models/weekly_plan.dart';

import 'meal_options_screen.dart';
import 'week_board_screen.dart';

class PlanningHomeScreen extends StatefulWidget {
  final UserGoalProfile goalProfile;

  const PlanningHomeScreen({
    super.key,
    required this.goalProfile,
  });

  @override
  State<PlanningHomeScreen> createState() =>
      _PlanningHomeScreenState();
}

class _PlanningHomeScreenState
    extends State<PlanningHomeScreen> {
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

  late WeeklyPlan plan;

  @override
  void initState() {
    super.initState();

    plan = _createInitialPlan();
  }

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
          child: ListView(
            physics:
                const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              32,
            ),
            children: [
              _buildHeader(),

              const SizedBox(
                height: 22,
              ),

              _buildGoalCard(),

              const SizedBox(
                height: 25,
              ),

              _buildMealsHeader(),

              const SizedBox(
                height: 11,
              ),

              ...plan.mealTypes.map(
                (
                  mealType,
                ) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child:
                        _buildMealCard(
                      mealType,
                    ),
                  );
                },
              ),

              const SizedBox(
                height: 13,
              ),

              _buildWeekBoardCard(),

              const SizedBox(
                height: 12,
              ),

              _buildPlanningHint(),
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
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'بناء أسبوعك',
          style: TextStyle(
            fontSize: 27,
            fontWeight:
                FontWeight.w900,
            color:
                textPrimary,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          'أنشئ خيارات وجباتك أولًا، ثم سنساعدك في توزيعها على الأسبوع.',
          style: TextStyle(
            color:
                textSecondary,
            fontSize: 11,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // GOAL CARD
  // ============================================================

  Widget _buildGoalCard() {
    final profile =
        widget.goalProfile;

    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          25,
        ),
        border:
            Border.all(
          color:
              borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha:
                  0.025,
            ),
            blurRadius:
                18,
            offset:
                const Offset(
              0,
              5,
            ),
          ),
        ],
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width:
                    44,
                height:
                    44,
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
                    const Icon(
                  Icons
                      .flag_rounded,
                  color:
                      primary,
                  size:
                      21,
                ),
              ),

              const SizedBox(
                width:
                    10,
              ),

              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const Text(
                      'هدفك اليومي',
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
                    const SizedBox(
                      height:
                          3,
                    ),
                    Text(
                      profile.goalTitle,
                      style:
                          const TextStyle(
                        fontSize:
                            13,
                        fontWeight:
                            FontWeight.w900,
                        color:
                            textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              TextButton(
                onPressed:
                    _showGoalSummary,
                style:
                    TextButton.styleFrom(
                  foregroundColor:
                      primary,
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal:
                        8,
                  ),
                ),
                child:
                    const Text(
                  'التفاصيل',
                  style:
                      TextStyle(
                    fontSize:
                        8.5,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height:
                17,
          ),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                profile.dailyCalories
                    .round()
                    .toString(),
                style:
                    const TextStyle(
                  fontSize:
                      34,
                  fontWeight:
                      FontWeight.w900,
                  color:
                      textPrimary,
                  height:
                      1,
                ),
              ),
              const SizedBox(
                width:
                    7,
              ),
              const Padding(
                padding:
                    EdgeInsets.only(
                  bottom:
                      2,
                ),
                child:
                    Text(
                  'سعرة / يوم',
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
                13,
          ),

          Row(
            children: [
              _macroSummary(
                value:
                    '${profile.proteinTarget.round()}غ',
                label:
                    'بروتين',
              ),
              const SizedBox(
                width:
                    7,
              ),
              _macroSummary(
                value:
                    '${profile.carbsTarget.round()}غ',
                label:
                    'كارب',
              ),
              const SizedBox(
                width:
                    7,
              ),
              _macroSummary(
                value:
                    '${profile.fatTarget.round()}غ',
                label:
                    'دهون',
              ),
            ],
          ),

          const SizedBox(
            height:
                13,
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal:
                  11,
              vertical:
                  9,
            ),
            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFFF8F7FC,
              ),
              borderRadius:
                  BorderRadius.circular(
                13,
              ),
            ),
            child:
                Row(
              children: [
                const Icon(
                  Icons
                      .restaurant_menu_rounded,
                  size:
                      16,
                  color:
                      primary,
                ),
                const SizedBox(
                  width:
                      7,
                ),
                Expanded(
                  child:
                      Text(
                    '${profile.mealsPerDay} وجبات يوميًا • ${profile.mealTimes.join(' • ')}',
                    style:
                        const TextStyle(
                      color:
                          textSecondary,
                      fontSize:
                          8,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _macroSummary({
    required String value,
    required String label,
  }) {
    return Expanded(
      child:
          Container(
        padding:
            const EdgeInsets.symmetric(
          vertical:
              9,
        ),
        decoration:
            BoxDecoration(
          color:
              const Color(
            0xFFF8F7FC,
          ),
          borderRadius:
              BorderRadius.circular(
            13,
          ),
        ),
        child:
            Column(
          children: [
            Text(
              value,
              style:
                  const TextStyle(
                fontSize:
                    12,
                fontWeight:
                    FontWeight.w900,
                color:
                    textPrimary,
              ),
            ),
            const SizedBox(
              height:
                  3,
            ),
            Text(
              label,
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
    );
  }

  // ============================================================
  // MEALS HEADER
  // ============================================================

  Widget _buildMealsHeader() {
    return Row(
      children: [
        const Expanded(
          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'وجباتك',
                style:
                    TextStyle(
                  fontSize:
                      18,
                  fontWeight:
                      FontWeight.w900,
                  color:
                      textPrimary,
                ),
              ),
              SizedBox(
                height:
                    3,
              ),
              Text(
                'أنشئ خيارات متعددة ثم استخدمها لبناء أسبوع متنوع.',
                style:
                    TextStyle(
                  color:
                      textSecondary,
                  fontSize:
                      8.5,
                ),
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

  Widget _buildMealCard(
    String mealType,
  ) {
    final templates =
        _templatesForMeal(
      mealType,
    );

    final target =
        _mealTarget(
      mealType,
    );

    final time =
        _mealTime(
      mealType,
    );

    final hasOptions =
        templates.isNotEmpty;

    final favorites =
        templates.where(
      (
        template,
      ) =>
          template.isFavorite,
    );

    return Material(
      color:
          Colors.white,
      borderRadius:
          BorderRadius.circular(
        22,
      ),
      child:
          InkWell(
        onTap:
            () =>
                _openMealOptions(
          mealType,
        ),
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        child:
            Container(
          padding:
              const EdgeInsets.all(
            15,
          ),
          decoration:
              BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              22,
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
                  _mealIcon(
                    mealType,
                  ),

                  const SizedBox(
                    width:
                        11,
                  ),

                  Expanded(
                    child:
                        Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          mealType,
                          style:
                              const TextStyle(
                            fontSize:
                                14,
                            fontWeight:
                                FontWeight.w900,
                            color:
                                textPrimary,
                          ),
                        ),
                        const SizedBox(
                          height:
                              4,
                        ),
                        Text(
                          hasOptions
                              ? '${templates.length} ${templates.length == 1 ? 'خيار' : 'خيارات'} جاهزة'
                              : 'لم تنشئ خيارات بعد',
                          style:
                              const TextStyle(
                            color:
                                textSecondary,
                            fontSize:
                                8.8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal:
                          9,
                      vertical:
                          6,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFF8F7FC,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                    child:
                        Text(
                      time,
                          style:
                              const TextStyle(
                        color:
                            textSecondary,
                        fontSize:
                            8,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width:
                        5,
                  ),

                  const Icon(
                    Icons
                        .arrow_back_ios_new_rounded,
                    size:
                        13,
                    color:
                        Color(
                      0xFF9A9CAB,
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
                        Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        const Text(
                          'هدف الوجبة',
                          style:
                              TextStyle(
                            color:
                                textSecondary,
                            fontSize:
                                7.5,
                          ),
                        ),
                        const SizedBox(
                          height:
                              2,
                        ),
                        Text(
                          '${target.round()} سعرة تقريبًا',
                          style:
                              const TextStyle(
                            color:
                                textPrimary,
                            fontSize:
                                9,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (favorites.isNotEmpty)
                    Row(
                      children: [
                        const Icon(
                          Icons
                              .star_rounded,
                          color:
                              Color(
                            0xFFFFB52E,
                          ),
                          size:
                              14,
                        ),
                        const SizedBox(
                          width:
                              3,
                        ),
                        Text(
                          '${favorites.length} مفضل',
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
                ],
              ),

              const SizedBox(
                height:
                    11,
              ),

              if (hasOptions)
                _buildOptionPreview(
                  templates,
                )
              else
                _buildEmptyMealPrompt(
                  mealType,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mealIcon(
    String mealType,
  ) {
    IconData icon;

    switch (mealType) {
      case 'الإفطار':
        icon =
            Icons.wb_sunny_outlined;
        break;

      case 'الغداء':
        icon =
            Icons.restaurant_outlined;
        break;

      case 'العشاء':
        icon =
            Icons.dinner_dining_outlined;
        break;

      case 'وجبة خفيفة':
        icon =
            Icons.local_cafe_outlined;
        break;

      default:
        icon =
            Icons.restaurant_rounded;
    }

    return Container(
      width:
          48,
      height:
          48,
      decoration:
          const BoxDecoration(
        color:
            Color(0xFFF0ECFF),
        shape:
            BoxShape.circle,
      ),
      child:
          Icon(
        icon,
        color:
            primary,
        size:
            22,
      ),
    );
  }

  Widget _buildOptionPreview(
    List<MealTemplate> templates,
  ) {
    final preview =
        templates.take(3).toList();

    return Row(
      children: [
        Expanded(
          child:
              Wrap(
            spacing:
                5,
            runSpacing:
                5,
            children:
                preview.map(
              (
                template,
              ) {
                return Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal:
                        8,
                    vertical:
                        6,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFFF8F7FC,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      9,
                    ),
                  ),
                  child:
                      Text(
                    template.name,
                    style:
                        const TextStyle(
                      color:
                          Color(
                        0xFF65687A,
                      ),
                      fontSize:
                          7.5,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),

        if (templates.length > 3)
          Text(
            '+${templates.length - 3}',
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
    );
  }

  Widget _buildEmptyMealPrompt(
    String mealType,
  ) {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            12,
        vertical:
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
          const Icon(
            Icons.add_circle_outline_rounded,
            color:
                primary,
            size:
                18,
          ),
          const SizedBox(
            width:
                7,
          ),
          Expanded(
            child:
                Text(
              'أنشئ أول $mealType واستخدمه أكثر من مرة خلال الأسبوع.',
              style:
                  const TextStyle(
                color:
                    textSecondary,
                fontSize:
                    8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // WEEK BOARD
  // ============================================================

  Widget _buildWeekBoardCard() {
    final totalOptions =
        plan.templates.length;

    final hasEnoughToPlan =
        totalOptions > 0;

    return Material(
      color:
          Colors.white,
      borderRadius:
          BorderRadius.circular(
        22,
      ),
      child:
          InkWell(
        onTap:
            _openWeekBoard,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        child:
            Container(
          padding:
              const EdgeInsets.all(
            16,
          ),
          decoration:
              BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              22,
            ),
            border:
                Border.all(
              color:
                  borderColor,
            ),
          ),
          child:
              Row(
            children: [
              Container(
                width:
                    49,
                height:
                    49,
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
                    const Icon(
                  Icons
                      .calendar_month_rounded,
                  color:
                      primary,
                  size:
                      22,
                ),
              ),

              const SizedBox(
                  width:
                      11),

              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const Text(
                      'لوحة الأسبوع',
                      style:
                          TextStyle(
                        fontSize:
                            14,
                        fontWeight:
                            FontWeight.w900,
                        color:
                            textPrimary,
                      ),
                    ),
                    const SizedBox(
                        height:
                            4),
                    Text(
                      hasEnoughToPlan
                          ? '$totalOptions خيارات جاهزة للتوزيع على أيام الأسبوع'
                          : 'أنشئ خيارات وجباتك أولًا ثم ابنِ أسبوعك',
                      style:
                          const TextStyle(
                        color:
                            textSecondary,
                        fontSize:
                            8.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons
                    .arrow_back_ios_new_rounded,
                size:
                    14,
                color:
                    Color(
                  0xFF9A9CAB,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanningHint() {
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
          17,
        ),
      ),
      child:
          Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          const Icon(
            Icons.auto_awesome_outlined,
            color:
                primary,
            size:
                18,
          ),
          const SizedBox(
              width:
                  8),
          const Expanded(
            child:
                Text(
              'فكرة Calory بسيطة: أنشئ الوجبة مرة، ويمكنك استخدامها عدة مرات أو إنشاء بدائل لها. بعد ذلك سنساعدك على توزيعها بطريقة مناسبة لأسبوعك.',
              style:
                  TextStyle(
                color:
                    Color(
                  0xFF696B7D,
                ),
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
  // MEAL OPTIONS
  // ============================================================

  Future<void> _openMealOptions(
    String mealType,
  ) async {
    final templates =
        _templatesForMeal(
      mealType,
    );

    final result =
        await Navigator.push<
            List<MealTemplate>>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            MealOptionsScreen(
          mealType:
              mealType,
          time:
              _mealTime(
            mealType,
          ),
          plan:
              plan,
          goalProfile:
              widget.goalProfile,
          templates:
              templates,
        ),
      ),
    );

    if (!mounted ||
        result == null) {
      return;
    }

    _replaceTemplatesForMeal(
      mealType,
      result,
    );
  }

  List<MealTemplate>
      _templatesForMeal(
    String mealType,
  ) {
    return plan.templates
        .where(
          (
            template,
          ) =>
              template.mealType ==
              mealType,
        )
        .toList();
  }

  void _replaceTemplatesForMeal(
    String mealType,
    List<MealTemplate>
        updatedTemplates,
  ) {
    plan.templates.removeWhere(
      (
        template,
      ) =>
          template.mealType ==
          mealType,
    );

    plan.templates.addAll(
      updatedTemplates,
    );

    setState(() {});
  }

  // ============================================================
  // WEEK BOARD
  // ============================================================

  Future<void> _openWeekBoard() async {
    if (plan.templates.isEmpty) {
      _showMessage(
        'أنشئ خيار وجبة واحدًا على الأقل قبل بناء الأسبوع.',
      );
      return;
    }

    final updatedPlan =
        await Navigator.push<WeeklyPlan>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            WeekBoardScreen(
          initialPlan:
              plan,
        ),
      ),
    );

    if (!mounted ||
        updatedPlan == null) {
      return;
    }

    setState(() {
      plan =
          updatedPlan;
    });
  }

  // ============================================================
  // TARGET
  // ============================================================

  double _mealTarget(
    String mealType,
  ) {
    final daily =
        widget.goalProfile.dailyCalories;

    final count =
        widget.goalProfile.mealsPerDay;

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

  String _mealTime(
    String mealType,
  ) {
    final index =
        plan.mealTypes.indexOf(
      mealType,
    );

    if (index >= 0 &&
        index <
            widget.goalProfile
                .mealTimes.length) {
      return widget.goalProfile
          .mealTimes[index];
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
    final profile =
        widget.goalProfile;

    showModalBottomSheet(
      context:
          context,
      backgroundColor:
          Colors.transparent,
      builder:
          (_) {
        return Container(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            14,
            20,
            25,
          ),
          decoration:
              const BoxDecoration(
            color:
                Colors.white,
            borderRadius:
                BorderRadius.vertical(
              top:
                  Radius.circular(
                30,
              ),
            ),
          ),
          child:
              SafeArea(
            top:
                false,
            child:
                Column(
              mainAxisSize:
                  MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Center(
                  child:
                      Container(
                    width:
                        42,
                    height:
                        4,
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFE2E2E9,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    height:
                        15),
                const Text(
                  'هدفك الغذائي',
                  style:
                      TextStyle(
                    fontSize:
                        19,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(
                    height:
                        15),
                _goalDetailRow(
                  'الهدف',
                  profile.goalTitle,
                ),
                _goalDetailRow(
                  'السعرات',
                  '${profile.dailyCalories.round()} سعرة / يوم',
                ),
                _goalDetailRow(
                  'البروتين',
                  '${profile.proteinTarget.round()}غ',
                ),
                _goalDetailRow(
                  'الكربوهيدرات',
                  '${profile.carbsTarget.round()}غ',
                ),
                _goalDetailRow(
                  'الدهون',
                  '${profile.fatTarget.round()}غ',
                ),
                _goalDetailRow(
                  'الوجبات',
                  '${profile.mealsPerDay} يوميًا',
                ),
                _goalDetailRow(
                  'النشاط',
                  profile.activityTitle,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _goalDetailRow(
    String label,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom:
            10,
      ),
      child:
          Row(
        children: [
          Expanded(
            child:
                Text(
              label,
              style:
                  const TextStyle(
                color:
                    textSecondary,
                fontSize:
                    9,
              ),
            ),
          ),
          Text(
            value,
            style:
                const TextStyle(
              fontSize:
                  10,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
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
      mealTypes:
          List<String>.from(
        widget.goalProfile.mealNames,
      ),
      templates:
          <MealTemplate>[],
      assignments:
          const [],
    );
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