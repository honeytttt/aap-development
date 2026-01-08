class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime createdAt;
  final int likes;
  final List<String> replies;
  final String? parentCommentId; // null for top-level comments

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.createdAt,
    this.likes = 0,
    this.replies = const [],
    this.parentCommentId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      likes: json['likes'] ?? 0,
      replies: List<String>.from(json['replies'] ?? []),
      parentCommentId: json['parentCommentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'replies': replies,
      'parentCommentId': parentCommentId,
    };
  }

  Comment copyWith({
    String? id,
    String? postId,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    DateTime? createdAt,
    int? likes,
    List<String>? replies,
    String? parentCommentId,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      replies: replies ?? this.replies,
      parentCommentId: parentCommentId ?? this.parentCommentId,
    );
  }
}
