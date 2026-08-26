import 'package:flutter/material.dart';

enum AppNotificationType {
  meal,
  water,
  insight,
  progress,
  streak,
  success,
  warning,
  general,
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

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      time: time,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }
}

extension AppNotificationTypeExtension on AppNotificationType {
  IconData get icon {
    switch (this) {
      case AppNotificationType.meal:
        return Icons.restaurant_rounded;
      case AppNotificationType.water:
        return Icons.water_drop_rounded;
      case AppNotificationType.insight:
        return Icons.lightbulb_outline_rounded;
      case AppNotificationType.progress:
        return Icons.bar_chart_rounded;
      case AppNotificationType.streak:
        return Icons.local_fire_department_rounded;
      case AppNotificationType.success:
        return Icons.check_circle_outline_rounded;
      case AppNotificationType.warning:
        return Icons.warning_amber_rounded;
      case AppNotificationType.general:
        return Icons.notifications_none_rounded;
    }
  }

  Color get color {
    switch (this) {
      case AppNotificationType.meal:
        return const Color(0xFFFF8A16);
      case AppNotificationType.water:
        return const Color(0xFF317BFF);
      case AppNotificationType.insight:
        return const Color(0xFF5B35F5);
      case AppNotificationType.progress:
        return const Color(0xFF7656E8);
      case AppNotificationType.streak:
        return const Color(0xFFFF6D1A);
      case AppNotificationType.success:
        return const Color(0xFF2DAA61);
      case AppNotificationType.warning:
        return const Color(0xFFFF8A16);
      case AppNotificationType.general:
        return const Color(0xFF697389);
    }
  }
}
