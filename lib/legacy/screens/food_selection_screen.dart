import 'package:flutter/material.dart';

import '../data/food_data.dart';
import '../models/food.dart';
import '../models/weekly_plan.dart';

import '../widgets/app_progress_header.dart';
import '../widgets/food_card.dart';

import 'meal_builder_screen.dart';

class FoodSelectionScreen extends StatefulWidget {
  final String mealType;
  final String time;
  final WeeklyPlan plan;

  const FoodSelectionScreen({
    super.key,
    required this.mealType,
    required this.time,
    required this.plan,
  });

  @override
  State<FoodSelectionScreen> createState() =>
      _FoodSelectionScreenState();
}

class _FoodSelectionScreenState
    extends State<FoodSelectionScreen> {
  static const Color primary = Color(0xFF5B35F5);
  static const Color background = Color(0xFFF7F7FB);

  final Set<String> selectedIds = <String>{};

  late final TextEditingController searchController;

  String query = '';
  String selectedCategory = 'الكل';

  static const List<String> categories = [
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
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Food> get filteredFoods {
    final normalizedQuery =
        query.trim().toLowerCase();

    return foodDatabase.where((food) {
      final name =
          food.name.toLowerCase();

      final matchesSearch =
          normalizedQuery.isEmpty ||
          name.contains(normalizedQuery);

      final matchesCategory =
          selectedCategory == 'الكل' ||
          food.category == selectedCategory;

      return matchesSearch &&
          matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            const AppProgressHeader(
              title: 'اختيار مكونات الوجبة',
              subtitle:
                  'اختر الأطعمة التي تريد استخدامها خلال هذه الوجبة.',
              progress: '2 / 7',
              value: 2 / 7,
            ),

            _buildSearchBox(),

            const SizedBox(height: 4),

            _buildCategorySelector(),

            const SizedBox(height: 4),

            Expanded(
              child: _buildFoodContent(),
            ),

            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        3,
        20,
        8,
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFFE7E7EF),
          ),
        ),
        child: TextField(
          controller: searchController,
          textDirection: TextDirection.rtl,
          textInputAction: TextInputAction.search,
          onChanged: (value) {
            setState(() {
              query = value;
            });
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Color(0xFF85899D),
            ),
            hintText: 'ابحث عن طعام...',
            hintStyle: TextStyle(
              color: Color(0xFFA4A6B2),
              fontSize: 10.5,
            ),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORIES
  // ============================================================

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 43,
      child: ListView.separated(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: 7),
        itemBuilder: (
          context,
          index,
        ) {
          final category =
              categories[index];

          final selected =
              selectedCategory ==
                  category;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory =
                    category;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 180,
              ),
              curve:
                  Curves.easeOutCubic,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(
                color: selected
                    ? primary
                    : Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
                border: Border.all(
                  color: selected
                      ? primary
                      : const Color(
                          0xFFE7E7EF,
                        ),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : const Color(
                          0xFF65687A,
                        ),
                  fontSize: 9.5,
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

  // ============================================================
  // FOOD CONTENT
  // ============================================================

  Widget _buildFoodContent() {
    final foods = filteredFoods;

    if (foods.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      physics:
          const BouncingScrollPhysics(),
      padding:
          const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        130,
      ),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.76,
      ),
      itemCount: foods.length,
      itemBuilder: (
        context,
        index,
      ) {
        final food = foods[index];

        final selected =
            selectedIds.contains(
          food.id,
        );

        return FoodCard(
          food: food,
          selected: selected,
          onTap: () {
            _toggleFood(food);
          },
        );
      },
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 35,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration:
                  const BoxDecoration(
                color: Color(0xFFF0ECFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                color: primary,
                size: 31,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'لم نجد هذا الطعام',
              style: TextStyle(
                fontSize: 15,
                fontWeight:
                    FontWeight.w900,
                color:
                    Color(0xFF18182B),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              query.trim().isEmpty
                  ? 'جرّب اختيار تصنيف آخر.'
                  : 'يمكنك إضافة هذا الطعام إلى مكتبتك لاحقًا.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color:
                    Color(0xFF85899D),
                fontSize: 10,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            if (query.trim().isNotEmpty)
              OutlinedButton.icon(
                onPressed:
                    _showAddFoodMessage,
                icon: const Icon(
                  Icons.add_rounded,
                  size: 18,
                ),
                label: const Text(
                  'إضافة طعام جديد',
                ),
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
                      15,
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
  // BOTTOM BAR
  // ============================================================

  Widget _buildBottomBar() {
    final count =
        selectedIds.length;

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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    '$count مكونات مختارة',
                    style:
                        const TextStyle(
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w900,
                      color:
                          Color(0xFF18182B),
                    ),
                  ),
                  const SizedBox(
                      height: 3),
                  Text(
                    count == 0
                        ? 'اختر الأطعمة التي تريد بناء الوجبة منها'
                        : 'جاهز للانتقال إلى بناء الوجبة',
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      color:
                          Color(0xFF85899D),
                      fontSize: 8.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 51,
              child: FilledButton(
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
                    horizontal: 20,
                  ),
                ),
                onPressed:
                    count == 0
                        ? null
                        : _continueToBuilder,
                child:
                    const Text(
                  'ابدأ البناء',
                  style: TextStyle(
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
  // ACTIONS
  // ============================================================

  void _toggleFood(Food food) {
    setState(() {
      if (selectedIds.contains(
        food.id,
      )) {
        selectedIds.remove(
          food.id,
        );
      } else {
        selectedIds.add(
          food.id,
        );
      }
    });
  }

  void _continueToBuilder() {
    final selectedFoods =
        foodDatabase.where(
      (food) {
        return selectedIds.contains(
          food.id,
        );
      },
    ).toList();

    if (selectedFoods.isEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            MealBuilderScreen(
          mealType:
              widget.mealType,
          time:
              widget.time,
          plan:
              widget.plan,
          foods:
              selectedFoods,
        ),
      ),
    );
  }

  void _showAddFoodMessage() {
    ScaffoldMessenger.of(
      context,
    )
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior:
              SnackBarBehavior.floating,
          content: Text(
            'سيتم إضافة "$query" إلى مكتبة الأطعمة في المرحلة التالية.',
          ),
        ),
      );
  }
}