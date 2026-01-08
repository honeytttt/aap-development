import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/core/models/post.dart';
import 'package:workout_app/core/models/comment.dart'; // ADDED IMPORT
import 'package:workout_app/features/auth/providers/auth_provider.dart';
import 'package:workout_app/features/feed/providers/feed_provider.dart';
import 'package:workout_app/features/feed/widgets/comment_item.dart';

class CommentsScreen extends StatefulWidget {
  final Post post;

  const CommentsScreen({super.key, required this.post});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _commentFocusNode.addListener(() {
      if (!_commentFocusNode.hasFocus) {
        // Clear reply mode when focus is lost
        Provider.of<FeedProvider>(context, listen: false).setReplyingTo(null);
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final feedProvider = Provider.of<FeedProvider>(context);
    
    final comments = feedProvider.comments
        .where((comment) => comment.postId == widget.post.id)
        .toList();

    // Helper function to get user initial
    String getUserInitial() {
      if (authProvider.user != null && authProvider.user!.name.isNotEmpty) {
        return authProvider.user!.name.substring(0, 1).toUpperCase();
      }
      return 'U';
    }

    // Get the comment we're replying to
    String? getReplyingToUserName() {
      if (feedProvider.replyingToCommentId != null) {
        final comment = feedProvider.comments.firstWhere(
          (c) => c.id == feedProvider.replyingToCommentId,
          orElse: () => Comment( // FIXED: Now properly referencing Comment class
            id: '',
            postId: '',
            userId: '',
            userName: '',
            userAvatar: '',
            content: '',
            createdAt: DateTime.now(),
          ),
        );
        return comment.userName;
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Comments (${widget.post.commentCount})',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Reply indicator banner
          if (feedProvider.replyingToCommentId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFE8F5E9),
              child: Row(
                children: [
                  const Icon(Icons.reply, size: 16, color: Color(0xFF4CAF50)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Replying to ${getReplyingToUserName() ?? 'comment'}',
                      style: const TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    color: const Color(0xFF4CAF50),
                    onPressed: () {
                      feedProvider.setReplyingTo(null);
                      _commentController.clear();
                    },
                  ),
                ],
              ),
            ),
          
          Expanded(
            child: comments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No comments yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to comment!',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return CommentItem(
                        comment: comment,
                        onReply: () {
                          feedProvider.setReplyingTo(comment.id);
                          _commentFocusNode.requestFocus();
                        },
                      );
                    },
                  ),
          ),
          
          // Comment input section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reply indicator
                if (feedProvider.replyingToCommentId != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.reply, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          'Replying to ${getReplyingToUserName() ?? 'comment'}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFF4CAF50),
                      child: Text(
                        getUserInitial(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        focusNode: _commentFocusNode,
                        decoration: InputDecoration(
                          hintText: feedProvider.replyingToCommentId != null 
                              ? 'Write a reply...' 
                              : 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        onSubmitted: (value) {
                          _postComment(authProvider, feedProvider);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () {
                        _postComment(authProvider, feedProvider);
                      },
                      icon: const Icon(Icons.send),
                      color: const Color(0xFF4CAF50),
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

  void _postComment(AuthProvider authProvider, FeedProvider feedProvider) {
    final content = _commentController.text.trim();
    if (content.isNotEmpty && authProvider.user != null) {
      feedProvider.addComment(
        postId: widget.post.id,
        userId: authProvider.user!.id,
        userName: authProvider.user!.name,
        userAvatar: '', // Mock avatar
        content: content,
        parentCommentId: feedProvider.replyingToCommentId,
      );
      _commentController.clear();
      feedProvider.setReplyingTo(null);
      _commentFocusNode.unfocus();
    }
  }
}
