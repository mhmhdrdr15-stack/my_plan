import 'package:flutter/material.dart';

import 'package:my_plan/core/localization/app_localization.dart';
import 'package:my_plan/core/navigation/app_bottom_nav.dart';
import 'package:my_plan/core/state/app_state.dart';

import 'package:my_plan/data/shared/catalog/food_catalog.dart';

import 'package:my_plan/features/food_log/pages/log_screen.dart';
import 'package:my_plan/features/nutrition/pages/progress_screen.dart';
import 'package:my_plan/features/plan/pages/plan_screen.dart';

class AddFoodScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigate;

  const AddFoodScreen({
    super.key,
    this.onNavigate,
  });

  @override
  State<AddFoodScreen> createState() =>
      _AddFoodScreenState();
}

class _AddFoodScreenState
    extends State<AddFoodScreen> {
  static const Color purple =
      Color(0xFF5930FF);

  static const Color navy =
      Color(0xFF111A35);

  static const Color muted =
      Color(0xFF63708C);

  static const Color softPurple =
      Color(0xFFF2EEFF);

  final TextEditingController searchController =
      TextEditingController();

  String query = '';

  final List<String> recentSearches = [
    'Chicken breast',
    'Brown rice',
    'Greek yogurt',
    'Banana',
  ];

  double servingSize =
      100.0;

  double servings =
      1.0;

  FoodCatalogItem selectedFood =
      FoodCatalog.all.first;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // FILTER
  // ============================================================

  List<FoodCatalogItem>
      get filteredFoods {
    final normalized =
        query.trim().toLowerCase();

    if (normalized.isEmpty) {
      return FoodCatalog.all;
    }

    return FoodCatalog.all
        .where(
          (food) {
            return '${food.name} ${food.brand} ${food.category}'
                .toLowerCase()
                .contains(
                  normalized,
                );
          },
        )
        .toList();
  }

  // ============================================================
  // SELECTED NUTRITION
  // ============================================================

  double get totalGrams {
    return servingSize *
        servings;
  }

  FoodNutrition get selectedNutrition {
    return selectedFood.nutritionFor(
      totalGrams,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFFBFBFE),
      body:
          SafeArea(
        child:
            Stack(
          children: [
            ListView(
              padding:
                  const EdgeInsets.fromLTRB(
                16,
                14,
                16,
                305,
              ),
              children: [
                _header(),

                const SizedBox(
                    height:
                        18),

                _searchBar(),

                const SizedBox(
                    height:
                        16),

                _categoryChips(),

                const SizedBox(
                    height:
                        18),

                if (recentSearches
                    .isNotEmpty) ...[
                  _recent(),

                  const SizedBox(
                      height:
                          24),
                ],

                _results(),
              ],
            ),

            _selectionSheet(),
          ],
        ),
      ),
      bottomNavigationBar:
          AppBottomNav(
        currentIndex:
            0,
        onItemSelected:
            _navigateTo,
        onAdd: () {},
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _header() {
    return Row(
      children: [
        IconButton(
          onPressed:
              () =>
                  Navigator.maybePop(
            context,
          ),
          icon:
              const Icon(
            Icons
                .arrow_back_ios_new_rounded,
            color:
                navy,
          ),
        ),

        Expanded(
          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              const Text(
                'إضافة طعام',
                style:
                    TextStyle(
                  color:
                      navy,
                  fontSize:
                      25,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
              const SizedBox(
                  height:
                      5),
              Text(
                translateText(
                  context,
                  'Search and add food to your log.',
                ),
                style:
                    const TextStyle(
                  color:
                      muted,
                  fontSize:
                      13,
                ),
              ),
            ],
          ),
        ),

        TextButton.icon(
          onPressed:
              () =>
                  _showComingSoon(
            'Scan',
          ),
          icon:
              const Icon(
            Icons
                .barcode_reader,
            size:
                20,
          ),
          label:
              const Text(
            'Scan',
            style:
                TextStyle(
              fontWeight:
                  FontWeight.w700,
            ),
          ),
          style:
              TextButton.styleFrom(
            foregroundColor:
                purple,
            backgroundColor:
                softPurple,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _searchBar() {
    return Container(
      height:
          58,
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            16,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFFF3F3F8,
        ),
        borderRadius:
            BorderRadius.circular(
          15,
        ),
      ),
      child:
          Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color:
                muted,
            size:
                25,
          ),

          const SizedBox(
              width:
                  12),

          Expanded(
            child:
                TextField(
              controller:
                  searchController,
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
                  const InputDecoration(
                border:
                    InputBorder.none,
                hintText:
                    'ابحث عن طعام أو تصنيف...',
                hintStyle:
                    TextStyle(
                  color:
                      muted,
                  fontSize:
                      13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CATEGORIES
  // ============================================================

  Widget _categoryChips() {
    final categories = [
      'All',
      ...FoodCatalog
          .categories,
    ];

    return SizedBox(
      height:
          38,
      child:
          ListView.separated(
        scrollDirection:
            Axis.horizontal,
        itemCount:
            categories.length,
        separatorBuilder:
            (
          context,
          index,
        ) =>
                const SizedBox(
          width:
              7,
        ),
        itemBuilder:
            (
          context,
          index,
        ) {
          final category =
              categories[index];

          final selected =
              index == 0
                  ? query.isEmpty
                  : FoodCatalog.search(
                      query,
                    ).any(
                      (food) =>
                          food.category ==
                          category,
                    );

          return GestureDetector(
            onTap:
                () {
              if (index ==
                  0) {
                setState(
                  () {
                    query =
                        '';
                    searchController
                        .clear();
                  },
                );
                return;
              }

              _filterByCategory(
                category,
              );
            },
            child:
                Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal:
                    13,
              ),
              alignment:
                  Alignment.center,
              decoration:
                  BoxDecoration(
                color:
                    selected
                        ? purple
                        : Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
                border:
                    Border.all(
                  color:
                      selected
                          ? purple
                          : const Color(
                              0xFFE7E7EF,
                            ),
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
                          : navy,
                  fontSize:
                      8.5,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _filterByCategory(
    String category,
  ) {
    setState(
      () {
        query =
            category;
        searchController.text =
            category;
      },
    );
  }

  // ============================================================
  // RECENT
  // ============================================================

  Widget _recent() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child:
                  Text(
                'عمليات البحث الأخيرة',
                style:
                    TextStyle(
                  color:
                      navy,
                  fontSize:
                      16,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ),
            GestureDetector(
              onTap:
                  () {
                setState(
                  () {
                    recentSearches
                        .clear();
                  },
                );
              },
              child:
                  const Text(
                'مسح',
                style:
                    TextStyle(
                  color:
                      purple,
                  fontSize:
                      11,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(
            height:
                11),

        SingleChildScrollView(
          scrollDirection:
              Axis.horizontal,
          child:
              Row(
            children:
                recentSearches.map(
              (
                item,
              ) {
                return Padding(
                  padding:
                      const EdgeInsets.only(
                    right:
                        7,
                  ),
                  child:
                      ActionChip(
                    avatar:
                        const Icon(
                      Icons
                          .history_rounded,
                      size:
                          15,
                      color:
                          muted,
                    ),
                    label:
                        Text(
                      item,
                    ),
                    onPressed:
                        () {
                      searchController
                          .text =
                          item;
                      setState(
                        () {
                          query =
                              item;
                        },
                      );
                    },
                    backgroundColor:
                        softPurple,
                    side:
                        BorderSide
                            .none,
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // RESULTS
  // ============================================================

  Widget _results() {
    final foods =
        filteredFoods;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child:
                  Text(
                'مكتبة الأطعمة',
                style:
                    TextStyle(
                  color:
                      navy,
                  fontSize:
                      18,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ),
            Text(
              '${foods.length} أطعمة',
              style:
                  const TextStyle(
                color:
                    muted,
                fontSize:
                    10,
              ),
            ),
          ],
        ),

        const SizedBox(
            height:
                12),

        if (foods.isEmpty)
          _emptyResults()
        else
          Container(
            decoration:
                BoxDecoration(
              color:
                  Colors.white,
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
              boxShadow:
                  const [
                BoxShadow(
                  color:
                      Color(
                    0x0C121A2C,
                  ),
                  blurRadius:
                      13,
                  offset:
                      Offset(
                    0,
                    4,
                  ),
                ),
              ],
            ),
            child:
                Column(
              children:
                  foods.map(
                _resultRow,
              ).toList(),
            ),
          ),
      ],
    );
  }

  Widget _emptyResults() {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        28,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),
      child:
          const Column(
        children: [
          Icon(
            Icons
                .search_off_rounded,
            size:
                40,
            color:
                muted,
          ),
          SizedBox(
              height:
                  8),
          Text(
            'لم نجد هذا الطعام',
            style:
                TextStyle(
              color:
                  navy,
              fontSize:
                  14,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
          SizedBox(
              height:
                  4),
          Text(
            'جرّب كلمة أخرى أو أضف طعامًا مخصصًا لاحقًا.',
            textAlign:
                TextAlign.center,
            style:
                TextStyle(
              color:
                  muted,
              fontSize:
                  9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultRow(
    FoodCatalogItem food,
  ) {
    return InkWell(
      onTap:
          () {
        setState(
          () {
            selectedFood =
                food;
            servingSize =
                100;
            servings =
                1;
          },
        );
      },
      child:
          Padding(
        padding:
            const EdgeInsets.all(
          11,
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
                errorBuilder:
                    (
                  context,
                  error,
                  stackTrace,
                ) =>
                        Container(
                  width:
                      52,
                  height:
                      52,
                  color:
                      const Color(
                    0xFFF1F2F6,
                  ),
                  child:
                      const Icon(
                    Icons
                        .restaurant_rounded,
                    color:
                        muted,
                  ),
                ),
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
                  Text(
                    translateText(
                      context,
                      food.name,
                    ),
                    maxLines:
                        1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      color:
                          navy,
                      fontSize:
                          12.5,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  const SizedBox(
                      height:
                          4),

                  Text(
                    '${food.brand} • ${food.category}',
                    style:
                        const TextStyle(
                      color:
                          muted,
                      fontSize:
                          9,
                    ),
                  ),

                  const SizedBox(
                      height:
                          5),

                  Text(
                    '${_format(food.proteinPer100g)}g P • '
                    '${_format(food.carbsPer100g)}g C • '
                    '${_format(food.fatPer100g)}g F',
                    style:
                        const TextStyle(
                      color:
                          muted,
                      fontSize:
                          8,
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
                  '${_format(food.caloriesPer100g)} kcal',
                  style:
                      const TextStyle(
                    color:
                        navy,
                    fontSize:
                        11,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                    height:
                        6),

                const Icon(
                  Icons
                      .add_circle_outline_rounded,
                  color:
                      purple,
                  size:
                      22,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SELECTION SHEET
  // ============================================================

  Widget _selectionSheet() {
    return Align(
      alignment:
          Alignment.bottomCenter,
      child:
          Container(
        padding:
            const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          18,
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
          boxShadow: [
            BoxShadow(
              color:
                  Color(
                0x1A121629,
              ),
              blurRadius:
                  24,
              offset:
                  Offset(
                0,
                -5,
              ),
            ),
          ],
        ),
        child:
            Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              width:
                  30,
              height:
                  4,
              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFFD2D5DF,
                ),
                borderRadius:
                    BorderRadius.circular(
                  99,
                ),
              ),
            ),

            const SizedBox(
                height:
                    10),

            Row(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                    9,
                  ),
                  child:
                      Image.asset(
                    selectedFood
                        .imageAsset,
                    width:
                        48,
                    height:
                        48,
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
                          48,
                      height:
                          48,
                      color:
                          const Color(
                        0xFFF1F2F6,
                      ),
                      child:
                          const Icon(
                        Icons
                            .restaurant_rounded,
                        color:
                            muted,
                      ),
                    ),
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
                      Text(
                        translateText(
                          context,
                          selectedFood
                              .name,
                        ),
                        maxLines:
                            1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style:
                            const TextStyle(
                          color:
                              navy,
                          fontSize:
                              14,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),

                      const SizedBox(
                          height:
                              4),

                      Text(
                        '${selectedFood.brand} • ${_format(totalGrams)} g',
                        style:
                            const TextStyle(
                          color:
                              muted,
                          fontSize:
                              9.5,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  '${_format(selectedNutrition.calories)}\nkcal',
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                    color:
                        navy,
                    fontSize:
                        15,
                    height:
                        1.1,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ],
            ),

            const SizedBox(
                height:
                    10),

            Row(
              children: [
                _macroChip(
                  'P',
                  selectedNutrition
                      .protein,
                  const Color(
                    0xFFFF3E4B,
                  ),
                ),
                const SizedBox(
                    width:
                        6),
                _macroChip(
                  'C',
                  selectedNutrition
                      .carbs,
                  const Color(
                    0xFF467BFF,
                  ),
                ),
                const SizedBox(
                    width:
                        6),
                _macroChip(
                  'F',
                  selectedNutrition
                      .fat,
                  const Color(
                    0xFF2DAA61,
                  ),
                ),
              ],
            ),

            const SizedBox(
                height:
                    10),

            Row(
              children: [
                _portionControl(
                  title:
                      'الكمية',
                  value:
                      '${_format(servingSize)} g',
                  minus:
                      () {
                    setState(
                      () {
                        servingSize =
                            (servingSize -
                                    25)
                                .clamp(
                          25.0,
                          1000.0,
                        );
                      },
                    );
                  },
                  plus:
                      () {
                    setState(
                      () {
                        servingSize =
                            (servingSize +
                                    25)
                                .clamp(
                          25.0,
                          1000.0,
                        );
                      },
                    );
                  },
                ),

                const SizedBox(
                    width:
                        8),

                _portionControl(
                  title:
                      'عدد الحصص',
                  value:
                      servings
                          .toStringAsFixed(
                        1,
                      ),
                  minus:
                      () {
                    setState(
                      () {
                        servings =
                            (servings -
                                    0.5)
                                .clamp(
                          0.5,
                          20.0,
                        );
                      },
                    );
                  },
                  plus:
                      () {
                    setState(
                      () {
                        servings =
                            (servings +
                                    0.5)
                                .clamp(
                          0.5,
                          20.0,
                        );
                      },
                    );
                  },
                ),
              ],
            ),

            const SizedBox(
                height:
                    12),

            SizedBox(
              width:
                  double.infinity,
              height:
                  52,
              child:
                  FilledButton.icon(
                onPressed:
                    _addSelectedFood,
                icon:
                    const Icon(
                  Icons.check_rounded,
                ),
                label:
                    Text(
                  'إضافة • ${_format(selectedNutrition.calories)} kcal',
                  style:
                      const TextStyle(
                    fontSize:
                        15,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                style:
                    FilledButton.styleFrom(
                  backgroundColor:
                      purple,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      11,
                    ),
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
  // ADD
  // ============================================================

  Future<void> _addSelectedFood() async {
    final nutrition =
        selectedNutrition;

    await appState.addFood(
      name:
          selectedFood.name,
      mealType:
          'Lunch',
      amount:
          '${_format(totalGrams)} g',
      calories:
          '${_format(nutrition.calories)} kcal',
      proteinPer100g:
          selectedFood
              .proteinPer100g,
      carbsPer100g:
          selectedFood
              .carbsPer100g,
      fatPer100g:
          selectedFood
              .fatPer100g,
    );

    if (!mounted) {
      return;
    }

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
            '${selectedFood.name} تمت إضافته بنجاح.',
          ),
        ),
      );
  }

  // ============================================================
  // MACRO CHIP
  // ============================================================

  Widget _macroChip(
    String label,
    double value,
    Color color,
  ) {
    return Expanded(
      child:
          Container(
        padding:
            const EdgeInsets.symmetric(
          vertical:
              8,
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
            10,
          ),
        ),
        child:
            Row(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,
          children: [
            Text(
              label,
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
                    4),
            Text(
              '${_format(value)} g',
              style:
                  TextStyle(
                color:
                    color,
                fontSize:
                    8.5,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PORTION
  // ============================================================

  Widget _portionControl({
    required String title,
    required String value,
    required VoidCallback minus,
    required VoidCallback plus,
  }) {
    return Expanded(
      child:
          Container(
        height:
            78,
        padding:
            const EdgeInsets.all(
          9,
        ),
        decoration:
            BoxDecoration(
          border:
              Border.all(
            color:
                const Color(
              0xFFE8E9F0,
            ),
          ),
          borderRadius:
              BorderRadius.circular(
            13,
          ),
        ),
        child:
            Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            Text(
              title,
              style:
                  const TextStyle(
                color:
                    navy,
                fontSize:
                    10,
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            const Spacer(),

            Row(
              children: [
                _control(
                  Icons.remove_rounded,
                  minus,
                  false,
                ),

                const Spacer(),

                Text(
                  value,
                  style:
                      const TextStyle(
                    color:
                        navy,
                    fontSize:
                        14,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const Spacer(),

                _control(
                  Icons.add_rounded,
                  plus,
                  true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _control(
    IconData icon,
    VoidCallback onTap,
    bool filled,
  ) {
    return InkWell(
      onTap:
          onTap,
      customBorder:
          const CircleBorder(),
      child:
          Container(
        width:
            27,
        height:
            27,
        decoration:
            BoxDecoration(
          shape:
              BoxShape.circle,
          color:
              filled
                  ? purple
                  : softPurple,
        ),
        child:
            Icon(
              icon,
              color:
                  filled
                      ? Colors.white
                      : purple,
              size:
                  17,
            ),
      ),
    );
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _navigateTo(
    int index,
  ) {
    if (widget.onNavigate !=
        null) {
      widget.onNavigate!(
        index,
      );
      return;
    }

    if (index == 0) {
      Navigator.of(
        context,
      ).maybePop();
      return;
    }

    final destination =
        switch (index) {
      1 => const PlanScreen(),
      2 => const LogFoodScreen(),
      3 => const ProgressScreen(),
      _ => null,
    };

    if (destination !=
        null) {
      Navigator.of(
        context,
      ).push(
        MaterialPageRoute<void>(
          builder:
              (_) =>
                  destination,
        ),
      );
    }
  }

  // ============================================================
  // COMING SOON
  // ============================================================

  void _showComingSoon(
    String feature,
  ) {
    ScaffoldMessenger.of(
      context,
    )
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content:
              Text(
            comingSoonText(
              context,
              feature,
            ),
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
  }

  // ============================================================
  // FORMAT
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
}