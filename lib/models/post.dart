class Comment {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final String avatarUrl;
  final String content;
  final DateTime timestamp;
  int likes;
  bool isLiked;
  final String? parentCommentId; // For nested comments
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    required this.avatarUrl,
    required this.content,
    required this.timestamp,
    this.likes = 0,
    this.isLiked = false,
    this.parentCommentId,
    this.replies = const [],
  });

  Comment copyWith({
    String? id,
    String? postId,
    String? userId,
    String? username,
    String? avatarUrl,
    String? content,
    DateTime? timestamp,
    int? likes,
    bool? isLiked,
    String? parentCommentId,
    List<Comment>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      replies: replies ?? this.replies,
    );
  }
}

class Post {
  final String id;
  final String userId;
  final String username;
  final String avatarUrl;
  final String content;
  final DateTime timestamp;
  int likes;
  bool isLiked;
  int commentsCount;
  final List<Comment> comments;
  final String? imageUrl;
  final List<String> hashtags;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.avatarUrl,
    required this.content,
    required this.timestamp,
    required this.likes,
    required this.isLiked,
    required this.commentsCount,
    this.comments = const [],
    this.imageUrl,
    required this.hashtags,
  });

  Post copyWith({
    String? id,
    String? userId,
    String? username,
    String? avatarUrl,
    String? content,
    DateTime? timestamp,
    int? likes,
    bool? isLiked,
    int? commentsCount,
    List<Comment>? comments,
    String? imageUrl,
    List<String>? hashtags,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      commentsCount: commentsCount ?? this.commentsCount,
      comments: comments ?? this.comments,
      imageUrl: imageUrl ?? this.imageUrl,
      hashtags: hashtags ?? this.hashtags,
    );
  }
}
