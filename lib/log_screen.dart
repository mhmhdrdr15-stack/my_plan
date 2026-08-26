import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'add_food_screen.dart';
import 'app_bottom_nav.dart';
import 'app_localization.dart';
import 'app_state.dart';
import 'widgets/log_sync_button.dart';
import 'screens/log/food_log_history_page.dart';
import 'plan_screen.dart';
import 'progress_screen.dart';
import 'reusable_widgets.dart';

class LogFoodScreen extends StatefulWidget {
  final bool showBottomNav;

  const LogFoodScreen({super.key, this.showBottomNav = true});

  @override
  State<LogFoodScreen> createState() => _LogFoodScreenState();
}

class _LogFoodScreenState extends State<LogFoodScreen> {
  static const purple = Color(0xFF5146F5);
  static const dark = Color(0xFF111B3A);
  static const secondary = Color(0xFF63708F);

  final foods = const [
    _FoodData(
      'Grilled Chicken',
      '200 g',
      '330 kcal',
      '52g protein  |  6g fat  |  0g carbs',
      Icons.restaurant_rounded,
      'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=300&q=80',
    ),
    _FoodData(
      'White Rice',
      '150 g',
      '195 kcal',
      '4g protein  |  0.4g fat  |  42g carbs',
      Icons.rice_bowl_rounded,
      'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=300&q=80',
    ),
    _FoodData(
      'Mixed Salad',
      '100 g',
      '80 kcal',
      '2g protein  |  4g fat  |  6g carbs',
      Icons.eco_rounded,
      'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300&q=80',
    ),
    _FoodData(
      'Olive Oil',
      '10 g',
      '90 kcal',
      '0g protein  |  10g fat  |  0g carbs',
      Icons.water_drop_outlined,
      'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300&q=80',
    ),
  ];

