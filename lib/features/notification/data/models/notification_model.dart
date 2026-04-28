import 'package:flutter/material.dart';

enum NotificationType { vaccine, reminder }

class AppNotification {
  final String title;
  final String body;
  final TimeOfDay time;
  bool isRead;
  final NotificationType type;

  AppNotification({
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
    required this.type,
  });
}
