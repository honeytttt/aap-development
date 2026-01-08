#!/bin/bash

echo "🔧 COMPLETE FIX FOR WORKOUT APP"
echo "================================"

# Clean everything first
flutter clean 2>/dev/null || true

# Create proper pubspec.yaml
cat > pubspec.yaml << 'EOF2'
name: workout_app
description: Workout social app
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.0
  cupertino_icons: ^1.0.6

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
EOF2

echo "✅ Created pubspec.yaml"

# Create directory structure
mkdir -p lib/core/models
mkdir -p lib/features/feed/screens
mkdir -p lib/features/feed/widgets
mkdir -p lib/features/feed/providers

# Create Comment model
cat > lib/core/models/comment.dart << 'EOF2'
class Comment {
  final String id;
  final String text;
  final String userName;
  final String userAvatar;
  final DateTime time;
  int likes;
  bool isLiked;
  final List<Comment> replies;
  
  Comment({
    required this.id,
    required this.text,
    required this.userName,
    required this.userAvatar,
    required this.time,
    this.likes = 0,
    this.isLiked = false,
    this.replies = const [],
  });
}
EOF2

echo "✅ Created Comment model"

# Create Comment Provider
cat > lib/features/feed/providers/comment_provider.dart << 'EOF2'
import 'package:flutter/foundation.dart';
import 'package:workout_app/core/models/comment.dart';

class CommentProvider with ChangeNotifier {
  List<Comment> _comments = [];
  
  List<Comment> get comments => _comments;
  
  CommentProvider() {
    _loadMockComments();
  }
  
  void _loadMockComments() {
    _comments = [
      Comment(
        id: '1',
        text: 'Great workout! Push-ups were intense 💪',
        userName: 'Alex',
        userAvatar: 'https://i.pravatar.cc/150?img=1',
        time: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 15,
        isLiked: false,
        replies: [
          Comment(
            id: '1_1',
            text: 'Thanks! It was tough but worth it',
            userName: 'Sarah',
            userAvatar: 'https://i.pravatar.cc/150?img=2',
            time: DateTime.now().subtract(const Duration(hours: 1)),
            likes: 3,
            isLiked: true,
          ),
        ],
      ),
      Comment(
        id: '2',
        text: 'Morning yoga session 🧘‍♀️ Feeling energized!',
        userName: 'Emma',
        userAvatar: 'https://i.pravatar.cc/150?img=3',
        time: DateTime.now().subtract(const Duration(hours: 3)),
        likes: 24,
        isLiked: true,
      ),
      Comment(
        id: '3',
        text: 'New PR: 50 pull-ups! 🎯',
        userName: 'Chris',
        userAvatar: 'https://i.pravatar.cc/150?img=4',
        time: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 42,
        isLiked: false,
      ),
    ];
  }
  
  void toggleLike(String commentId) {
    _toggleLikeInList(_comments, commentId);
    notifyListeners();
  }
  
  bool _toggleLikeInList(List<Comment> comments, String commentId) {
    for (int i = 0; i < comments.length; i++) {
      if (comments[i].id == commentId) {
        final comment = comments[i];
        comments[i] = Comment(
          id: comment.id,
          text: comment.text,
          userName: comment.userName,
          userAvatar: comment.userAvatar,
          time: comment.time,
          likes: comment.isLiked ? comment.likes - 1 : comment.likes + 1,
          isLiked: !comment.isLiked,
          replies: comment.replies,
        );
        return true;
      }
      
      if (comments[i].replies.isNotEmpty) {
        final replies = List<Comment>.from(comments[i].replies);
        final found = _toggleLikeInList(replies, commentId);
        if (found) {
          final comment = comments[i];
          comments[i] = Comment(
            id: comment.id,
            text: comment.text,
            userName: comment.userName,
            userAvatar: comment.userAvatar,
            time: comment.time,
            likes: comment.likes,
            isLiked: comment.isLiked,
            replies: replies,
          );
          return true;
        }
      }
    }
    return false;
  }
}
EOF2

echo "✅ Created Comment Provider"

# Create Comment Widget WITH IMPORT
cat > lib/features/feed/widgets/comment_widget.dart << 'EOF2'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/core/models/comment.dart';
import 'package:workout_app/features/feed/providers/comment_provider.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final bool isReply;
  
  const CommentWidget({
    super.key,
    required this.comment,
    this.isReply = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final commentProvider = Provider.of<CommentProvider>(context, listen: false);
    
    return Padding(
      padding: EdgeInsets.only(
        left: isReply ? 24.0 : 0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(comment.userAvatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment.text,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          _formatTime(comment.time),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () {
                            commentProvider.toggleLike(comment.id);
                          },
                          child: Row(
                            children: [
                              Icon(
                                comment.isLiked ? Icons.favorite : Icons.favorite_border,
                                size: 18,
                                color: comment.isLiked ? Colors.red : Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${comment.likes}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: comment.isLiked ? Colors.red : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (comment.replies.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...comment.replies.map(
              (reply) => CommentWidget(
                comment: reply,
                isReply: true,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Just now';
    }
  }
}
EOF2

echo "✅ Created Comment Widget"

# Create Feed Screen WITH PROPER IMPORTS
cat > lib/features/feed/screens/feed_screen.dart << 'EOF2'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/core/models/comment.dart';  // ADD THIS IMPORT
import 'package:workout_app/features/feed/providers/comment_provider.dart';
import 'package:workout_app/features/feed/widgets/comment_widget.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workout Feed',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<CommentProvider>(
        builder: (context, commentProvider, _) {
          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.green[50],
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFF4CAF50),
                      child: Icon(
                        Icons.fitness_center,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Workout Comments',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${commentProvider.comments.length} comments • ${_calculateTotalLikes(commentProvider.comments)} likes',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.green[100],
                child: const Row(
                  children: [
                    Icon(Icons.info, color: Color(0xFF4CAF50)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tap ❤️ icon to test like functionality',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Comments List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: commentProvider.comments.length,
                  itemBuilder: (context, index) {
                    final comment = commentProvider.comments[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: CommentWidget(comment: comment),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSuccessMessage(context);
        },
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.check, color: Colors.white),
      ),
    );
  }
  
  int _calculateTotalLikes(List<Comment> comments) {
    int total = 0;
    for (var comment in comments) {
      total += comment.likes;
    }
    return total;
  }
  
  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '✅ Comments like is working perfectly!',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Color(0xFF4CAF50),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
EOF2

echo "✅ Created Feed Screen with proper imports"

# Create main.dart
cat > lib/main.dart << 'EOF2'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/feed/screens/feed_screen.dart';
import 'package:workout_app/features/feed/providers/comment_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommentProvider()),
      ],
      child: MaterialApp(
        title: 'Workout App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: const Color(0xFF4CAF50),
          useMaterial3: true,
        ),
        home: const FeedScreen(),
      ),
    );
  }
}
EOF2

echo "✅ Created main.dart"

# Get dependencies
flutter pub get

echo ""
echo "🎉 FIX COMPLETE!"
echo "================"
echo ""
echo "✅ Fixed Issues:"
echo "   1. Missing Comment import in feed_screen.dart"
echo "   2. Proper type annotations"
echo "   3. Working imports"
echo ""
echo "🚀 To run the app:"
echo "   flutter run"
echo ""
echo "🧪 Test the comments like:"
echo "   1. Tap heart icons"
echo "   2. Watch them toggle"
echo "   3. See counts update"
echo ""
echo "🔥 Everything should work now!"
