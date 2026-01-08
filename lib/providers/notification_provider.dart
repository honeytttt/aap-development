import 'package:flutter/foundation.dart';

class AppNotification {
  final String id;
  final String type;
  final String message;
  final String userId;
  final String username;
  final String? postId;
  final DateTime timestamp;
  bool isRead;

  AppNotification({
    required this.id,
    required this.type,
    required this.message,
    required this.userId,
    required this.username,
    this.postId,
    required this.timestamp,
    this.isRead = false,
  });
}

class NotificationProvider with ChangeNotifier {
  List<AppNotification> _notifications = [];
  int _unreadCount = 0;

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  NotificationProvider() {
    _initializeMockNotifications();
  }

  void _initializeMockNotifications() {
    _notifications = [
      AppNotification(
        id: 'notif1',
        type: 'like',
        message: 'liked your post',
        userId: 'user2',
        username: 'YogaMaster',
        postId: 'post1',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      AppNotification(
        id: 'notif2',
        type: 'comment',
        message: 'commented on your post',
        userId: 'user3',
        username: 'GymRat',
        postId: 'post1',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AppNotification(
        id: 'notif3',
        type: 'follow',
        message: 'started following you',
        userId: 'user4',
        username: 'FitnessNewbie',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      AppNotification(
        id: 'notif4',
        type: 'workout',
        message: 'completed a 5k run',
        userId: 'user1',
        username: 'FitnessPro',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      AppNotification(
        id: 'notif5',
        type: 'achievement',
        message: 'earned "Marathon Runner" badge',
        userId: 'current_user',
        username: 'You',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
    
    _updateUnreadCount();
    notifyListeners();
  }

  void _updateUnreadCount() {
    _unreadCount = _notifications.where((n) => !n.isRead).length;
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index].isRead = true;
      _updateUnreadCount();
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    _updateUnreadCount();
    notifyListeners();
  }

  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    _updateUnreadCount();
    notifyListeners();
  }

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    _updateUnreadCount();
    notifyListeners();
  }

  void simulateNewNotification() {
    final types = ['like', 'comment', 'follow'];
    final users = ['FitnessPro', 'YogaMaster', 'GymRat', 'FitMom'];
    final messages = [
      'liked your post',
      'commented: "Great workout!"',
      'started following you',
      'shared your post',
    ];
    
    final randomType = types[DateTime.now().millisecond % types.length];
    final randomUser = users[DateTime.now().second % users.length];
    final randomMessage = messages[DateTime.now().millisecond % messages.length];
    
    addNotification(
      AppNotification(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        type: randomType,
        message: randomMessage,
        userId: 'user_${DateTime.now().millisecond}',
        username: randomUser,
        timestamp: DateTime.now(),
      ),
    );
  }
}
