import 'package:flutter/foundation.dart';

class NotificationProvider with ChangeNotifier {
  List<Map<String, dynamic>> _notifications = [];
  int _unreadCount = 0;
  
  List<Map<String, dynamic>> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  
  NotificationProvider() {
    _loadMockNotifications();
  }
  
  void _loadMockNotifications() {
    _notifications = [
      {
        'id': '1',
        'title': 'New Like',
        'body': 'Sarah liked your workout post',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
        'type': 'like',
        'read': false,
      },
      {
        'id': '2',
        'title': 'New Comment',
        'body': 'Mike commented on your post',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
        'type': 'comment',
        'read': false,
      },
      {
        'id': '3',
        'title': 'New Follower',
        'body': 'Emma started following you',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
        'type': 'follow',
        'read': true,
      },
      {
        'id': '4',
        'title': 'Workout Reminder',
        'body': 'Time for your evening workout!',
        'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
        'type': 'workout',
        'read': true,
      },
    ];
    
    _updateUnreadCount();
  }
  
  void _updateUnreadCount() {
    _unreadCount = _notifications.where((n) => !n['read']).length;
  }
  
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n['id'] == id);
    if (index != -1 && !_notifications[index]['read']) {
      _notifications[index]['read'] = true;
      _updateUnreadCount();
      notifyListeners();
    }
  }
  
  void markAllAsRead() {
    for (final notification in _notifications) {
      notification['read'] = true;
    }
    _updateUnreadCount();
    notifyListeners();
  }
  
  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n['id'] == id);
    _updateUnreadCount();
    notifyListeners();
  }
  
  void simulateNewNotification() {
    final newNotification = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': 'Test Notification',
      'body': 'This is a test notification from the app',
      'timestamp': DateTime.now(),
      'type': 'like',
      'read': false,
    };
    
    _notifications.insert(0, newNotification);
    _updateUnreadCount();
    notifyListeners();
  }
}
