import 'package:flutter/material.dart';

enum AppNotificationType {
  like,
  comment,
  follow,
  workout,
  achievement,
  system,
}

enum AppNotificationStatus {
  unread,
  read,
  dismissed,
}

class AppNotification {
  final String id;
  final AppNotificationType type;
  final String title;
  final String body;
  final String? userId;
  final String? targetUserId;
  final String? postId;
  final String? commentId;
  final String? message;
  final Color color;
  final IconData icon;
  final DateTime timestamp;
  bool isRead;
  AppNotificationStatus status;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.userId,
    this.targetUserId,
    this.postId,
    this.commentId,
    this.message,
    required this.color,
    required this.icon,
    required this.timestamp,
    this.isRead = false,
    this.status = AppNotificationStatus.unread,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'title': title,
      'body': body,
      'userId': userId,
      'targetUserId': targetUserId,
      'postId': postId,
      'commentId': commentId,
      'message': message,
      'color': color.value,
      'icon': icon.codePoint,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'status': status.toString(),
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      type: AppNotificationType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => AppNotificationType.system,
      ),
      title: json['title'],
      body: json['body'],
      userId: json['userId'],
      targetUserId: json['targetUserId'],
      postId: json['postId'],
      commentId: json['commentId'],
      message: json['message'],
      color: Color(json['color']),
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      status: AppNotificationStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => AppNotificationStatus.unread,
      ),
    );
  }

  AppNotification copyWith({
    String? id,
    AppNotificationType? type,
    String? title,
    String? body,
    String? userId,
    String? targetUserId,
    String? postId,
    String? commentId,
    String? message,
    Color? color,
    IconData? icon,
    DateTime? timestamp,
    bool? isRead,
    AppNotificationStatus? status,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      userId: userId ?? this.userId,
      targetUserId: targetUserId ?? this.targetUserId,
      postId: postId ?? this.postId,
      commentId: commentId ?? this.commentId,
      message: message ?? this.message,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      status: status ?? this.status,
    );
  }
}
