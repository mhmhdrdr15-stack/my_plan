import 'package:flutter/material.dart';
import 'package:my_plan/core/localization/app_localization.dart';
import 'package:my_plan/core/state/app_state.dart';
import 'package:my_plan/core/theme/app_colors.dart';
import 'package:my_plan/core/widgets/reusable_widgets.dart';
import 'package:my_plan/features/nutrition/pages/snack_details_screen.dart';
import 'package:my_plan/features/nutrition/pages/today_details_screen.dart';
import 'package:my_plan/features/settings/pages/settings_screen.dart';
import 'package:my_plan/features/home/widgets/next_meal_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void addWater(double amount) {
    appState.addWater(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const HeaderSection(),
                        const SizedBox(height: 14),
                        const TodayProgressCard(),
                        const SizedBox(height: 12),
                        AnimatedBuilder(
                          animation: appState,
                          builder: (context, _) => InsightWaterSection(
                            water: appState.water,
                            waterGoal: appState.waterGoal,
                            onAddWater: addWater,
                          ),
                        ),
                        NextMealCard(
                          mealName: 'Snack',
                          time: '5:30 PM',
                          foods: const [
                            MealFood(name: 'Apple', grams: 150),
                            MealFood(name: 'Almonds', grams: 20),
                          ],
                          calories: 200,
                          protein: 5,
                          remainingCalories: 600,
                          status: NextMealStatus.planned,
                          imageAsset: 'assets/food/apple.jpg',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const SnackDetailsScreen(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const TodayPlanCard(),
                        const SizedBox(height: 180),
                      ]),
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
}

