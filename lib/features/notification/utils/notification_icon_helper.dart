import 'package:dana/features/notification/data/models/notification_model.dart';

class NotificationIconHelper {
  static String getIconPath(NotificationType type) {
    switch (type) {
      case NotificationType.vaccine:
        return 'assets/Icons/notification/vaccine_icon.svg';
      case NotificationType.reminder:
        return 'assets/Icons/notification/light_bill_icon.svg';
    }
  }
}
