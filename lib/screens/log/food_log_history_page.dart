import 'package:flutter/material.dart';

class HistoryFood {
  final String id;
  final String name;
  final String meal;
  final String time;
  final int grams;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  const HistoryFood({
    required this.id,
    required this.name,
    required this.meal,
    required this.time,
    required this.grams,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}

class FoodLogHistoryPage extends StatefulWidget {
  const FoodLogHistoryPage({super.key});

  @override
  State<FoodLogHistoryPage> createState() => _FoodLogHistoryPageState();
}

class _FoodLogHistoryPageState extends State<FoodLogHistoryPage> {
  String selectedFilter = 'All';
  String searchQuery = '';

  final foods = const [
    HistoryFood(
      id: '1',
      name: 'Egg',
      meal: 'Breakfast',
      time: '08:00 AM',
      grams: 100,
      calories: 143,
      protein: 13,
      carbs: 1,
      fat: 10,
    ),
    HistoryFood(
      id: '2',
      name: 'Whole Wheat Bread',
      meal: 'Breakfast',
      time: '08:00 AM',
      grams: 60,
      calories: 150,
      protein: 6,
      carbs: 25,
      fat: 2,
    ),
    HistoryFood(
      id: '3',
      name: 'Chicken Breast',
      meal: 'Lunch',
      time: '02:00 PM',
      grams: 200,
      calories: 330,
      protein: 62,
      carbs: 0,
      fat: 7,
    ),
    HistoryFood(
      id: '4',
      name: 'White Rice',
      meal: 'Lunch',
      time: '02:00 PM',
      grams: 150,
      calories: 195,
      protein: 4,
      carbs: 42,
      fat: 0,
    ),
    HistoryFood(
      id: '5',
      name: 'Mixed Salad',
      meal: 'Lunch',
      time: '02:00 PM',
      grams: 100,
      calories: 35,
      protein: 2,
      carbs: 7,
      fat: 0,
    ),
    HistoryFood(
      id: '6',
      name: 'Apple',
      meal: 'Snack',
      time: '05:30 PM',
      grams: 150,
      calories: 78,
      protein: 0,
      carbs: 21,
      fat: 0,
    ),
    HistoryFood(
      id: '7',
      name: 'Almonds',
      meal: 'Snack',
      time: '05:30 PM',
      grams: 20,
      calories: 120,
      protein: 4,
      carbs: 4,
      fat: 10,
    ),
    HistoryFood(
      id: '8',
      name: 'Tuna',
      meal: 'Dinner',
      time: '08:30 PM',
      grams: 120,
      calories: 140,
      protein: 31,
      carbs: 0,
      fat: 1,
    ),
  ];

  List<HistoryFood> get filteredFoods {
    final query = searchQuery.trim().toLowerCase();
    return foods.where((food) {
      final filterMatches =
          selectedFilter == 'All' || food.meal == selectedFilter;
      final searchMatches =
          query.isEmpty ||
          food.name.toLowerCase().contains(query) ||
          food.meal.toLowerCase().contains(query);
      return filterMatches && searchMatches;
    }).toList();
  }

  int _total(int Function(HistoryFood food) value) =>
      filteredFoods.fold(0, (sum, food) => sum + value(food));

  @override
  Widget build(BuildContext context) {
    const mealOrder = ['Breakfast', 'Lunch', 'Snack', 'Dinner'];
    return Scaffold(
      backgroundColor: HistoryColors.background,
      appBar: AppBar(
        backgroundColor: HistoryColors.background,
        elevation: 0,
        title: const Text(
          'Food Log History',
          style: TextStyle(
            color: HistoryColors.text,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          color: HistoryColors.text,
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        children: [
          _dateSelector(),
          const SizedBox(height: 12),
          _summary(),
          const SizedBox(height: 14),
          _search(),
          const SizedBox(height: 11),
          _filters(),
          const SizedBox(height: 16),
          if (filteredFoods.isEmpty)
            const _EmptyHistory()
          else
            for (final meal in mealOrder)
              if (filteredFoods.any((food) => food.meal == meal)) ...[
                _mealSection(
                  meal,
                  filteredFoods.where((food) => food.meal == meal).toList(),
                ),
                const SizedBox(height: 14),
              ],
        ],
      ),
    );
  }

  Widget _dateSelector() => Container(
    height: 54,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: const Color(0xFFEFF1F5)),
    ),
    child: const Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          color: HistoryColors.primary,
          size: 18,
        ),
        SizedBox(width: 9),
        Expanded(
          child: Text(
            'Sunday, 23 August 2026',
            style: TextStyle(
              color: HistoryColors.text,
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Icon(Icons.chevron_left_rounded, color: HistoryColors.muted2),
        Icon(Icons.chevron_right_rounded, color: HistoryColors.muted2),
      ],
    ),
  );

  Widget _summary() => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFEFF1F5)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x09000000),
          blurRadius: 18,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            const Text(
              'Today',
              style: TextStyle(
                color: HistoryColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Text(
              '${filteredFoods.length} foods',
              style: const TextStyle(
                color: HistoryColors.muted,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),
        Row(
          children: [
            _summaryValue(
              Icons.local_fire_department_rounded,
              '${_total((food) => food.calories)}',
              'kcal',
              'Calories',
              HistoryColors.orange,
            ),
            _summaryValue(
              Icons.favorite_rounded,
              '${_total((food) => food.protein)}',
              'g',
              'Protein',
              HistoryColors.red,
            ),
            _summaryValue(
              Icons.rice_bowl_rounded,
              '${_total((food) => food.carbs)}',
              'g',
              'Carbs',
              HistoryColors.blue,
            ),
            _summaryValue(
              Icons.eco_rounded,
              '${_total((food) => food.fat)}',
              'g',
              'Fat',
              HistoryColors.green,
            ),
          ],
        ),
      ],
    ),
  );

