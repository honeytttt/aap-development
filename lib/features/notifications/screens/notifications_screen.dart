import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/notifications/providers/notifications_provider.dart';
import 'package:workout_app/features/notifications/widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final provider = Provider.of<NotificationsProvider>(context, listen: false);
    await provider.loadNotifications();
  }

  Future<void> _refreshNotifications() async {
    final provider = Provider.of<NotificationsProvider>(context, listen: false);
    await provider.refreshNotifications();
  }

  void _markAllAsRead() {
    final provider = Provider.of<NotificationsProvider>(context, listen: false);
    provider.markAllAsRead();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text('Are you sure you want to clear all notifications?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final provider = Provider.of<NotificationsProvider>(context, listen: false);
              provider.clearAllNotifications();
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications cleared'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSimulation() {
    final provider = Provider.of<NotificationsProvider>(context, listen: false);
    provider.toggleNotificationSimulation();
    
    final message = provider.simulationActive
        ? 'Notification simulation started'
        : 'Notification simulation stopped';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _simulateNewNotification() {
    final provider = Provider.of<NotificationsProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Simulate Notification'),
        content: const Text('Select notification type to simulate'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.simulateNewNotification(type: NotificationType.like);
              Navigator.pop(context);
            },
            child: const Text('Like'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.simulateNewNotification(type: NotificationType.comment);
              Navigator.pop(context);
            },
            child: const Text('Comment'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationsProvider>(context);
    final notifications = provider.notifications;
    final unreadCount = provider.unreadCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          // Mark all as read
          if (unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.mark_email_read),
              tooltip: 'Mark all as read',
              onPressed: _markAllAsRead,
            ),
          
          // Clear all
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear all notifications',
              onPressed: _clearAllNotifications,
            ),
          
          // Simulate notification
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Simulate notification',
            onPressed: _simulateNewNotification,
          ),
          
          // Simulation toggle
          IconButton(
            icon: Icon(
              provider.simulationActive
                  ? Icons.notifications_paused
                  : Icons.notifications_active,
            ),
            tooltip: provider.simulationActive
                ? 'Stop simulation'
                : 'Start simulation',
            onPressed: _toggleSimulation,
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No notifications yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'When you get notifications, they\'ll appear here',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _simulateNewNotification,
                        icon: const Icon(Icons.add_alert),
                        label: const Text('Simulate Notification'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshNotifications,
                  color: Colors.green,
                  child: ListView.separated(
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: Colors.grey[200],
                    ),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return NotificationItem(
                        notification: notification,
                        onTap: () {
                          provider.markAsRead(notification.id);
                          // TODO: Navigate to relevant screen based on notification type
                          if (notification.postId != null) {
                            // Navigate to post
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Navigating to post ${notification.postId}'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                        onDismiss: () {
                          provider.deleteNotification(notification.id);
                        },
                        showDivider: index < notifications.length - 1,
                      );
                    },
                  ),
                ),
      // Floating action button for simulation
      floatingActionButton: FloatingActionButton(
        onPressed: _simulateNewNotification,
        backgroundColor: Colors.green[600],
        child: const Icon(Icons.add_alert, color: Colors.white),
      ),
    );
  }
}