  final suggestions = const [
    _Suggestion(
      'Greek Yogurt',
      '150 g',
      '120 kcal',
      'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=300&q=80',
    ),
    _Suggestion(
      'Banana',
      '1 medium',
      '105 kcal',
      'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=300&q=80',
    ),
    _Suggestion(
      'Almonds',
      '20 g',
      '120 kcal',
      'https://images.unsplash.com/photo-1508061253366-f7da158b6d46?w=300&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFE),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 125),
              children: [
                _header(),
                const SizedBox(height: 22),
                _searchBar(),
                const SizedBox(height: 20),
                _quickActions(),
                const SizedBox(height: 22),
                _summaryCard(),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: appState,
                  builder: (context, _) => Row(
                    children: [
                      const Text(
                        'Logged Today',
                        style: TextStyle(
                          color: Color(0xFF17203A),
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${appState.loggedFoods} ${translateText(context, 'items')}  |  1,610 Kcal',
                        style: const TextStyle(
                          color: secondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: _openFoodLogHistory,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF5B35F5),
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(Icons.chevron_right_rounded, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _foodList(),
                const SizedBox(height: 14),
                _addFoodButton(),
                const SizedBox(height: 25),
                _sectionHeader(
                  'Suggestions for you',
                  'See all',
                  _openFoodLogHistory,
                ),
                const SizedBox(height: 12),
                _suggestionList(),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.showBottomNav
          ? AppBottomNav(
              currentIndex: 2,
              onItemSelected: _navigateTo,
              onAdd: _openAddFood,
            )
          : null,
    );
  }

  void _openAddFood() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AddFoodScreen()));
  }

  Future<void> _syncLog() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() {});
  }

  void _openFoodLogHistory() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const FoodLogHistoryPage()));
  }

  void _navigateTo(int index) {
    if (index == 2) return;
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }
    final destination = switch (index) {
      1 => const PlanScreen(),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translateText(context, 'Log Food'),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: dark,
                ),
              ),
              SizedBox(height: 3),
              Text(
                translateText(context, 'Track what you eat'),
                style: TextStyle(fontSize: 16, color: secondary),
              ),
            ],
          ),
        ),
        LogSyncButton(onSync: _syncLog),
        const SizedBox(width: 7),
        IconButton(
          onPressed: _openFoodLogHistory,
          icon: const Icon(Icons.history_rounded, size: 28, color: dark),
          tooltip: translateText(context, 'History'),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 27, color: secondary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              translateText(context, 'Search for a food, brand or meal'),
              style: TextStyle(color: secondary, fontSize: 14),
            ),
          ),
          Icon(Icons.qr_code_scanner_rounded, color: purple, size: 24),
        ],
      ),
    );
  }

  Widget _quickActions() {
    const actions = [
      _ActionData(Icons.qr_code_scanner_rounded, 'Barcode', purple),
      _ActionData(Icons.camera_alt_outlined, 'Scan Meal', Color(0xFF1EAE5A)),
      _ActionData(Icons.bolt_rounded, 'Quick Add', Color(0xFFFFA600)),
      _ActionData(Icons.history_rounded, 'Recent', Color(0xFF3388F5)),
    ];
    return Row(
      children: [
        for (var i = 0; i < actions.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == actions.length - 1 ? 0 : 8),
              child: _quickAction(actions[i]),
            ),
          ),
      ],
    );
  }

  Widget _quickAction(_ActionData action) {
    return Container(
      height: 92,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F1F5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(action.icon, color: action.color, size: 25),
          const SizedBox(height: 7),
          Text(
            translateText(context, action.title),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: dark,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F1F5)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 128,
            height: 128,
            child: CustomPaint(
              painter: _CaloriesPainter(progress: 1200 / 1800),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xFFFF6428),
                    size: 22,
                  ),
                  SizedBox(height: 2),
                  Text(
                    '1,200',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: dark,
                    ),
                  ),
                  Text(
                    'of 1,800 kcal',
                    style: TextStyle(fontSize: 9, color: secondary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              children: [
                _macroRow(
                  'Protein',
                  '85 / 130 g',
                  .65,
                  const Color(0xFFFF3548),
                ),
                const SizedBox(height: 14),
                _macroRow('Carbs', '120 / 180 g', .67, const Color(0xFF347AF5)),
                const SizedBox(height: 14),
                _macroRow('Fats', '40 / 60 g', .67, const Color(0xFF20B65C)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _macroRow(String title, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                translateText(context, title),
                style: const TextStyle(
                  fontSize: 12,
                  color: dark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 10, color: secondary)),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: progress,
          minHeight: 5,
          color: color,
          backgroundColor: const Color(0xFFE9EAEE),
        ),
      ],
    );
  }

  Widget _sectionHeader(
    String title,
    String trailing, [
    VoidCallback? onTrailing,
  ]) {
    return Row(
      children: [
        Expanded(
          child: Text(
            translateText(context, title),
            style: const TextStyle(
              color: dark,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        onTrailing == null
            ? Text(
                translateText(context, trailing),
                style: const TextStyle(
                  color: secondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              )
            : TextButton(
                onPressed: onTrailing,
                style: TextButton.styleFrom(
                  foregroundColor: secondary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  translateText(context, trailing),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _foodList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0F1F5)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < foods.length; i++)
            _foodItem(foods[i], i == foods.length - 1),
        ],
      ),
    );
  }

  Widget _foodItem(_FoodData food, bool last) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFE8E9ED))),
      ),
      child: Row(
        children: [
          AppNetworkImage(
            url: food.imageUrl,
            fallback: food.icon,
            width: 66,
            height: 66,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translateText(context, food.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: dark,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  translateText(context, food.amount),
                  style: const TextStyle(color: secondary, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  translateText(context, food.details),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: secondary, fontSize: 9),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                food.kcal,
                style: const TextStyle(
                  color: dark,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 15),
              const Icon(Icons.more_horiz_rounded, size: 17, color: dark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addFoodButton() {
    return OutlinedButton.icon(
      onPressed: _openAddFood,
      icon: const Icon(Icons.add_rounded, size: 20),
      label: Text(translateText(context, 'Add More Food')),
      style: OutlinedButton.styleFrom(
        foregroundColor: purple,
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: purple),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _suggestionList() {
    return SizedBox(
      height: 178,
      child: Row(
        children: [
          for (var i = 0; i < suggestions.length; i++)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: i == suggestions.length - 1 ? 0 : 8,
                ),
                child: _suggestionCard(suggestions[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _suggestionCard(_Suggestion item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FB),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppNetworkImage(
            url: item.imageUrl,
            fallback: Icons.fastfood_rounded,
            width: double.infinity,
            height: 92,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 7, 5, 0),
            child: Text(
              translateText(context, item.name),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: dark,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 3, 5, 0),
            child: Text(
              item.amount,
              style: const TextStyle(color: secondary, fontSize: 9),
            ),
          ),
          const Spacer(),
          Container(
            height: 32,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Text(
                  item.kcal,
                  style: const TextStyle(
                    color: dark,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.add_circle_outline_rounded,
                  color: purple,
                  size: 17,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CaloriesPainter extends CustomPainter {
  final double progress;

  _CaloriesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 7;
    final background = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFF1E8E4);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      math.pi * 2,
      false,
      background,
    );
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0xFFFF5B24), Color(0xFFFFB000)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CaloriesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _ActionData {
  final IconData icon;
  final String title;
  final Color color;

  const _ActionData(this.icon, this.title, this.color);
}

class _FoodData {
  final String name;
  final String amount;
  final String kcal;
  final String details;
  final IconData icon;
  final String imageUrl;

  const _FoodData(
    this.name,
    this.amount,
    this.kcal,
    this.details,
    this.icon,
    this.imageUrl,
  );
}

class _Suggestion {
  final String name;
  final String amount;
  final String kcal;
  final String imageUrl;

  const _Suggestion(this.name, this.amount, this.kcal, this.imageUrl);
}
