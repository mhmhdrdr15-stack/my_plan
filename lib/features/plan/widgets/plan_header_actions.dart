import 'package:flutter/material.dart';

class PlanHeaderActions {
  static Future<void> showDatePickerForPlan({
    required BuildContext context,
    required DateTime selectedDate,
    required ValueChanged<DateTime> onDateSelected,
  }) async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: DateTime(now.year + 1, now.month, now.day),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: PlanColors.primary,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: PlanColors.text,
          ),
          datePickerTheme: DatePickerThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            headerBackgroundColor: PlanColors.primary,
            headerForegroundColor: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (result != null) onDateSelected(result);
  }

  static Future<void> showPlanActions({
    required BuildContext context,
    required DateTime selectedDate,
    required bool hasPlan,
    VoidCallback? onEditPlan,
    VoidCallback? onCreatePlan,
    VoidCallback? onCopyPlan,
    VoidCallback? onApplyToAnotherDay,
    VoidCallback? onCopyFromAnotherDay,
    VoidCallback? onResetPlan,
    VoidCallback? onClearPlan,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => PlanActionsBottomSheet(
        selectedDate: selectedDate,
        hasPlan: hasPlan,
        onEditPlan: onEditPlan,
        onCreatePlan: onCreatePlan,
        onCopyPlan: onCopyPlan,
        onApplyToAnotherDay: onApplyToAnotherDay,
        onCopyFromAnotherDay: onCopyFromAnotherDay,
        onResetPlan: onResetPlan,
        onClearPlan: onClearPlan,
      ),
    );
  }
}

class PlanActionsBottomSheet extends StatelessWidget {
  final DateTime selectedDate;
  final bool hasPlan;
  final VoidCallback? onEditPlan;
  final VoidCallback? onCreatePlan;
  final VoidCallback? onCopyPlan;
  final VoidCallback? onApplyToAnotherDay;
  final VoidCallback? onCopyFromAnotherDay;
  final VoidCallback? onResetPlan;
  final VoidCallback? onClearPlan;

  const PlanActionsBottomSheet({
    super.key,
    required this.selectedDate,
    required this.hasPlan,
    this.onEditPlan,
    this.onCreatePlan,
    this.onCopyPlan,
    this.onApplyToAnotherDay,
    this.onCopyFromAnotherDay,
    this.onResetPlan,
    this.onClearPlan,
  });

  String get dateLabel =>
      '${_months[selectedDate.month - 1]} ${selectedDate.day}, ${selectedDate.year}';

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final actions = hasPlan
        ? [
            _PlanAction(
              Icons.edit_outlined,
              "Edit Today's Plan",
              'Change meals, foods, portions or times',
              PlanColors.primary,
              onEditPlan,
            ),
            _PlanAction(
              Icons.copy_outlined,
              'Copy Plan',
              'Copy this entire plan',
              const Color(0xFF7656E8),
              onCopyPlan,
            ),
            _PlanAction(
              Icons.calendar_view_day_outlined,
              'Apply to Another Day',
              'Copy this plan to another date',
              const Color(0xFF477BFF),
              onApplyToAnotherDay,
            ),
            _PlanAction(
              Icons.restart_alt_rounded,
              'Reset Plan',
              'Restore the suggested plan',
              PlanColors.orange,
              onResetPlan,
            ),
            _PlanAction(
              Icons.delete_outline_rounded,
              'Clear Today\'s Plan',
              'Remove all planned meals',
              PlanColors.red,
              onClearPlan,
            ),
          ]
        : [
            _PlanAction(
              Icons.add_circle_outline_rounded,
              "Create Today's Plan",
              'Start planning meals for today',
              PlanColors.primary,
              onCreatePlan,
            ),
            _PlanAction(
              Icons.content_copy_rounded,
              'Copy From Another Day',
              'Use an existing day as your plan',
              const Color(0xFF477BFF),
              onCopyFromAnotherDay,
            ),
          ];

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDE1EA),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EEFF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.calendar_month_outlined,
                    color: PlanColors.primary,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Plan Actions',
                        style: TextStyle(
                          color: PlanColors.text,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateLabel,
                        style: const TextStyle(
                          color: PlanColors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFEEF0F4)),
            const SizedBox(height: 8),
            for (final action in actions)
              PlanActionTile(
                icon: action.icon,
                title: action.title,
                subtitle: action.subtitle,
                color: action.color,
                onTap: () {
                  Navigator.pop(context);
                  action.onTap?.call();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _PlanAction {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _PlanAction(
    this.icon,
    this.title,
    this.subtitle,
    this.color,
    this.onTap,
  );
}

class PlanActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const PlanActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(15),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.09),
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
                    color: PlanColors.text,
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
                    color: PlanColors.muted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            color: PlanColors.muted2,
            size: 21,
          ),
        ],
      ),
    ),
  );
}

