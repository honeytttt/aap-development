import 'package:flutter/material.dart';
import 'package:workout_app/core/models/post.dart';
import 'package:workout_app/core/models/comment.dart';
import 'package:workout_app/core/models/user.dart';
import 'package:workout_app/core/models/media.dart';

class FeedProvider with ChangeNotifier {
  List<Post> _posts = [];
  Map<String, List<Comment>> _postComments = {};
  bool _isLoading = false;
  bool _hasMore = true;
  
  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  
  FeedProvider() {
    print("📱 FeedProvider initialized");
    _initializeMockData();
  }
  
  void _initializeMockData() {
    print("🔄 Initializing mock data...");
    // Mock users - using UI Avatars to avoid CORS issues
    final users = [
      User(
        id: '1',
        username: 'fitness_john',
        displayName: 'John Fitness',
        avatarUrl: 'https://ui-avatars.com/api/?name=John+Fitness&background=4CAF50&color=fff',
        bio: 'Fitness enthusiast | Personal trainer',
        followersCount: 1243,
        followingCount: 342,
        postsCount: 56,
        joinedDate: DateTime(2023, 1, 15),
      ),
      User(
        id: '2',
        username: 'yoga_sarah',
        displayName: 'Sarah Yoga',
        avatarUrl: 'https://ui-avatars.com/api/?name=Sarah+Yoga&background=2196F3&color=fff',
        bio: 'Yoga instructor | Wellness coach',
        followersCount: 892,
        followingCount: 210,
        postsCount: 34,
        joinedDate: DateTime(2023, 3, 22),
      ),
      User(
        id: '3',
        username: 'gym_bro',
        displayName: 'Mike Strong',
        avatarUrl: 'https://ui-avatars.com/api/?name=Mike+Strong&background=FF9800&color=fff',
        bio: 'Bodybuilder | Nutrition expert',
        followersCount: 2100,
        followingCount: 450,
        postsCount: 89,
        joinedDate: DateTime(2022, 11, 5),
      ),
    ];
    
    // Mock posts
    _posts = [
      Post(
        id: 'post1',
        user: users[0],
        caption: 'Morning workout done! 💪\n#fitness #workout #morningroutine',
        hashtags: ['fitness', 'workout', 'morningroutine'],
        media: [
          MediaItem(
            type: MediaType.image,
            url: 'https://images.pexels.com/photos/2261477/pexels-photo-2261477.jpeg?auto=compress&cs=tinysrgb&w=800',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likesCount: 124,
        commentsCount: 23,
        isLiked: false,
        workoutType: 'Strength Training',
        duration: 45,
        calories: 320,
      ),
      Post(
        id: 'post2',
        user: users[1],
        caption: 'Sunset yoga session 🌅\n#yoga #mindfulness #wellness',
        hashtags: ['yoga', 'mindfulness', 'wellness'],
        media: [
          MediaItem(
            type: MediaType.image,
            url: 'https://images.pexels.com/photos/1812964/pexels-photo-1812964.jpeg?auto=compress&cs=tinysrgb&w=800',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        likesCount: 89,
        commentsCount: 12,
        isLiked: false,
        workoutType: 'Yoga',
        duration: 30,
        calories: 180,
      ),
      Post(
        id: 'post3',
        user: users[2],
        caption: 'New personal record today! 🏋️‍♂️\n#gym #progress #fitnessjourney',
        hashtags: ['gym', 'progress', 'fitnessjourney'],
        media: [
          MediaItem(
            type: MediaType.image,
            url: 'https://images.pexels.com/photos/1229356/pexels-photo-1229356.jpeg?auto=compress&cs=tinysrgb&w=800',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        likesCount: 256,
        commentsCount: 45,
        isLiked: false,
        workoutType: 'Weightlifting',
        duration: 60,
        calories: 450,
      ),
    ];
    
    print("✅ Loaded ${_posts.length} mock posts");
    
    // Initialize comments
    for (var post in _posts) {
      _postComments[post.id] = post.comments;
    }
  }
  
  void likePost(String postId, String userId) {
    print("❤️ Like post: $postId by user: $userId");
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts[index];
      final isLiked = post.isLiked;
      
      _posts[index] = post.copyWith(
        likesCount: isLiked ? post.likesCount - 1 : post.likesCount + 1,
        isLiked: !isLiked,
      );
      notifyListeners();
      print("✅ Post liked! New like count: ${_posts[index].likesCount}");
    } else {
      print("❌ Post not found: $postId");
    }
  }
  
  void unlikePost(String postId) {
    print("💔 Unlike post: $postId");
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(
        likesCount: post.likesCount - 1,
        isLiked: false,
      );
      notifyListeners();
    }
  }
  
  List<Comment> getCommentsForPost(String postId) {
    return _postComments[postId] ?? [];
  }
  
  void loadCommentsForPost(String postId) {
    print("💬 Loading comments for post: $postId");
    // Mock comments
    if (!_postComments.containsKey(postId) || _postComments[postId]!.isEmpty) {
      _postComments[postId] = [
        Comment(
          id: 'comment1_$postId',
          userId: '2',
          userName: 'yoga_sarah',
          text: 'Great workout! Keep it up! 💪',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          likesCount: 5,
          isLiked: false,
        ),
        Comment(
          id: 'comment2_$postId',
          userId: '3',
          userName: 'gym_bro',
          text: 'Solid form! What was your routine?',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          likesCount: 3,
          isLiked: false,
        ),
      ];
      notifyListeners();
      print("✅ Loaded ${_postComments[postId]!.length} comments");
    }
  }
  
  void addComment({
    required String postId,
    required String text,
  }) {
    print("💬 Adding comment to post: $postId");
    final newComment = Comment(
      id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
      userId: '1', // Current user ID (mock)
      userName: 'fitness_john',
      text: text,
      createdAt: DateTime.now(),
      likesCount: 0,
      isLiked: false,
    );
    
    if (!_postComments.containsKey(postId)) {
      _postComments[postId] = [];
    }
    
    _postComments[postId]!.insert(0, newComment);
    
    // Update post comments count
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      _posts[postIndex] = post.copyWith(
        commentsCount: post.commentsCount + 1,
      );
    }
    
    notifyListeners();
    print("✅ Comment added! Total comments: ${_postComments[postId]!.length}");
  }
  
  void addReply({
    required String postId,
    required String parentCommentId,
    required String text,
  }) {
    print("💬 Adding reply to comment: $parentCommentId");
    final newReply = Comment(
      id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
      userId: '1', // Current user ID (mock)
      userName: 'fitness_john',
      text: text,
      createdAt: DateTime.now(),
      likesCount: 0,
      isLiked: false,
      parentCommentId: parentCommentId,
    );
    
    final comments = _postComments[postId] ?? [];
    
    // Find and update the parent comment
    for (int i = 0; i < comments.length; i++) {
      if (comments[i].id == parentCommentId) {
        final parentComment = comments[i];
        final updatedReplies = [...parentComment.replies, newReply];
        
        final updatedComment = parentComment.copyWith(replies: updatedReplies);
        comments[i] = updatedComment;
        
        // Update post comments count
        final postIndex = _posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          final post = _posts[postIndex];
          _posts[postIndex] = post.copyWith(
            commentsCount: post.commentsCount + 1,
          );
        }
        
        notifyListeners();
        print("✅ Reply added!");
        break;
      }
    }
  }
  
  void likeComment(String postId, String commentId, String userId) {
    print("❤️ Like comment: $commentId");
    final comments = _postComments[postId];
    if (comments == null) return;
    
    for (int i = 0; i < comments.length; i++) {
      final comment = comments[i];
      
      // Check main comment
      if (comment.id == commentId) {
        final isLiked = comment.isLiked;
        comments[i] = comment.copyWith(
          likesCount: isLiked ? comment.likesCount - 1 : comment.likesCount + 1,
          isLiked: !isLiked,
        );
        notifyListeners();
        return;
      }
      
      // Check replies
      for (int j = 0; j < comment.replies.length; j++) {
        final reply = comment.replies[j];
        if (reply.id == commentId) {
          final isLiked = reply.isLiked;
          final newReplies = List<Comment>.from(comment.replies);
          newReplies[j] = reply.copyWith(
            likesCount: isLiked ? reply.likesCount - 1 : reply.likesCount + 1,
            isLiked: !isLiked,
          );
          comments[i] = comment.copyWith(replies: newReplies);
          notifyListeners();
          return;
        }
      }
    }
  }
  
  void unlikeComment(String postId, String commentId) {
    print("💔 Unlike comment: $commentId");
    final comments = _postComments[postId];
    if (comments == null) return;
    
    for (int i = 0; i < comments.length; i++) {
      final comment = comments[i];
      
      if (comment.id == commentId) {
        comments[i] = comment.copyWith(
          likesCount: comment.likesCount - 1,
          isLiked: false,
        );
        notifyListeners();
        return;
      }
      
      // Check replies
      for (int j = 0; j < comment.replies.length; j++) {
        final reply = comment.replies[j];
        if (reply.id == commentId) {
          final newReplies = List<Comment>.from(comment.replies);
          newReplies[j] = reply.copyWith(
            likesCount: reply.likesCount - 1,
            isLiked: false,
          );
          comments[i] = comment.copyWith(replies: newReplies);
          notifyListeners();
          return;
        }
      }
    }
  }
  
  void addPost(Post post) {
    print("🆕 Adding new post to feed:");
    print("  ID: ${post.id}");
    print("  User: ${post.user.username}");
    print("  Caption: ${post.caption.substring(0, min(50, post.caption.length))}...");
    print("  Hashtags: ${post.hashtags}");
    print("  Media count: ${post.media.length}");
    
    _posts.insert(0, post);
    _postComments[post.id] = [];
    
    print("✅ Post added! Total posts: ${_posts.length}");
    
    // CRITICAL: Notify listeners that the data has changed
    notifyListeners();
    print("📢 Listeners notified about new post!");
  }
  
  void addPostFromCreate({
    required String caption,
    required List<String> hashtags,
    required List<MediaItem> media,
    required User user,
    String? workoutType,
    int? duration,
    int? calories,
  }) {
    print("🎨 Creating post from CreatePostScreen:");
    print("  User: ${user.username}");
    print("  Caption: $caption");
    print("  Hashtags: $hashtags");
    print("  Media: ${media.length} items");
    print("  Workout type: $workoutType");
    
    final newPost = Post(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      user: user,
      caption: caption,
      hashtags: hashtags,
      media: media,
      createdAt: DateTime.now(),
      likesCount: 0,
      commentsCount: 0,
      isLiked: false,
      workoutType: workoutType,
      duration: duration,
      calories: calories,
    );
    
    addPost(newPost);
  }
  
  Future<void> loadMorePosts() async {
    if (_isLoading || !_hasMore) return;
    
    _isLoading = true;
    notifyListeners();
    
    print("📥 Loading more posts...");
    
    await Future.delayed(const Duration(seconds: 2));
    
    // Add more mock posts
    final users = [
      User(
        id: '4',
        username: 'runner_girl',
        displayName: 'Emily Runner',
        avatarUrl: 'https://ui-avatars.com/api/?name=Emily+Runner&background=E91E63&color=fff',
        bio: 'Marathon runner | Endurance athlete',
        followersCount: 567,
        followingCount: 189,
        postsCount: 42,
        joinedDate: DateTime(2023, 5, 10),
      ),
    ];
    
    _posts.addAll([
      Post(
        id: 'post${_posts.length + 1}',
        user: users[0],
        caption: 'Morning run in the park! 🏃‍♀️\n#running #cardio #morningrun',
        hashtags: ['running', 'cardio', 'morningrun'],
        media: [
          MediaItem(
            type: MediaType.image,
            url: 'https://images.pexels.com/photos/235922/pexels-photo-235922.jpeg?auto=compress&cs=tinysrgb&w=800',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        likesCount: 78,
        commentsCount: 15,
        isLiked: false,
        workoutType: 'Running',
        duration: 40,
        calories: 280,
      ),
    ]);
    
    _isLoading = false;
    _hasMore = _posts.length < 10; // Limit to 10 posts for demo
    notifyListeners();
    
    print("✅ Loaded more posts. Total: ${_posts.length}");
  }
  
  int min(int a, int b) => a < b ? a : b;
}
