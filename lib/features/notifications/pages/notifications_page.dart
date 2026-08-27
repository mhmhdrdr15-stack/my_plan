import 'package:flutter/material.dart';
import 'package:my_plan/core/localization/app_localization.dart';
import 'package:my_plan/features/notifications/models/notification_model.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<AppNotification> notifications = [
    const AppNotification(
      id: '1',
      title: 'Lunch is coming up',
      message: 'Your lunch is planned for 2:00 PM.',
      time: '10 min ago',
      type: AppNotificationType.meal,
      isRead: false,
    ),
    const AppNotification(
      id: '2',
      title: "You're behind on hydration",
      message: "You still need 1.1 L to reach today's goal.",
      time: '1 hour ago',
      type: AppNotificationType.water,
      isRead: false,
    ),
    const AppNotification(
      id: '3',
      title: "You're doing great today",
      message: "You're on track to reach your calorie target.",
      time: '3 hours ago',
      type: AppNotificationType.success,
      isRead: true,
    ),
    const AppNotification(
      id: '4',
      title: "You're short on protein",
      message: 'You still need around 45g of protein today.',
      time: 'Yesterday',
      type: AppNotificationType.insight,
      isRead: true,
    ),
    const AppNotification(
      id: '5',
      title: '7 day streak! 🔥',
      message: "You've logged your meals consistently for 7 days.",
      time: 'Yesterday',
      type: AppNotificationType.streak,
      isRead: true,
    ),
    const AppNotification(
      id: '6',
      title: 'Your weekly progress is ready',
      message: 'See your calorie, protein and consistency trends.',
      time: 'Monday',
      type: AppNotificationType.progress,
      isRead: true,
    ),
  ];

  int get unreadCount => notifications.where((item) => !item.isRead).length;

  void markAllAsRead() {
    setState(() {
      for (var i = 0; i < notifications.length; i++) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    });
  }

  void markAsRead(int index) {
    if (notifications[index].isRead) return;
    setState(() {
      notifications[index] = notifications[index].copyWith(isRead: true);
    });
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
        title: Row(
          children: [
            Text(
              translateText(context, 'Notifications'),
              style: TextStyle(
                color: Color(0xFF17203A),
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B35F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: markAllAsRead,
              child: Text(
                translateText(context, 'Mark all read'),
                style: TextStyle(
                  color: Color(0xFF5B35F5),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: notifications.isEmpty
          ? const EmptyNotifications()
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
              children: [
                _buildSectionTitle(translateText(context, 'Today')),
                const SizedBox(height: 8),
                ...notifications
                    .asMap()
                    .entries
                    .where(
                      (entry) =>
                          entry.value.time != 'Yesterday' &&
                          entry.value.time != 'Monday',
                    )
                    .map((entry) => _notificationItem(entry)),
                const SizedBox(height: 11),
                _buildSectionTitle(translateText(context, 'Earlier')),
                const SizedBox(height: 8),
                ...notifications
                    .asMap()
                    .entries
                    .where(
                      (entry) =>
                          entry.value.time == 'Yesterday' ||
                          entry.value.time == 'Monday',
                    )
                    .map((entry) => _notificationItem(entry)),
              ],
            ),
    );
  }

  Widget _notificationItem(MapEntry<int, AppNotification> entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: NotificationCard(
        notification: entry.value,
        onTap: () {
          markAsRead(entry.key);
          _handleNotification(entry.value);
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF7B849A),
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  void _handleNotification(AppNotification notification) {
    switch (notification.type) {
      case AppNotificationType.meal:
        _showMessage('Open Meal Details');
        break;
      case AppNotificationType.water:
        _showMessage('Open Log Water');
        break;
      case AppNotificationType.insight:
        _showMessage('Open Daily Insights');
        break;
      case AppNotificationType.progress:
      case AppNotificationType.streak:
        _showMessage('Open Progress');
        break;
      case AppNotificationType.success:
        _showMessage('Open Today Details');
        break;
      case AppNotificationType.warning:
      case AppNotificationType.general:
        _showMessage('Open notification');
        break;
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
      );
  }
}

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = notification.type.color;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : const Color(0xFFFBF9FF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: notification.isRead
                  ? const Color(0xFFEFF1F5)
                  : const Color(0xFFE3DCFF),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x09000000),
                blurRadius: 16,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(notification.type.icon, color: color, size: 22),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                                            translateText(context, notification.title),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF17203A),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            margin: const EdgeInsets.only(left: 7, top: 3),
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF5B35F5),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      translateText(context, notification.message),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF7B849A),
                        fontSize: 11,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      translateText(context, notification.time),
                      style: const TextStyle(
                        color: Color(0xFFA0A8B8),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFA0A8B8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: const BoxDecoration(
                color: Color(0xFFF0EEFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF5B35F5),
                size: 40,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              translateText(context, "You're all caught up"),
              style: TextStyle(
                color: Color(0xFF17203A),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              translateText(context, 'No new notifications.'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF7B849A),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
