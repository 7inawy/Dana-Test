import 'package:dana/core/widgets/custom_app_bar.dart';
import 'package:dana/extensions/localization_extension.dart';
import 'package:dana/features/notification/presentation/widgets/notification_item.dart';
import 'package:dana/features/notification/presentation/widgets/notification_section_title.dart';
import 'package:dana/providers/app_theme_provider.dart';
import 'package:dana/features/notification/data/models/notification_model.dart';
import 'package:dana/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  static const String routeName = 'NotificationScreen';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  late List<AppNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = const [];
  }

  List<AppNotification> get _unread =>
      _notifications.where((n) => !n.isRead).toList();

  List<AppNotification> get _read =>
      _notifications.where((n) => n.isRead).toList();

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
      }
    });
  }

  void _markAsRead(AppNotification notification) {
    if (!notification.isRead) {
      setState(() {
        notification.isRead = true;
        _notifications = List.from(_notifications)
          ..remove(notification)
          ..insert(0, notification);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDark =
        themeProvider.appTheme == ThemeMode.dark ||
        (themeProvider.appTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.notificationsTitle,
        isDark: isDark,
      ),
      body: AnimatedSize(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          children: [
            if (_notifications.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: 48.h),
                child: Center(
                  child: Text(
                    context.l10n.notificationsEmpty,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.medium12TextBody(context),
                  ),
                ),
              ),
            if (_unread.isNotEmpty) ...[
              NotificationSectionTitle(
                title: context.l10n.notificationsNew,
                showMarkAll: true,
                markAllLabel: context.l10n.markAllAsRead,
                onMarkAll: _markAllAsRead,
              ),
              SizedBox(height: 12.h),
              ..._unread.map(
                (n) => NotificationItem(
                  notification: n,
                  onTap: () => _markAsRead(n),
                ),
              ),
              SizedBox(height: 24.h),
            ],
            if (_read.isNotEmpty) ...[
              NotificationSectionTitle(
                title: context.l10n.notificationsOld,
                showMarkAll: false,
              ),
              SizedBox(height: 12.h),
              ..._read.map(
                (n) => NotificationItem(
                  notification: n,
                  onTap: () => _markAsRead(n),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
