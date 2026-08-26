import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool mealReminders = true;
  bool waterReminders = true;
  bool dailySummary = true;
  bool weeklyProgress = true;
  bool goalInsights = true;
  bool streaks = true;

  TimeOfDay breakfastTime = const TimeOfDay(hour: 7, minute: 45);
  TimeOfDay lunchTime = const TimeOfDay(hour: 13, minute: 45);
  TimeOfDay snackTime = const TimeOfDay(hour: 17, minute: 15);
  TimeOfDay dinnerTime = const TimeOfDay(hour: 20, minute: 15);

  Future<void> chooseTime({
    required String type,
    required TimeOfDay current,
  }) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: current,
    );
    if (selected == null || !mounted) return;

    setState(() {
      switch (type) {
        case 'breakfast':
          breakfastTime = selected;
        case 'lunch':
          lunchTime = selected;
        case 'snack':
          snackTime = selected;
        case 'dinner':
          dinnerTime = selected;
      }
    });
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FC),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
          color: const Color(0xFF17203A),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF17203A),
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
        children: [
          const SettingsSectionTitle(title: 'General'),
          SettingsSwitchTile(
            icon: Icons.restaurant_rounded,
            iconColor: const Color(0xFFFF8A16),
            title: 'Meal reminders',
            subtitle: 'Remind me before planned meals',
            value: mealReminders,
            onChanged: (value) => setState(() => mealReminders = value),
          ),
          SettingsSwitchTile(
            icon: Icons.water_drop_rounded,
            iconColor: const Color(0xFF317BFF),
            title: 'Water reminders',
            subtitle: 'Remind me to stay hydrated',
            value: waterReminders,
            onChanged: (value) => setState(() => waterReminders = value),
          ),
          SettingsSwitchTile(
            icon: Icons.nightlight_outlined,
            iconColor: const Color(0xFF5B35F5),
            title: 'Daily summary',
            subtitle: 'Show my nutrition summary at night',
            value: dailySummary,
            onChanged: (value) => setState(() => dailySummary = value),
          ),
          SettingsSwitchTile(
            icon: Icons.bar_chart_rounded,
            iconColor: const Color(0xFF7656E8),
            title: 'Weekly progress',
            subtitle: 'Notify me when my weekly report is ready',
            value: weeklyProgress,
            onChanged: (value) => setState(() => weeklyProgress = value),
          ),
          SettingsSwitchTile(
            icon: Icons.lightbulb_outline_rounded,
            iconColor: const Color(0xFF5B35F5),
            title: 'Goal insights',
            subtitle: 'Helpful nutrition recommendations',
            value: goalInsights,
            onChanged: (value) => setState(() => goalInsights = value),
          ),
          SettingsSwitchTile(
            icon: Icons.local_fire_department_rounded,
            iconColor: const Color(0xFFFF6D1A),
            title: 'Streaks & achievements',
            subtitle: 'Celebrate milestones and streaks',
            value: streaks,
            onChanged: (value) => setState(() => streaks = value),
          ),
          const SizedBox(height: 22),
          const SettingsSectionTitle(title: 'Meal reminder times'),
          TimeSettingTile(
            title: 'Breakfast',
            time: formatTime(breakfastTime),
            enabled: mealReminders,
            onTap: () => chooseTime(type: 'breakfast', current: breakfastTime),
          ),
          TimeSettingTile(
            title: 'Lunch',
            time: formatTime(lunchTime),
            enabled: mealReminders,
            onTap: () => chooseTime(type: 'lunch', current: lunchTime),
          ),
          TimeSettingTile(
            title: 'Snack',
            time: formatTime(snackTime),
            enabled: mealReminders,
            onTap: () => chooseTime(type: 'snack', current: snackTime),
          ),
          TimeSettingTile(
            title: 'Dinner',
            time: formatTime(dinnerTime),
            enabled: mealReminders,
            onTap: () => chooseTime(type: 'dinner', current: dinnerTime),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFEFF1F5)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF6D7588),
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'We will avoid unnecessary notifications and automatically stop reminders when an action has already been completed.',
                    style: TextStyle(
                      color: Color(0xFF7B849A),
                      fontSize: 11,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsSectionTitle extends StatelessWidget {
  final String title;

  const SettingsSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 3, bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
        color: Color(0xFF7B849A),
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFEFF1F5)),
    ),
    child: Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(.09),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 21),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF17203A),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF7B849A),
                  fontSize: 10.5,
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          activeColor: const Color(0xFF5B35F5),
          onChanged: onChanged,
        ),
      ],
    ),
  );
}

class TimeSettingTile extends StatelessWidget {
  final String title;
  final String time;
  final bool enabled;
  final VoidCallback onTap;

  const TimeSettingTile({
    super.key,
    required this.title,
    required this.time,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: enabled ? 1 : .45,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEFF1F5)),
      ),
      child: ListTile(
        enabled: enabled,
        onTap: enabled ? onTap : null,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF1EEFF),
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.schedule_rounded,
            color: Color(0xFF5B35F5),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF17203A),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              time,
              style: const TextStyle(
                color: Color(0xFF5B35F5),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFA0A8B8)),
          ],
        ),
      ),
    ),
  );
}
