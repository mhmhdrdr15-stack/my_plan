import 'package:flutter/material.dart';

import '../models/meal_template.dart';
import '../models/weekly_plan.dart';
import '../services/weekly_plan_service.dart';

class MealDistributionScreen extends StatefulWidget {
  final WeeklyPlan plan;
  final MealTemplate template;
  final String mealType;

  const MealDistributionScreen({
    super.key,
    required this.plan,
    required this.template,
    required this.mealType,
  });

  @override
  State<MealDistributionScreen> createState() =>
      _MealDistributionScreenState();
}

class _MealDistributionScreenState
    extends State<MealDistributionScreen> {
  static const Color primary =
      Color(0xFF5B35F5);

  final WeeklyPlanService service =
      WeeklyPlanService();

  final Set<int> selectedDays =
      <int>{};

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  120,
                ),
                children: [
                  _templatePreview(),
                  const SizedBox(height: 22),
                  const Text(
                    'أين تريد استخدام هذا القالب؟',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'يمكنك استخدام نفس الوجبة في عدة أيام.',
                    style: TextStyle(
                      color:
                          Color(0xFF85899D),
                      fontSize: 10.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _quickCard(
                    title:
                        'كل الأسبوع',
                    subtitle:
                        'الاثنين → الأحد',
                    icon: Icons
                        .calendar_month_rounded,
                    onTap: _selectAll,
                  ),
                  _quickCard(
                    title:
                        'أيام العمل',
                    subtitle:
                        'الاثنين → الجمعة',
                    icon:
                        Icons.work_outline_rounded,
                    onTap:
                        _selectWorkDays,
                  ),
                  _quickCard(
                    title:
                        'عطلة الأسبوع',
                    subtitle:
                        'السبت + الأحد',
                    icon:
                        Icons.weekend_outlined,
                    onTap:
                        _selectWeekend,
                  ),
                  const SizedBox(height: 17),
                  const Text(
                    'اختيار يدوي',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 9),
                  ...List.generate(
                    widget.plan.days.length,
                    _dayCard,
                  ),
                  const SizedBox(height: 20),
                  _preview(),
                ],
              ),
            ),
            _bottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        6,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.pop(context),
            child: const Icon(
              Icons
                  .arrow_forward_ios_rounded,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'توزيع قالب الوجبة',
                  style:
                      TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'حدد الأيام التي تريد استخدامه فيها.',
                  style:
                      TextStyle(
                    color:
                        Color(0xFF85899D),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _templatePreview() {
    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(23),
        border: Border.all(
          color:
              const Color(0xFFE7E7EF),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration:
                const BoxDecoration(
              color:
                  Color(0xFFF0ECFF),
              shape:
                  BoxShape.circle,
            ),
            child: const Icon(
              Icons.restaurant_rounded,
              color: primary,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  widget.template.name,
                  style:
                      const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.template.meal.calories.round()} سعرة • '
                  '${widget.template.meal.protein.round()}غ بروتين',
                  style:
                      const TextStyle(
                    color: primary,
                    fontSize: 9.5,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 9,
      ),
      child: Material(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(19),
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(19),
          child: Padding(
            padding:
                const EdgeInsets.all(13),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration:
                      const BoxDecoration(
                    color:
                        Color(0xFFF0ECFF),
                    shape:
                        BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        title,
                        style:
                            const TextStyle(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                          height: 2),
                      Text(
                        subtitle,
                        style:
                            const TextStyle(
                          color:
                              Color(0xFF85899D),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons
                      .arrow_back_ios_new_rounded,
                  size: 13,
                  color:
                      Color(0xFF9A9CAB),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dayCard(
    int index,
  ) {
    final selected =
        selectedDays.contains(
      index,
    );

    return GestureDetector(
      onTap: () {
        setState(() {
          if (selected) {
            selectedDays.remove(
              index,
            );
          } else {
            selectedDays.add(
              index,
            );
          }
        });
      },
      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 170,
        ),
        margin:
            const EdgeInsets.only(
          bottom: 8,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        decoration:
            BoxDecoration(
          color: selected
              ? const Color(
                  0xFFF4F0FF,
                )
              : Colors.white,
          borderRadius:
              BorderRadius.circular(
            17,
          ),
          border:
              Border.all(
            color: selected
                ? primary
                : const Color(
                    0xFFE7E7EF,
                  ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 23,
              height: 23,
              decoration:
                  BoxDecoration(
                color: selected
                    ? primary
                    : Colors.white,
                shape:
                    BoxShape.circle,
                border:
                    Border.all(
                  color: selected
                      ? primary
                      : const Color(
                          0xFFBFC1CD,
                        ),
                ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 15,
                      color:
                          Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.plan.days[index],
                style:
                    const TextStyle(
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ),
            if (selected)
              const Text(
                'محدد',
                style:
                    TextStyle(
                  color: primary,
                  fontSize: 9,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _preview() {
    if (selectedDays.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding:
          const EdgeInsets.all(15),
      decoration:
          BoxDecoration(
        color:
            const Color(0xFFF4F0FF),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'معاينة التوزيع',
            style:
                TextStyle(
              color: primary,
              fontSize: 11,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(
              widget.plan.days.length,
              (index) {
                final selected =
                    selectedDays.contains(
                  index,
                );

                return Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration:
                      BoxDecoration(
                    color: selected
                        ? primary
                        : Colors.white,
                    borderRadius:
                        BorderRadius
                            .circular(10),
                  ),
                  child: Text(
                    widget.plan.days[index]
                        .substring(0, 2),
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : const Color(
                              0xFF85899D,
                            ),
                      fontSize: 8,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    final count =
        selectedDays.length;

    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        9,
        20,
        12,
      ),
      color:
          Colors.white,
      child:
          SafeArea(
        top: false,
        child:
            SizedBox(
          width:
              double.infinity,
          height:
              53,
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
            ),
            onPressed:
                count == 0
                    ? null
                    : _apply,
            child:
                Text(
              count == 0
                  ? 'اختر الأيام'
                  : 'تطبيق على $count أيام',
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectAll() {
    setState(() {
      selectedDays
        ..clear()
        ..addAll(
          List.generate(
            widget.plan.days.length,
            (index) => index,
          ),
        );
    });
  }

  void _selectWorkDays() {
    setState(() {
      selectedDays
        ..clear()
        ..addAll(
          List.generate(
            widget.plan.days.length
                .clamp(0, 5),
            (index) => index,
          ),
        );
    });
  }

  void _selectWeekend() {
    setState(() {
      selectedDays.clear();

      if (widget.plan.days.length >= 7) {
        selectedDays.addAll([5, 6]);
      }
    });
  }

  void _apply() {
    final updatedPlan =
        service.assignTemplate(
      plan: widget.plan,
      template: widget.template,
      mealType: widget.mealType,
      days: selectedDays.toList(),
    );

    Navigator.pop(
      context,
      updatedPlan,
    );
  }
}