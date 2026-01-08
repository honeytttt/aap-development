import 'package:flutter/material.dart';
import 'user.dart';
import 'comment.dart';
import 'media.dart';

class Post {
  final String id;
  final User user;
  final String caption;
  final List<String> hashtags;
  final List<MediaItem> media;
  final DateTime createdAt;
  int likesCount;
  int commentsCount;
  bool isLiked;
  List<Comment> comments;
  final String? workoutType;
  final int? duration;
  final int? calories;

  Post({
    required this.id,
    required this.user,
    required this.caption,
    this.hashtags = const [],
    required this.media,
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.comments = const [],
    this.workoutType,
    this.duration,
    this.calories,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'caption': caption,
      'hashtags': hashtags,
      'media': media.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLiked': isLiked,
      'comments': comments.map((c) => c.toJson()).toList(),
      'workoutType': workoutType,
      'duration': duration,
      'calories': calories,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      user: User.fromJson(json['user']),
      caption: json['caption'],
      hashtags: List<String>.from(json['hashtags'] ?? []),
      media: (json['media'] as List)
          .map((m) => MediaItem.fromJson(m))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      comments: (json['comments'] as List?)
          ?.map((c) => Comment.fromJson(c))
          .toList() ?? [],
      workoutType: json['workoutType'],
      duration: json['duration'],
      calories: json['calories'],
    );
  }

  Post copyWith({
    String? id,
    User? user,
    String? caption,
    List<String>? hashtags,
    List<MediaItem>? media,
    DateTime? createdAt,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    List<Comment>? comments,
    String? workoutType,
    int? duration,
    int? calories,
  }) {
    return Post(
      id: id ?? this.id,
      user: user ?? this.user,
      caption: caption ?? this.caption,
      hashtags: hashtags ?? this.hashtags,
      media: media ?? this.media,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      comments: comments ?? this.comments,
      workoutType: workoutType ?? this.workoutType,
      duration: duration ?? this.duration,
      calories: calories ?? this.calories,
    );
  }
}