// ===============================================================
// HEADER
// ===============================================================

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translateText(context, 'Good morning, Mahmoud \u{1F44B}'),
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  translateText(context, 'Sunday, 23 August'),
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            key: const ValueKey('open-settings'),
            tooltip: translateText(context, 'Settings'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SettingsScreen(),
              ),
            ),
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.text,
            ),
          ),
      /*
      enum NextMealStatus { planned, logged, skipped, overdue }

      class MealFood {
        final String name;
        final int grams;

        const MealFood({required this.name, required this.grams});
      }

      class NextMealCard extends StatefulWidget {
        final String mealName;
        final String time;
        final List<MealFood> foods;
        final int calories;
        final int protein;
        final int remainingCalories;
        final NextMealStatus status;
        final String imageAsset;
        final VoidCallback? onTap;

        const NextMealCard({
          super.key,
          required this.mealName,
          required this.time,
          required this.foods,
          required this.calories,
          required this.protein,
          required this.remainingCalories,
          required this.status,
          required this.imageAsset,
          this.onTap,
        });

        @override
        State<NextMealCard> createState() => _NextMealCardState();
      }

      class _NextMealCardState extends State<NextMealCard> {
        bool logged = false;

        String get foodsSummary {
          if (widget.foods.isEmpty) return 'No foods planned';
          final visibleFoods = widget.foods.take(2).map(
            (food) => '${translateText(context, food.name)} ${food.grams}g',
          );
          final summary = visibleFoods.join(' • ');
          return widget.foods.length > 2
              ? '$summary • +${widget.foods.length - 2} ${translateText(context, 'more')}'
              : summary;
        }

        Future<void> _markAsEaten() async {
          if (logged || widget.status == NextMealStatus.logged) return;
          setState(() => logged = true);
          await appState.addFood(
            name: widget.mealName,
            mealType: widget.mealName,
            amount: '1 serving',
            calories: '${widget.calories} kcal',
          );
        }

        @override
        Widget build(BuildContext context) {
          final currentStatus = logged ? NextMealStatus.logged : widget.status;
          final statusColor = switch (currentStatus) {
            NextMealStatus.planned => const Color(0xFF6B5CE7),
            NextMealStatus.logged => const Color(0xFF2DAA61),
            NextMealStatus.skipped => const Color(0xFFFF3E4B),
            NextMealStatus.overdue => const Color(0xFFE88413),
          };
          final statusBackground = switch (currentStatus) {
            NextMealStatus.planned => const Color(0xFFF0EEFF),
            NextMealStatus.logged => const Color(0xFFEAF8EF),
            NextMealStatus.skipped => const Color(0xFFFFEEF0),
            NextMealStatus.overdue => const Color(0xFFFFF3E7),
          };
          final statusIcon = switch (currentStatus) {
            NextMealStatus.planned => Icons.circle_outlined,
            NextMealStatus.logged => Icons.check_circle_rounded,
            NextMealStatus.skipped => Icons.cancel_rounded,
            NextMealStatus.overdue => Icons.error_rounded,
          };
          final statusText = switch (currentStatus) {
            NextMealStatus.planned => 'Planned',
            NextMealStatus.logged => 'Logged',
            NextMealStatus.skipped => 'Skipped',
            NextMealStatus.overdue => 'Overdue',
          };

          return GestureDetector(
            onTap: widget.onTap,
            child: AppCard(
              color: currentStatus == NextMealStatus.logged
                  ? const Color(0xFFF1FAF5)
                  : Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        translateText(context, 'Next Meal'),
                        style: const TextStyle(
                          color: Color(0xFF1F2842),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right_rounded, size: 22),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          widget.imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.restaurant_rounded, size: 27),
                          ),
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    translateText(context, widget.mealName),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.text,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.time,
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              foodsSummary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 11,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              '${widget.calories} kcal • ${widget.protein} g protein',
                              style: const TextStyle(
                                color: Color(0xFF4D5569),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: statusBackground,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(statusIcon, color: statusColor, size: 13),
                                  const SizedBox(width: 4),
                                  Text(
                                    translateText(context, statusText),
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 11),
                  Container(
                    width: double.infinity,
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F1FF),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bar_chart_rounded, color: Color(0xFF6953E9)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${widget.remainingCalories} kcal ${translateText(context, 'remaining')}',
                            style: const TextStyle(
                              color: Color(0xFF242B40),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                          child: FilledButton.icon(
                            key: const ValueKey('next-meal-mark-eaten'),
                            onPressed: currentStatus == NextMealStatus.planned
                                ? _markAsEaten
                                : null,
                            icon: Icon(
                              currentStatus == NextMealStatus.logged
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.check_rounded,
                              size: 15,
                            ),
                            label: Text(
                              translateText(
                                context,
                                currentStatus == NextMealStatus.logged
                                    ? 'Eaten'
                                    : 'Mark as eaten',
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF1FA05C),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              textStyle: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
      }
      */
        ],
      ),
    );
  }
}

enum LegacyNextMealStatus { planned, logged, skipped, overdue }

class LegacyMealFood {
  final String name;
  final int grams;

  const LegacyMealFood({required this.name, required this.grams});
}

class LegacyNextMealCard extends StatefulWidget {
  final String mealName;
  final String time;
  final List<LegacyMealFood> foods;
  final int calories;
  final int protein;
  final int remainingCalories;
  final LegacyNextMealStatus status;
  final String imageAsset;
  final VoidCallback? onTap;

  const LegacyNextMealCard({
    super.key,
    required this.mealName,
    required this.time,
    required this.foods,
    required this.calories,
    required this.protein,
    required this.remainingCalories,
    required this.status,
    required this.imageAsset,
    this.onTap,
  });

  @override
  State<LegacyNextMealCard> createState() => _LegacyNextMealCardState();
}

class _LegacyNextMealCardState extends State<LegacyNextMealCard> {
  bool logged = false;