class PlanDialogs {
  static Future<void> showResetConfirmation(
    BuildContext context, {
    VoidCallback? onConfirm,
  }) async {
    await _showConfirmation(
      context,
      title: 'Reset Today\'s Plan?',
      message:
          'Your current planned meals will be replaced by the suggested plan.',
      confirmLabel: 'Reset Plan',
      color: PlanColors.orange,
      onConfirm: onConfirm,
    );
  }

  static Future<void> showClearConfirmation(
    BuildContext context, {
    VoidCallback? onConfirm,
  }) async {
    await _showConfirmation(
      context,
      title: 'Clear Today\'s Plan?',
      message: 'All planned meals for today will be removed.',
      confirmLabel: 'Clear Plan',
      color: PlanColors.red,
      onConfirm: onConfirm,
    );
  }

  static Future<void> showChooseTargetDay(
    BuildContext context, {
    required ValueChanged<DateTime> onSelected,
  }) async {
    final today = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today.subtract(const Duration(days: 365)),
      lastDate: today.add(const Duration(days: 365)),
    );
    if (selected != null) onSelected(selected);
  }

  static Future<void> showChooseSourceDay(
    BuildContext context, {
    required ValueChanged<DateTime> onSelected,
  }) async {
    await showChooseTargetDay(context, onSelected: onSelected);
  }

  static Future<void> _showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required Color color,
    VoidCallback? onConfirm,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: const TextStyle(
            color: PlanColors.text,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(color: PlanColors.muted, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm?.call();
            },
            style: FilledButton.styleFrom(backgroundColor: color),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }
}

class PlanPageHeader extends StatelessWidget {
  final DateTime selectedDate;
  final bool hasPlan;
  final ValueChanged<DateTime> onDateChanged;
  final VoidCallback? onEditPlan;
  final VoidCallback? onCreatePlan;
  final VoidCallback? onCopyPlan;
  final VoidCallback? onApplyToAnotherDay;
  final VoidCallback? onCopyFromAnotherDay;
  final VoidCallback? onResetPlan;
  final VoidCallback? onClearPlan;

  const PlanPageHeader({
    super.key,
    required this.selectedDate,
    required this.hasPlan,
    required this.onDateChanged,
    this.onEditPlan,
    this.onCreatePlan,
    this.onCopyPlan,
    this.onApplyToAnotherDay,
    this.onCopyFromAnotherDay,
    this.onResetPlan,
    this.onClearPlan,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan',
              style: TextStyle(
                color: PlanColors.text,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Plan your meals. Stay on track.',
              style: TextStyle(
                color: PlanColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      _headerButton(
        context,
        Icons.calendar_month_outlined,
        () => PlanHeaderActions.showDatePickerForPlan(
          context: context,
          selectedDate: selectedDate,
          onDateSelected: onDateChanged,
        ),
      ),
      const SizedBox(width: 7),
      _headerButton(
        context,
        Icons.more_horiz_rounded,
        () => PlanHeaderActions.showPlanActions(
          context: context,
          selectedDate: selectedDate,
          hasPlan: hasPlan,
          onEditPlan: onEditPlan,
          onCreatePlan: onCreatePlan,
          onCopyPlan: onCopyPlan,
          onApplyToAnotherDay: onApplyToAnotherDay,
          onCopyFromAnotherDay: onCopyFromAnotherDay,
          onResetPlan: onResetPlan,
          onClearPlan: onClearPlan,
        ),
      ),
    ],
  );

  Widget _headerButton(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
  ) => Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: const Color(0xFFEFF1F5)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x09000000),
          blurRadius: 12,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: IconButton(
      padding: EdgeInsets.zero,
      tooltip: icon == Icons.more_horiz_rounded
          ? 'Plan actions'
          : 'Choose date',
      onPressed: onTap,
      icon: Icon(icon, size: 21, color: PlanColors.text),
    ),
  );
}

class PlanColors {
  static const text = Color(0xFF17203A);
  static const muted = Color(0xFF7B849A);
  static const muted2 = Color(0xFFA0A8B8);
  static const primary = Color(0xFF5B35F5);
  static const orange = Color(0xFFFF8A16);
  static const red = Color(0xFFFF3E4B);
}