  Widget _summaryValue(
    IconData icon,
    String value,
    String unit,
    String label,
    Color color,
  ) => Expanded(
    child: Column(
      children: [
        Container(
          width: 31,
          height: 31,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: HistoryColors.text,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(
            color: HistoryColors.muted,
            fontSize: 8.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: HistoryColors.muted2, fontSize: 8.5),
        ),
      ],
    ),
  );

  Widget _search() => TextField(
    onChanged: (value) => setState(() => searchQuery = value),
    decoration: const InputDecoration(
      hintText: 'Search logged food...',
      prefixIcon: Icon(
        Icons.search_rounded,
        color: HistoryColors.muted,
        size: 21,
      ),
    ),
  );

  Widget _filters() {
    const filters = ['All', 'Breakfast', 'Lunch', 'Snack', 'Dinner'];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 7),
        itemBuilder: (_, index) {
          final filter = filters[index];
          final active = selectedFilter == filter;
          return GestureDetector(
            onTap: () => setState(() => selectedFilter = filter),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? HistoryColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: active
                      ? HistoryColors.primary
                      : const Color(0xFFE8EAF0),
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: active ? Colors.white : HistoryColors.muted,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _mealSection(String meal, List<HistoryFood> mealFoods) => Container(
    padding: const EdgeInsets.fromLTRB(14, 13, 14, 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: const Color(0xFFEFF1F5)),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Text(mealEmoji(meal), style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal,
                    style: const TextStyle(
                      color: HistoryColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${mealFoods.first.time} • ${mealFoods.length} foods',
                    style: const TextStyle(
                      color: HistoryColors.muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${mealFoods.fold(0, (sum, food) => sum + food.calories)} kcal',
              style: const TextStyle(
                color: HistoryColors.text,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const Divider(height: 16, color: Color(0xFFEEF0F4)),
        for (final food in mealFoods)
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: const Icon(
              Icons.restaurant_rounded,
              color: HistoryColors.muted,
            ),
            title: Text(
              food.name,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              '${food.grams} g',
              style: const TextStyle(color: HistoryColors.muted, fontSize: 9.5),
            ),
            trailing: Text(
              '${food.calories} kcal',
              style: const TextStyle(
                color: HistoryColors.muted,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () => _showDetails(food),
          ),
      ],
    ),
  );

  String mealEmoji(String meal) => switch (meal) {
    'Breakfast' => '🍳',
    'Lunch' => '🍗',
    'Snack' => '🍎',
    'Dinner' => '🥗',
    _ => '🍽️',
  };

  void _showDetails(HistoryFood food) => showModalBottomSheet<void>(
    context: context,
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              food.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text('${food.grams} g • ${food.meal} • ${food.time}'),
            const SizedBox(height: 14),
            Text(
              '${food.calories} kcal  •  ${food.protein}g protein  •  ${food.carbs}g carbs  •  ${food.fat}g fat',
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ),
  );
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();
  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(40),
      child: Text(
        'No food found',
        style: TextStyle(
          color: HistoryColors.text,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}

class HistoryColors {
  static const background = Color(0xFFF7F8FC);
  static const text = Color(0xFF17203A);
  static const muted = Color(0xFF7B849A);
  static const muted2 = Color(0xFFA0A8B8);
  static const primary = Color(0xFF5B35F5);
  static const orange = Color(0xFFFF8A16);
  static const red = Color(0xFFFF3E4B);
  static const blue = Color(0xFF467BFF);
  static const green = Color(0xFF2DAA61);
}
