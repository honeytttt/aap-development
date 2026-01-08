import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/core/models/notification.dart';
import 'package:workout_app/features/notifications/providers/notifications_provider.dart';

class NotificationItem extends StatelessWidget {
  final AppNotification notification;
  
  const NotificationItem({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmation(context);
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          Provider.of<NotificationsProvider>(context, listen: false)
              .deleteNotification(notification.id);
        }
      },
      child: Card(
        color: notification.isRead ? Colors.white : Colors.blue[50],
        elevation: 1,
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: notification.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              _getNotificationIcon(notification.type),
              color: notification.color,
              size: 28,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                _formatTime(notification.timestamp),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(notification.body),
              if (notification.message != null && notification.message!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      notification.message!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
            ],
          ),
          trailing: !notification.isRead
              ? Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
          onTap: () {
            if (!notification.isRead) {
              Provider.of<NotificationsProvider>(context, listen: false)
                  .markAsRead(notification.id);
            }
            _handleNotificationTap(context);
          },
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification'),
        content: const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _handleNotificationTap(BuildContext context) {
    // Handle different notification types
    switch (notification.type) {
      case AppNotificationType.like:
      case AppNotificationType.comment:
        if (notification.postId != null) {
          // Navigate to post
          // Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailScreen(postId: notification.postId!)));
        }
        break;
      case AppNotificationType.follow:
        if (notification.userId != null) {
          // Navigate to profile
          // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(userId: notification.userId!)));
        }
        break;
      default:
        break;
    }
  }

  IconData _getNotificationIcon(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.like:
        return Icons.favorite;
      case AppNotificationType.comment:
        return Icons.comment;
      case AppNotificationType.follow:
        return Icons.person_add;
      case AppNotificationType.workout:
        return Icons.fitness_center;
      case AppNotificationType.achievement:
        return Icons.emoji_events;
      case AppNotificationType.system:
        return Icons.info;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
