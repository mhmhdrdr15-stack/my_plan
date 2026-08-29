import 'package:flutter/material.dart';

import '../models/meal_template.dart';
import '../models/user_goal_profile.dart';
import '../models/weekly_plan.dart';

import 'meal_builder_screen.dart';
import 'meal_distribution_screen.dart';

class MealOptionsScreen extends StatefulWidget {
  final String mealType;
  final String time;
  final WeeklyPlan plan;
  final UserGoalProfile goalProfile;
  final List<MealTemplate> templates;

  const MealOptionsScreen({
    super.key,
    required this.mealType,
    required this.time,
    required this.plan,
    required this.goalProfile,
    required this.templates,
  });

  @override
  State<MealOptionsScreen> createState() =>
      _MealOptionsScreenState();
}

class _MealOptionsScreenState extends State<MealOptionsScreen> {
  static const Color primary = Color(0xFF5B35F5);
  static const Color background = Color(0xFFF7F7FB);
  static const Color textPrimary = Color(0xFF18182B);
  static const Color textSecondary = Color(0xFF85899D);
  static const Color borderColor = Color(0xFFE7E7EF);

  late List<MealTemplate> _templates;

  @override
  void initState() {
    super.initState();

    _templates = List<MealTemplate>.from(
      widget.templates,
    );
  }

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
                child: _buildContent(),
              ),
              _buildFooter(),
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
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        8,
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'رجوع',
                onPressed: _goBack,
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.mealType,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight:
                            FontWeight.w900,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _templates.isEmpty
                          ? 'ابدأ بإنشاء أول خيار لهذه الوجبة.'
                          : '${_templates.length} خيارات جاهزة لهذه الوجبة.',
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
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFF0ECFF,
                  ),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Text(
                  widget.time,
                  style:
                      const TextStyle(
                    color: primary,
                    fontSize: 9,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          AnimatedContainer(
            duration:
                const Duration(
              milliseconds: 200,
            ),
            width: double.infinity,
            height: 5,
            decoration:
                BoxDecoration(
              color: _templates.isEmpty
                  ? const Color(
                      0xFFEDE9FD,
                    )
                  : primary,
              borderRadius:
                  BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent() {
    if (_templates.isEmpty) {
      return _buildEmptyState();
    }

    return ListView(
      physics:
          const BouncingScrollPhysics(),
      padding:
          const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        24,
      ),
      children: [
        _buildIntroCard(),

        const SizedBox(
          height: 18,
        ),

        Row(
          children: [
            const Expanded(
              child: Text(
                'خياراتك',
                style:
                    TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w900,
                  color: textPrimary,
                ),
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
                    const Color(
                  0xFFF0ECFF,
                ),
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),
              child: Text(
                '${_templates.length}',
                style:
                    const TextStyle(
                  color: primary,
                  fontSize: 9,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 10,
        ),

        ..._templates.map(
          _buildTemplateCard,
        ),

        const SizedBox(
          height: 4,
        ),

        _buildCreateAnotherButton(),
      ],
    );
  }

  // ============================================================
  // INTRO
  // ============================================================

  Widget _buildIntroCard() {
    final target =
        _mealTarget();

    return Container(
      padding:
          const EdgeInsets.all(
        16,
      ),
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
              borderColor,
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
                  .auto_awesome_rounded,
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
                const Text(
                  'أنشئ أكثر من خيار',
                  style:
                      TextStyle(
                    fontSize:
                        12.5,
                    fontWeight:
                        FontWeight.w900,
                    color:
                        textPrimary,
                  ),
                ),
                const SizedBox(
                    height: 4),
                Text(
                  'هدف ${widget.mealType}: حوالي ${target.round()} سعرة.',
                  style:
                      const TextStyle(
                    color:
                        textSecondary,
                    fontSize:
                        9,
                  ),
                ),
                const SizedBox(
                    height: 3),
                const Text(
                  'يمكنك تكرار أي خيار أكثر من مرة خلال الأسبوع.',
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
        ],
      ),
    );
  }

  // ============================================================
  // TEMPLATE CARD
  // ============================================================

  Widget _buildTemplateCard(
    MealTemplate template,
  ) {
    final meal =
        template.meal;

    final target =
        _mealTarget();

    final difference =
        (meal.calories - target)
            .abs();

    final closeToTarget =
        difference <= 60;

    return Container(
      margin:
          const EdgeInsets.only(
        bottom:
            10,
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
          21,
        ),
        border:
            Border.all(
          color:
              template.isFavorite
                  ? primary
                  : borderColor,
          width:
              template.isFavorite
                  ? 1.3
                  : 1,
        ),
      ),
      child:
          Column(
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              _buildMealImage(
                template,
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
                    Row(
                      children: [
                        Expanded(
                          child:
                              Text(
                            template.name,
                            maxLines:
                                1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style:
                                const TextStyle(
                              fontSize:
                                  13,
                              fontWeight:
                                  FontWeight.w900,
                              color:
                                  textPrimary,
                            ),
                          ),
                        ),
                        if (template.isFavorite)
                          const Icon(
                            Icons.star_rounded,
                            color:
                                Color(
                              0xFFFFB52E,
                            ),
                            size:
                                17,
                          ),
                      ],
                    ),

                    const SizedBox(
                        height:
                            4),

                    Text(
                      _ingredientsPreview(
                        meal,
                      ),
                      maxLines:
                          1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                        color:
                            textSecondary,
                        fontSize:
                            8.5,
                      ),
                    ),

                    const SizedBox(
                        height:
                            8),

                    Row(
                      children: [
                        _miniStat(
                          '${meal.calories.round()}',
                          'kcal',
                          primary,
                        ),
                        const SizedBox(
                            width:
                                5),
                        _miniStat(
                          '${meal.protein.round()}g',
                          'P',
                          const Color(
                            0xFF4978E8,
                          ),
                        ),
                        const SizedBox(
                            width:
                                5),
                        _miniStat(
                          '${meal.carbs.round()}g',
                          'C',
                          const Color(
                            0xFFE7A32E,
                          ),
                        ),
                        const SizedBox(
                            width:
                                5),
                        _miniStat(
                          '${meal.fat.round()}g',
                          'F',
                          const Color(
                            0xFFE36868,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              IconButton(
                visualDensity:
                    VisualDensity.compact,
                tooltip:
                    'خيارات',
                onPressed:
                    () =>
                        _showActions(
                  template,
                ),
                icon:
                    const Icon(
                  Icons
                      .more_horiz_rounded,
                  color:
                      textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(
              height:
                  10),

          Row(
            children: [
              Expanded(
                child:
                    Container(
                  height:
                      34,
                  alignment:
                      Alignment.center,
                  decoration:
                      BoxDecoration(
                    color:
                        closeToTarget
                            ? const Color(
                                0xFFEEF9F3,
                              )
                            : const Color(
                                0xFFF8F7FC,
                              ),
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                  child:
                      Text(
                    closeToTarget
                        ? 'قريب من هدف الوجبة'
                        : '${difference.round()} سعرة عن الهدف',
                    style:
                        TextStyle(
                      color:
                          closeToTarget
                              ? const Color(
                                  0xFF2FA66A,
                                )
                              : textSecondary,
                      fontSize:
                          8,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                  width:
                      7),

              SizedBox(
                height:
                    34,
                child:
                    OutlinedButton(
                  onPressed:
                      () =>
                          _useTemplate(
                    template,
                  ),
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
                        10,
                      ),
                    ),
                  ),
                  child:
                      const Text(
                    'استخدام',
                    style:
                        TextStyle(
                      fontSize:
                          8.5,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // IMAGE
  // ============================================================

  Widget _buildMealImage(
    MealTemplate template,
  ) {
    if (template.meal.items.isEmpty) {
      return _fallbackImage();
    }

    final imageUrl =
        template
            .meal
            .items
            .first
            .food
            .imageUrl;

    if (imageUrl.isEmpty) {
      return _fallbackImage();
    }

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(
        16,
      ),
      child:
          SizedBox(
        width:
            61,
        height:
            61,
        child:
            Image.network(
          imageUrl,
          fit:
              BoxFit.cover,
          errorBuilder:
              (
            context,
            error,
            stackTrace,
          ) {
            return _fallbackImage();
          },
        ),
      ),
    );
  }

  Widget _fallbackImage() {
    return Container(
      width:
          61,
      height:
          61,
      decoration:
          BoxDecoration(
        color:
            const Color(
          0xFFF0ECFF,
        ),
        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),
      child:
          const Icon(
        Icons.restaurant_rounded,
        color:
            primary,
      ),
    );
  }

  Widget _miniStat(
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            6,
        vertical:
            4,
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
          8,
        ),
      ),
      child:
          Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Text(
            value,
            style:
                TextStyle(
              color:
                  color,
              fontSize:
                  7.5,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
          const SizedBox(
              width:
                  2),
          Text(
            label,
            style:
                TextStyle(
              color:
                  color,
              fontSize:
                  6.5,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CREATE ANOTHER
  // ============================================================

  Widget _buildCreateAnotherButton() {
    return SizedBox(
      width:
          double.infinity,
      height:
          52,
      child:
          OutlinedButton.icon(
        onPressed:
            _createNewOption,
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
              17,
            ),
          ),
        ),
        icon:
            const Icon(
          Icons.add_rounded,
        ),
        label:
            Text(
          'إنشاء ${widget.mealType} جديد',
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
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          30,
        ),
        child:
            Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              width:
                  76,
              height:
                  76,
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
                    .restaurant_menu_rounded,
                color:
                    primary,
                size:
                    32,
              ),
            ),

            const SizedBox(
                height:
                    15),

            Text(
              'أنشئ أول ${widget.mealType}',
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                fontSize:
                    17,
                fontWeight:
                    FontWeight.w900,
                color:
                    textPrimary,
              ),
            ),

            const SizedBox(
                height:
                    6),

            const Text(
              'يمكنك إنشاء خيار واحد أو عدة خيارات ثم استخدامها في أيام مختلفة.',
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                color:
                    textSecondary,
                fontSize:
                    9.5,
                height:
                    1.5,
              ),
            ),

            const SizedBox(
                height:
                    20),

            SizedBox(
              width:
                  double.infinity,
              height:
                  53,
              child:
                  FilledButton.icon(
                onPressed:
                    _createNewOption,
                style:
                    FilledButton.styleFrom(
                  backgroundColor:
                      primary,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      17,
                    ),
                  ),
                ),
                icon:
                    const Icon(
                  Icons.add_rounded,
                ),
                label:
                    Text(
                  'إنشاء ${widget.mealType}',
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
  // FOOTER
  // ============================================================

  Widget _buildFooter() {
    final hasTemplates =
        _templates.isNotEmpty;

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
                    hasTemplates
                        ? '${_templates.length} خيارات جاهزة'
                        : 'ابدأ بخيار واحد',
                    style:
                        const TextStyle(
                      fontSize:
                          10.5,
                      fontWeight:
                          FontWeight.w900,
                      color:
                          textPrimary,
                    ),
                  ),
                  const SizedBox(
                      height:
                          3),
                  const Text(
                    'يمكنك إنشاء خيارات إضافية متى شئت.',
                    maxLines:
                        1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        TextStyle(
                      color:
                          textSecondary,
                      fontSize:
                          8,
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
                  49,
              child:
                  FilledButton(
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
                onPressed:
                    hasTemplates
                        ? _finishMealOptions
                        : _createNewOption,
                child:
                    Text(
                  hasTemplates
                      ? 'انتهيت'
                      : 'ابدأ',
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
  // CREATE
  // ============================================================

  Future<void> _createNewOption() async {
    final result =
        await Navigator.push<MealTemplate>(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
                MealBuilderScreen(
          mealType:
              widget.mealType,
          time:
              widget.time,
          plan:
              widget.plan,
          foods:
              const [],
          goalProfile:
              widget.goalProfile,
        ),
      ),
    );

    if (!mounted ||
        result == null) {
      return;
    }

    final number =
        _templates.length + 1;

    final template =
        result.copyWith(
      name:
          '${widget.mealType} ${number.toString().padLeft(2, '0')}',
    );

    setState(() {
      _templates.add(
        template,
      );
    });

    _showSnack(
      'تم حفظ ${template.name}.',
    );
  }

  // ============================================================
  // EDIT
  // ============================================================

  Future<void> _editTemplate(
    MealTemplate template,
  ) async {
    final result =
        await Navigator.push<MealTemplate>(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
                MealBuilderScreen(
          mealType:
              widget.mealType,
          time:
              widget.time,
          plan:
              widget.plan,
          foods:
              template.meal.items
                  .map(
                    (item) =>
                        item.food,
                  )
                  .toList(),
          existingTemplate:
              template,
          goalProfile:
              widget.goalProfile,
        ),
      ),
    );

    if (!mounted ||
        result == null) {
      return;
    }

    final index =
        _templates.indexWhere(
      (item) =>
          item.id ==
          template.id,
    );

    if (index == -1) {
      return;
    }

    final updated =
        result.copyWith(
      id:
          template.id,
      name:
          template.name,
      isFavorite:
          template.isFavorite,
    );

    setState(() {
      _templates[index] =
          updated;
    });

    _showSnack(
      'تم تحديث ${template.name}.',
    );
  }

  // ============================================================
  // ACTIONS SHEET
  // ============================================================

  void _showActions(
    MealTemplate template,
  ) {
    showModalBottomSheet<void>(
      context:
          context,
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
            25,
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
                    height:
                        14),

                Text(
                  template.name,
                  style:
                      const TextStyle(
                    fontSize:
                        18,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(
                    height:
                        10),

                _actionTile(
                  Icons.edit_outlined,
                  'تعديل الوجبة',
                  () {
                    Navigator.pop(
                      context,
                    );
                    _editTemplate(
                      template,
                    );
                  },
                ),

                _actionTile(
                  Icons.copy_outlined,
                  'نسخ الوجبة',
                  () {
                    Navigator.pop(
                      context,
                    );
                    _duplicateTemplate(
                      template,
                    );
                  },
                ),

                _actionTile(
                  template.isFavorite
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  template.isFavorite
                      ? 'إزالة من المفضلة'
                      : 'تعيين كمفضلة',
                  () {
                    Navigator.pop(
                      context,
                    );
                    _toggleFavorite(
                      template,
                    );
                  },
                ),

                _actionTile(
                  Icons.playlist_add_rounded,
                  'استخدامه الآن',
                  () {
                    Navigator.pop(
                      context,
                    );
                    _useTemplate(
                      template,
                    );
                  },
                ),

                _actionTile(
                  Icons.info_outline_rounded,
                  'عرض التفاصيل',
                  () {
                    Navigator.pop(
                      context,
                    );
                    _showDetails(
                      template,
                    );
                  },
                ),

                _actionTile(
                  Icons.delete_outline_rounded,
                  'حذف',
                  () {
                    Navigator.pop(
                      context,
                    );
                    _deleteTemplate(
                      template,
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

  Widget _actionTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool destructive = false,
  }) {
    final color =
        destructive
            ? const Color(
                0xFFE45858,
              )
            : primary;

    return ListTile(
      onTap:
          onTap,
      contentPadding:
          EdgeInsets.zero,
      leading:
          Container(
        width:
            41,
        height:
            41,
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
          color:
              color,
          size:
              18,
        ),
      ),
      title:
          Text(
        title,
        style:
            TextStyle(
          color:
              destructive
                  ? const Color(
                      0xFFE45858,
                    )
                  : const Color(
                      0xFF303044,
                    ),
          fontSize:
              11,
          fontWeight:
              FontWeight.w700,
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

  // ============================================================
  // DUPLICATE
  // ============================================================

  void _duplicateTemplate(
    MealTemplate template,
  ) {
    final copy =
        template.copyWith(
      id:
          '${template.id}_copy_${DateTime.now().millisecondsSinceEpoch}',
      name:
          '${widget.mealType} ${(_templates.length + 1).toString().padLeft(2, '0')}',
      isFavorite:
          false,
    );

    setState(() {
      _templates.add(
        copy,
      );
    });

    _showSnack(
      'تم إنشاء نسخة جديدة.',
    );
  }

  // ============================================================
  // FAVORITE
  // ============================================================

  void _toggleFavorite(
    MealTemplate template,
  ) {
    final index =
        _templates.indexWhere(
      (item) =>
          item.id ==
          template.id,
    );

    if (index == -1) {
      return;
    }

    setState(() {
      _templates[index] =
          template.copyWith(
        isFavorite:
            !template.isFavorite,
      );
    });
  }

  // ============================================================
  // DELETE
  // ============================================================

  void _deleteTemplate(
    MealTemplate template,
  ) {
    showDialog<void>(
      context:
          context,
      builder:
          (_) {
        return AlertDialog(
          title:
              const Text(
            'حذف الخيار؟',
          ),
          content:
              Text(
            'سيتم حذف ${template.name} من خيارات ${widget.mealType}.',
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
              style:
                  FilledButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFFE45858,
                ),
              ),
              onPressed:
                  () {
                setState(() {
                  _templates
                      .removeWhere(
                    (item) =>
                        item.id ==
                        template.id,
                  );
                });

                Navigator.pop(
                  context,
                );

                _showSnack(
                  'تم حذف ${template.name}.',
                );
              },
              child:
                  const Text(
                'حذف',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // USE TEMPLATE
  // ============================================================

  Future<void> _useTemplate(
    MealTemplate template,
  ) async {
    final updatedPlan =
        await Navigator.push<WeeklyPlan>(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
                MealDistributionScreen(
          plan:
              widget.plan,
          template:
              template,
          mealType:
              widget.mealType,
        ),
      ),
    );

    if (!mounted ||
        updatedPlan == null) {
      return;
    }

    // لا نعيد WeeklyPlan مباشرة من MealOptionsScreen.
    // الصفحة الأب تتوقع List<MealTemplate>.
    //
    // في هذه المرحلة نكتفي بإبقاء المستخدم داخل
    // شاشة الخيارات بعد نجاح التوزيع.

    _showSnack(
      'تم توزيع ${template.name} على الأسبوع.',
    );
  }

  // ============================================================
  // DETAILS
  // ============================================================

  void _showDetails(
    MealTemplate template,
  ) {
    final meal =
        template.meal;

    showModalBottomSheet<void>(
      context:
          context,
      backgroundColor:
          Colors.transparent,
      isScrollControlled:
          true,
      builder:
          (_) {
        return Container(
          constraints:
              const BoxConstraints(
            maxHeight:
                650,
          ),
          padding:
              const EdgeInsets.fromLTRB(
            20,
            14,
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
                SingleChildScrollView(
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  _sheetHandle(),

                  const SizedBox(
                      height:
                          15),

                  Text(
                    template.name,
                    style:
                        const TextStyle(
                      fontSize:
                          21,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),

                  const SizedBox(
                      height:
                          6),

                  Text(
                    '${meal.calories.round()} سعرة • '
                    '${meal.protein.round()}غ بروتين • '
                    '${meal.carbs.round()}غ كارب • '
                    '${meal.fat.round()}غ دهون',
                    style:
                        const TextStyle(
                      color:
                          primary,
                      fontSize:
                          9.5,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  const SizedBox(
                      height:
                          17),

                  const Text(
                    'مكونات الوجبة',
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
                          9),

                  ...meal.items.map(
                    (item) {
                      return Container(
                        margin:
                            const EdgeInsets
                                .only(
                          bottom:
                              7,
                        ),
                        padding:
                            const EdgeInsets
                                .all(
                          11,
                        ),
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFFFAFAFD,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            13,
                          ),
                        ),
                        child:
                            Row(
                          children: [
                            Expanded(
                              child:
                                  Text(
                                item
                                    .food
                                    .name,
                                style:
                                    const TextStyle(
                                  fontSize:
                                      10,
                                  fontWeight:
                                      FontWeight
                                          .w800,
                                ),
                              ),
                            ),
                            Text(
                              '${item.amountInGrams.round()}غ',
                              style:
                                  const TextStyle(
                                color:
                                    textSecondary,
                                fontSize:
                                    8.5,
                              ),
                            ),
                            const SizedBox(
                                width:
                                    10),
                            Text(
                              '${item.calories.round()} kcal',
                              style:
                                  const TextStyle(
                                color:
                                    primary,
                                fontSize:
                                    8,
                                fontWeight:
                                    FontWeight
                                        .w800,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _goBack() {
    Navigator.pop<List<MealTemplate>>(
      context,
      List<MealTemplate>.from(
        _templates,
      ),
    );
  }

  void _finishMealOptions() {
    Navigator.pop<List<MealTemplate>>(
      context,
      List<MealTemplate>.from(
        _templates,
      ),
    );
  }

  // ============================================================
  // TARGET
  // ============================================================

  double _mealTarget() {
    final daily =
        widget.goalProfile.dailyCalories;

    final count =
        widget.goalProfile.mealsPerDay;

    if (count <= 0) {
      return daily;
    }

    if (count == 2) {
      return daily * 0.50;
    }

    if (count == 3) {
      switch (widget.mealType) {
        case 'الإفطار':
          return daily * 0.25;

        case 'الغداء':
          return daily * 0.40;

        case 'العشاء':
          return daily * 0.35;

        default:
          return daily / count;
      }
    }

    if (count == 4) {
      switch (widget.mealType) {
        case 'الإفطار':
          return daily * 0.25;

        case 'الغداء':
          return daily * 0.35;

        case 'العشاء':
          return daily * 0.25;

        default:
          return daily * 0.15;
      }
    }

    if (count == 5) {
      switch (widget.mealType) {
        case 'الإفطار':
          return daily * 0.20;

        case 'الغداء':
          return daily * 0.30;

        case 'العشاء':
          return daily * 0.28;

        default:
          return daily * 0.11;
      }
    }

    return daily / count;
  }

  // ============================================================
  // HELPERS
  // ============================================================

  String _ingredientsPreview(
    dynamic meal,
  ) {
    final items =
        meal.items;

    if (items.isEmpty) {
      return 'لا توجد مكونات';
    }

    return items
        .map(
          (item) =>
              item.food.name,
        )
        .take(4)
        .join(' • ');
  }

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