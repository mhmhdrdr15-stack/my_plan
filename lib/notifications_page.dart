import 'package:flutter/material.dart';

class AppNotificationType {
  final IconData icon;
  final Color color;

  const AppNotificationType._(this.icon, this.color);

  static const meal = AppNotificationType._(
    Icons.restaurant_rounded,
    Color(0xFFFF8A16),
  );
  static const water = AppNotificationType._(
    Icons.water_drop_rounded,
    Color(0xFF317BFF),
  );
  static const insight = AppNotificationType._(
    Icons.lightbulb_outline_rounded,
    Color(0xFF5B35F5),
  );
  static const progress = AppNotificationType._(
    Icons.bar_chart_rounded,
    Color(0xFF7656E8),
  );
  static const success = AppNotificationType._(
    Icons.check_circle_outline_rounded,
    Color(0xFF2DAA61),
  );
  static const warning = AppNotificationType._(
    Icons.warning_amber_rounded,
    Color(0xFFFF8A16),
  );
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String time;
  final AppNotificationType type;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });

  AppNotification copyWith({bool? isRead}) => AppNotification(
    id: id,
    title: title,
    message: message,
    time: time,
    type: type,
    isRead: isRead ?? this.isRead,
  );
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<AppNotification> _notifications = [
    const AppNotification(
      id: 'meal-1',
      title: 'Next meal is coming up',
      message: 'Your snack is planned for 5:30 PM.',
      time: '10 min ago',
      type: AppNotificationType.meal,
    ),
    const AppNotification(
      id: 'water-1',
      title: 'Keep drinking water',
      message: 'You are 1.1 L away from your daily goal.',
      time: '35 min ago',
      type: AppNotificationType.water,
    ),
    const AppNotification(
      id: 'insight-1',
      title: 'Daily insight',
      message: 'Add a protein-rich snack to reach your goal.',
      time: '1 hour ago',
      type: AppNotificationType.insight,
    ),
    const AppNotification(
      id: 'progress-1',
      title: 'You are on track',
      message: 'You reached 67% of your calorie goal today.',
      time: 'Yesterday',
      type: AppNotificationType.success,
      isRead: true,
    ),
  ];

  int get unreadCount => _notifications.where((item) => !item.isRead).length;

  void markRead(int index) {
    if (!_notifications[index].isRead) {
      setState(
        () => _notifications[index] = _notifications[index].copyWith(
          isRead: true,
        ),
      );
    }
  }

  void markAllRead() {
    setState(() {
      for (var index = 0; index < _notifications.length; index++) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = _notifications
        .where((item) => item.time != 'Yesterday')
        .toList();
    final earlier = _notifications
        .where((item) => item.time == 'Yesterday')
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: markAllRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? const _EmptyNotifications()
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              children: [
                if (today.isNotEmpty) ...[
                  const _SectionLabel('Today'),
                  ...today.map((item) => _notificationTile(item)),
                ],
                if (earlier.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  const _SectionLabel('Earlier'),
                  ...earlier.map((item) => _notificationTile(item)),
                ],
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => setState(_notifications.clear),
                  icon: const Icon(Icons.delete_sweep_outlined, size: 19),
                  label: const Text('Clear all notifications'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFF3E4B),
                    side: const BorderSide(color: Color(0xFFFFD5D9)),
                    backgroundColor: const Color(0xFFFFF7F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _notificationTile(AppNotification notification) {
    final index = _notifications.indexOf(notification);
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          onTap: () => markRead(index),
          borderRadius: BorderRadius.circular(17),
          child: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: const Color(0xFFEEF0F4)),
              color: notification.isRead
                  ? Colors.white
                  : const Color(0xFFFCFAFF),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: notification.type.color.withOpacity(.11),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    notification.type.icon,
                    color: notification.type.color,
                    size: 21,
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
                              notification.title,
                              style: const TextStyle(
                                color: Color(0xFF17203A),
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          if (!notification.isRead) const _UnreadDot(),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: const TextStyle(
                          color: Color(0xFF7B849A),
                          fontSize: 11,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.time,
                        style: TextStyle(
                          color: notification.type.color,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 2, bottom: 9),
    child: Text(
      text,
      style: const TextStyle(
        color: Color(0xFF7B849A),
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _UnreadDot extends StatelessWidget {
  const _UnreadDot();
  @override
  Widget build(BuildContext context) => Container(
    width: 8,
    height: 8,
    decoration: const BoxDecoration(
      color: Color(0xFF5B35F5),
      shape: BoxShape.circle,
    ),
  );
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF1EEFF),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              color: Color(0xFF5B35F5),
              size: 32,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'You are all caught up',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          const Text(
            'New updates will appear here.',
            style: TextStyle(color: Color(0xFF7B849A), fontSize: 12),
          ),
        ],
      ),
    ),
  );
}
