import 'package:flutter/foundation.dart';
import '../models/post.dart';

class FeedProvider with ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  FeedProvider() {
    debugPrint('📱 FeedProvider initialized');
    _initializeMockData();
  }

  Future<void> _initializeMockData() async {
    debugPrint('🔄 Initializing mock data...');
    
    if (_posts.isNotEmpty) {
      debugPrint('Posts already loaded: ${_posts.length}');
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    _posts = [
      Post(
        id: 'post1',
        userId: 'user1',
        username: 'FitnessPro',
        avatarUrl: 'https://ui-avatars.com/api/?name=Fitness+Pro&background=4CAF50&color=fff',
        content: 'Morning workout done! 💪 #fitness #workout',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 42,
        isLiked: false,
        commentsCount: 5,
        comments: [
          Comment(
            id: 'comment1',
            postId: 'post1',
            userId: 'user2',
            username: 'YogaMaster',
            avatarUrl: 'https://ui-avatars.com/api/?name=Yoga+Master&background=2196F3&color=fff',
            content: 'Great work! 💪',
            timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
            likes: 5,
            isLiked: false,
            replies: [
              Comment(
                id: 'reply1',
                postId: 'post1',
                userId: 'user1',
                username: 'FitnessPro',
                avatarUrl: 'https://ui-avatars.com/api/?name=Fitness+Pro&background=4CAF50&color=fff',
                content: 'Thanks! 🙏',
                timestamp: DateTime.now().subtract(const Duration(hours: 1)),
                likes: 2,
                isLiked: false,
                parentCommentId: 'comment1',
              ),
              Comment(
                id: 'reply2',
                postId: 'post1',
                userId: 'user3',
                username: 'GymRat',
                avatarUrl: 'https://ui-avatars.com/api/?name=Gym+Rat&background=F44336&color=fff',
                content: 'Awesome progress! 🚀',
                timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
                likes: 1,
                isLiked: false,
                parentCommentId: 'comment1',
              ),
            ],
          ),
          Comment(
            id: 'comment2',
            postId: 'post1',
            userId: 'user3',
            username: 'GymRat',
            avatarUrl: 'https://ui-avatars.com/api/?name=Gym+Rat&background=F44336&color=fff',
            content: 'Keep it up! 🔥',
            timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
            likes: 3,
            isLiked: false,
          ),
        ],
        imageUrl: 'https://images.pexels.com/photos/2294361/pexels-photo-2294361.jpeg',
        hashtags: ['fitness', 'workout', 'morning'],
      ),
      Post(
        id: 'post2',
        userId: 'user2',
        username: 'YogaMaster',
        avatarUrl: 'https://ui-avatars.com/api/?name=Yoga+Master&background=2196F3&color=fff',
        content: 'Sunset yoga session 🌅 #yoga #mindfulness',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 28,
        isLiked: true,
        commentsCount: 3,
        comments: [
          Comment(
            id: 'comment3',
            postId: 'post2',
            userId: 'user1',
            username: 'FitnessPro',
            avatarUrl: 'https://ui-avatars.com/api/?name=Fitness+Pro&background=4CAF50&color=fff',
            content: 'Beautiful sunset! 🌅',
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
            likes: 7,
            isLiked: false,
          ),
        ],
        imageUrl: 'https://images.pexels.com/photos/8436665/pexels-photo-8436665.jpeg',
        hashtags: ['yoga', 'mindfulness', 'sunset'],
      ),
      Post(
        id: 'post3',
        userId: 'user3',
        username: 'GymRat',
        avatarUrl: 'https://ui-avatars.com/api/?name=Gym+Rat&background=F44336&color=fff',
        content: 'New personal record today! 🏋️ #gains #progress',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        likes: 65,
        isLiked: false,
        commentsCount: 12,
        comments: [],
        imageUrl: 'https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg',
        hashtags: ['gains', 'progress', 'personalrecord'],
      ),
    ];
    
    debugPrint('✅ Loaded ${_posts.length} mock posts');
    _isLoading = false;
    notifyListeners();
  }

  // Add a new post to the feed
  Future<void> addPost(Post post) async {
    debugPrint('📝 Adding new post: ${post.content.substring(0, 30)}...');
    
    final newPost = Post(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      userId: post.userId,
      username: post.username,
      avatarUrl: post.avatarUrl,
      content: post.content,
      timestamp: DateTime.now(),
      likes: 0,
      isLiked: false,
      commentsCount: 0,
      comments: [],
      imageUrl: post.imageUrl,
      hashtags: post.hashtags,
    );
    
    _posts.insert(0, newPost);
    debugPrint('✅ Post added successfully! Total posts: ${_posts.length}');
    notifyListeners();
    
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Like/unlike a post
  void toggleLike(String postId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final updatedPost = post.copyWith(
        isLiked: !post.isLiked,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
      );
      _posts[postIndex] = updatedPost;
      debugPrint('❤️ Post ${post.isLiked ? 'unliked' : 'liked'}: $postId');
      notifyListeners();
    }
  }

  // Add a comment to a post
  void addComment(String postId, String content) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      
      final newComment = Comment(
        id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
        postId: postId,
        userId: 'current_user',
        username: 'Current User',
        avatarUrl: 'https://ui-avatars.com/api/?name=Current+User&background=4CAF50&color=fff',
        content: content,
        timestamp: DateTime.now(),
      );
      
      final updatedPost = post.copyWith(
        commentsCount: post.commentsCount + 1,
        comments: [...post.comments, newComment],
      );
      
      _posts[postIndex] = updatedPost;
      debugPrint('💬 Comment added to post: $postId');
      notifyListeners();
    }
  }

  // Add a reply to a comment
  void addReply(String postId, String commentId, String content) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      
      // Function to find and update comment with reply
      List<Comment> updateCommentsWithReply(List<Comment> comments, String targetId, Comment newReply) {
        return comments.map((comment) {
          if (comment.id == targetId) {
            // Found the comment, add reply
            return comment.copyWith(
              replies: [...comment.replies, newReply],
            );
          } else if (comment.replies.isNotEmpty) {
            // Check replies recursively
            return comment.copyWith(
              replies: updateCommentsWithReply(comment.replies, targetId, newReply),
            );
          }
          return comment;
        }).toList();
      }
      
      final newReply = Comment(
        id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
        postId: postId,
        userId: 'current_user',
        username: 'Current User',
        avatarUrl: 'https://ui-avatars.com/api/?name=Current+User&background=4CAF50&color=fff',
        content: content,
        timestamp: DateTime.now(),
        parentCommentId: commentId,
      );
      
      final updatedComments = updateCommentsWithReply(post.comments, commentId, newReply);
      
      final updatedPost = post.copyWith(
        comments: updatedComments,
        commentsCount: post.commentsCount + 1,
      );
      
      _posts[postIndex] = updatedPost;
      debugPrint('↩️ Reply added to comment: $commentId');
      notifyListeners();
    }
  }

  // Like/unlike a comment or reply (FIXED FOR NESTED COMMENTS)
  void toggleCommentLike(String postId, String commentId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex == -1) return;
    
    final post = _posts[postIndex];
    
    // Function to find and toggle like on comment
    List<Comment> toggleLikeInComments(List<Comment> comments, String targetId) {
      return comments.map((comment) {
        if (comment.id == targetId) {
          // Found the comment
          debugPrint('❤️ Toggling like for comment: ${comment.id} (current: ${comment.isLiked})');
          return comment.copyWith(
            isLiked: !comment.isLiked,
            likes: comment.isLiked ? comment.likes - 1 : comment.likes + 1,
          );
        } else if (comment.replies.isNotEmpty) {
          // Check replies recursively
          return comment.copyWith(
            replies: toggleLikeInComments(comment.replies, targetId),
          );
        }
        return comment;
      }).toList();
    }
    
    final updatedComments = toggleLikeInComments(post.comments, commentId);
    final updatedPost = post.copyWith(comments: updatedComments);
    _posts[postIndex] = updatedPost;
    
    debugPrint('✅ Comment like toggled for: $commentId');
    notifyListeners();
  }

  // Reload mock data
  Future<void> reloadMockData() async {
    debugPrint('🔄 Reloading mock data');
    _posts.clear();
    await _initializeMockData();
  }
}
