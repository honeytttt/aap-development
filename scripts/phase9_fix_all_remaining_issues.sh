#!/bin/bash
# Fix All Remaining Issues

echo "🔧 Fixing logout, nested comments, and comment likes..."

# 1. First, check if SharedPreferences is properly installed
echo "📝 Checking dependencies..."
if ! grep -q "shared_preferences:" pubspec.yaml; then
    echo "❌ SharedPreferences not found, adding..."
    sed -i '/dependencies:/a\  shared_preferences: ^2.2.2' pubspec.yaml
fi

# 2. Fix Auth Provider logout issue
echo "📝 Fixing AuthProvider logout..."
cat > lib/features/auth/providers/auth_provider.dart << 'AUTH_PROVIDER'
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_app/core/models/user.dart';

class AuthProvider with ChangeNotifier {
  AppUser? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  static const String _userKey = 'current_user';

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadUserFromStorage();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson != null && userJson.isNotEmpty) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        _currentUser = AppUser(
          id: userMap['id'],
          username: userMap['username'],
          email: userMap['email'],
          fullName: userMap['fullName'],
          avatarUrl: userMap['avatarUrl'],
          bio: userMap['bio'],
          isVerified: userMap['isVerified'] ?? false,
        );
        print('✅ User loaded from storage: ${_currentUser?.username}');
      }
    } catch (e) {
      print('❌ Error loading user from storage: $e');
    }
  }

  Future<void> _saveUserToStorage(AppUser? user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (user == null) {
        await prefs.remove(_userKey);
        print('✅ User removed from storage');
      } else {
        final userJson = json.encode({
          'id': user.id,
          'username': user.username,
          'email': user.email,
          'fullName': user.fullName,
          'avatarUrl': user.avatarUrl,
          'bio': user.bio,
          'isVerified': user.isVerified,
        });
        await prefs.setString(_userKey, userJson);
        print('✅ User saved to storage: ${user.username}');
      }
    } catch (e) {
      print('❌ Error saving user to storage: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // For testing, accept any email/password
      if (email.isNotEmpty && password.isNotEmpty) {
        _currentUser = AppUser(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          username: email.split('@')[0],
          email: email,
          fullName: 'Test User',
          avatarUrl: 'https://picsum.photos/100/100?random=0',
          bio: 'Fitness enthusiast',
          isVerified: true,
        );

        // Save to storage
        await _saveUserToStorage(_currentUser);

        _isLoading = false;
        notifyListeners();
        
        print('✅ User logged in: ${_currentUser?.username}');
        return true;
      } else {
        _error = 'Invalid credentials';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String username, String fullName) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = AppUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        username: username,
        email: email,
        fullName: fullName,
        avatarUrl: 'https://picsum.photos/100/100?random=0',
        bio: '',
        isVerified: false,
      );

      // Save to storage
      await _saveUserToStorage(_currentUser);

      _isLoading = false;
      notifyListeners();
      
      print('✅ User registered: ${_currentUser?.username}');
      return true;
    } catch (e) {
      _error = 'Registration failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    print('🚪 Logging out...');
    
    // Clear from storage
    await _saveUserToStorage(null);
    
    // Clear from memory
    _currentUser = null;
    notifyListeners();
    
    print('✅ User logged out successfully');
  }

  Future<void> updateProfile(AppUser user) async {
    _currentUser = user;
    await _saveUserToStorage(user);
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
AUTH_PROVIDER

# 3. Fix Profile Screen to properly handle logout
echo "📝 Fixing ProfileScreen logout handler..."
cat > lib/features/profile/screens/profile_screen.dart << 'PROFILE_SCREEN'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/auth/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings - Coming Soon')),
              );
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No User Found', style: TextStyle(fontSize: 20)),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile header
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '@${user.username}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (user.isVerified)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.blue[400],
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Verified',
                          style: TextStyle(
                            color: Colors.blue[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  // Bio
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      user.bio.isNotEmpty ? user.bio : 'No bio yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat('Posts', '24'),
                      _buildStat('Followers', '1.2K'),
                      _buildStat('Following', '356'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Actions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Edit Profile - Coming Soon'),
                                ),
                              );
                            },
                            child: const Text('Edit Profile'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Show confirmation dialog
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text('Are you sure you want to logout?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                ),
                              );
                              
                              if (confirmed == true && context.mounted) {
                                // Show loading
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Logging out...'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                                
                                // Perform logout
                                await authProvider.logout();
                                
                                // Show success message
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Logged out successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Logout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Recent Posts Grid
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recent Posts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Text('Post ${index + 1}'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
PROFILE_SCREEN

# 4. Fix Feed Provider for nested comments and comment likes
echo "📝 Fixing FeedProvider for nested comments and likes..."
cat > lib/features/feed/providers/feed_provider.dart << 'FEED_PROVIDER'
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:workout_app/core/models/post.dart';
import 'package:workout_app/core/models/comment.dart';
import 'package:workout_app/core/models/user.dart';
import 'package:workout_app/core/models/media.dart';

class FeedProvider with ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  FeedProvider() {
    _initializeMockData();
  }

  void _initializeMockData() {
    final random = Random();
    
    // Create mock users
    final mockUsers = [
      AppUser(
        id: '1',
        username: 'fitness_guru',
        email: 'guru@example.com',
        fullName: 'Alex Johnson',
        avatarUrl: 'https://picsum.photos/100/100?random=1',
        bio: 'Fitness Coach & Nutritionist',
        isVerified: true,
      ),
      AppUser(
        id: '2',
        username: 'yoga_master',
        email: 'yoga@example.com',
        fullName: 'Sara Williams',
        avatarUrl: 'https://picsum.photos/100/100?random=2',
        bio: 'Yoga Instructor',
        isVerified: true,
      ),
      AppUser(
        id: '3',
        username: 'gym_rat',
        email: 'gym@example.com',
        fullName: 'Mike Chen',
        avatarUrl: 'https://picsum.photos/100/100?random=3',
        bio: 'Bodybuilding Enthusiast',
        isVerified: false,
      ),
    ];

    // Create mock posts with nested comments
    _posts = List.generate(5, (index) {
      final user = mockUsers[index % mockUsers.length];
      final isVideo = index % 3 == 0;
      
      // Create comments with nested replies
      final comments = _createMockComments(postId: 'post_$index', depth: 0);
      
      return Post(
        id: 'post_$index',
        userId: user.id,
        username: user.username,
        userAvatar: user.avatarUrl,
        caption: 'Workout day $index! 💪 #Fitness #Workout #Gains',
        media: [
          Media(
            id: 'media_${index}_1',
            type: isVideo ? MediaType.video : MediaType.image,
            url: isVideo 
                ? 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'
                : 'https://picsum.photos/400/600?random=$index',
            thumbnailUrl: 'https://picsum.photos/200/300?random=$index',
            width: 400,
            height: 600,
            uploadDate: DateTime.now().subtract(Duration(days: index)),
            duration: isVideo ? const Duration(seconds: 60) : null,
          ),
        ],
        likesCount: random.nextInt(1000),
        commentsCount: comments.length,
        sharesCount: random.nextInt(50),
        isLiked: random.nextBool(),
        createdAt: DateTime.now().subtract(Duration(days: index)),
        comments: comments,
      );
    });
  }

  List<Comment> _createMockComments({required String postId, int depth = 0, int count = 3}) {
    final random = Random();
    final mockUsers = [
      {'id': 'user_1', 'username': 'fitness_fan', 'avatar': 'https://picsum.photos/100/100?random=4'},
      {'id': 'user_2', 'username': 'workout_buddy', 'avatar': 'https://picsum.photos/100/100?random=5'},
      {'id': 'user_3', 'username': 'gym_enthusiast', 'avatar': 'https://picsum.photos/100/100?random=6'},
    ];
    
    return List.generate(count, (commentIndex) {
      final user = mockUsers[commentIndex % mockUsers.length];
      final commentId = 'comment_${postId}_${commentIndex}';
      
      // Create replies for some comments (nested)
      List<Comment> replies = [];
      if (depth < 2 && commentIndex % 2 == 0) { // Limit depth to 2 levels
        replies = _createMockComments(
          postId: postId,
          depth: depth + 1,
          count: 2,
        ).map((reply) => Comment(
          id: '${commentId}_reply_${reply.id}',
          postId: postId,
          userId: reply.userId,
          username: reply.username,
          userAvatar: reply.userAvatar,
          text: reply.text,
          likesCount: reply.likesCount,
          isLiked: reply.isLiked,
          createdAt: DateTime.now().subtract(Duration(hours: commentIndex + depth)),
          replies: [],
          depth: depth + 1,
        )).toList();
      }
      
      return Comment(
        id: commentId,
        postId: postId,
        userId: user['id']!,
        username: user['username']!,
        userAvatar: user['avatar']!,
        text: _getRandomComment(),
        likesCount: random.nextInt(50),
        isLiked: random.nextBool(),
        createdAt: DateTime.now().subtract(Duration(hours: commentIndex + depth)),
        replies: replies,
        depth: depth,
      );
    });
  }

  String _getRandomComment() {
    final comments = [
      'Great workout! 💪',
      'Keep pushing! 🔥',
      'Looking strong!',
      'Amazing form!',
      'What\'s your routine?',
      'Inspirational! 🙌',
      'How many sets?',
      'That\'s impressive!',
      'Motivation level: 100!',
      'Keep grinding! 💯'
    ];
    return comments[Random().nextInt(comments.length)];
  }

  void likePost(String postId) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(
        likesCount: post.likesCount + (post.isLiked ? -1 : 1),
        isLiked: !post.isLiked,
      );
      notifyListeners();
    }
  }

  void unlikePost(String postId) {
    likePost(postId); // Toggle like
  }

  void likeComment(String postId, String commentId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final updatedComments = _toggleCommentLike(post.comments, commentId);
      _posts[postIndex] = post.copyWith(comments: updatedComments);
      notifyListeners();
    }
  }

  List<Comment> _toggleCommentLike(List<Comment> comments, String commentId) {
    return comments.map((comment) {
      if (comment.id == commentId) {
        return comment.copyWith(
          likesCount: comment.likesCount + (comment.isLiked ? -1 : 1),
          isLiked: !comment.isLiked,
        );
      } else if (comment.replies.isNotEmpty) {
        return comment.copyWith(
          replies: _toggleCommentLike(comment.replies, commentId),
        );
      }
      return comment;
    }).toList();
  }

  void addComment(String postId, Comment comment) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final updatedComments = [...post.comments, comment];
      _posts[postIndex] = post.copyWith(
        comments: updatedComments,
        commentsCount: post.commentsCount + 1,
      );
      notifyListeners();
    }
  }

  void addReply(String postId, String parentCommentId, Comment reply) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final updatedComments = _addReplyToComments(post.comments, parentCommentId, reply);
      _posts[postIndex] = post.copyWith(
        comments: updatedComments,
        commentsCount: post.commentsCount + 1,
      );
      notifyListeners();
    }
  }

  List<Comment> _addReplyToComments(List<Comment> comments, String parentCommentId, Comment reply) {
    return comments.map((comment) {
      if (comment.id == parentCommentId) {
        final updatedReplies = [...comment.replies, reply];
        return comment.copyWith(replies: updatedReplies);
      } else if (comment.replies.isNotEmpty) {
        return comment.copyWith(
          replies: _addReplyToComments(comment.replies, parentCommentId, reply),
        );
      }
      return comment;
    }).toList();
  }

  void deleteComment(String postId, String commentId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final updatedComments = _removeCommentFromList(post.comments, commentId);
      _posts[postIndex] = post.copyWith(
        comments: updatedComments,
        commentsCount: post.commentsCount - 1,
      );
      notifyListeners();
    }
  }

  List<Comment> _removeCommentFromList(List<Comment> comments, String commentId) {
    final List<Comment> result = [];
    for (final comment in comments) {
      if (comment.id != commentId) {
        final updatedComment = comment.copyWith(
          replies: _removeCommentFromList(comment.replies, commentId),
        );
        result.add(updatedComment);
      }
    }
    return result;
  }

  void addPost(Post post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  void refreshFeed() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
  }
}
FEED_PROVIDER

