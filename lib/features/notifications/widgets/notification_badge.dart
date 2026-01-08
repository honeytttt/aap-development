import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/notifications/providers/notifications_provider.dart';

class NotificationBadge extends StatelessWidget {
  final double? size;
  final Color? badgeColor;
  final Color? textColor;
  final bool showCount;

  const NotificationBadge({
    super.key,
    this.size = 24,
    this.badgeColor = Colors.red,
    this.textColor = Colors.white,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationsProvider>(context);
    final count = provider.unreadCount;

    if (count == 0) {
      return const SizedBox.shrink();
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          Icons.notifications,
          size: size,
          color: Theme.of(context).iconTheme.color,
        ),
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: 1.5,
              ),
            ),
            constraints: BoxConstraints(
              minWidth: size! * 0.5,
              minHeight: size! * 0.5,
            ),
            child: Center(
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: TextStyle(
                  color: textColor,
                  fontSize: size! * 0.35,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
