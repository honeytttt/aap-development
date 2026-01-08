import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:workout_app/core/models/notification.dart';

class NotificationsProvider with ChangeNotifier {
  List<Notification> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  bool _simulationActive = false;
  Timer? _simulationTimer;

  List<Notification> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  bool get simulationActive => _simulationActive;

  // Mock notifications data
  final List<Map<String, dynamic>> _mockNotifications = [
    {
      'id': 'notif_1',
      'type': 'like',
      'title': 'New Like',
      'message': 'Fitness Enthusiast liked your post',
      'userId': 'user1',
      'userName': 'Fitness Enthusiast',
      'userAvatar': 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=FE',
      'postId': '1',
      'createdAt': DateTime.now().subtract(const Duration(minutes: 5)),
      'status': 'unread',
    },
    {
      'id': 'notif_2',
      'type': 'comment',
      'title': 'New Comment',
      'message': 'Gym Buddy commented on your post: "Great workout!"',
      'userId': 'user2',
      'userName': 'Gym Buddy',
      'userAvatar': 'https://via.placeholder.com/150/2196F3/FFFFFF?text=GB',
      'postId': '1',
      'commentId': 'c1',
      'createdAt': DateTime.now().subtract(const Duration(hours: 1)),
      'status': 'read',
    },
    {
      'id': 'notif_3',
      'type': 'follow',
      'title': 'New Follower',
      'message': 'Yoga Master started following you',
      'userId': 'user3',
      'userName': 'Yoga Master',
      'userAvatar': 'https://via.placeholder.com/150/FF5722/FFFFFF?text=YM',
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'read',
    },
    {
      'id': 'notif_4',
      'type': 'reply',
      'title': 'Reply to Comment',
      'message': 'Yoga Master replied to your comment',
      'userId': 'user3',
      'userName': 'Yoga Master',
      'userAvatar': 'https://via.placeholder.com/150/FF5722/FFFFFF?text=YM',
      'postId': '2',
      'commentId': 'c2_1',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'read',
    },
    {
      'id': 'notif_5',
      'type': 'mention',
      'title': 'You were mentioned',
      'message': 'Fitness Enthusiast mentioned you in a comment',
      'userId': 'user1',
      'userName': 'Fitness Enthusiast',
      'userAvatar': 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=FE',
      'postId': '1',
      'commentId': 'c1',
      'createdAt': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'read',
    },
    {
      'id': 'notif_6',
      'type': 'system',
      'title': 'Welcome to Workout App!',
      'message': 'Start sharing your fitness journey with the community',
      'createdAt': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'read',
    },
  ];

  // Load notifications
  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      // Convert mock data to Notification objects
      _notifications = _mockNotifications
          .map((data) => Notification.fromJson(data))
          .toList();
      
      // Update unread count
      _updateUnreadCount();
      
    } catch (e) {
      if (kDebugMode) {
        print('Error loading notifications: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh notifications
  Future<void> refreshNotifications() async {
    await loadNotifications();
  }

  // Mark notification as read
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index].markAsRead();
      _updateUnreadCount();
      notifyListeners();
    }
  }

  // Mark all as read
  void markAllAsRead() {
    for (final notification in _notifications) {
      notification.markAsRead();
    }
    _updateUnreadCount();
    notifyListeners();
  }

  // Delete notification
  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    _updateUnreadCount();
    notifyListeners();
  }

  // Clear all notifications
  void clearAllNotifications() {
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
  }

  // Update unread count
  void _updateUnreadCount() {
    _unreadCount = _notifications.where((n) => n.isUnread).length;
  }

  // Simulate receiving new notification
  void simulateNewNotification({
    NotificationType type = NotificationType.like,
    String? userName,
    String? userAvatar,
    String? postId,
  }) {
    final user = userName ?? 'Fitness Fan';
    final avatar = userAvatar ?? 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=FF';
    
    String title;
    String message;
    
    switch (type) {
      case NotificationType.like:
        title = 'New Like';
        message = '$user liked your post';
        break;
      case NotificationType.comment:
        title = 'New Comment';
        message = '$user commented on your post';
        break;
      case NotificationType.reply:
        title = 'Reply to Comment';
        message = '$user replied to your comment';
        break;
      case NotificationType.follow:
        title = 'New Follower';
        message = '$user started following you';
        break;
      case NotificationType.mention:
        title = 'You were mentioned';
        message = '$user mentioned you in a comment';
        break;
      case NotificationType.system:
        title = 'System Update';
        message = 'New features available in the app';
        break;
    }
    
    final newNotification = Notification(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      title: title,
      message: message,
      userId: 'simulated_user',
      userName: user,
      userAvatar: avatar,
      postId: postId,
      createdAt: DateTime.now(),
      status: NotificationStatus.unread,
    );
    
    _notifications.insert(0, newNotification);
    _updateUnreadCount();
    notifyListeners();
    
    // Show snackbar or toast (this would be handled by UI)
    if (kDebugMode) {
      print('📱 New notification: $title - $message');
    }
  }

  // Start notification simulation
  void startNotificationSimulation() {
    if (_simulationActive) return;
    
    _simulationActive = true;
    notifyListeners();
    
    // Simulate receiving notifications every 10-30 seconds
    _simulationTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (!_simulationActive) {
        timer.cancel();
        return;
      }
      
      // Random notification type
      final types = NotificationType.values;
      final randomType = types[DateTime.now().millisecond % types.length];
      
      simulateNewNotification(type: randomType);
    });
  }

  // Stop notification simulation
  void stopNotificationSimulation() {
    _simulationActive = false;
    _simulationTimer?.cancel();
    _simulationTimer = null;
    notifyListeners();
  }

  // Toggle simulation
  void toggleNotificationSimulation() {
    if (_simulationActive) {
      stopNotificationSimulation();
    } else {
      startNotificationSimulation();
    }
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}
