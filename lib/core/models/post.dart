import 'package:workout_app/core/models/comment.dart';
import 'package:workout_app/core/models/media.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final List<Media> media;
  final List<String> hashtags;
  final List<String> likes;
  final List<Comment> comments;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isDraft;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.media = const [],
    this.hashtags = const [],
    this.likes = const [],
    this.comments = const [],
    required this.createdAt,
    this.updatedAt,
    this.isDraft = false,
  });

  // Add copyWith method to Post class
  Post copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    List<Media>? media,
    List<String>? hashtags,
    List<String>? likes,
    List<Comment>? comments,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDraft,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      media: media ?? this.media,
      hashtags: hashtags ?? this.hashtags,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDraft: isDraft ?? this.isDraft,
    );
  }

  // Factory method to create from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      content: json['content'] ?? '',
      media: (json['media'] as List<dynamic>?)
              ?.map((m) => Media.fromJson(m))
              .toList() ??
          [],
      hashtags: (json['hashtags'] as List<dynamic>?)
              ?.map((h) => h.toString())
              .toList() ??
          [],
      likes: (json['likes'] as List<dynamic>?)
              ?.map((l) => l.toString())
              .toList() ??
          [],
      comments: (json['comments'] as List<dynamic>?)
              ?.map((c) => Comment.fromJson(c))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      isDraft: json['isDraft'] ?? false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'content': content,
      'media': media.map((m) => m.toJson()).toList(),
      'hashtags': hashtags,
      'likes': likes,
      'comments': comments.map((c) => c.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isDraft': isDraft,
    };
  }
}
