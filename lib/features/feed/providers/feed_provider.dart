import 'package:flutter/foundation.dart';
import 'package:workout_app/core/models/post.dart';
import 'package:workout_app/core/models/comment.dart';

class FeedProvider with ChangeNotifier {
  List<Post> _posts = [];
  List<Comment> _comments = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;

  FeedProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    _isLoading = true;
    notifyListeners();

    // Mock posts
    _posts = [
      Post(
        id: '1',
        userId: 'user1',
        userName: 'Yoga Enthusiast',
        userAvatar: 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=YE',
        content: 'Just completed a peaceful morning yoga session. Feeling energized and ready for the day!',
        images: [],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 42,
        likedBy: ['user2', 'user3'],
        commentCount: 5,
      ),
      Post(
        id: '2',
        userId: 'user2',
        userName: 'Meditation Guide',
        userAvatar: 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=MG',
        content: '10 minutes of mindful breathing can transform your entire day. Try it!',
        images: [],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        likes: 89,
        likedBy: ['user1'],
        commentCount: 12,
      ),
    ];

    // Mock comments (no replies yet - Phase 4B will add nested replies)
    _comments = [
      Comment(
        id: 'c1',
        postId: '1',
        userId: 'user2',
        userName: 'Meditation Guide',
        userAvatar: 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=MG',
        content: 'Great job! Yoga truly changes lives.',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        likes: 5,
        replies: [],
      ),
      Comment(
        id: 'c2',
        postId: '1',
        userId: 'user3',
        userName: 'Wellness Warrior',
        userAvatar: 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=WW',
        content: 'Which yoga poses did you focus on today?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        likes: 2,
        replies: [],
      ),
    ];

    Future.delayed(const Duration(milliseconds: 500), () {
      _isLoading = false;
      notifyListeners();
    });
  }

  void likePost(String postId, String userId) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts[index];
      if (post.likedBy.contains(userId)) {
        // Unlike
        _posts[index] = post.copyWith(
          likes: post.likes - 1,
          likedBy: List<String>.from(post.likedBy)..remove(userId),
        );
      } else {
        // Like
        _posts[index] = post.copyWith(
          likes: post.likes + 1,
          likedBy: List<String>.from(post.likedBy)..add(userId),
        );
      }
      notifyListeners();
    }
  }

  void addComment(String postId, String userId, String userName, String userAvatar, String content) {
    final newComment = Comment(
      id: 'c${DateTime.now().millisecondsSinceEpoch}',
      postId: postId,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      content: content,
      createdAt: DateTime.now(),
      likes: 0,
      replies: [],
    );

    _comments.insert(0, newComment);

    // Update post comment count
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      _posts[postIndex] = post.copyWith(
        commentCount: post.commentCount + 1,
      );
    }

    notifyListeners();
  }

  void likeComment(String commentId, String userId) {
    // Basic implementation - will be enhanced for nested replies in Phase 4B
    final index = _comments.indexWhere((comment) => comment.id == commentId);
    if (index != -1) {
      final comment = _comments[index];
      _comments[index] = comment.copyWith(
        likes: comment.likes + 1,
      );
      notifyListeners();
    }
  }
}
