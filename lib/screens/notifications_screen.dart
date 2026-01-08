import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notificationProvider.unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.done_all),
              onPressed: () {
                notificationProvider.markAllAsRead();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All notifications marked as read'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              tooltip: 'Mark all as read',
            ),
          IconButton(
            icon: const Icon(Icons.add_alert),
            onPressed: () {
              notificationProvider.simulateNewNotification();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('New notification added!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            tooltip: 'Add test notification',
          ),
        ],
      ),
      body: notificationProvider.notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No notifications yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'When you get notifications, they\'ll appear here',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<NotificationProvider>(context, listen: false)
                          .simulateNewNotification();
                    },
                    icon: const Icon(Icons.add_alert),
                    label: const Text('Add Test Notification'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Unread count badge
                if (notificationProvider.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: Colors.green[50],
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${notificationProvider.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'unread notifications',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            notificationProvider.markAllAsRead();
                          },
                          child: const Text(
                            'MARK ALL READ',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: notificationProvider.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notificationProvider.notifications[index];
                      return Dismissible(
                        key: Key(notification.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          final deletedNotification = notification;
                          notificationProvider.deleteNotification(notification.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Notification deleted'),
                              backgroundColor: Colors.red,
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  notificationProvider.addNotification(deletedNotification);
                                },
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: notification.isRead ? Colors.white : Colors.green[50],
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getNotificationColor(notification.type),
                              child: _getNotificationIcon(notification.type),
                            ),
                            title: Text(
                              notification.username,
                              style: TextStyle(
                                fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(notification.message),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTime(notification.timestamp),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            trailing: notification.isRead
                                ? IconButton(
                                    icon: const Icon(Icons.close, size: 18),
                                    onPressed: () {
                                      notificationProvider.deleteNotification(notification.id);
                                    },
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.check_circle, color: Colors.green),
                                    onPressed: () {
                                      notificationProvider.markAsRead(notification.id);
                                    },
                                  ),
                            onTap: () {
                              if (!notification.isRead) {
                                notificationProvider.markAsRead(notification.id);
                              }
                              _handleNotificationTap(context, notification);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Icon _getNotificationIcon(String type) {
    switch (type) {
      case 'like':
        return const Icon(Icons.favorite, color: Colors.white, size: 20);
      case 'comment':
        return const Icon(Icons.comment, color: Colors.white, size: 20);
      case 'follow':
        return const Icon(Icons.person_add, color: Colors.white, size: 20);
      case 'workout':
        return const Icon(Icons.fitness_center, color: Colors.white, size: 20);
      case 'achievement':
        return const Icon(Icons.emoji_events, color: Colors.white, size: 20);
      default:
        return const Icon(Icons.notifications, color: Colors.white, size: 20);
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'like':
        return Colors.red;
      case 'comment':
        return Colors.blue;
      case 'follow':
        return Colors.green;
      case 'workout':
        return Colors.orange;
      case 'achievement':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _handleNotificationTap(BuildContext context, AppNotification notification) {
    switch (notification.type) {
      case 'like':
      case 'comment':
        if (notification.postId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Navigating to post ${notification.postId}'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
        break;
      case 'follow':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigating to ${notification.username}\'s profile'),
            duration: const Duration(seconds: 1),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification tapped'),
            duration: Duration(seconds: 1),
          ),
        );
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
