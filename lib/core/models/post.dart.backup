class Post {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final List<String> images;
  final DateTime createdAt;
  final int likes;
  final List<String> likedBy;
  final int commentCount;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.images = const [],
    required this.createdAt,
    this.likes = 0,
    this.likedBy = const [],
    this.commentCount = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      content: json['content'],
      images: List<String>.from(json['images'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      likes: json['likes'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
      commentCount: json['commentCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'content': content,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'likedBy': likedBy,
      'commentCount': commentCount,
    };
  }

  Post copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    List<String>? images,
    DateTime? createdAt,
    int? likes,
    List<String>? likedBy,
    int? commentCount,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
      commentCount: commentCount ?? this.commentCount,
    );
  }
}
