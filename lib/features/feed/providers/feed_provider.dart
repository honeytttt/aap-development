import 'package:flutter/foundation.dart';
import 'package:workout_app/core/models/comment.dart';
import 'package:workout_app/core/models/post.dart';

class FeedProvider with ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load initial posts
  Future<void> loadPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock posts data
      _posts = [
        Post(
          id: '1',
          userId: 'user1',
          userName: 'Fitness Enthusiast',
          userAvatar: 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=FE',
          content: 'Just completed my morning workout! Feeling energized and ready for the day. 💪',
          media: [],
          hashtags: ['#workout', '#fitness', '#morningroutine'],
          likes: ['user2', 'user3'],
          comments: [
            Comment(
              id: 'c1',
              postId: '1',
              userId: 'user2',
              userName: 'Gym Buddy',
              userAvatar: 'https://via.placeholder.com/150/2196F3/FFFFFF?text=GB',
              content: 'Great job! What was your routine today?',
              likes: ['user1'],
              replies: [],
              depth: 0,
              createdAt: DateTime.now().subtract(const Duration(hours: 1)),
            ),
          ],
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Post(
          id: '2',
          userId: 'user3',
          userName: 'Yoga Master',
          userAvatar: 'https://via.placeholder.com/150/FF5722/FFFFFF?text=YM',
          content: 'Morning yoga session complete. Remember to breathe deeply and stay present. 🧘‍♀️',
          media: [],
          hashtags: ['#yoga', '#mindfulness', '#wellness'],
          likes: ['user1', 'user2', 'user4'],
          comments: [
            Comment(
              id: 'c2',
              postId: '2',
              userId: 'user1',
              userName: 'Fitness Enthusiast',
              userAvatar: 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=FE',
              content: 'I need to try yoga! Any beginner tips?',
              likes: ['user3'],
              replies: [
                Comment(
                  id: 'c2_1',
                  postId: '2',
                  userId: 'user3',
                  userName: 'Yoga Master',
                  userAvatar: 'https://via.placeholder.com/150/FF5722/FFFFFF?text=YM',
                  content: 'Start with gentle poses and focus on breathing. Don\'t push too hard!',
                  likes: ['user1'],
                  replies: [],
                  depth: 1,
                  createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
                ),
              ],
              depth: 0,
              createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
            ),
          ],
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ];
      
      _error = null;
    } catch (e) {
      _error = 'Failed to load posts: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh posts
  Future<void> refreshPosts() async {
    await loadPosts();
  }

  // Add a post
  void addPost(Post post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  // Like a post
  void likePost(String postId, String userId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final likes = List<String>.from(post.likes);
      
      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
      }
      
      _posts[postIndex] = post.copyWith(likes: likes);
      notifyListeners();
    }
  }

  // Add a comment
  void addComment(String postId, Comment comment) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final comments = List<Comment>.from(post.comments);
      comments.add(comment);
      
      _posts[postIndex] = post.copyWith(comments: comments);
      notifyListeners();
    }
  }

  // Like a comment
  void likeComment(String postId, String commentId, String userId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final comments = List<Comment>.from(post.comments);
      
      bool commentUpdated = _updateCommentLikes(comments, commentId, userId);
      
      if (commentUpdated) {
        _posts[postIndex] = post.copyWith(comments: comments);
        notifyListeners();
      }
    }
  }

  // Helper method to update comment likes recursively
  bool _updateCommentLikes(List<Comment> comments, String commentId, String userId) {
    for (int i = 0; i < comments.length; i++) {
      if (comments[i].id == commentId) {
        final comment = comments[i];
        final likes = List<String>.from(comment.likes);
        
        if (likes.contains(userId)) {
          likes.remove(userId);
        } else {
          likes.add(userId);
        }
        
        comments[i] = comment.copyWith(likes: likes);
        return true;
      }
      
      if (comments[i].replies.isNotEmpty) {
        final replies = List<Comment>.from(comments[i].replies);
        if (_updateCommentLikes(replies, commentId, userId)) {
          comments[i] = comments[i].copyWith(replies: replies);
          return true;
        }
      }
    }
    return false;
  }

  // Add a reply to a comment
  void addReply(String postId, String parentCommentId, Comment reply) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final comments = List<Comment>.from(post.comments);
      
      bool replyAdded = _addReplyToComment(comments, parentCommentId, reply);
      
      if (replyAdded) {
        _posts[postIndex] = post.copyWith(comments: comments);
        notifyListeners();
      }
    }
  }

  // Helper method to add reply recursively
  bool _addReplyToComment(List<Comment> comments, String parentCommentId, Comment reply) {
    for (int i = 0; i < comments.length; i++) {
      if (comments[i].id == parentCommentId) {
        final comment = comments[i];
        final replies = List<Comment>.from(comment.replies);
        replies.add(reply);
        comments[i] = comment.copyWith(replies: replies);
        return true;
      }
      
      if (comments[i].replies.isNotEmpty) {
        final replies = List<Comment>.from(comments[i].replies);
        if (_addReplyToComment(replies, parentCommentId, reply)) {
          comments[i] = comments[i].copyWith(replies: replies);
          return true;
        }
      }
    }
    return false;
  }
}
