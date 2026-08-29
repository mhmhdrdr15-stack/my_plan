import 'package:flutter/material.dart';

import '../models/meal_assignment.dart';
import '../models/meal_template.dart';
import '../models/weekly_plan.dart';
import '../services/weekly_plan_service.dart';

class WeekBoardScreen extends StatefulWidget {
  final WeeklyPlan initialPlan;

  const WeekBoardScreen({
    super.key,
    required this.initialPlan,
  });

  @override
  State<WeekBoardScreen> createState() =>
      _WeekBoardScreenState();
}

class _WeekBoardScreenState
    extends State<WeekBoardScreen> {
  static const Color primary =
      Color(0xFF5B35F5);

  final WeeklyPlanService _service =
      WeeklyPlanService();

  late WeeklyPlan plan;

  int selectedDay = 4;

  bool weekView = false;

  @override
  void initState() {
    super.initState();
    plan = widget.initialPlan;

    if (selectedDay >=
        plan.days.length) {
      selectedDay = 0;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F7FB),
      body: SafeArea(
        child:
            Column(
          children: [
            _header(),
            _progressCard(),
            _viewSwitcher(),
            Expanded(
              child: weekView
                  ? _weekView()
                  : _dayView(),
            ),
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
      child:
          Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(
                context,
                plan,
              );
            },
            child:
                const Icon(
              Icons
                  .arrow_forward_ios_rounded,
              size:
                  18,
            ),
          ),
          const SizedBox(
              width: 12),
          const Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  'بناء أسبوعك',
                  style:
                      TextStyle(
                    fontSize:
                        21,
                    fontWeight:
                        FontWeight
                            .w900,
                  ),
                ),
                SizedBox(
                    height: 3),
                Text(
                  'خطتك الأسبوعية في مكان واحد',
                  style:
                      TextStyle(
                    color:
                        Color(
                      0xFF85899D,
                    ),
                    fontSize:
                        10.5,
                  ),
                ),
              ],
            ),
          ),
          _iconButton(
            Icons.more_horiz_rounded,
            _showMore,
          ),
        ],
      ),
    );
  }

  Widget _progressCard() {
    final value =
        plan.completion.clamp(
      0.0,
      1.0,
    );

    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      padding:
          const EdgeInsets.all(16),
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
              const Color(
            0xFFE7E7EF,
          ),
        ),
      ),
      child:
          Column(
        children: [
          Row(
            children: [
              const Expanded(
                child:
                    Text(
                  'تقدم الخطة',
                  style:
                      TextStyle(
                    fontSize:
                        12,
                    fontWeight:
                        FontWeight
                            .w900,
                  ),
                ),
              ),
              Text(
                '${plan.filledSlots} / ${plan.totalSlots}',
                style:
                    const TextStyle(
                  color:
                      primary,
                  fontSize:
                      11,
                  fontWeight:
                      FontWeight
                          .w900,
                ),
              ),
            ],
          ),
          const SizedBox(
              height: 10),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            child:
                LinearProgressIndicator(
              value:
                  value,
              minHeight:
                  7,
              backgroundColor:
                  const Color(
                0xFFEDE9FD,
              ),
              valueColor:
                  const AlwaysStoppedAnimation<
                      Color>(
                primary,
              ),
            ),
          ),
          const SizedBox(
              height: 12),
          Row(
            children:
                plan.mealTypes
                    .map(
                      (
                        mealType,
                      ) {
                        final count =
                            plan.assignments
                                .where(
                                  (
                                    assignment,
                                  ) =>
                                      assignment
                                          .mealType ==
                                      mealType,
                                )
                                .map(
                                  (
                                    e,
                                  ) =>
                                      e.dayIndex,
                                )
                                .toSet()
                                .length;

                        return Expanded(
                          child:
                              _typeProgress(
                            mealType,
                            count,
                          ),
                        );
                      },
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _typeProgress(
    String mealType,
    int count,
  ) {
    final complete =
        count ==
            plan.days.length;

    return Row(
      children: [
        Icon(
          complete
              ? Icons
                  .check_circle_rounded
              : Icons
                  .radio_button_unchecked,
          size: 15,
          color: complete
              ? const Color(
                  0xFF2FA66A,
                )
              : const Color(
                  0xFFB1B3BE,
                ),
        ),
        const SizedBox(
            width: 4),
        Expanded(
          child:
              Text(
            '$mealType $count/${plan.days.length}',
            maxLines:
                1,
            overflow:
                TextOverflow
                    .ellipsis,
            style:
                const TextStyle(
              fontSize:
                  8.5,
              fontWeight:
                  FontWeight.w700,
              color:
                  Color(
                0xFF6F7183,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _viewSwitcher() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 2,
      ),
      child:
          Container(
        height:
            42,
        padding:
            const EdgeInsets.all(
          4,
        ),
        decoration:
            BoxDecoration(
          color:
              const Color(
            0xFFEFEFF5,
          ),
          borderRadius:
              BorderRadius.circular(
            14,
          ),
        ),
        child:
            Row(
          children: [
            Expanded(
              child:
                  _switchButton(
                title:
                    'اليوم',
                selected:
                    !weekView,
                onTap: () {
                  setState(() {
                    weekView =
                        false;
                  });
                },
              ),
            ),
            Expanded(
              child:
                  _switchButton(
                title:
                    'الأسبوع',
                selected:
                    weekView,
                onTap: () {
                  setState(() {
                    weekView =
                        true;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap:
          onTap,
      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds:
              170,
        ),
        decoration:
            BoxDecoration(
          color: selected
              ? Colors.white
              : Colors.transparent,
          borderRadius:
              BorderRadius.circular(
            11,
          ),
          boxShadow:
              selected
                  ? [
                      BoxShadow(
                        color:
                            Colors.black
                                .withValues(
                          alpha:
                              0.04,
                        ),
                        blurRadius:
                            8,
                        offset:
                            const Offset(
                          0,
                          2,
                        ),
                      ),
                    ]
                  : null,
        ),
        alignment:
            Alignment.center,
        child:
            Text(
          title,
          style:
              TextStyle(
            color: selected
                ? primary
                : const Color(
                    0xFF7F8190,
                  ),
            fontSize:
                10,
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _dayView() {
    return Column(
      children: [
        _daySelector(),
        Expanded(
          child:
              ListView(
            padding:
                const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              40,
            ),
            children: [
              _dayHero(),
              const SizedBox(
                  height: 16),
              ...plan.mealTypes.map(
                (
                  mealType,
                ) =>
                    Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom:
                        10,
                  ),
                  child:
                      _slotCard(
                    mealType,
                  ),
                ),
              ),
              const SizedBox(
                  height: 8),
              _dailyBalance(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _daySelector() {
    return SizedBox(
      height:
          82,
      child:
          ListView.builder(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        scrollDirection:
            Axis.horizontal,
        itemCount:
            plan.days.length,
        itemBuilder:
            (
          context,
          index,
        ) {
          final selected =
              selectedDay ==
                  index;

          final count =
              plan.assignmentsForDay(
            index,
          ).length;

          return GestureDetector(
            onTap:
                () {
              setState(() {
                selectedDay =
                    index;
              });
            },
            child:
                AnimatedContainer(
              duration:
                  const Duration(
                milliseconds:
                    180,
              ),
              width:
                  67,
              margin:
                  EdgeInsetsDirectional
                      .only(
                start:
                    index == 0
                        ? 0
                        : 8,
              ),
              decoration:
                  BoxDecoration(
                color: selected
                    ? primary
                    : Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  19,
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
              child:
                  Column(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                children: [
                  Text(
                    plan.days[index]
                        .substring(
                      0,
                      2,
                    ),
                    style:
                        TextStyle(
                      color: selected
                          ? Colors.white70
                          : const Color(
                              0xFF85899D,
                            ),
                      fontSize:
                          9,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                      height: 4),
                  Text(
                    '${index + 1}',
                    style:
                        TextStyle(
                      color: selected
                          ? Colors.white
                          : const Color(
                              0xFF18182B,
                            ),
                      fontSize:
                          18,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                      height: 2),
                  Text(
                    '$count/${plan.mealTypes.length}',
                    style:
                        TextStyle(
                      color: selected
                          ? Colors.white70
                          : primary,
                      fontSize:
                          8,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _dayHero() {
    final assignments =
        plan.assignmentsForDay(
      selectedDay,
    );

    final calories =
        assignments.fold<double>(
      0,
      (
        sum,
        assignment,
      ) =>
          sum +
          assignment
              .template
              .meal
              .calories,
    );

    final protein =
        assignments.fold<double>(
      0,
      (
        sum,
        assignment,
      ) =>
          sum +
          assignment
              .template
              .meal
              .protein,
    );

    return Container(
      padding:
          const EdgeInsets.all(
        18,
      ),
      decoration:
          BoxDecoration(
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
        borderRadius:
            BorderRadius.circular(
          25,
        ),
      ),
      child:
          Row(
        children: [
          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  plan.days[selectedDay],
                  style:
                      const TextStyle(
                    color:
                        Colors.white70,
                    fontSize:
                        10,
                  ),
                ),
                const SizedBox(
                    height: 4),
                Text(
                  '${assignments.length} / ${plan.mealTypes.length} وجبات',
                  style:
                      const TextStyle(
                    color:
                        Colors.white,
                    fontSize:
                        20,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          _heroStat(
            calories.round(),
            'سعرة',
          ),
          const SizedBox(
              width: 14),
          _heroStat(
            protein.round(),
            'بروتين',
          ),
        ],
      ),
    );
  }

  Widget _heroStat(
    int value,
    String label,
  ) {
    return Column(
      children: [
        Text(
          '$value',
          style:
              const TextStyle(
            color:
                Colors.white,
            fontSize:
                15,
            fontWeight:
                FontWeight.w900,
          ),
        ),
        const SizedBox(
            height: 2),
        Text(
          label,
          style:
              const TextStyle(
            color:
                Colors.white70,
            fontSize:
                8,
          ),
        ),
      ],
    );
  }

  Widget _slotCard(
    String mealType,
  ) {
    final assignment =
        plan.findAssignment(
      dayIndex:
          selectedDay,
      mealType:
          mealType,
    );

    if (assignment == null) {
      return _emptySlot(
        mealType,
      );
    }

    return _filledSlot(
      mealType,
      assignment,
    );
  }

  Widget _emptySlot(
    String mealType,
  ) {
    return Material(
      color:
          Colors.white,
      borderRadius:
          BorderRadius.circular(
        22,
      ),
      child:
          InkWell(
        onTap:
            () =>
                _showTemplatePicker(
          mealType,
        ),
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        child:
            Container(
          padding:
              const EdgeInsets.all(
            15,
          ),
          decoration:
              BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              22,
            ),
            border:
                Border.all(
              color:
                  const Color(
                0xFFE7E7EF,
              ),
            ),
          ),
          child:
              Row(
            children: [
              Container(
                width:
                    48,
                height:
                    48,
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
                    const Icon(
                  Icons
                      .add_rounded,
                  color:
                      primary,
                ),
              ),
              const SizedBox(
                  width: 11),
              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      mealType,
                      style:
                          const TextStyle(
                        fontSize:
                            13,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                        height: 4),
                    const Text(
                      'لم تتم إضافة وجبة بعد',
                      style:
                          TextStyle(
                        color:
                            Color(
                          0xFF85899D,
                        ),
                        fontSize:
                            9.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'إضافة',
                style:
                    TextStyle(
                  color:
                      primary,
                  fontSize:
                      10,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filledSlot(
    String mealType,
    MealAssignment assignment,
  ) {
    final meal =
        assignment.template.meal;

    return Material(
      color:
          Colors.white,
      borderRadius:
          BorderRadius.circular(
        22,
      ),
      child:
          InkWell(
        onTap: () =>
            _showMealActions(
          mealType,
          assignment,
        ),
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        child:
            Padding(
          padding:
              const EdgeInsets.all(
            10,
          ),
          child:
              Row(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  17,
                ),
                child:
                    SizedBox(
                  width:
                      76,
                  height:
                      76,
                  child:
                      _mealImage(
                    meal,
                  ),
                ),
              ),
              const SizedBox(
                  width: 11),
              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child:
                              Text(
                            mealType,
                            style:
                                const TextStyle(
                              color:
                                  Color(
                                0xFF85899D,
                              ),
                              fontSize:
                                  8.5,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons
                              .more_horiz_rounded,
                          size:
                              17,
                          color:
                              Color(
                            0xFF85899D,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                        height: 3),
                    Text(
                      assignment
                          .template
                          .name,
                      maxLines:
                          1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        fontSize:
                            14,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                        height: 5),
                    Text(
                      '${meal.calories.round()} سعرة • '
                      '${meal.protein.round()}غ بروتين',
                      style:
                          const TextStyle(
                        color:
                            primary,
                        fontSize:
                            9,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                        height: 7),
                    Row(
                      children: [
                        _miniChip(
                          '${meal.cost.toStringAsFixed(2)} ₺',
                          Icons
                              .account_balance_wallet_outlined,
                        ),
                        const SizedBox(
                            width: 6),
                        _miniChip(
                          'قالب',
                          Icons
                              .bookmark_outline_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mealImage(
    dynamic meal,
  ) {
    if (meal.items.isEmpty) {
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
        ),
      );
    }

    return Image.network(
      meal.items.first.food.imageUrl,
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
          ),
        );
      },
    );
  }

  Widget _miniChip(
    String text,
    IconData icon,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFFF5F3FF,
        ),
        borderRadius:
            BorderRadius.circular(
          9,
        ),
      ),
      child:
          Row(
        children: [
          Icon(
            icon,
            size:
                11,
            color:
                primary,
          ),
          const SizedBox(
              width: 3),
          Text(
            text,
            style:
                const TextStyle(
              color:
                  primary,
              fontSize:
                  7.5,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dailyBalance() {
    final assignments =
        plan.assignmentsForDay(
      selectedDay,
    );

    final calories =
        assignments.fold<double>(
      0,
      (
        sum,
        assignment,
      ) =>
          sum +
          assignment
              .template
              .meal
              .calories,
    );

    final protein =
        assignments.fold<double>(
      0,
      (
        sum,
        assignment,
      ) =>
          sum +
          assignment
              .template
              .meal
              .protein,
    );

    final cost =
        assignments.fold<double>(
      0,
      (
        sum,
        assignment,
      ) =>
          sum +
          assignment
              .template
              .meal
              .cost,
    );

    return Container(
      padding:
          const EdgeInsets.all(
        17,
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
              const Color(
            0xFFE7E7EF,
          ),
        ),
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'ملخص اليوم',
            style:
                TextStyle(
              fontSize:
                  14,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
          const SizedBox(
              height: 14),
          Row(
            children: [
              _balance(
                calories.round(),
                'سعرة',
              ),
              _balance(
                protein.round(),
                'بروتين',
              ),
              _balance(
                cost.toStringAsFixed(
                  2,
                ),
                '₺',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _balance(
    dynamic value,
    String label,
  ) {
    return Expanded(
      child:
          Column(
        children: [
          Text(
            '$value',
            style:
                const TextStyle(
              fontSize:
                  17,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
          const SizedBox(
              height: 3),
          Text(
            label,
            style:
                const TextStyle(
              color:
                  Color(
                0xFF85899D,
              ),
              fontSize:
                  8.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _weekView() {
    return ListView(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        35,
      ),
      children: [
        const Text(
          'نظرة سريعة على الأسبوع',
          style:
              TextStyle(
            fontSize:
                17,
            fontWeight:
                FontWeight.w900,
          ),
        ),
        const SizedBox(
            height: 5),
        const Text(
          'اضغط على أي يوم لفتح تفاصيله.',
          style:
              TextStyle(
            color:
                Color(
              0xFF85899D,
            ),
            fontSize:
                10,
          ),
        ),
        const SizedBox(
            height: 13),
        ...List.generate(
          plan.days.length,
          _weekDayCard,
        ),
      ],
    );
  }

  Widget _weekDayCard(
    int dayIndex,
  ) {
    final assignments =
        plan.assignmentsForDay(
      dayIndex,
    );

    final complete =
        assignments.length ==
            plan.mealTypes.length;

    final calories =
        assignments.fold<double>(
      0,
      (
        sum,
        assignment,
      ) =>
          sum +
          assignment
              .template
              .meal
              .calories,
    );

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 10,
      ),
      child:
          Material(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          21,
        ),
        child:
            InkWell(
          onTap:
              () {
            setState(() {
              selectedDay =
                  dayIndex;
              weekView =
                  false;
            });
          },
          borderRadius:
              BorderRadius.circular(
            21,
          ),
          child:
              Padding(
            padding:
                const EdgeInsets.all(
              13,
            ),
            child:
                Row(
              children: [
                Container(
                  width:
                      49,
                  height:
                      49,
                  decoration:
                      BoxDecoration(
                    color:
                        complete
                            ? const Color(
                                0xFFEAF8F0,
                              )
                            : const Color(
                                0xFFF4F2FA,
                              ),
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                  child:
                      Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      Text(
                        plan
                            .days[
                                dayIndex]
                            .substring(
                          0,
                          2,
                        ),
                        style:
                            const TextStyle(
                          fontSize:
                              7,
                          color:
                              Color(
                            0xFF85899D,
                          ),
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                          height: 2),
                      Text(
                        '${dayIndex + 1}',
                        style:
                            const TextStyle(
                          fontSize:
                              15,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
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
                      Row(
                        children: [
                          Expanded(
                            child:
                                Text(
                              plan
                                  .days[
                                      dayIndex],
                              style:
                                  const TextStyle(
                                fontSize:
                                    13,
                                fontWeight:
                                    FontWeight.w900,
                              ),
                            ),
                          ),
                          Text(
                            '${assignments.length}/${plan.mealTypes.length}',
                            style:
                                TextStyle(
                              color:
                                  complete
                                      ? const Color(
                                          0xFF2FA66A,
                                        )
                                      : primary,
                              fontSize:
                                  9.5,
                              fontWeight:
                                  FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: 7),
                      Row(
                        children:
                            plan.mealTypes.map(
                          (
                            mealType,
                          ) {
                            final assignment =
                                plan.findAssignment(
                              dayIndex:
                                  dayIndex,
                              mealType:
                                  mealType,
                            );

                            return Expanded(
                              child:
                                  Container(
                                margin:
                                    const EdgeInsets.only(
                                  left:
                                      4,
                                ),
                                height:
                                    7,
                                decoration:
                                    BoxDecoration(
                                  color:
                                      assignment ==
                                              null
                                          ? const Color(
                                              0xFFEDEDF3,
                                            )
                                          : primary,
                                  borderRadius:
                                      BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                      const SizedBox(
                          height: 6),
                      Text(
                        calories ==
                                0
                            ? 'لا توجد وجبات بعد'
                            : '${calories.round()} سعرة مخططة',
                        style:
                            const TextStyle(
                          color:
                              Color(
                            0xFF85899D,
                          ),
                          fontSize:
                              8.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                    width: 6),
                Icon(
                  complete
                      ? Icons
                          .check_circle_rounded
                      : Icons
                          .arrow_back_ios_new_rounded,
                  size:
                      complete
                          ? 18
                          : 13,
                  color:
                      complete
                          ? const Color(
                              0xFF2FA66A,
                            )
                          : const Color(
                              0xFF9A9CAB,
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTemplatePicker(
    String mealType,
  ) {
    final templates =
        plan.templates.where(
      (template) =>
          template.mealType ==
          mealType,
    ).toList();

    if (templates.isEmpty) {
      _showSnack(
        'لا يوجد قالب محفوظ لهذا النوع من الوجبات.',
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent,
      builder:
          (_) {
        return Container(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            24,
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
          ),
          child:
              SafeArea(
            top:
                false,
            child:
                Column(
              mainAxisSize:
                  MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                _sheetHandle(),
                const SizedBox(
                    height: 18),
                Text(
                  'اختر قالب $mealType',
                  style:
                      const TextStyle(
                    fontSize:
                        20,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(
                    height: 12),
                ...templates.map(
                  (
                    template,
                  ) =>
                      _templatePickerRow(
                    template,
                    mealType,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _templatePickerRow(
    MealTemplate template,
    String mealType,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 8,
      ),
      child:
          Material(
        color:
            const Color(
          0xFFFAFAFD,
        ),
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        child:
            InkWell(
          onTap:
              () {
            final updated =
                _service.assignTemplate(
              plan:
                  plan,
              template:
                  template,
              mealType:
                  mealType,
              days: [
                selectedDay,
              ],
            );

            setState(() {
              plan =
                  updated;
            });

            Navigator.pop(
              context,
            );
          },
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          child:
              Padding(
            padding:
                const EdgeInsets.all(
              9,
            ),
            child:
                Row(
              children: [
                Container(
                  width:
                      53,
                  height:
                      53,
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
                      const Icon(
                    Icons
                        .restaurant_rounded,
                    color:
                        primary,
                  ),
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
                        template
                            .name,
                        style:
                            const TextStyle(
                          fontSize:
                              12,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                          height: 4),
                      Text(
                        '${template.meal.calories.round()} سعرة • '
                        '${template.meal.protein.round()}غ بروتين',
                        style:
                            const TextStyle(
                          color:
                              primary,
                          fontSize:
                              9,
                          fontWeight:
                              FontWeight.w700,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMealActions(
    String mealType,
    MealAssignment assignment,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent,
      builder:
          (_) {
        return Container(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            24,
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
          ),
          child:
              SafeArea(
            top:
                false,
            child:
                Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                _sheetHandle(),
                const SizedBox(
                    height: 17),
                Text(
                  assignment
                      .template
                      .name,
                  style:
                      const TextStyle(
                    fontSize:
                        19,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(
                    height: 10),
                _action(
                  Icons
                      .copy_outlined,
                  'استخدام في أيام أخرى',
                  () {
                    Navigator.pop(
                      context,
                    );
                    _showMultiDayPicker(
                      assignment
                          .template,
                      mealType,
                    );
                  },
                ),
                _action(
                  Icons
                      .swap_horiz_rounded,
                  'استبدال',
                  () {
                    Navigator.pop(
                      context,
                    );
                    _showTemplatePicker(
                      mealType,
                    );
                  },
                ),
                _action(
                  Icons
                      .drive_file_move_outline,
                  'نقل إلى يوم آخر',
                  () {
                    Navigator.pop(
                      context,
                    );
                    _showMoveSheet(
                      mealType,
                    );
                  },
                ),
                _action(
                  Icons.delete_outline_rounded,
                  'حذف من اليوم',
                  () {
                    setState(() {
                      plan =
                          _service
                              .removeAssignment(
                        plan:
                            plan,
                        dayIndex:
                            selectedDay,
                        mealType:
                            mealType,
                      );
                    });

                    Navigator.pop(
                      context,
                    );

                    _showSnack(
                      'تم حذف الوجبة • يمكنك التراجع',
                    );
                  },
                  destructive:
                      true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _action(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool destructive = false,
  }) {
    return ListTile(
      onTap:
          onTap,
      contentPadding:
          EdgeInsets.zero,
      leading:
          Container(
        width:
            40,
        height:
            40,
        decoration:
            BoxDecoration(
          color:
              destructive
                  ? const Color(
                      0xFFFFEEEE,
                    )
                  : const Color(
                      0xFFF0ECFF,
                    ),
          shape:
              BoxShape.circle,
        ),
        child:
            Icon(
          icon,
          size:
              18,
          color:
              destructive
                  ? const Color(
                      0xFFE45858,
                    )
                  : primary,
        ),
      ),
      title:
          Text(
        title,
        style:
            TextStyle(
          fontSize:
              12,
          fontWeight:
              FontWeight.w700,
          color:
              destructive
                  ? const Color(
                      0xFFE45858,
                    )
                  : const Color(
                      0xFF303044,
                    ),
        ),
      ),
    );
  }

  void _showMultiDayPicker(
    MealTemplate template,
    String mealType,
  ) {
    final selected =
        <int>{};

    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent,
      isScrollControlled:
          true,
      builder:
          (_) {
        return StatefulBuilder(
          builder:
              (
            context,
            modalSetState,
          ) {
            return Container(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                24,
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
              ),
              child:
                  SafeArea(
                top:
                    false,
                child:
                    Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    _sheetHandle(),
                    const SizedBox(
                        height: 17),
                    Text(
                      'استخدام ${template.name}',
                      style:
                          const TextStyle(
                        fontSize:
                            19,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                        height: 10),
                    ...List.generate(
                      plan.days.length,
                      (
                        index,
                      ) {
                        final checked =
                            selected
                                .contains(
                          index,
                        );

                        return CheckboxListTile(
                          value:
                              checked,
                          activeColor:
                              primary,
                          contentPadding:
                              EdgeInsets.zero,
                          title:
                              Text(
                            plan.days[
                                index],
                            style:
                                const TextStyle(
                              fontSize:
                                  11,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                          onChanged:
                              (
                            value,
                          ) {
                            modalSetState(
                              () {
                                if (value ==
                                    true) {
                                  selected
                                      .add(
                                    index,
                                  );
                                } else {
                                  selected
                                      .remove(
                                    index,
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(
                        height: 10),
                    SizedBox(
                      width:
                          double.infinity,
                      height:
                          52,
                      child:
                          FilledButton(
                        style:
                            FilledButton
                                .styleFrom(
                          backgroundColor:
                              primary,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              17,
                            ),
                          ),
                        ),
                        onPressed:
                            selected.isEmpty
                                ? null
                                : () {
                                    setState(
                                      () {
                                        plan =
                                            _service.assignTemplate(
                                          plan:
                                              plan,
                                          template:
                                              template,
                                          mealType:
                                              mealType,
                                          days:
                                              selected.toList(),
                                        );
                                      },
                                    );

                                    Navigator.pop(
                                      context,
                                    );
                                  },
                        child:
                            Text(
                          selected.isEmpty
                              ? 'اختر الأيام'
                              : 'تطبيق على ${selected.length} أيام',
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
          },
        );
      },
    );
  }

  void _showMoveSheet(
    String mealType,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent,
      builder:
          (_) {
        return Container(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            24,
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
          ),
          child:
              SafeArea(
            top:
                false,
            child:
                Column(
              mainAxisSize:
                  MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                _sheetHandle(),
                const SizedBox(
                    height: 17),
                const Text(
                  'نقل الوجبة إلى',
                  style:
                      TextStyle(
                    fontSize:
                        19,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(
                    height: 10),
                ...List.generate(
                  plan.days.length,
                  (
                    index,
                  ) {
                    if (index ==
                        selectedDay) {
                      return const SizedBox.shrink();
                    }

                    return ListTile(
                      contentPadding:
                          EdgeInsets.zero,
                      onTap:
                          () {
                        setState(
                          () {
                            plan =
                                _service.moveAssignment(
                              plan:
                                  plan,
                              fromDay:
                                  selectedDay,
                              toDay:
                                  index,
                              mealType:
                                  mealType,
                            );

                            selectedDay =
                                index;
                          },
                        );

                        Navigator.pop(
                          context,
                        );

                        _showSnack(
                          'تم نقل الوجبة',
                        );
                      },
                      title:
                          Text(
                        plan.days[
                            index],
                        style:
                            const TextStyle(
                          fontSize:
                              12,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                      trailing:
                          const Icon(
                        Icons
                            .arrow_back_ios_new_rounded,
                        size:
                            13,
                        color:
                            Color(
                          0xFF85899D,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMore() {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent,
      builder:
          (_) {
        return Container(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            24,
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
          ),
          child:
              SafeArea(
            top:
                false,
            child:
                Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                _action(
                  Icons
                      .auto_awesome_rounded,
                  'أكمل الأسبوع',
                  () {
                    Navigator.pop(
                      context,
                    );
                    _completeWeek();
                  },
                ),
                _action(
                  Icons
                      .check_circle_outline_rounded,
                  'مراجعة الخطة',
                  () {
                    Navigator.pop(
                      context,
                    );
                    _showSnack(
                      plan.isComplete
                          ? 'الأسبوع مكتمل ✓'
                          : 'تبقى ${plan.totalSlots - plan.filledSlots} وجبات',
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _completeWeek() {
    final emptySlots =
        <String>[];

    for (int day = 0;
        day < plan.days.length;
        day++) {
      for (final mealType
          in plan.mealTypes) {
        if (plan.findAssignment(
              dayIndex:
                  day,
              mealType:
                  mealType,
            ) ==
            null) {
          emptySlots.add(
            '${plan.days[day]} — $mealType',
          );
        }
      }
    }

    if (emptySlots.isEmpty) {
      _showSnack(
        'الأسبوع مكتمل بالفعل ✓',
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent,
      builder:
          (_) {
        return Container(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            24,
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
          ),
          child:
              SafeArea(
            top:
                false,
            child:
                Column(
              mainAxisSize:
                  MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                _sheetHandle(),
                const SizedBox(
                    height: 17),
                const Text(
                  'الأماكن المتبقية',
                  style:
                      TextStyle(
                    fontSize:
                        20,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(
                    height: 5),
                Text(
                  'بقي ${emptySlots.length} وجبات لإكمال الأسبوع.',
                  style:
                      const TextStyle(
                    color:
                        Color(
                      0xFF85899D,
                    ),
                    fontSize:
                        10,
                  ),
                ),
                const SizedBox(
                    height: 12),
                ...emptySlots
                    .take(5)
                    .map(
                      (
                        item,
                      ) =>
                          Padding(
                        padding:
                            const EdgeInsets
                                .only(
                          bottom:
                              7,
                        ),
                        child:
                            Container(
                          width:
                              double.infinity,
                          padding:
                              const EdgeInsets
                                  .all(
                            12,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFFFAFAFD,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),
                          ),
                          child:
                              Text(
                            item,
                            style:
                                const TextStyle(
                              fontSize:
                                  10,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                const SizedBox(
                    height: 8),
                SizedBox(
                  width:
                      double.infinity,
                  height:
                      52,
                  child:
                      FilledButton(
                    style:
                        FilledButton.styleFrom(
                      backgroundColor:
                          primary,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          17,
                        ),
                      ),
                    ),
                    onPressed:
                        () {
                      Navigator.pop(
                        context,
                      );

                      final first =
                          emptySlots.first
                              .split(
                        ' — ',
                      );

                      selectedDay =
                          plan.days
                              .indexOf(
                        first.first,
                      );

                      _showTemplatePicker(
                        first.length >
                                1
                            ? first[1]
                            : plan
                                .mealTypes
                                .first,
                      );
                    },
                    child:
                        const Text(
                      'معالجة الفراغ الأول',
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
      },
    );
  }

  Widget _iconButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color:
          Colors.white,
      borderRadius:
          BorderRadius.circular(
        15,
      ),
      child:
          InkWell(
        onTap:
            onTap,
        borderRadius:
            BorderRadius.circular(
          15,
        ),
        child:
            Container(
          width:
              42,
          height:
              42,
          decoration:
              BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              15,
            ),
            border:
                Border.all(
              color:
                  const Color(
                0xFFE7E7EF,
              ),
            ),
          ),
          child:
              Icon(
            icon,
            size:
                18,
          ),
        ),
      ),
    );
  }

  Widget _sheetHandle() {
    return Center(
      child:
          Container(
        width:
            42,
        height:
            4,
        decoration:
            BoxDecoration(
          color:
              const Color(
            0xFFE2E2E9,
          ),
          borderRadius:
              BorderRadius.circular(
            10,
          ),
        ),
      ),
    );
  }

  void _showSnack(
    String text,
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
            text,
          ),
        ),
      );
  }
}