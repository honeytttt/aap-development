import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/notifications/providers/notifications_provider.dart';

class NotificationBadge extends StatelessWidget {
  final Color? color;
  final Color? textColor;
  final double? size;

  const NotificationBadge({
    Key? key,
    this.color = Colors.red,
    this.textColor = Colors.white,
    this.size = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsProvider>(
      builder: (context, provider, child) {
        if (provider.unreadCount == 0) {
          return const SizedBox.shrink();
        }

        final count = provider.unreadCount > 99 ? '99+' : '${provider.unreadCount}';
        
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          constraints: BoxConstraints(
            minWidth: size!,
            minHeight: size!,
          ),
          child: Center(
            child: Text(
              count,
              style: TextStyle(
                color: textColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
