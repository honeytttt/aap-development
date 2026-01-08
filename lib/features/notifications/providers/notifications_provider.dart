import 'package:flutter/material.dart';
import 'package:workout_app/core/models/notification.dart';

class NotificationsProvider with ChangeNotifier {
  List<AppNotification> _notifications = [];
  int _unreadCount = 0;

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  NotificationsProvider() {
    _initializeMockNotifications();
  }

  void _initializeMockNotifications() {
    _notifications = [
      AppNotification(
        id: '1',
        type: AppNotificationType.like,
        title: 'New Like',
        body: 'John liked your post',
        userId: 'user2',
        targetUserId: 'currentUser',
        postId: 'post1',
        color: Colors.pink,
        icon: Icons.favorite,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      AppNotification(
        id: '2',
        type: AppNotificationType.comment,
        title: 'New Comment',
        body: 'Sarah commented on your workout',
        userId: 'user3',
        targetUserId: 'currentUser',
        postId: 'post2',
        commentId: 'comment1',
        color: Colors.blue,
        icon: Icons.comment,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      AppNotification(
        id: '3',
        type: AppNotificationType.follow,
        title: 'New Follower',
        body: 'Mike started following you',
        userId: 'user4',
        targetUserId: 'currentUser',
        color: Colors.orange,
        icon: Icons.person_add,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      AppNotification(
        id: '4',
        type: AppNotificationType.workout,
        title: 'Workout Reminder',
        body: "Don't forget your evening workout!",
        color: Colors.green,
        icon: Icons.fitness_center,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AppNotification(
        id: '5',
        type: AppNotificationType.achievement,
        title: 'Achievement Unlocked!',
        body: 'You completed 7-day streak!',
        color: Colors.yellow,
        icon: Icons.emoji_events,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
    
    _updateUnreadCount();
  }

  void _updateUnreadCount() {
    _unreadCount = _notifications.where((n) => !n.isRead).length;
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(
        isRead: true,
        status: AppNotificationStatus.read,
      );
      _updateUnreadCount();
      notifyListeners();
    }
  }

  void markAllAsRead() {
    _notifications = _notifications
        .map((notification) => notification.copyWith(
              isRead: true,
              status: AppNotificationStatus.read,
            ))
        .toList();
    _updateUnreadCount();
    notifyListeners();
  }

  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    _updateUnreadCount();
    notifyListeners();
  }

  void clearAllNotifications() {
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
  }

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    _updateUnreadCount();
    notifyListeners();
  }

  // Simulate real-time notifications
  void simulateNotification(AppNotificationType type) {
    final now = DateTime.now();
    final notifications = {
      AppNotificationType.like: AppNotification(
        id: 'sim_${now.millisecondsSinceEpoch}',
        type: AppNotificationType.like,
        title: 'New Like',
        body: 'User liked your recent post',
        userId: 'sim_user',
        targetUserId: 'currentUser',
        postId: 'sim_post',
        color: Colors.pink,
        icon: Icons.favorite,
        timestamp: now,
      ),
      AppNotificationType.comment: AppNotification(
        id: 'sim_${now.millisecondsSinceEpoch}',
        type: AppNotificationType.comment,
        title: 'New Comment',
        body: 'User commented on your post',
        userId: 'sim_user',
        targetUserId: 'currentUser',
        postId: 'sim_post',
        commentId: 'sim_comment',
        color: Colors.blue,
        icon: Icons.comment,
        timestamp: now,
      ),
      AppNotificationType.follow: AppNotification(
        id: 'sim_${now.millisecondsSinceEpoch}',
        type: AppNotificationType.follow,
        title: 'New Follower',
        body: 'User started following you',
        userId: 'sim_user',
        targetUserId: 'currentUser',
        color: Colors.orange,
        icon: Icons.person_add,
        timestamp: now,
      ),
    };

    if (notifications.containsKey(type)) {
      addNotification(notifications[type]!);
    }
  }
}
