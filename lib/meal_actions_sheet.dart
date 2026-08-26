import 'package:flutter/material.dart';

class MealActionStatus {
  final String label;
  final Color color;
  final IconData icon;

  const MealActionStatus._(this.label, this.color, this.icon);

  static const planned = MealActionStatus._(
    'Planned',
    Color(0xFF5B35F5),
    Icons.circle_outlined,
  );
  static const logged = MealActionStatus._(
    'Logged',
    Color(0xFF2DAA61),
    Icons.check_circle_outline_rounded,
  );
  static const skipped = MealActionStatus._(
    'Skipped',
    Color(0xFFFF3E4B),
    Icons.cancel_outlined,
  );
  static const overdue = MealActionStatus._(
    'Overdue',
    Color(0xFFFF8A16),
    Icons.warning_amber_rounded,
  );
}

class MealActionsSheet {
  static Future<void> show({
    required BuildContext context,
    required String mealName,
    required String mealTime,
    required String nutrition,
    required MealActionStatus status,
    VoidCallback? onEditMeal,
    VoidCallback? onLogMeal,
    VoidCallback? onChangeTime,
    VoidCallback? onMoveMeal,
    VoidCallback? onSkipMeal,
    VoidCallback? onRestoreMeal,
    VoidCallback? onViewMeal,
    VoidCallback? onEditLoggedAmount,
    VoidCallback? onRemoveFromPlan,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _MealActionsBottomSheet(
        mealName: mealName,
        mealTime: mealTime,
        nutrition: nutrition,
        status: status,
        onEditMeal: onEditMeal,
        onLogMeal: onLogMeal,
        onChangeTime: onChangeTime,
        onMoveMeal: onMoveMeal,
        onSkipMeal: onSkipMeal,
        onRestoreMeal: onRestoreMeal,
        onViewMeal: onViewMeal,
        onEditLoggedAmount: onEditLoggedAmount,
        onRemoveFromPlan: onRemoveFromPlan,
      ),
    );
  }
}

class _MealActionsBottomSheet extends StatelessWidget {
  final String mealName;
  final String mealTime;
  final String nutrition;
  final MealActionStatus status;
  final VoidCallback? onEditMeal;
  final VoidCallback? onLogMeal;
  final VoidCallback? onChangeTime;
  final VoidCallback? onMoveMeal;
  final VoidCallback? onSkipMeal;
  final VoidCallback? onRestoreMeal;
  final VoidCallback? onViewMeal;
  final VoidCallback? onEditLoggedAmount;
  final VoidCallback? onRemoveFromPlan;

