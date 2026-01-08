class Comment {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final DateTime createdAt;
  int likesCount;
  bool isLiked;
  final String? parentCommentId;
  List<Comment> replies;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.createdAt,
    this.likesCount = 0,
    this.isLiked = false,
    this.parentCommentId,
    this.replies = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'likesCount': likesCount,
      'isLiked': isLiked,
      'parentCommentId': parentCommentId,
      'replies': replies.map((r) => r.toJson()).toList(),
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
      likesCount: json['likesCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      parentCommentId: json['parentCommentId'],
      replies: (json['replies'] as List?)
          ?.map((r) => Comment.fromJson(r))
          .toList() ?? [],
    );
  }

  Comment copyWith({
    String? id,
    String? userId,
    String? userName,
    String? text,
    DateTime? createdAt,
    int? likesCount,
    bool? isLiked,
    String? parentCommentId,
    List<Comment>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      replies: replies ?? this.replies,
    );
  }
}