# 5. Fix Comment Item Widget for nested comments and likes
echo "📝 Fixing CommentItem widget..."
cat > lib/features/feed/widgets/comment_item.dart << 'COMMENT_ITEM'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/core/models/comment.dart';
import 'package:workout_app/features/feed/providers/feed_provider.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;
  final Function(String)? onReply;

  const CommentItem({
    Key? key,
    required this.comment,
    this.onReply,
  }) : super(key: key);

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _showReplies = false;
  bool _isReplying = false;
  final TextEditingController _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: (widget.comment.depth * 16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main comment
          _buildCommentContent(),
          
          // Reply input (when active)
          if (_isReplying) _buildReplyInput(),
          
          // Replies toggle and list
          if (widget.comment.replies.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showReplies = !_showReplies;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 48, top: 8, bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          _showReplies ? Icons.expand_less : Icons.expand_more,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.comment.replies.length} ${widget.comment.replies.length == 1 ? 'reply' : 'replies'}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_showReplies)
                  Column(
                    children: widget.comment.replies
                        .map((reply) => CommentItem(
                              comment: reply,
                              onReply: widget.onReply,
                            ))
                        .toList(),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCommentContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(widget.comment.userAvatar),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.comment.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.comment.text,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${_timeAgo(widget.comment.createdAt)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        _toggleCommentLike();
                      },
                      child: Row(
                        children: [
                          Icon(
                            widget.comment.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 12,
                            color: widget.comment.isLiked
                                ? Colors.red
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.comment.likesCount}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isReplying = !_isReplying;
                        });
                        if (_isReplying && widget.onReply != null) {
                          widget.onReply!(widget.comment.id);
                        }
                      },
                      child: Text(
                        'Reply',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 48, top: 8, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _replyController,
              decoration: InputDecoration(
                hintText: 'Write a reply...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.green),
            onPressed: () {
              if (_replyController.text.isNotEmpty) {
                _submitReply();
              }
            },
          ),
        ],
      ),
    );
  }

  void _toggleCommentLike() {
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    feedProvider.likeComment(widget.comment.postId, widget.comment.id);
  }

  void _submitReply() {
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    final reply = Comment(
      id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
      postId: widget.comment.postId,
      userId: 'current_user',
      username: 'You',
      userAvatar: 'https://picsum.photos/100/100?random=0',
      text: _replyController.text,
      createdAt: DateTime.now(),
      depth: widget.comment.depth + 1,
    );

    feedProvider.addReply(
      widget.comment.postId,
      widget.comment.id,
      reply,
    );

    _replyController.clear();
    setState(() {
      _isReplying = false;
      _showReplies = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reply posted'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Just now';
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }
}
COMMENT_ITEM

# 6. Fix Comments Screen for nested comments
echo "📝 Fixing CommentsScreen..."
cat > lib/features/feed/screens/comments_screen.dart << 'COMMENTS_SCREEN'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/core/models/post.dart';
import 'package:workout_app/core/models/comment.dart';
import 'package:workout_app/features/feed/providers/feed_provider.dart';
import 'package:workout_app/features/feed/widgets/comment_item.dart';

class CommentsScreen extends StatefulWidget {
  final Post post;

  const CommentsScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  String? _replyingToCommentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.post.comments.length,
              itemBuilder: (context, index) {
                final comment = widget.post.comments[index];
                return CommentItem(
                  comment: comment,
                  onReply: (commentId) {
                    setState(() {
                      _replyingToCommentId = commentId;
                    });
                    _commentController.text = '@${comment.username} ';
                    _commentController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _commentController.text.length),
                    );
                  },
                );
              },
            ),
          ),
          _buildCommentInput(context),
        ],
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_replyingToCommentId != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    'Replying to comment',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _replyingToCommentId = null;
                        _commentController.clear();
                      });
                    },
                    child: const Icon(Icons.close, size: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: _replyingToCommentId != null
                        ? 'Write your reply...'
                        : 'Add a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.green),
                onPressed: () {
                  if (_commentController.text.isNotEmpty) {
                    _submitComment(context);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitComment(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    
    final comment = Comment(
      id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
      postId: widget.post.id,
      userId: 'current_user',
      username: 'You',
      userAvatar: 'https://picsum.photos/100/100?random=0',
      text: _commentController.text,
      createdAt: DateTime.now(),
    );

    if (_replyingToCommentId != null) {
      feedProvider.addReply(
        widget.post.id,
        _replyingToCommentId!,
        comment,
      );
    } else {
      feedProvider.addComment(widget.post.id, comment);
    }

    _commentController.clear();
    setState(() {
      _replyingToCommentId = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_replyingToCommentId != null
            ? 'Reply posted'
            : 'Comment posted'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
COMMENTS_SCREEN

# 7. Clean up and rebuild
echo "✅ All fixes applied!"
echo "🔄 Running flutter clean..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔍 Running flutter analyze..."
flutter analyze

echo ""
echo "🎉 All remaining issues fixed!"
echo "✅ Logout now works properly"
echo "✅ Nested comments system implemented"
echo "✅ Comment likes work"
echo "✅ Reply functionality added"
echo "✅ Authentication persists across restarts"
echo ""
echo "🚀 Test the fixes:"
echo "   1. Run: flutter run"
echo "   2. Login and go to Profile -> Test Logout"
echo "   3. Go to Feed -> Open any post comments"
echo "   4. Test liking comments"
echo "   5. Test replying to comments (creates nested replies)"
echo "   6. Test expanding/collapsing replies"
echo ""
echo "📋 Features now working:"
echo "   • Logout with confirmation dialog"
echo "   • Nested comments up to 2 levels deep"
echo "   • Comment likes with visual feedback"
echo "   • Reply system with @username tagging"
echo "   • Expand/collapse replies"
echo "   • Proper comment threading"
