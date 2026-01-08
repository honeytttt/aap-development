
class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime createdAt;
  final int likes;
  final List<String> likedBy;
  final List<Comment> replies; // Now contains actual Comment objects, not just IDs
  final String? parentCommentId; // null for top-level comments
  final int depth; // 0 for top-level, 1 for reply to top-level, etc.
  final bool isExpanded; // For UI expansion state

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.createdAt,
    this.likes = 0,
    this.likedBy = const [],
    this.replies = const [],
    this.parentCommentId,
    this.depth = 0,
    this.isExpanded = true,
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
      likedBy: List<String>.from(json['likedBy'] ?? []),
      replies: (json['replies'] as List? ?? [])
          .map((replyJson) => Comment.fromJson(replyJson))
          .toList(),
      parentCommentId: json['parentCommentId'],
      depth: json['depth'] ?? 0,
      isExpanded: json['isExpanded'] ?? true,
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
      'likedBy': likedBy,
      'replies': replies.map((reply) => reply.toJson()).toList(),
      'parentCommentId': parentCommentId,
      'depth': depth,
      'isExpanded': isExpanded,
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
    List<String>? likedBy,
    List<Comment>? replies,
    String? parentCommentId,
    int? depth,
    bool? isExpanded,
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
      likedBy: likedBy ?? this.likedBy,
      replies: replies ?? this.replies,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      depth: depth ?? this.depth,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  // Helper method to add a reply
  Comment addReply(Comment reply) {
    return copyWith(
      replies: [...replies, reply],
    );
  }

  // Helper method to toggle expansion
  Comment toggleExpanded() {
    return copyWith(
      isExpanded: !isExpanded,
    );
  }

  // Helper to like/unlike comment
  Comment toggleLike(String userId) {
    final newLikedBy = List<String>.from(likedBy);
    final isLiked = newLikedBy.contains(userId);
    
    if (isLiked) {
      newLikedBy.remove(userId);
      return copyWith(
        likes: likes - 1,
        likedBy: newLikedBy,
      );
    } else {
      newLikedBy.add(userId);
      return copyWith(
        likes: likes + 1,
        likedBy: newLikedBy,
      );
    }
  }
}

// Helper class to manage comment threads
class CommentThread {
  final List<Comment> topLevelComments;
  final Map<String, Comment> allComments;

  CommentThread({
    required this.topLevelComments,
    required this.allComments,
  });

  // Flatten comments for display
  List<Comment> get flattenedComments {
    final List<Comment> result = [];
    
    void addCommentWithReplies(Comment comment) {
      result.add(comment);
      if (comment.isExpanded) {
        for (final reply in comment.replies) {
          addCommentWithReplies(reply);
        }
      }
    }
    
    for (final comment in topLevelComments) {
      addCommentWithReplies(comment);
    }
    
    return result;
  }

  // Add a new comment (either top-level or reply)
  CommentThread addComment(Comment comment) {
    final newAllComments = Map<String, Comment>.from(allComments);
    newAllComments[comment.id] = comment;
    
    if (comment.parentCommentId == null) {
      // Top-level comment
      return CommentThread(
        topLevelComments: [...topLevelComments, comment],
        allComments: newAllComments,
      );
    } else {
      // Reply to existing comment
      final parent = newAllComments[comment.parentCommentId!];
      if (parent != null) {
        final updatedParent = parent.addReply(comment);
        newAllComments[comment.parentCommentId!] = updatedParent;
        
        // Update top-level comments if needed
        List<Comment> updatedTopLevel = topLevelComments;
        if (parent.parentCommentId == null) {
          // Parent is top-level, replace it
          updatedTopLevel = topLevelComments.map((c) => 
            c.id == parent.id ? updatedParent : c
          ).toList();
        }
        
        return CommentThread(
          topLevelComments: updatedTopLevel,
          allComments: newAllComments,
        );
      }
    }
    
    return this;
  }
}
