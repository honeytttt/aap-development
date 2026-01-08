import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feed_provider.dart';
import '../models/post.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;
  final String postId;
  final VoidCallback onReply;
  final int level;

  const CommentItem({
    super.key,
    required this.comment,
    required this.postId,
    required this.onReply,
    this.level = 0,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _expanded = true;
  
  void _toggleLike() {
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    feedProvider.toggleCommentLike(widget.postId, widget.comment.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: widget.level * 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.comment.avatarUrl),
                radius: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
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
                          const SizedBox(height: 4),
                          Text(
                            widget.comment.content,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _formatTime(widget.comment.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Like button - FIXED for nested comments
                        GestureDetector(
                          onTap: _toggleLike,
                          child: Row(
                            children: [
                              Icon(
                                widget.comment.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 14,
                                color: widget.comment.isLiked
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.comment.likes}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: widget.onReply,
                          child: const Text(
                            'Reply',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
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
          
          // Replies
          if (widget.comment.replies.isNotEmpty)
            Column(
              children: [
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _expanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.comment.replies.length} ${widget.comment.replies.length == 1 ? 'reply' : 'replies'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_expanded)
                  Column(
                    children: widget.comment.replies.map((reply) {
                      return CommentItem(
                        comment: reply,
                        postId: widget.postId,
                        onReply: widget.onReply,
                        level: widget.level + 1,
                      );
                    }).toList(),
                  ),
              ],
            ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