  const _MealActionsBottomSheet({
    required this.mealName,
    required this.mealTime,
    required this.nutrition,
    required this.status,
    this.onEditMeal,
    this.onLogMeal,
    this.onChangeTime,
    this.onMoveMeal,
    this.onSkipMeal,
    this.onRestoreMeal,
    this.onViewMeal,
    this.onEditLoggedAmount,
    this.onRemoveFromPlan,
  });

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetHandle(),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: status.color.withOpacity(.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(status.icon, color: status.color, size: 25),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$mealTime  •  $nutrition',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF7B849A),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(status: status),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEF0F4)),
          const SizedBox(height: 8),
          ..._actions(context),
        ],
      ),
    ),
  );

  List<Widget> _actions(BuildContext context) {
    switch (status) {
      case MealActionStatus.planned:
        return [
          _ActionItem(
            Icons.edit_outlined,
            'Edit Meal',
            'Change foods, portions or meal time',
            status.color,
            onEditMeal,
          ),
          _ActionItem(
            Icons.check_circle_outline_rounded,
            'Log Meal',
            'Mark this meal as eaten',
            const Color(0xFF2DAA61),
            onLogMeal,
          ),
          _ActionItem(
            Icons.schedule_rounded,
            'Change Time',
            'Move this meal to another time',
            const Color(0xFF477BFF),
            onChangeTime,
          ),
          _ActionItem(
            Icons.swap_horiz_rounded,
            'Move Meal',
            'Move this meal to another day',
            const Color(0xFF7656E8),
            onMoveMeal,
          ),
          _ActionItem(
            Icons.skip_next_rounded,
            'Skip Meal',
            'Skip this planned meal',
            const Color(0xFFFF8A16),
            onSkipMeal,
          ),
          _ActionItem(
            Icons.delete_outline_rounded,
            'Remove from Plan',
            'Remove this meal from today',
            const Color(0xFFFF3E4B),
            onRemoveFromPlan,
          ),
        ];
      case MealActionStatus.logged:
        return [
          _ActionItem(
            Icons.visibility_outlined,
            'View Meal',
            'See meal details and nutrition',
            status.color,
            onViewMeal,
          ),
          _ActionItem(
            Icons.tune_rounded,
            'Edit Logged Amount',
            'Change what you actually ate',
            const Color(0xFF2DAA61),
            onEditLoggedAmount,
          ),
          _ActionItem(
            Icons.edit_outlined,
            'Edit Planned Meal',
            'Change the future meal plan',
            const Color(0xFF7656E8),
            onEditMeal,
          ),
          _ActionItem(
            Icons.swap_horiz_rounded,
            'Move Meal',
            'Move the planned meal',
            const Color(0xFF477BFF),
            onMoveMeal,
          ),
          _ActionItem(
            Icons.delete_outline_rounded,
            'Remove from Plan',
            'Remove it from future planning',
            const Color(0xFFFF3E4B),
            onRemoveFromPlan,
          ),
        ];
      case MealActionStatus.skipped:
        return [
          _ActionItem(
            Icons.visibility_outlined,
            'View Meal',
            'See the meal that was planned',
            status.color,
            onViewMeal,
          ),
          _ActionItem(
            Icons.edit_outlined,
            'Edit Meal',
            'Change foods, portions or time',
            const Color(0xFF7656E8),
            onEditMeal,
          ),
          _ActionItem(
            Icons.restore_rounded,
            'Restore Meal',
            'Put this meal back into today',
            const Color(0xFF2DAA61),
            onRestoreMeal,
          ),
          _ActionItem(
            Icons.swap_horiz_rounded,
            'Move Meal',
            'Move this meal to another day',
            const Color(0xFF477BFF),
            onMoveMeal,
          ),
          _ActionItem(
            Icons.delete_outline_rounded,
            'Remove from Plan',
            'Delete this planned meal',
            const Color(0xFFFF3E4B),
            onRemoveFromPlan,
          ),
        ];
      case MealActionStatus.overdue:
        return [
          _ActionItem(
            Icons.check_circle_outline_rounded,
            'Log Meal',
            'Mark this meal as eaten',
            const Color(0xFF2DAA61),
            onLogMeal,
          ),
          _ActionItem(
            Icons.edit_outlined,
            'Edit Meal',
            'Change foods, portions or time',
            status.color,
            onEditMeal,
          ),
          _ActionItem(
            Icons.schedule_rounded,
            'Change Time',
            'Move this meal to another time',
            const Color(0xFF477BFF),
            onChangeTime,
          ),
          _ActionItem(
            Icons.skip_next_rounded,
            'Skip Meal',
            'Skip this overdue meal',
            const Color(0xFFFF8A16),
            onSkipMeal,
          ),
          _ActionItem(
            Icons.delete_outline_rounded,
            'Remove from Plan',
            'Remove this meal from today',
            const Color(0xFFFF3E4B),
            onRemoveFromPlan,
          ),
        ];
    }
    return const <Widget>[];
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _ActionItem(
    this.icon,
    this.title,
    this.subtitle,
    this.color,
    this.onTap,
  );

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () {
      Navigator.pop(context);
      onTap?.call();
    },
    borderRadius: BorderRadius.circular(14),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(.09),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF7B849A),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFFA0A8B8),
            size: 21,
          ),
        ],
      ),
    ),
  );
}

class _StatusPill extends StatelessWidget {
  final MealActionStatus status;
  const _StatusPill({required this.status});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: status.color.withOpacity(.10),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      status.label,
      style: TextStyle(
        color: status.color,
        fontSize: 9.5,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();
  @override
  Widget build(BuildContext context) => Container(
    width: 38,
    height: 4,
    decoration: BoxDecoration(
      color: const Color(0xFFDDE1EA),
      borderRadius: BorderRadius.circular(20),
    ),
  );
}
