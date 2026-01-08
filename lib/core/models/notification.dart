enum NotificationType {
  like,
  comment,
  reply,
  follow,
  mention,
  system,
}

enum NotificationStatus {
  unread,
  read,
}

class Notification {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String? userId;           // User who triggered the notification
  final String? userName;
  final String? userAvatar;
  final String? postId;           // Related post (if any)
  final String? commentId;        // Related comment (if any)
  final DateTime createdAt;
  NotificationStatus status;
  final Map<String, dynamic>? metadata;

  Notification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.userId,
    this.userName,
    this.userAvatar,
    this.postId,
    this.commentId,
    required this.createdAt,
    this.status = NotificationStatus.unread,
    this.metadata,
  });

  // Mark as read
  void markAsRead() {
    status = NotificationStatus.read;
  }

  // Check if notification is unread
  bool get isUnread => status == NotificationStatus.unread;

  // Get icon based on notification type
  String get icon {
    switch (type) {
      case NotificationType.like:
        return '❤️';
      case NotificationType.comment:
        return '💬';
      case NotificationType.reply:
        return '↩️';
      case NotificationType.follow:
        return '👤';
      case NotificationType.mention:
        return '@';
      case NotificationType.system:
        return '🔔';
      default:
        return '🔔';
    }
  }

  // Get color based on notification type
  String get color {
    switch (type) {
      case NotificationType.like:
        return '#FF5252'; // Red
      case NotificationType.comment:
        return '#2196F3'; // Blue
      case NotificationType.reply:
        return '#4CAF50'; // Green
      case NotificationType.follow:
        return '#9C27B0'; // Purple
      case NotificationType.mention:
        return '#FF9800'; // Orange
      case NotificationType.system:
        return '#607D8B'; // Blue Grey
      default:
        return '#9E9E9E'; // Grey
    }
  }

  // Factory method to create from JSON
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.system,
      ),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      postId: json['postId'],
      commentId: json['commentId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      status: json['status'] == 'read'
          ? NotificationStatus.read
          : NotificationStatus.unread,
      metadata: json['metadata'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'title': title,
      'message': message,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'postId': postId,
      'commentId': commentId,
      'createdAt': createdAt.toIso8601String(),
      'status': status == NotificationStatus.read ? 'read' : 'unread',
      'metadata': metadata,
    };
  }
}
