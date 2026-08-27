import 'package:flutter/material.dart';
import 'package:my_plan/core/navigation/app_bottom_nav.dart';
import 'package:my_plan/core/localization/app_localization.dart';
import 'package:my_plan/core/state/app_state.dart';
import 'package:my_plan/features/food_log/pages/log_screen.dart';
import 'package:my_plan/features/plan/pages/plan_screen.dart';
import 'package:my_plan/features/nutrition/pages/progress_screen.dart';
import 'package:my_plan/core/widgets/reusable_widgets.dart';

class AddFoodScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigate;

  const AddFoodScreen({super.key, this.onNavigate});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  static const purple = Color(0xFF5930FF);
  static const navy = Color(0xFF111A35);
  static const muted = Color(0xFF63708C);
  static const softPurple = Color(0xFFF2EEFF);

  final searchController = TextEditingController();
  String query = '';
  final recentSearches = [
    'Chicken breast',
    'Brown rice',
    'Greek yogurt',
    'Banana',
  ];
  int servingSize = 100;
  double servings = 1;
  _Food selectedFood = foods[0];

  static const foods = [
    _Food(
      'Chicken Breast (Grilled)',
      'Generic',
      '100 g',
      '165 kcal',
      '31g P  •  0g C  •  3.6g F',
      'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=300&q=80',
    ),
    _Food(
      'Brown Rice (Cooked)',
      'Generic',
      '100 g',
      '112 kcal',
      '2.6g P  •  23g C  •  0.9g F',
      'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=300&q=80',
    ),
    _Food(
      'Greek Yogurt 0%',
      'Fage',
      '170 g',
      '100 kcal',
      '17g P  •  6g C  •  0g F',
      'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=300&q=80',
    ),
    _Food(
      'Banana',
      'Generic',
      '1 medium (118 g)',
      '105 kcal',
      '1g P  •  27g C  •  0g F',
      'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=300&q=80',
    ),
    _Food(
      'Almonds',
      'Blue Diamond',
      '28 g',
      '160 kcal',
      '6g P  •  6g C  •  14g F',
      'https://images.unsplash.com/photo-1508061253366-f7da158b6d46?w=300&q=80',
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$feature is coming soon'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  List<_Food> get filteredFoods {
    if (query.trim().isEmpty) return foods;
    final text = query.toLowerCase();
    return foods
        .where(
          (food) => '${food.name} ${food.brand}'.toLowerCase().contains(text),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 275),
              children: [
                _header(),
                const SizedBox(height: 18),
                _searchBar(),
                const SizedBox(height: 16),
                _quickActions(),
                const SizedBox(height: 26),
                if (recentSearches.isNotEmpty) ...[
                  _recent(),
                  const SizedBox(height: 25),
                ],
                _favorites(),
                const SizedBox(height: 26),
                _results(),
              ],
            ),
            _selectionSheet(),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onItemSelected: _navigateTo,
        onAdd: () {},
      ),
    );
  }

  void _navigateTo(int index) {
    if (widget.onNavigate != null) {
      widget.onNavigate!(index);
      return;
    }
    if (index == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    final destination = switch (index) {
      1 => const PlanScreen(),
      2 => const LogFoodScreen(),
      3 => const ProgressScreen(),
      _ => null,
    };
    if (destination != null) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => destination));
    }
  }

  Widget _header() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navy),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translateText(context, 'Add Food'),
                style: TextStyle(
                  color: navy,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 5),
              Text(
                translateText(context, 'Search and add food to your log.'),
                style: TextStyle(color: muted, fontSize: 13),
              ),
            ],
          ),
        ),
        TextButton.icon(
          onPressed: () => _showComingSoon('Scan'),
          icon: const Icon(Icons.barcode_reader, size: 20),
          label: Text(
            translateText(context, 'Scan'),
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          style: TextButton.styleFrom(
            foregroundColor: purple,
            backgroundColor: softPurple,
          ),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: muted, size: 25),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (value) => setState(() => query = value),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: translateText(
                  context,
                  'Search for a food, brand or meal',
                ),
                hintStyle: TextStyle(color: muted, fontSize: 13),
              ),
            ),
          ),
          const Icon(Icons.tune_rounded, color: purple, size: 24),
        ],
      ),
    );
  }

  Widget _quickActions() {
    const actions = [
      (Icons.bolt_rounded, 'Quick Add', Colors.orange),
      (Icons.spa_rounded, 'My Foods', Colors.green),
      (Icons.restaurant_rounded, 'Meals', Colors.blue),
      (Icons.sell_outlined, 'Brands', purple),
    ];
    return Row(
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(
              onTap: () => _showComingSoon(action.$2),
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 84,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0C15203A),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(action.$1, color: action.$3, size: 27),
                    const SizedBox(height: 8),
                    Text(
                      translateText(context, action.$2),
                      style: const TextStyle(
                        color: navy,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _recent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          translateText(context, 'Recent Searches'),
          translateText(context, 'Clear all'),
          () => setState(() => recentSearches.clear()),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: recentSearches.map((item) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InputChip(
                  label: Text(translateText(context, item)),
                  avatar: const Icon(
                    Icons.schedule_rounded,
                    size: 16,
                    color: muted,
                  ),
                  onDeleted: () => setState(() => recentSearches.remove(item)),
                  backgroundColor: softPurple,
                  side: BorderSide.none,
                  labelStyle: const TextStyle(
                    color: navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _favorites() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          translateText(context, 'Your Favorites'),
          translateText(context, 'See all'),
          () => _showComingSoon('Favorites'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final food =
                  foods[index == 0
                      ? 3
                      : index == 1
                      ? 2
                      : index == 2
                      ? 4
                      : 1];
              return SizedBox(width: 142, child: _favoriteCard(food));
            },
          ),
        ),
      ],
    );
  }

  Widget _favoriteCard(_Food food) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0E121A2D),
            blurRadius: 11,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppNetworkImage(
            url: food.image,
            fallback: Icons.restaurant_rounded,
            width: double.infinity,
            height: 88,
            radius: 14,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(9, 8, 8, 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translateText(context, food.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  food.amount,
                  style: const TextStyle(color: muted, fontSize: 10.5),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        food.calories,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.add_circle_outline_rounded,
                      color: purple,
                      size: 22,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _results() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          query.isEmpty
              ? translateText(context, 'Search Results')
              : '${translateText(context, 'Search Results')}: "$query"',
          style: const TextStyle(
            color: navy,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C121A2C),
                blurRadius: 13,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: filteredFoods.map(_resultRow).toList()),
        ),
      ],
    );
  }

  Widget _resultRow(_Food food) {
    return InkWell(
      onTap: () => setState(() {
        selectedFood = food;
        servingSize = 100;
        servings = 1;
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            AppNetworkImage(
              url: food.image,
              fallback: Icons.restaurant_rounded,
              width: 48,
              height: 48,
              radius: 8,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translateText(context, food.name),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${translateText(context, food.brand)}  •  ${food.amount}',
                    style: const TextStyle(color: muted, fontSize: 10.5),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  food.calories,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  food.macros,
                  style: const TextStyle(color: muted, fontSize: 8.5),
                ),
              ],
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.add_circle_outline_rounded,
              color: purple,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectionSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A121629),
              blurRadius: 24,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD2D5DF),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                AppNetworkImage(
                  url: selectedFood.image,
                  fallback: Icons.restaurant_rounded,
                  width: 48,
                  height: 48,
                  radius: 9,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translateText(context, selectedFood.name),
                        style: TextStyle(
                          color: navy,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${translateText(context, selectedFood.brand)}  •  ${selectedFood.amount}',
                        style: TextStyle(color: muted, fontSize: 10.5),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${selectedFood.calories.replaceFirst(' kcal', '')}\nkcal',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 15,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _miniPortion(
                  'Serving Size',
                  '$servingSize g',
                  () => setState(
                    () => servingSize = (servingSize - 25).clamp(25, 1000),
                  ),
                  () => setState(() => servingSize += 25),
                ),
                const SizedBox(width: 9),
                _miniPortion(
                  'Number of Servings',
                  servings.toStringAsFixed(1),
                  () =>
                      setState(() => servings = (servings - .5).clamp(.5, 20)),
                  () => setState(() => servings += .5),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: () async {
                  await appState.addFood(
                    name: selectedFood.name,
                    mealType: 'Lunch',
                    amount: '$servingSize g',
                    calories:
                        '${selectedFood.calories.replaceFirst(' kcal', '')} kcal',
                  );
                  if (mounted) Navigator.pop(context);
                },
                icon: const Icon(Icons.check_rounded),
                label: Text(
                  translateText(context, 'Add to Lunch'),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniPortion(
    String title,
    String value,
    VoidCallback minus,
    VoidCallback plus,
  ) {
    return Expanded(
      child: Container(
        height: 78,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE8E9F0)),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translateText(context, title),
              style: const TextStyle(
                color: navy,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                _control(Icons.remove_rounded, minus, false),
                const Spacer(),
                Text(
                  value,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                _control(Icons.add_rounded, plus, true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _control(IconData icon, VoidCallback onTap, bool filled) => InkWell(
    onTap: onTap,
    customBorder: const CircleBorder(),
    child: Container(
      width: 27,
      height: 27,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? purple : softPurple,
      ),
      child: Icon(icon, color: filled ? Colors.white : purple, size: 17),
    ),
  );

  Widget _sectionTitle(String title, String action, VoidCallback onTap) => Row(
    children: [
      Text(
        title,
        style: const TextStyle(
          color: navy,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
      const Spacer(),
      GestureDetector(
        onTap: onTap,
        child: Text(
          action,
          style: const TextStyle(
            color: purple,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ],
  );
}

class _Food {
  final String name;
  final String brand;
  final String amount;
  final String calories;
  final String macros;
  final String image;

  const _Food(
    this.name,
    this.brand,
    this.amount,
    this.calories,
    this.macros,
    this.image,
  );
}
