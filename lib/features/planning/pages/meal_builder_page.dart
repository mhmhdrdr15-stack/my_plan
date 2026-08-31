import 'package:flutter/material.dart';

import 'package:my_plan/data/shared/catalog/food_catalog.dart';
import 'package:my_plan/features/planning/models/meal.dart';
import 'package:my_plan/features/planning/models/meal_template.dart';

class MealBuilderPage extends StatefulWidget {
  final String mealType;
  final String mealTime;
  final double targetCalories;
  final MealTemplate? existingTemplate;

  const MealBuilderPage({
    super.key,
    required this.mealType,
    required this.mealTime,
    required this.targetCalories,
    this.existingTemplate,
  });

  @override
  State<MealBuilderPage> createState() =>
      _MealBuilderPageState();
}

class _MealBuilderPageState
    extends State<MealBuilderPage> {
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

  late Meal _meal;

  final TextEditingController _searchController =
      TextEditingController();

  String _search = '';

  @override
  void initState() {
    super.initState();

    if (widget.existingTemplate != null) {
      _meal =
          widget.existingTemplate!.meal;
    } else {
      _meal = Meal(
        id:
            'meal_${DateTime.now().millisecondsSinceEpoch}',
        name:
            '${widget.mealType} ${_nextOptionName()}',
        mealType:
            widget.mealType,
        time:
            widget.mealTime,
        items:
            const [],
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // SEARCHED FOODS
  // ============================================================

  List<FoodCatalogItem> get _filteredFoods {
    final query =
        _search.trim().toLowerCase();

    if (query.isEmpty) {
      return FoodCatalog.all;
    }

    return FoodCatalog.all
        .where(
          (food) =>
              '${food.name} ${food.brand} ${food.category}'
                  .toLowerCase()
                  .contains(query),
        )
        .toList();
  }

  // ============================================================
  // TOTALS
  // ============================================================

  double get _calories {
    return _meal.calories;
  }

  double get _protein {
    return _meal.protein;
  }

  double get _carbs {
    return _meal.carbs;
  }

  double get _fat {
    return _meal.fat;
  }

  double get _difference {
    return _calories -
        widget.targetCalories;
  }

  double get _progress {
    if (widget.targetCalories <= 0) {
      return 0;
    }

    return (_calories /
            widget.targetCalories)
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
      child:
          Scaffold(
        backgroundColor:
            background,
        body:
            SafeArea(
          child:
              Column(
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
                    8,
                    20,
                    25,
                  ),
                  children: [
                    _buildTargetCard(),

                    const SizedBox(
                        height:
                            15),

                    _buildIngredientsSection(),

                    const SizedBox(
                        height:
                            10),

                    _buildAddIngredientButton(),

                    if (_search.isNotEmpty) ...[
                      const SizedBox(
                          height:
                              12),
                      _buildFoodSearchResults(),
                    ],
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
        8,
        20,
        8,
      ),
      child:
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
              Icons
                  .arrow_forward_ios_rounded,
              size:
                  18,
            ),
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  'بناء ${widget.mealType}',
                  style:
                      const TextStyle(
                    color:
                        text,
                    fontSize:
                        22,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(
                    height:
                        3),
                Text(
                  '${widget.mealTime} • أضف المكونات التي تريدها',
                  style:
                      const TextStyle(
                    color:
                        secondary,
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
                11,
              ),
            ),
            child:
                Text(
              '${_meal.itemCount} مكونات',
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
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TARGET CARD
  // ============================================================

  Widget _buildTargetCard() {
    final difference =
        _difference.abs();

    final isClose =
        difference <= 50;

    final statusColor =
        isClose
            ? const Color(
                0xFF2FA66A,
              )
            : _difference < 0
                ? primary
                : const Color(
                    0xFFD27A1F,
                  );

    final statusText =
        _difference.abs() < 1
            ? 'وصلت إلى هدف الوجبة'
            : _difference < 0
                ? 'باقي ${difference.round()} kcal'
                : 'تجاوزت الهدف بـ ${difference.round()} kcal';

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
          23,
        ),
        border:
            Border.all(
          color:
              border,
        ),
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
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
                      'هدف الوجبة',
                      style:
                          TextStyle(
                        color:
                            secondary,
                        fontSize:
                            8.5,
                      ),
                    ),
                    SizedBox(
                        height:
                            3),
                    Text(
                      'ابنِ وجبتك حول هذا الرقم',
                      style:
                          TextStyle(
                        color:
                            text,
                        fontSize:
                            12.5,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .end,
                children: [
                  Text(
                    '${widget.targetCalories.round()} kcal',
                    style:
                        const TextStyle(
                      color:
                          primary,
                      fontSize:
                          16,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                      height:
                          2),
                  Text(
                    'الهدف',
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
            ],
          ),

          const SizedBox(
              height:
                  16),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment
                    .end,
            children: [
              Text(
                _calories.round().toString(),
                style:
                    const TextStyle(
                  color:
                      text,
                  fontSize:
                      34,
                  height:
                      1,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
              const SizedBox(
                  width:
                      6),
              const Padding(
                padding:
                    EdgeInsets.only(
                  bottom:
                      3,
                ),
                child:
                    Text(
                  'kcal',
                  style:
                      TextStyle(
                    color:
                        secondary,
                    fontSize:
                        9,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
              height:
                  10),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              30,
            ),
            child:
                LinearProgressIndicator(
              value:
                  _progress,
              minHeight:
                  8,
              backgroundColor:
                  const Color(
                0xFFF0EEF7,
              ),
              valueColor:
                  AlwaysStoppedAnimation<
                      Color>(
                statusColor,
              ),
            ),
          ),

          const SizedBox(
              height:
                  8),

          Row(
            children: [
              Expanded(
                child:
                    Text(
                  statusText,
                  style:
                      TextStyle(
                    color:
                        statusColor,
                    fontSize:
                        8,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '${(_progress * 100).round()}%',
                style:
                    const TextStyle(
                  color:
                      secondary,
                  fontSize:
                      8,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(
              height:
                  14),

          Row(
            children: [
              Expanded(
                child:
                    _macroStat(
                  'P',
                  _protein,
                  const Color(
                    0xFFE75D67,
                  ),
                ),
              ),
              const SizedBox(
                  width:
                      7),
              Expanded(
                child:
                    _macroStat(
                  'C',
                  _carbs,
                  const Color(
                    0xFF497EF0,
                  ),
                ),
              ),
              const SizedBox(
                  width:
                      7),
              Expanded(
                child:
                    _macroStat(
                  'F',
                  _fat,
                  const Color(
                    0xFF39A96B,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _macroStat(
    String title,
    double value,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical:
            9,
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
          11,
        ),
      ),
      child:
          Row(
        mainAxisAlignment:
            MainAxisAlignment
                .center,
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
              width:
                  5),
          Text(
            '${_format(value)}g',
            style:
                TextStyle(
              color:
                  color,
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
  // INGREDIENTS
  // ============================================================

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment
              .start,
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
                    'مكونات الوجبة',
                    style:
                        TextStyle(
                      color:
                          text,
                      fontSize:
                          17,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  SizedBox(
                      height:
                          3),
                  Text(
                    'يمكنك إضافة أي مكون في أي وقت.',
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
              '${_meal.itemCount}',
              style:
                  const TextStyle(
                color:
                    primary,
                fontSize:
                    17,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ],
        ),

        const SizedBox(
            height:
                10),

        if (_meal.isEmpty)
          _buildEmptyIngredients()
        else
          ..._meal.items
              .asMap()
              .entries
              .map(
                (
                  entry,
                ) =>
                    _buildIngredientCard(
                  entry.key,
                  entry.value,
                ),
              ),
      ],
    );
  }

  Widget _buildEmptyIngredients() {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        25,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          19,
        ),
        border:
            Border.all(
          color:
              border,
        ),
      ),
      child:
          const Column(
        children: [
          Icon(
            Icons
                .restaurant_menu_outlined,
            color:
                primary,
            size:
                37,
          ),
          SizedBox(
              height:
                  8),
          Text(
            'ابدأ بإضافة مكونات',
            style:
                TextStyle(
              color:
                  text,
              fontSize:
                  13,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
          SizedBox(
              height:
                  4),
          Text(
            'لا توجد مكونات مختارة بعد.',
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
    );
  }

  Widget _buildIngredientCard(
    int index,
    MealItem item,
  ) {
    final nutrition =
        item.nutrition;

    return Container(
      margin:
          const EdgeInsets.only(
        bottom:
            9,
      ),
      padding:
          const EdgeInsets.all(
        12,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
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
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  11,
                ),
                child:
                    Image.asset(
                  item.food.imageAsset,
                  width:
                      54,
                  height:
                      54,
                  fit:
                      BoxFit.cover,
                  errorBuilder:
                      (
                    context,
                    error,
                    stackTrace,
                  ) =>
                          Container(
                    width:
                        54,
                    height:
                        54,
                    color:
                        const Color(
                      0xFFF1F2F6,
                    ),
                    child:
                        const Icon(
                      Icons
                          .restaurant_rounded,
                      color:
                          secondary,
                    ),
                  ),
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
                      item.food.name,
                      maxLines:
                          1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        color:
                            text,
                        fontSize:
                            11.5,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                        height:
                            3),
                    Text(
                      '${_format(item.grams)} g',
                      style:
                          const TextStyle(
                        color:
                            secondary,
                        fontSize:
                            8,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                        height:
                            5),
                    Text(
                      '${_format(nutrition.calories)} kcal • '
                      '${_format(nutrition.protein)}g P • '
                      '${_format(nutrition.carbs)}g C • '
                      '${_format(nutrition.fat)}g F',
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

              IconButton(
                visualDensity:
                    VisualDensity.compact,
                onPressed:
                    () =>
                        _removeItem(
                  index,
                ),
                icon:
                    const Icon(
                  Icons
                      .delete_outline_rounded,
                  color:
                      Color(
                    0xFFE16C6C,
                  ),
                  size:
                      19,
                ),
              ),
            ],
          ),

          const SizedBox(
              height:
                  9),

          Row(
            children: [
              const Text(
                'الكمية',
                style:
                    TextStyle(
                  color:
                      secondary,
                  fontSize:
                      8,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const Spacer(),

              _roundControl(
                icon:
                    Icons.remove_rounded,
                onTap:
                    () =>
                        _changeGrams(
                  index,
                  -25,
                ),
              ),

              Container(
                margin:
                    const EdgeInsets.symmetric(
                  horizontal:
                      10,
                ),
                padding:
                    const EdgeInsets.symmetric(
                  horizontal:
                      13,
                  vertical:
                      6,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFF8F7FD,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    9,
                  ),
                ),
                child:
                    Text(
                  '${_format(item.grams)} g',
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
              ),

              _roundControl(
                icon:
                    Icons.add_rounded,
                filled:
                    true,
                onTap:
                    () =>
                        _changeGrams(
                  index,
                  25,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundControl({
    required IconData icon,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return InkWell(
      onTap:
          onTap,
      customBorder:
          const CircleBorder(),
      child:
          Container(
        width:
            30,
        height:
            30,
        decoration:
            BoxDecoration(
          shape:
              BoxShape.circle,
          color:
              filled
                  ? primary
                  : const Color(
                      0xFFF0ECFF,
                    ),
        ),
        child:
            Icon(
          icon,
          color:
              filled
                  ? Colors.white
                  : primary,
          size:
              16,
        ),
      ),
    );
  }

  // ============================================================
  // ADD INGREDIENT
  // ============================================================

  Widget _buildAddIngredientButton() {
    return SizedBox(
      width:
          double.infinity,
      height:
          50,
      child:
          OutlinedButton.icon(
        onPressed:
            _openFoodPicker,
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
              15,
            ),
          ),
        ),
        icon:
            const Icon(
          Icons.add_rounded,
        ),
        label:
            const Text(
          'إضافة مكون',
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
  // SEARCH RESULTS
  // ============================================================

  Widget _buildFoodSearchResults() {
    return Container(
      padding:
          const EdgeInsets.all(
        12,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          17,
        ),
        border:
            Border.all(
          color:
              border,
        ),
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Text(
            'نتائج البحث',
            style:
                const TextStyle(
              color:
                  text,
              fontSize:
                  11,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          const SizedBox(
              height:
                  8),

          ..._filteredFoods
              .take(6)
              .map(
                _foodSearchRow,
              ),
        ],
      ),
    );
  }

  Widget _foodSearchRow(
    FoodCatalogItem food,
  ) {
    return InkWell(
      onTap:
          () =>
              _addFood(
        food,
      ),
      child:
          Padding(
        padding:
            const EdgeInsets.symmetric(
          vertical:
              7,
        ),
        child:
            Row(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                8,
              ),
              child:
                  Image.asset(
                food.imageAsset,
                width:
                    42,
                height:
                    42,
                fit:
                    BoxFit.cover,
              ),
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
                    food.name,
                    style:
                        const TextStyle(
                      color:
                          text,
                      fontSize:
                          9,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                      height:
                          2),
                  Text(
                    '${_format(food.caloriesPer100g)} kcal / 100g',
                    style:
                        const TextStyle(
                      color:
                          secondary,
                      fontSize:
                          7,
                    ),
                  ),
                  const SizedBox(
                      height:
                          2),
                  Text(
                    '${_format(food.proteinPer100g)}P • '
                    '${_format(food.carbsPer100g)}C • '
                    '${_format(food.fatPer100g)}F',
                    style:
                        const TextStyle(
                      color:
                          secondary,
                      fontSize:
                          6.5,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons
                  .add_circle_outline_rounded,
              color:
                  primary,
              size:
                  21,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FOOD PICKER
  // ============================================================

  Future<void> _openFoodPicker() async {
    final result =
        await showModalBottomSheet<
            FoodCatalogItem>(
      context:
          context,
      isScrollControlled:
          true,
      backgroundColor:
          Colors.transparent,
      builder:
          (
        context,
      ) {
        return _FoodPickerSheet(
          foods:
              FoodCatalog.all,
        );
      },
    );

    if (!mounted ||
        result == null) {
      return;
    }

    _addFood(
      result,
    );
  }

  // ============================================================
  // ADD FOOD
  // ============================================================

  void _addFood(
    FoodCatalogItem food,
  ) {
    final defaultGrams =
        _defaultAmountForFood(
      food,
    );

    setState(
      () {
        _meal =
            _meal.addItem(
          MealItem(
            food:
                food,
            grams:
                defaultGrams,
          ),
        );

        _search = '';
        _searchController
            .clear();
      },
    );
  }

  double _defaultAmountForFood(
    FoodCatalogItem food,
  ) {
    switch (food.id) {
      case 'egg':
        return 100;

      case 'apple':
        return 150;

      case 'brown_rice':
        return 150;

      case 'chicken_breast':
        return 150;

      case 'bread':
        return 60;

      case 'salad':
        return 100;

      default:
        return 100;
    }
  }

  // ============================================================
  // ITEM ACTIONS
  // ============================================================

  void _changeGrams(
    int index,
    double change,
  ) {
    final current =
        _meal.items[index];

    final newAmount =
        (current.grams +
                change)
            .clamp(
      25.0,
      2000.0,
    );

    setState(
      () {
        _meal =
            _meal.updateItem(
          index,
          current.copyWith(
            grams:
                newAmount,
          ),
        );
      },
    );
  }

  void _removeItem(
    int index,
  ) {
    setState(
      () {
        _meal =
            _meal.removeItemAt(
          index,
        );
      },
    );
  }

  // ============================================================
  // SAVE
  // ============================================================

  void _saveMeal() {
    if (_meal.isEmpty) {
      _showMessage(
        'أضف مكونًا واحدًا على الأقل.',
      );
      return;
    }

    if (_calories <= 0) {
      _showMessage(
        'يجب أن تحتوي الوجبة على سعرات.',
      );
      return;
    }

    final template =
        MealTemplate(
      id:
          widget.existingTemplate?.id ??
              'template_${DateTime.now().millisecondsSinceEpoch}',
      name:
          _meal.name,
      mealType:
          widget.mealType,
      meal:
          _meal.copyWith(
        time:
            widget.mealTime,
      ),
      assignedDays:
          widget.existingTemplate
                  ?.assignedDays ??
              const <String>{},
      isFavorite:
          widget.existingTemplate
                  ?.isFavorite ??
              false,
    );

    Navigator.pop<
        MealTemplate>(
      context,
      template,
    );
  }

  // ============================================================
  // OPTION NAME
  // ============================================================

  String _nextOptionName() {
    return '01';
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
                Color(
              0x10000000,
            ),
            blurRadius:
                16,
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
                    '${_calories.round()} / ${widget.targetCalories.round()} kcal',
                    style:
                        const TextStyle(
                      color:
                          text,
                      fontSize:
                          10,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                      height:
                          3),
                  Text(
                    '${_meal.itemCount} مكونات • '
                    '${_protein.round()}g بروتين',
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

            const SizedBox(
                width:
                    10),

            SizedBox(
              height:
                  51,
              child:
                  FilledButton(
                onPressed:
                    _saveMeal,
                style:
                    FilledButton.styleFrom(
                  backgroundColor:
                      primary,
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
                  'حفظ كخيار',
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
  // HELPERS
  // ============================================================

  String _format(
    double value,
  ) {
    if (value ==
        value.roundToDouble()) {
      return value
          .round()
          .toString();
    }

    return value
        .toStringAsFixed(
          1,
        )
        .replaceFirst(
          RegExp(
            r'\.0$',
          ),
          '',
        );
  }

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
// FOOD PICKER SHEET
// ================================================================

class _FoodPickerSheet
    extends StatefulWidget {
  final List<FoodCatalogItem> foods;

  const _FoodPickerSheet({
    required this.foods,
  });

  @override
  State<_FoodPickerSheet> createState() =>
      _FoodPickerSheetState();
}

class _FoodPickerSheetState
    extends State<_FoodPickerSheet> {
  final TextEditingController controller =
      TextEditingController();

  String query = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<FoodCatalogItem> get filtered {
    final q =
        query.trim().toLowerCase();

    if (q.isEmpty) {
      return widget.foods;
    }

    return widget.foods.where(
      (food) {
        return '${food.name} ${food.brand} ${food.category}'
            .toLowerCase()
            .contains(q);
      },
    ).toList();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Directionality(
      textDirection:
          TextDirection.rtl,
      child:
          Container(
        height:
            MediaQuery.sizeOf(
                  context,
                ).height *
                0.82,
        padding:
            const EdgeInsets.fromLTRB(
          18,
          10,
          18,
          0,
        ),
        decoration:
            const BoxDecoration(
          color:
              Colors.white,
          borderRadius:
              BorderRadius.vertical(
            top:
                Radius.circular(
              28,
            ),
          ),
        ),
        child:
            Column(
          children: [
            Container(
              width:
                  34,
              height:
                  4,
              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFFD7D9E2,
                ),
                borderRadius:
                    BorderRadius.circular(
                  30,
                ),
              ),
            ),

            const SizedBox(
                height:
                    13),

            const Align(
              alignment:
                  Alignment.centerRight,
              child:
                  Text(
                'إضافة مكون للوجبة',
                style:
                    TextStyle(
                  fontSize:
                      18,
                  fontWeight:
                      FontWeight.w900,
                  color:
                      Color(
                    0xFF18182B,
                  ),
                ),
              ),
            ),

            const SizedBox(
                height:
                    10),

            TextField(
              controller:
                  controller,
              autofocus:
                  true,
              onChanged:
                  (value) {
                setState(
                  () {
                    query =
                        value;
                  },
                );
              },
              decoration:
                  InputDecoration(
                hintText:
                    'ابحث عن طعام...',
                prefixIcon:
                    const Icon(
                  Icons
                      .search_rounded,
                ),
                filled:
                    true,
                fillColor:
                    const Color(
                  0xFFF7F7FB,
                ),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),
                  borderSide:
                      BorderSide
                          .none,
                ),
              ),
            ),

            const SizedBox(
                height:
                    10),

            Expanded(
              child:
                  ListView.separated(
                physics:
                    const BouncingScrollPhysics(),
                itemCount:
                    filtered.length,
                separatorBuilder:
                    (
                  context,
                  index,
                ) =>
                        const SizedBox(
                  height:
                      4,
                ),
                itemBuilder:
                    (
                  context,
                  index,
                ) {
                  final food =
                      filtered[index];

                  return InkWell(
                    onTap:
                        () =>
                            Navigator.pop<
                                FoodCatalogItem>(
                      context,
                      food,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                    child:
                        Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        vertical:
                            7,
                      ),
                      child:
                          Row(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                              9,
                            ),
                            child:
                                Image.asset(
                              food.imageAsset,
                              width:
                                  52,
                              height:
                                  52,
                              fit:
                                  BoxFit.cover,
                            ),
                          ),

                          const SizedBox(
                              width:
                                  9),

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
                                    height:
                                        3),
                                Text(
                                  '${_format(food.caloriesPer100g)} kcal / 100g',
                                  style:
                                      const TextStyle(
                                    color:
                                        Color(
                                      0xFF85899D,
                                    ),
                                    fontSize:
                                        7.5,
                                  ),
                                ),
                                const SizedBox(
                                    height:
                                        2),
                                Text(
                                  '${_format(food.proteinPer100g)}P • '
                                  '${_format(food.carbsPer100g)}C • '
                                  '${_format(food.fatPer100g)}F',
                                  style:
                                      const TextStyle(
                                    color:
                                        Color(
                                      0xFF85899D,
                                    ),
                                    fontSize:
                                        7,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons
                                .add_circle_outline_rounded,
                            color:
                                Color(
                              0xFF5B35F5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _format(
    double value,
  ) {
    if (value ==
        value.roundToDouble()) {
      return value
          .round()
          .toString();
    }

    return value
        .toStringAsFixed(
          1,
        );
  }
}