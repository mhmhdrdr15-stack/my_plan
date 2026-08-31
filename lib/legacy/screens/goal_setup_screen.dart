import 'package:flutter/material.dart';

import '../models/user_goal_profile.dart';
import 'meal_schedule_screen.dart';
import 'planning_home_screen.dart';

class GoalSetupScreen extends StatefulWidget {
  final UserGoalProfile? initialProfile;

  const GoalSetupScreen({
    super.key,
    this.initialProfile,
  });

  @override
  State<GoalSetupScreen> createState() =>
      _GoalSetupScreenState();
}

class _GoalSetupScreenState
    extends State<GoalSetupScreen> {
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

  // ============================================================
  // CONTROLLERS
  // ============================================================

  late final TextEditingController caloriesController;

  // ============================================================
  // STATE
  // ============================================================

  String selectedGoal =
      'خسارة الوزن';

  String selectedActivity =
      'متوسط';

  int currentStep = 5;

  late double suggestedCalories;

  @override
  void initState() {
    super.initState();

    final profile =
        widget.initialProfile;

    suggestedCalories =
        profile?.dailyCalories ??
            2200;

    caloriesController =
        TextEditingController(
      text:
          suggestedCalories.round().toString(),
    );

    if (profile != null) {
      selectedGoal =
          profile.goalTitle;

      selectedActivity =
          profile.activityTitle;
    }
  }

  @override
  void dispose() {
    caloriesController.dispose();
    super.dispose();
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
                child:
                    ListView(
                  physics:
                      const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    30,
                  ),
                  children: [
                    _buildTitle(),

                    const SizedBox(
                      height: 20,
                    ),

                    _buildCaloriesCard(),

                    const SizedBox(
                      height: 14,
                    ),

                    _buildMacroCard(),

                    const SizedBox(
                      height: 14,
                    ),

                    _buildProfileSummary(),

                    const SizedBox(
                      height: 14,
                    ),

                    _buildInformationCard(),
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
        4,
      ),
      child:
          Column(
        children: [
          Row(
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
                      'إعداد هدفك',
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
                      'راجع اقتراح Calory وعدّله كما يناسبك.',
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
                  '$currentStep / 5',
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

          const SizedBox(
              height:
                  11),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            child:
                LinearProgressIndicator(
              value:
                  currentStep / 5,
              minHeight:
                  5,
              backgroundColor:
                  const Color(
                0xFFEAE7F8,
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

  // ============================================================
  // TITLE
  // ============================================================

  Widget _buildTitle() {
    return const Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'خطتك اليومية جاهزة',
          style:
              TextStyle(
            fontSize:
                27,
            fontWeight:
                FontWeight.w900,
            color:
                textPrimary,
          ),
        ),
        SizedBox(
            height:
                6),
        Text(
          'هذا اقتراح أولي مبني على بياناتك. يمكنك تغيير السعرات وأوقات الوجبات وتوزيعها قبل البدء.',
          style:
              TextStyle(
            color:
                textSecondary,
            fontSize:
                10,
            height:
                1.55,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CALORIES CARD
  // ============================================================

  Widget _buildCaloriesCard() {
    return Container(
      padding:
          const EdgeInsets.all(
        18,
      ),
      decoration:
          BoxDecoration(
        borderRadius:
            BorderRadius.circular(
          25,
        ),
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
              alpha:
                  0.16,
            ),
            blurRadius:
                22,
            offset:
                const Offset(
              0,
              8,
            ),
          ),
        ],
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'السعرات اليومية',
            style:
                TextStyle(
              color:
                  Colors.white70,
              fontSize:
                  9,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(
              height:
                  8),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment
                    .end,
            children: [
              Text(
                _currentCalories
                    .round()
                    .toString(),
                style:
                    const TextStyle(
                  color:
                      Colors.white,
                  fontSize:
                      43,
                  height:
                      1,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
              const SizedBox(
                  width:
                      8),
              const Padding(
                padding:
                    EdgeInsets.only(
                  bottom:
                      4,
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
              height:
                  12),

          const Text(
            'اقترحنا هذا الرقم بناءً على بياناتك ونشاطك.',
            style:
                TextStyle(
              color:
                  Colors.white70,
              fontSize:
                  8.5,
              height:
                  1.4,
            ),
          ),

          const SizedBox(
              height:
                  14),

          SizedBox(
            width:
                double.infinity,
            height:
                44,
            child:
                TextField(
              controller:
                  caloriesController,
              keyboardType:
                  const TextInputType
                      .numberWithOptions(
                decimal:
                    false,
              ),
              textDirection:
                  TextDirection.ltr,
              onChanged:
                  (_) {
                setState(() {});
              },
              style:
                  const TextStyle(
                color:
                    Colors.white,
                fontSize:
                    14,
                fontWeight:
                    FontWeight.w900,
              ),
              decoration:
                  InputDecoration(
                filled:
                    true,
                fillColor:
                    Colors.white
                        .withValues(
                  alpha:
                      0.12,
                ),
                prefixIcon:
                    const Icon(
                  Icons
                      .edit_rounded,
                  color:
                      Colors.white70,
                  size:
                      18,
                ),
                suffixText:
                    'kcal',
                suffixStyle:
                    const TextStyle(
                  color:
                      Colors.white70,
                  fontSize:
                      9,
                ),
                hintText:
                    'أدخل السعرات',
                hintStyle:
                    const TextStyle(
                  color:
                      Colors.white54,
                ),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    13,
                  ),
                  borderSide:
                      BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets
                        .symmetric(
                  horizontal:
                      13,
                ),
              ),
            ),
          ),

          const SizedBox(
              height:
                  10),

          GestureDetector(
            onTap:
                _resetSuggestedCalories,
            child:
                const Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Icon(
                  Icons
                      .auto_awesome_rounded,
                  color:
                      Colors.white70,
                  size:
                      14,
                ),
                SizedBox(
                    width:
                        5),
                Text(
                  'إعادة الرقم المقترح',
                  style:
                      TextStyle(
                    color:
                        Colors.white70,
                    fontSize:
                        8,
                    fontWeight:
                        FontWeight.w700,
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
  // MACROS
  // ============================================================

  Widget _buildMacroCard() {
    final calories =
        _currentCalories;

    final protein =
        calories * 0.30 / 4;

    final carbs =
        calories * 0.40 / 4;

    final fat =
        calories * 0.30 / 9;

    return Container(
      padding:
          const EdgeInsets.all(
        16,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'الماكروز المقترحة',
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

          const Text(
            'يمكننا إعادة حسابها مع تغيير السعرات.',
            style:
                TextStyle(
              color:
                  textSecondary,
              fontSize:
                  8.5,
            ),
          ),

          const SizedBox(
              height:
                  13),

          Row(
            children: [
              Expanded(
                child:
                    _macroBox(
                  value:
                      '${protein.round()}غ',
                  title:
                      'بروتين',
                  color:
                      const Color(
                    0xFF4978E8,
                  ),
                ),
              ),
              const SizedBox(
                  width:
                      7),
              Expanded(
                child:
                    _macroBox(
                  value:
                      '${carbs.round()}غ',
                  title:
                      'كربوهيدرات',
                  color:
                      const Color(
                    0xFFE7A32E,
                  ),
                ),
              ),
              const SizedBox(
                  width:
                      7),
              Expanded(
                child:
                    _macroBox(
                  value:
                      '${fat.round()}غ',
                  title:
                      'دهون',
                  color:
                      const Color(
                    0xFFE36868,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _macroBox({
    required String value,
    required String title,
    required Color color,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical:
            10,
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
          13,
        ),
      ),
      child:
          Column(
        children: [
          Text(
            value,
            style:
                TextStyle(
              color:
                  color,
              fontSize:
                  15,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
          const SizedBox(
              height:
                  3),
          Text(
            title,
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
    );
  }

  // ============================================================
  // PROFILE SUMMARY
  // ============================================================

  Widget _buildProfileSummary() {
    return Container(
      padding:
          const EdgeInsets.all(
        16,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'ملخص اختيارك',
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
                  12),

          _summaryRow(
            icon:
                Icons.flag_rounded,
            title:
                'الهدف',
            value:
                selectedGoal,
          ),

          _summaryRow(
            icon:
                Icons.directions_walk_rounded,
            title:
                'النشاط',
            value:
                selectedActivity,
          ),

          _summaryRow(
            icon:
                Icons.restaurant_menu_rounded,
            title:
                'الوجبات',
            value:
                'سيتم تحديدها في الخطوة التالية',
          ),
        ],
      ),
    );
  }

  Widget _summaryRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom:
            9,
      ),
      child:
          Row(
        children: [
          Container(
            width:
                34,
            height:
                34,
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
              size:
                  16,
            ),
          ),

          const SizedBox(
              width:
                  8),

          Expanded(
            child:
                Text(
              title,
              style:
                  const TextStyle(
                color:
                    textSecondary,
                fontSize:
                    8,
              ),
            ),
          ),

          Text(
            value,
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
    );
  }

  // ============================================================
  // INFORMATION
  // ============================================================

  Widget _buildInformationCard() {
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons
                .info_outline_rounded,
            color:
                primary,
            size:
                19,
          ),
          const SizedBox(
              width:
                  8),
          const Expanded(
            child:
                Text(
              'السعرات المعروضة اقتراح وليست رقمًا مفروضًا. في الخطوة التالية ستحدد عدد الوجبات، وقت كل وجبة، وكمية السعرات التي تريد تخصيصها لها.',
              style:
                  TextStyle(
                color:
                    textSecondary,
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
  // BOTTOM BAR
  // ============================================================

  Widget _buildBottomBar() {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        10,
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
            SizedBox(
          width:
              double.infinity,
          height:
              53,
          child:
              FilledButton.icon(
            onPressed:
                _continueToMealSchedule,
            style:
                FilledButton.styleFrom(
              backgroundColor:
                  primary,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  17,
                ),
              ),
            ),
            icon:
                const Icon(
              Icons
                  .arrow_back_rounded,
            ),
            label:
                const Text(
              'تحديد وجباتي وأوقاتها',
              style:
                  TextStyle(
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CONTINUE
  // ============================================================

  Future<void>
      _continueToMealSchedule() async {
    final calories =
        _currentCalories;

    if (calories <= 0) {
      _showMessage(
        'أدخل سعرات يومية صحيحة.',
      );
      return;
    }

    final profile =
        _buildProfile(
      calories,
    );

    final updatedProfile =
        await Navigator.push<
            UserGoalProfile>(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
                MealScheduleScreen(
          profile:
              profile,
        ),
      ),
    );

    if (!mounted ||
        updatedProfile == null) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
                PlanningHomeScreen(
          goalProfile:
              updatedProfile,
        ),
      ),
    );
  }

  // ============================================================
  // BUILD PROFILE
  // ============================================================

  UserGoalProfile _buildProfile(
    double calories,
  ) {
    final protein =
        calories * 0.30 / 4;

    final carbs =
        calories * 0.40 / 4;

    final fat =
        calories * 0.30 / 9;

    return UserGoalProfile(
      goalTitle:
          selectedGoal,
      activityTitle:
          selectedActivity,
      dailyCalories:
          calories,
      proteinTarget:
          protein,
      carbsTarget:
          carbs,
      fatTarget:
          fat,
      mealsPerDay:
          3,
      mealNames:
          const [
        'الإفطار',
        'الغداء',
        'العشاء',
      ],
      mealTimes:
          const [
        '08:00 ص',
        '02:00 م',
        '08:00 م',
      ],
    );
  }

  // ============================================================
  // SUGGESTED CALORIES
  // ============================================================

  double get _currentCalories {
    final value =
        double.tryParse(
      caloriesController.text
          .trim(),
    );

    return value ??
        suggestedCalories;
  }

  void _resetSuggestedCalories() {
    setState(() {
      caloriesController.text =
          suggestedCalories
              .round()
              .toString();
    });
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