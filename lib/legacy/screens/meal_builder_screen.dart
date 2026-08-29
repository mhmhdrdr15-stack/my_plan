import 'package:flutter/material.dart';

import '../data/food_data.dart';
import '../models/food.dart';
import '../models/meal.dart';
import '../models/meal_template.dart';
import '../models/user_goal_profile.dart';
import '../models/weekly_plan.dart';
import '../services/meal_target_calculator.dart';

class MealBuilderScreen extends StatefulWidget {
  final String mealType;
  final String time;
  final WeeklyPlan plan;
  final List<Food> foods;
  final MealTemplate? existingTemplate;
  final UserGoalProfile? goalProfile;

  const MealBuilderScreen({
    super.key,
    required this.mealType,
    required this.time,
    required this.plan,
    required this.foods,
    this.existingTemplate,
    this.goalProfile,
  });

  @override
  State<MealBuilderScreen> createState() =>
      _MealBuilderScreenState();
}

class _MealBuilderScreenState
    extends State<MealBuilderScreen> {
  static const Color primary = Color(0xFF5B35F5);
  static const Color background = Color(0xFFF7F7FB);
  static const Color textPrimary = Color(0xFF18182B);
  static const Color textSecondary = Color(0xFF85899D);
  static const Color borderColor = Color(0xFFE7E7EF);

  final MealTargetCalculator _targetCalculator =
      const MealTargetCalculator();

  final TextEditingController _searchController =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController();

  late List<MealItem> _items;

  String _searchQuery = '';
  String _selectedCategory = 'الكل';
  bool _showFoodPicker = false;

  static const List<String> _categories = [
    'الكل',
    'بروتين',
    'نشويات',
    'خضار',
    'ألبان',
    'فواكه',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.existingTemplate != null) {
      _items = List<MealItem>.from(
        widget.existingTemplate!.meal.items,
      );
    } else {
      _items = widget.foods
          .map(
            (food) => MealItem(
              food: food,
              amountInGrams: _defaultAmount(food),
            ),
          )
          .toList();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ============================================================
  // NUTRITION TOTALS
  // ============================================================

  double get _calories {
    return _items.fold(
      0,
      (sum, item) => sum + item.calories,
    );
  }

  double get _protein {
    return _items.fold(
      0,
      (sum, item) => sum + item.protein,
    );
  }

  double get _carbs {
    return _items.fold(
      0,
      (sum, item) => sum + item.carbs,
    );
  }

  double get _fat {
    return _items.fold(
      0,
      (sum, item) => sum + item.fat,
    );
  }

  MealTarget? get _target {
    final profile = widget.goalProfile;

    if (profile == null) {
      return null;
    }

    final targets = _targetCalculator.calculate(
      profile,
    );

    for (final target in targets) {
      if (target.mealType == widget.mealType) {
        return target;
      }
    }

    final index = profile.mealNames.indexOf(
      widget.mealType,
    );

    if (index >= 0 && index < targets.length) {
      return targets[index];
    }

    return null;
  }

  List<Food> get _filteredFoods {
    final query = _searchQuery
        .trim()
        .toLowerCase();

    return foodDatabase.where(
      (food) {
        final matchesQuery =
            query.isEmpty ||
            food.name
                .toLowerCase()
                .contains(query);

        final matchesCategory =
            _selectedCategory == 'الكل' ||
            food.category == _selectedCategory;

        return matchesQuery && matchesCategory;
      },
    ).toList();
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
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics:
                      const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    125,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _buildTargetCard(),

                      const SizedBox(height: 18),

                      _buildIngredientsHeader(),

                      const SizedBox(height: 10),

                      if (_items.isEmpty)
                        _buildEmptyMeal()
                      else
                        _buildIngredients(),

                      const SizedBox(height: 5),

                      _buildAddFoodButton(),

                      if (_showFoodPicker) ...[
                        const SizedBox(height: 10),
                        _buildFoodPicker(),
                      ],

                      const SizedBox(height: 16),

                      _buildAssistant(),
                    ],
                  ),
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
    final isEditing =
        widget.existingTemplate != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        5,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing
                      ? 'تعديل ${widget.mealType}'
                      : 'إنشاء ${widget.mealType}',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isEditing
                      ? widget.existingTemplate!.name
                      : 'أنشئ خيارًا جديدًا',
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 9.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF0ECFF),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Text(
              widget.time,
              style: const TextStyle(
                color: primary,
                fontSize: 9,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TARGET CARD
  // ============================================================

  Widget _buildTargetCard() {
    final target = _target;

    if (target == null) {
      return _buildSummaryCard();
    }

    final calorieTarget = target.calories;
    final proteinTarget = target.protein;

    final calorieProgress =
        calorieTarget <= 0
            ? 0.0
            : (_calories / calorieTarget)
                .clamp(0.0, 1.0);

    final proteinProgress =
        proteinTarget <= 0
            ? 0.0
            : (_protein / proteinTarget)
                .clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.025,
            ),
            blurRadius: 16,
            offset: const Offset(0, 5),
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
                      'هدف الوجبة',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'ابنِ وجبتك وأنت ترى تقدمك مباشرة',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              _statusBadge(
                target,
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                _calories.round().toString(),
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: textPrimary,
                  height: 1,
                ),
              ),
              const SizedBox(width: 7),
              Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 2,
                ),
                child: Text(
                  'من ${calorieTarget.round()} سعرة',
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 9,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          _progressRow(
            label: 'السعرات',
            progress: calorieProgress,
          ),

          const SizedBox(height: 10),

          _progressRow(
            label: 'البروتين',
            progress: proteinProgress,
          ),

          const SizedBox(height: 14),

          _macroSummary(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          23,
        ),
        border:
            Border.all(
          color:
              borderColor,
        ),
      ),
      child:
          _macroSummary(),
    );
  }

  Widget _statusBadge(
    MealTarget target,
  ) {
    final difference =
        _calories -
            target.calories;

    if (difference.abs() <= 40) {
      return _badge(
        'ممتاز',
        const Color(0xFF2FA66A),
      );
    }

    if (difference < 0) {
      return _badge(
        'باقي ${difference.abs().round()}',
        primary,
      );
    }

    return _badge(
      'أعلى ${difference.round()}',
      const Color(0xFFD27A1F),
    );
  }

  Widget _badge(
    String text,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration:
          BoxDecoration(
        color: color.withValues(
          alpha: 0.08,
        ),
        borderRadius:
            BorderRadius.circular(10),
      ),
      child:
          Text(
        text,
        style:
            TextStyle(
          color:
              color,
          fontSize:
              8,
          fontWeight:
              FontWeight.w900,
        ),
      ),
    );
  }

  Widget _progressRow({
    required String label,
    required double progress,
  }) {
    final percent =
        (progress * 100).round();

    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            label,
            style:
                const TextStyle(
              color:
                  textSecondary,
              fontSize: 8,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(20),
            child:
                LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor:
                  const Color(0xFFF0EEF7),
              valueColor:
                  const AlwaysStoppedAnimation<
                      Color>(
                primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 7),
        SizedBox(
          width: 33,
          child: Text(
            '$percent%',
            textAlign: TextAlign.end,
            style:
                const TextStyle(
              color:
                  primary,
              fontSize: 8,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _macroSummary() {
    return Row(
      children: [
        _macroStat(
          '${_protein.round()}غ',
          'بروتين',
        ),
        _macroStat(
          '${_carbs.round()}غ',
          'كارب',
        ),
        _macroStat(
          '${_fat.round()}غ',
          'دهون',
        ),
      ],
    );
  }

  Widget _macroStat(
    String value,
    String label,
  ) {
    return Expanded(
      child:
          Container(
        margin:
            const EdgeInsetsDirectional.only(
          end: 6,
        ),
        padding:
            const EdgeInsets.symmetric(
          vertical: 9,
        ),
        decoration:
            BoxDecoration(
          color:
              const Color(0xFFF8F7FC),
          borderRadius:
              BorderRadius.circular(12),
        ),
        child:
            Column(
          children: [
            Text(
              value,
              style:
                  const TextStyle(
                fontSize: 10,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style:
                  const TextStyle(
                color:
                    textSecondary,
                fontSize: 7,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INGREDIENTS
  // ============================================================

  Widget _buildIngredientsHeader() {
    return Row(
      children: [
        const Expanded(
          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'مكونات الوجبة',
                style:
                    TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w900,
                  color:
                      textPrimary,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'أضف أي مكون وعدّل الكمية بحرية.',
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
        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 5,
          ),
          decoration:
              BoxDecoration(
            color:
                const Color(0xFFF0ECFF),
            borderRadius:
                BorderRadius.circular(10),
          ),
          child:
              Text(
            '${_items.length}',
            style:
                const TextStyle(
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
    );
  }

  Widget _buildIngredients() {
    return Column(
      children: _items.map(
        (item) {
          return _buildIngredientCard(
            item,
          );
        },
      ).toList(),
    );
  }

  Widget _buildIngredientCard(
    MealItem item,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom:
            9,
      ),
      padding:
          const EdgeInsets.all(
        11,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          20,
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
              _foodImage(
                item.food,
              ),
              const SizedBox(
                  width: 10),
              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      item.food.name,
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis,
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
                        height: 4),
                    Text(
                      '${item.calories.round()} kcal • '
                      'P ${item.protein.round()}غ • '
                      'C ${item.carbs.round()}غ • '
                      'F ${item.fat.round()}غ',
                      style:
                          const TextStyle(
                        color:
                            textSecondary,
                        fontSize:
                            7.8,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                visualDensity:
                    VisualDensity.compact,
                onPressed:
                    () =>
                        _removeItem(
                  item,
                ),
                icon:
                    const Icon(
                  Icons
                      .delete_outline_rounded,
                  color:
                      Color(0xFFE16B6B),
                  size:
                      19,
                ),
              ),
            ],
          ),
          const SizedBox(
              height: 9),
          Row(
            children: [
              const Text(
                'الكمية',
                style:
                    TextStyle(
                  color:
                      textSecondary,
                  fontSize:
                      8.5,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
              const Spacer(),
              _quantityButton(
                Icons.remove_rounded,
                () =>
                    _changeAmount(
                  item,
                  -10,
                ),
              ),
              GestureDetector(
                onTap:
                    () =>
                        _editAmount(
                  item,
                ),
                child:
                    Container(
                  width:
                      82,
                  height:
                      32,
                  alignment:
                      Alignment.center,
                  margin:
                      const EdgeInsets
                          .symmetric(
                    horizontal:
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
                    '${item.amountInGrams.round()} غ',
                    style:
                        const TextStyle(
                      fontSize:
                          9.5,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ),
              ),
              _quantityButton(
                Icons.add_rounded,
                () =>
                    _changeAmount(
                  item,
                  10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _foodImage(
    Food food,
  ) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(13),
      child:
          SizedBox(
        width:
            55,
        height:
            55,
        child:
            Image.network(
          food.imageUrl,
          fit:
              BoxFit.cover,
          errorBuilder:
              (
            context,
            error,
            stackTrace,
          ) {
            return Container(
              color:
                  const Color(0xFFF0ECFF),
              child:
                  const Icon(
                Icons.restaurant_rounded,
                color:
                    primary,
                size:
                    21,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _quantityButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap:
          onTap,
      child:
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
            Icon(
          icon,
          color:
              primary,
          size:
              16,
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmptyMeal() {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            20,
        vertical:
            24,
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
          Container(
            width:
                64,
            height:
                64,
            decoration:
                const BoxDecoration(
              color:
                  Color(0xFFF0ECFF),
              shape:
                  BoxShape.circle,
            ),
            child:
                const Icon(
              Icons
                  .restaurant_menu_rounded,
              color:
                  primary,
              size:
                  28,
            ),
          ),
          const SizedBox(
              height:
                  11),
          const Text(
            'ابدأ بإضافة مكونات',
            style:
                TextStyle(
              fontSize:
                  14,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
          const SizedBox(
              height:
                  5),
          const Text(
            'يمكنك إضافة أي طعام من قاعدة البيانات.',
            textAlign:
                TextAlign.center,
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
    );
  }

  // ============================================================
  // ADD FOOD
  // ============================================================

  Widget _buildAddFoodButton() {
    return SizedBox(
      width:
          double.infinity,
      height:
          52,
      child:
          OutlinedButton.icon(
        onPressed:
            () {
          setState(() {
            _showFoodPicker =
                !_showFoodPicker;
          });
        },
        style:
            OutlinedButton.styleFrom(
          foregroundColor:
              primary,
          backgroundColor:
              Colors.white,
          side:
              const BorderSide(
            color:
                Color(0xFFDCD6FA),
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              17,
            ),
          ),
        ),
        icon:
            Icon(
          _showFoodPicker
              ? Icons.close_rounded
              : Icons.add_rounded,
        ),
        label:
            Text(
          _showFoodPicker
              ? 'إغلاق قاعدة الأطعمة'
              : 'إضافة مكون',
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
  // FOOD PICKER
  // ============================================================

  Widget _buildFoodPicker() {
    final foods =
        _filteredFoods;

    return Container(
      padding:
          const EdgeInsets.all(
        13,
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child:
                    Text(
                  'إضافة من قاعدة الأطعمة',
                  style:
                      TextStyle(
                    fontSize:
                        12,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '${foods.length} نتيجة',
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

          const SizedBox(
              height: 9),

          Container(
            height:
                46,
            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFFF8F7FC,
              ),
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child:
                TextField(
              controller:
                  _searchController,
              onChanged:
                  (value) {
                setState(() {
                  _searchQuery =
                      value;
                });
              },
              decoration:
                  const InputDecoration(
                prefixIcon:
                    Icon(
                  Icons
                      .search_rounded,
                  color:
                      textSecondary,
                  size:
                      20,
                ),
                hintText:
                    'ابحث عن طعام...',
                hintStyle:
                    TextStyle(
                  color:
                      textSecondary,
                  fontSize:
                      9,
                ),
                border:
                    InputBorder.none,
              ),
            ),
          ),

          const SizedBox(
              height: 9),

          SizedBox(
            height:
                37,
            child:
                ListView.separated(
              scrollDirection:
                  Axis.horizontal,
              itemCount:
                  _categories.length,
              separatorBuilder:
                  (_, _) =>
                      const SizedBox(
                width:
                    6,
              ),
              itemBuilder:
                  (
                context,
                index,
              ) {
                final category =
                    _categories[
                        index];

                final selected =
                    _selectedCategory ==
                        category;

                return GestureDetector(
                  onTap:
                      () {
                    setState(() {
                      _selectedCategory =
                          category;
                    });
                  },
                  child:
                      AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds:
                          150,
                    ),
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal:
                          12,
                    ),
                    alignment:
                        Alignment.center,
                    decoration:
                        BoxDecoration(
                      color:
                          selected
                              ? primary
                              : const Color(
                                  0xFFF8F7FC,
                                ),
                      borderRadius:
                          BorderRadius.circular(
                        11,
                      ),
                    ),
                    child:
                        Text(
                      category,
                      style:
                          TextStyle(
                        color:
                            selected
                                ? Colors.white
                                : const Color(
                                    0xFF65687A,
                                  ),
                        fontSize:
                            8,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(
              height: 10),

          if (foods.isEmpty)
            _buildNoResults()
          else
            ...foods
                .take(15)
                .map(
                  _buildFoodRow,
                ),
        ],
      ),
    );
  }

  Widget _buildFoodRow(
    Food food,
  ) {
    final alreadyAdded =
        _items.any(
      (item) =>
          item.food.id ==
          food.id,
    );

    return GestureDetector(
      onTap:
          () => _addFood(
        food,
      ),
      child:
          Container(
        margin:
            const EdgeInsets.only(
          bottom:
              7,
        ),
        padding:
            const EdgeInsets.all(
          9,
        ),
        decoration:
            BoxDecoration(
          color:
              alreadyAdded
                  ? const Color(
                      0xFFF7F4FF,
                    )
                  : const Color(
                      0xFFFAFAFD,
                    ),
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          border:
              Border.all(
            color:
                alreadyAdded
                    ? const Color(
                        0xFFE0D8FF,
                      )
                    : const Color(
                        0xFFEDECF2,
                      ),
          ),
        ),
        child:
            Row(
          children: [
            _smallFoodImage(
              food,
            ),
            const SizedBox(
                width: 9),
            Expanded(
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    food.name,
                    style:
                        const TextStyle(
                      fontSize:
                          10,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                      height: 3),
                  Text(
                    '${food.caloriesPer100g.round()} kcal / 100غ',
                    style:
                        const TextStyle(
                      color:
                          textSecondary,
                      fontSize:
                          7.5,
                    ),
                  ),
                  const SizedBox(
                      height: 2),
                  Text(
                    'P ${food.proteinPer100g.round()}غ • '
                    'C ${food.carbsPer100g.round()}غ • '
                    'F ${food.fatPer100g.round()}غ',
                    style:
                        const TextStyle(
                      color:
                          primary,
                      fontSize:
                          7.3,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width:
                  29,
              height:
                  29,
              decoration:
                  BoxDecoration(
                color:
                    alreadyAdded
                        ? primary
                        : const Color(
                            0xFFF0ECFF,
                          ),
                shape:
                    BoxShape.circle,
              ),
              child:
                  Icon(
                alreadyAdded
                    ? Icons
                        .check_rounded
                    : Icons
                        .add_rounded,
                color:
                    alreadyAdded
                        ? Colors.white
                        : primary,
                size:
                    16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallFoodImage(
    Food food,
  ) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(
        10,
      ),
      child:
          SizedBox(
        width:
            42,
        height:
            42,
        child:
            Image.network(
          food.imageUrl,
          fit:
              BoxFit.cover,
          errorBuilder:
              (
            context,
            error,
            stackTrace,
          ) {
            return Container(
              color:
                  const Color(
                0xFFF0ECFF,
              ),
              child:
                  const Icon(
                Icons
                    .restaurant_rounded,
                color:
                    primary,
                size:
                    17,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Padding(
      padding:
          const EdgeInsets.all(
        18,
      ),
      child:
          Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            color:
                textSecondary,
            size:
                25,
          ),
          const SizedBox(
              height: 6),
          const Text(
            'لم نجد نتائج',
            style:
                TextStyle(
              fontSize:
                  10,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ASSISTANT
  // ============================================================

  Widget _buildAssistant() {
    final target =
        _target;

    if (target == null) {
      return const SizedBox.shrink();
    }

    final calorieDifference =
        target.calories -
            _calories;

    final proteinDifference =
        target.protein -
            _protein;

    String title;
    String message;
    IconData icon;

    if (calorieDifference.abs() <=
            40 &&
        proteinDifference.abs() <=
            5) {
      title =
          'الوجبة قريبة جدًا من الهدف';
      message =
          'السعرات والبروتين متوازنان بشكل ممتاز.';
      icon =
          Icons.auto_awesome_rounded;
    } else if (calorieDifference >
        40) {
      title =
          'يمكنك إضافة المزيد';
      message =
          'بقي حوالي ${calorieDifference.round()} سعرة للوصول إلى هدف الوجبة.';
      icon =
          Icons.add_circle_outline_rounded;
    } else if (calorieDifference <
        -40) {
      title =
          'الوجبة أعلى من الهدف';
      message =
          'تجاوزت الهدف بحوالي ${calorieDifference.abs().round()} سعرة.';
      icon =
          Icons.tune_rounded;
    } else if (proteinDifference >
        5) {
      title =
          'البروتين يحتاج قليلًا';
      message =
          'بقي حوالي ${proteinDifference.round()}غ بروتين.';
      icon =
          Icons.fitness_center_rounded;
    } else {
      title =
          'التوازن جيد';
      message =
          'يمكنك تعديل الكميات حسب تفضيلك.';
      icon =
          Icons.check_circle_outline_rounded;
    }

    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        15,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFFF4F0FF,
        ),
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        border:
            Border.all(
          color:
              const Color(
            0xFFE1D9FF,
          ),
        ),
      ),
      child:
          Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
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
                Icon(
              icon,
              color:
                  primary,
              size:
                  18,
            ),
          ),
          const SizedBox(
              width:
                  9),
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
                        primary,
                    fontSize:
                        10.5,
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
                        Color(0xFF696B7D),
                    fontSize:
                        8.8,
                    height:
                        1.45,
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
    final editing =
        widget.existingTemplate !=
            null;

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
                    '${_calories.round()} سعرة',
                    style:
                        const TextStyle(
                      fontSize:
                          11,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                      height:
                          2),
                  Text(
                    editing
                        ? 'تعديل الخيار الحالي'
                        : 'سيتم حفظه كخيار لـ${widget.mealType}',
                    maxLines:
                        1,
                    overflow:
                        TextOverflow
                            .ellipsis,
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
                    12),
            SizedBox(
              height:
                  51,
              child:
                  FilledButton(
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
                      17,
                    ),
                  ),
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal:
                        17,
                  ),
                ),
                onPressed:
                    _items.isEmpty
                        ? null
                        : _save,
                child:
                    Text(
                  editing
                      ? 'حفظ التعديل'
                      : 'حفظ الخيار',
                  style:
                      const TextStyle(
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
  // SAVE
  // ============================================================

  void _save() {
    if (_items.isEmpty) {
      _showSnack(
        'أضف مكونًا واحدًا على الأقل.',
      );
      return;
    }

    final existing =
        widget.existingTemplate;

    final id =
        existing?.id ??
        '${widget.mealType}_${DateTime.now().millisecondsSinceEpoch}';

    final meal =
        Meal(
      id:
          id,
      name:
          existing?.name ??
              widget.mealType,
      time:
          widget.time,
      items:
          List<MealItem>.from(
        _items,
      ),
    );

    final template =
        MealTemplate(
      id:
          id,
      name:
          existing?.name ??
              widget.mealType,
      mealType:
          widget.mealType,
      meal:
          meal,
      isFavorite:
          existing?.isFavorite ??
              false,
    );

    Navigator.pop(
      context,
      template,
    );
  }

  // ============================================================
  // AMOUNT
  // ============================================================

  void _changeAmount(
    MealItem item,
    double delta,
  ) {
    final index =
        _items.indexOf(
      item,
    );

    if (index == -1) {
      return;
    }

    final next =
        (item.amountInGrams + delta)
            .clamp(
              10,
              2000,
            )
            .toDouble();

    setState(() {
      _items[index] =
          item.copyWith(
        amountInGrams:
            next,
      );
    });
  }

  Future<void> _editAmount(
    MealItem item,
  ) async {
    final controller =
        TextEditingController(
      text:
          item.amountInGrams
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
              const Text(
            'تعديل الكمية',
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
                  'الكمية',
              suffixText:
                  'غ',
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

    if (result == null) {
      return;
    }

    final index =
        _items.indexOf(
      item,
    );

    if (index == -1) {
      return;
    }

    setState(() {
      _items[index] =
          item.copyWith(
        amountInGrams:
            result
                .clamp(
          10,
          2000,
        )
                .toDouble(),
      );
    });
  }

  void _removeItem(
    MealItem item,
  ) {
    setState(() {
      _items.remove(
        item,
      );
    });
  }

  // ============================================================
  // ADD FOOD
  // ============================================================

  void _addFood(
    Food food,
  ) {
    final existingIndex =
        _items.indexWhere(
      (item) =>
          item.food.id ==
          food.id,
    );

    if (existingIndex != -1) {
      final current =
          _items[existingIndex];

      setState(() {
        _items[existingIndex] =
            current.copyWith(
          amountInGrams:
              current.amountInGrams +
                  _defaultAmount(
                    food,
                  ),
        );
      });

      _showSnack(
        'تمت زيادة كمية ${food.name}.',
      );
      return;
    }

    setState(() {
      _items.add(
        MealItem(
          food:
              food,
          amountInGrams:
              _defaultAmount(
            food,
          ),
        ),
      );
    });
  }

  // ============================================================
  // DEFAULT AMOUNTS
  // ============================================================

  double _defaultAmount(
    Food food,
  ) {
    final name =
        food.name.toLowerCase();

    if (name.contains('بيض')) {
      return 100;
    }

    if (name.contains('دجاج')) {
      return 150;
    }

    if (name.contains('أرز') ||
        name.contains('ارز')) {
      return 150;
    }

    if (name.contains('خبز')) {
      return 60;
    }

    if (name.contains('شوفان')) {
      return 60;
    }

    if (name.contains('موز')) {
      return 100;
    }

    if (name.contains('بطاط')) {
      return 150;
    }

    if (name.contains('خيار') ||
        name.contains('بندورة') ||
        name.contains('طماطم')) {
      return 100;
    }

    if (name.contains('جبن') ||
        name.contains('جبنة')) {
      return 40;
    }

    if (name.contains('زبادي') ||
        name.contains('لبن')) {
      return 150;
    }

    return 100;
  }

  // ============================================================
  // SNACK
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