  Future<void> _markAsEaten() async {
    if (logged || widget.status == LegacyNextMealStatus.logged) return;
    setState(() => logged = true);
    await appState.addFood(
      name: widget.mealName,
      mealType: widget.mealName,
      amount: '1 serving',
      calories: '${widget.calories} kcal',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLogged = logged || widget.status == LegacyNextMealStatus.logged;
    final foodsSummary = widget.foods
        .take(2)
        .map((food) => '${translateText(context, food.name)} ${food.grams}g')
        .join(' • ');
    return GestureDetector(
      onTap: widget.onTap,
      child: AppCard(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  translateText(context, 'Next Meal'),
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.imageAsset,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(
                      width: 72,
                      height: 72,
                      child: Icon(Icons.restaurant_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              translateText(context, widget.mealName),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                            ),
                          ),
                          Text(
                            widget.time,
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(foodsSummary, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                      const SizedBox(height: 6),
                      Text('${widget.calories} kcal • ${widget.protein} g protein', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 7),
                      SmallStatus(
                        text: translateText(context, isLogged ? 'Logged' : 'Planned'),
                        background: isLogged ? const Color(0xFFEAF8EF) : const Color(0xFFF0EEFF),
                        foreground: isLogged ? const Color(0xFF2DAA61) : const Color(0xFF6B5CE7),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            Container(
              padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F3FF),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        color: AppColors.primary,
                        size: 19,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          '${widget.remainingCalories} kcal ${translateText(context, 'remaining')}',
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '${((widget.remainingCalories / 1800) * 100).round()}%',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                    const SizedBox(height: 9),
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: FilledButton.icon(
                        key: const ValueKey('next-meal-mark-eaten'),
                        onPressed: isLogged ? null : _markAsEaten,
                        icon: Icon(
                          isLogged
                              ? Icons.check_circle_outline_rounded
                              : Icons.check_rounded,
                          size: 16,
                        ),
                        label: Text(
                          translateText(context, isLogged ? 'Eaten' : 'Mark as eaten'),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2DAA61),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          textStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
}

// ===============================================================
// TODAY'S PROGRESS
// ===============================================================

class TodayProgressCard extends StatelessWidget {
  const TodayProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                translateText(context, "Today's Progress"),
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              GestureDetector(
                key: const ValueKey('today-progress-details'),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const TodayDetailsScreen(),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      translateText(context, 'Details'),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.primary,
                      size: 19,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 5, child: _CalorieSummary(compact: true)),
              SizedBox(width: 12),
              SizedBox(
                height: 235,
                child: VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Color(0xFFEFF1F5),
                ),
              ),
              SizedBox(width: 12),
              Expanded(flex: 6, child: MacroProgressList()),
            ],
          ),
          const SizedBox(height: 9),
          Container(
            height: 43,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    translateText(context, 'View all nutrients'),
                    style: TextStyle(
                      color: Color(0xFF343A4E),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                    size: 19,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalorieSummary extends StatelessWidget {
  final bool compact;

  const _CalorieSummary({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final defaultSize = compact ? 132.0 : 210.0;
        final circleSize = constraints.maxWidth.isFinite
            ? constraints.maxWidth.clamp(100.0, defaultSize).toDouble()
            : defaultSize;

        return Column(
          children: [
            SizedBox(
              width: circleSize,
              height: circleSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: circleSize,
                    height: circleSize,
                    child: CircularProgressIndicator(
                      value: .67,
                      strokeWidth: compact ? 9 : 13,
                      backgroundColor: AppColors.orangeTrack,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.orange,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🔥', style: TextStyle(fontSize: 22)),
                      SizedBox(height: 3),
                      Text(
                        '1,200',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        translateText(context, 'of 1,800 kcal'),
                        style: TextStyle(
                          color: Color(0xFF8B93A5),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '600',
                    style: TextStyle(
                      color: Color(0xFF1EA55A),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: ' kcal',
                    style: TextStyle(
                      color: Color(0xFF31384D),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 1),
            Text(
              translateText(context, 'remaining'),
              style: TextStyle(
                color: Color(0xFF939AAC),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 9),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF9F3),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: Color(0xFF1F9D58),
                  ),
                  SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      translateText(context, "You're on track! 🎉"),
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF209757),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class MacroProgressList extends StatelessWidget {
  const MacroProgressList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MacroRow(
          icon: Icons.local_fire_department_rounded,
          title: translateText(context, 'Calories'),
          current: '1,200',
          goal: '1,800 kcal',
          percent: 67,
          color: AppColors.orange,
        ),
        SizedBox(height: 12),
        MacroRow(
          icon: Icons.spa_rounded,
          title: translateText(context, 'Protein'),
          current: '85',
          goal: '130 g',
          percent: 65,
          color: AppColors.red,
        ),
        SizedBox(height: 12),
        MacroRow(
          icon: Icons.rice_bowl_rounded,
          title: translateText(context, 'Carbohydrates'),
          current: '120',
          goal: '180 g',
          percent: 67,
          color: AppColors.blue,
        ),
        SizedBox(height: 12),
        MacroRow(
          icon: Icons.eco_rounded,
          title: translateText(context, 'Fats'),
          current: '40',
          goal: '60 g',
          percent: 67,
          color: AppColors.green,
        ),
      ],
    );
  }
}

class MacroRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String current;
  final String goal;
  final int percent;
  final Color color;

  const MacroRow({
    super.key,
    required this.icon,
    required this.title,
    required this.current,
    required this.goal,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final track = color == AppColors.orange
        ? AppColors.orangeTrack
        : color == AppColors.red
        ? AppColors.redTrack
        : color == AppColors.blue
        ? AppColors.blueTrack
        : AppColors.greenTrack;

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: track, shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 21),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translateText(context, title),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: current,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: ' / $goal',
                          style: const TextStyle(
                            color: AppColors.muted2,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$percent%',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 6,
            backgroundColor: track,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

// ===============================================================
// INSIGHT + WATER
// ===============================================================

class InsightWaterSection extends StatelessWidget {
  final double water;
  final double waterGoal;
  final ValueChanged<double> onAddWater;

  const InsightWaterSection({
    super.key,
    required this.water,
    required this.waterGoal,
    required this.onAddWater,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(child: InsightCard()),
          const SizedBox(width: 12),
          Expanded(
            child: WaterCard(
              current: water,
              goal: waterGoal,
              onAddWater: onAddWater,
            ),
          ),
        ],
      ),
    );
  }
}

class InsightCard extends StatelessWidget {
  const InsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.insightBg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.smart_toy_outlined,
                  size: 17,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  translateText(context, 'Daily Insight'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.more_horiz_rounded,
                color: Color(0xFF777F93),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: translateText(context, 'You need '),
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                TextSpan(
                  text: translateText(context, '~45g more protein'),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1.5,
                  ),
                ),
                TextSpan(
                  text:
                      '\n${translateText(context, 'to reach your daily goal.')}',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              FoodMiniIcon(
                icon: Icons.restaurant_rounded,
                color: Color(0xFFFFC979),
                imageUrl:
                    'https://images.unsplash.com/photo-1547592180-85f173990554?w=160&q=80',
                size: 32,
              ),
              FoodMiniIcon(
                icon: Icons.rice_bowl_rounded,
                color: Color(0xFF6EA9FF),
                imageUrl:
                    'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=160&q=80',
                size: 32,
              ),
              FoodMiniIcon(
                icon: Icons.egg_alt_outlined,
                color: Color(0xFFF7B868),
                imageUrl:
                    'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=160&q=80',
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 11),
          SizedBox(
            height: 36,
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: Color(0xFFE1D9FF)),
                backgroundColor: const Color(0xFFFBFAFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    translateText(context, 'See suggestions'),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 3),
                  Icon(Icons.chevron_right_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodMiniIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String imageUrl;
  final double size;

  const FoodMiniIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.imageUrl,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7FB),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).round(),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Icon(icon, color: color, size: size * .55),
        ),
      ),
    );
  }
}

class WaterCard extends StatelessWidget {
  final double current;
  final double goal;
  final ValueChanged<double> onAddWater;

  const WaterCard({
    super.key,
    required this.current,
    required this.goal,
    required this.onAddWater,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (current / goal).clamp(0.0, 1.0);

    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.water_drop_outlined,
                size: 21,
                color: AppColors.water,
              ),
              const SizedBox(width: 9),
              Text(
                translateText(context, 'Water'),
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.more_horiz_rounded,
                color: Color(0xFF777F93),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                current.toStringAsFixed(1),
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '/ ${goal.toStringAsFixed(1)} L',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${(percent * 100).round()}%',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 7,
              backgroundColor: AppColors.waterTrack,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.water),
            ),
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: WaterActionButton(
                  label: '+250 ml',
                  onTap: () => onAddWater(.25),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: WaterActionButton(
                  label: '+500 ml',
                  onTap: () => onAddWater(.50),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: WaterActionButton(
                  label: '+1 L',
                  onTap: () => onAddWater(1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 38,
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => onAddWater(.25),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF0F5FF),
                foregroundColor: AppColors.water,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.local_drink_outlined, size: 17),
              label: Text(
                translateText(context, 'Log water'),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaterActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const WaterActionButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFF1F5FF),
          foregroundColor: const Color(0xFF4676E8),
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            translateText(context, label),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

// ===============================================================
// NEXT MEAL
// ===============================================================

/*
class NextMealCard extends StatefulWidget {
  const NextMealCard({super.key});

  @override
  State<NextMealCard> createState() => _NextMealCardState();
}

class _NextMealCardState extends State<NextMealCard> {
  bool logged = false;

  Future<void> _markAsEaten() async {
    if (logged) return;
    setState(() => logged = true);
    await appState.addFood(
      name: 'Lunch',
      mealType: 'Lunch',
      amount: '1 serving',
      calories: '620 kcal',
    );
  }

  void _openDetails() {
    if (logged) return;
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const MealDetailsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openDetails,
      borderRadius: BorderRadius.circular(20),
      child: AppCard(
        color: AppColors.nextMealBg,
        padding: const EdgeInsets.fromLTRB(12, 11, 9, 11),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(17)),
                  child: AppNetworkImage(
                    url:
                        'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=240&q=80',
                    fallback: Icons.fastfood_rounded,
                    width: 72,
                    height: 72,
                    radius: 17,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translateText(context, 'Next Meal'),
                    style: TextStyle(
                      color: Color(0xFF1FA05C),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    translateText(context, 'Lunch'),
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    translateText(
                      context,
                      '2:00 PM  ΓÇó  620 kcal  ΓÇó  52g protein  ΓÇó  Chicken, rice, salad',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    height: 27,
                    child: FilledButton.icon(
                      key: const ValueKey('next-meal-mark-eaten'),
                      onPressed: logged ? null : _markAsEaten,
                      icon: Icon(
                        logged
                            ? Icons.check_circle_outline_rounded
                            : Icons.check_rounded,
                        size: 14,
                      ),
                      label: Text(
                        translateText(
                          context,
                          logged ? 'Eaten' : 'Mark as eaten',
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1FA05C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        textStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  translateText(context, 'You have'),
                  style: TextStyle(color: AppColors.muted, fontSize: 11),
                ),
                SizedBox(height: 1),
                Text(
                  '600',
                  style: TextStyle(
                    color: Color(0xFF18A05B),
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  translateText(context, 'kcal remaining'),
                  style: TextStyle(color: AppColors.muted, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(width: 3),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF4F566A),
              size: 23,
            ),
          ],
        ),
      ),
    );
  }
}

*/

// ===============================================================
// TODAY'S PLAN
// ===============================================================

class TodayPlanCard extends StatelessWidget {
  const TodayPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 9),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                translateText(context, "Today's Plan"),
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_rounded,
                      size: 15,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      translateText(context, 'Edit Plan'),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const MealRow(
            icon: Icons.egg_alt_outlined,
            iconBg: Color(0xFFF5F5F7),
            imageUrl:
                'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=240&q=80',
            title: 'Breakfast',
            time: '08:00 AM',
            items: 'Egg 100g  ΓÇó  Bread 60g',
            nutrition: '420 kcal  ΓÇó  28g protein',
            status: MealStatus.logged,
          ),
          const MealDivider(),
          const MealRow(
            icon: Icons.restaurant_rounded,
            iconBg: Color(0xFFF5F5F7),
            imageUrl:
                'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=240&q=80',
            title: 'Lunch',
            time: '02:00 PM',
            items: 'Chicken 200g  ΓÇó  Rice 150g  ΓÇó  Salad 100g',
            nutrition: '620 kcal  ΓÇó  52g protein',
            status: MealStatus.logged,
          ),
          const MealDivider(),
          const MealRow(
            icon: Icons.apple_rounded,
            iconBg: Color(0xFFF5F5F7),
            imageUrl:
                'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=240&q=80',
            title: 'Snack',
            time: '05:30 PM',
            items: 'Apple 150g  ΓÇó  Almonds 20g',
            nutrition: '200 kcal  ΓÇó  5g protein',
            status: MealStatus.planned,
          ),
          const MealDivider(),
          const MealRow(
            icon: Icons.eco_outlined,
            iconBg: Color(0xFFF5F5F7),
            imageUrl:
                'https://images.unsplash.com/photo-1547592180-85f173990554?w=240&q=80',
            title: 'Dinner',
            time: '08:30 PM',
            items: 'Tuna 120g  ΓÇó  Bread 80g',
            nutrition: '450 kcal  ΓÇó  40g protein',
            status: MealStatus.skipped,
          ),
        ],
      ),
    );
  }
}

enum MealStatus { logged, planned, skipped }

class MealRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String imageUrl;
  final String title;
  final String time;
  final String items;
  final String nutrition;
  final MealStatus status;

  const MealRow({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.imageUrl,
    required this.title,
    required this.time,
    required this.items,
    required this.nutrition,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final config = switch (status) {
      MealStatus.logged => (
        accent: AppColors.green,
        statusBg: AppColors.greenTrack,
        statusText: 'Logged',
        statusColor: AppColors.green,
        statusIcon: Icons.check_rounded,
      ),
      MealStatus.planned => (
        accent: const Color(0xFF6C62FF),
        statusBg: const Color(0xFFF0EFFF),
        statusText: 'Planned',
        statusColor: const Color(0xFF5B5AE8),
        statusIcon: Icons.circle_outlined,
      ),
      MealStatus.skipped => (
        accent: AppColors.red,
        statusBg: AppColors.redTrack,
        statusText: 'Skipped',
        statusColor: AppColors.red,
        statusIcon: Icons.close_rounded,
      ),
    };

    return SizedBox(
      height: 77,
      child: Row(
        children: [
          AppNetworkImage(
            url: imageUrl,
            fallback: icon,
            width: 51,
            height: 51,
            radius: 14,
          ),
          const SizedBox(width: 9),
          Container(
            width: 29,
            height: 29,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: config.accent, width: 2),
            ),
            child: Icon(config.statusIcon, size: 16, color: config.accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translateText(context, title),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items
                        .split('  ΓÇó  ')
                        .map((item) => translateText(context, item))
                        .join('  ΓÇó  '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nutrition
                        .split('  ΓÇó  ')
                        .map((item) => translateText(context, item))
                        .join('  ΓÇó  '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF6C7488),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 62,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: SmallStatus(
                    text: translateText(context, config.statusText),
                    background: config.statusBg,
                    foreground: config.statusColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 3),
          const Icon(
            Icons.more_horiz_rounded,
            color: Color(0xFF727A8B),
            size: 19,
          ),
        ],
      ),
    );
  }
}

class MealDivider extends StatelessWidget {
  const MealDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 71),
      child: Divider(height: 1, color: Color(0xFFEEF0F4)),
    );
  }
}

class SmallStatus extends StatelessWidget {
  final String text;
  final Color background;
  final Color foreground;

  const SmallStatus({
    super.key,
    required this.text,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foreground,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ===============================================================
// REUSABLE APP CARD
// ===============================================================

// ===============================================================
// REUSABLE APP CARD
// ===============================================================
