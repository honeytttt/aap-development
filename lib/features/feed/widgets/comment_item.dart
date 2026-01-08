import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/core/models/comment.dart';
import 'package:workout_app/features/feed/providers/feed_provider.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;
  final VoidCallback onReply;
  final String postId;

  const CommentItem({
    super.key,
    required this.comment,
    required this.onReply,
    required this.postId,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _showReplies = false;

  void _toggleLike() {
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    final currentUserId = '1'; // Mock current user ID
    
    if (widget.comment.isLiked) {
      feedProvider.unlikeComment(widget.postId, widget.comment.id);
    } else {
      feedProvider.likeComment(widget.postId, widget.comment.id, currentUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    final currentUserId = '1'; // Mock current user ID

    return Container(
      margin: EdgeInsets.only(
        left: widget.comment.parentCommentId != null ? 24.0 : 0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 0,
            color: Colors.grey[50],
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                          'https://ui-avatars.com/api/?name=${widget.comment.userName}&background=4CAF50&color=fff',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.comment.userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _formatTime(widget.comment.createdAt),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.comment.text,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    widget.comment.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 18,
                                    color: widget.comment.isLiked
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  onPressed: _toggleLike,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.comment.likesCount}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                TextButton(
                                  onPressed: widget.onReply,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                  ),
                                  child: const Text(
                                    'Reply',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
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
                ],
              ),
            ),
          ),
          // Replies
          if (widget.comment.replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                children: [
                  if (!_showReplies)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showReplies = true;
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'View ${widget.comment.replies.length} ${widget.comment.replies.length == 1 ? 'reply' : 'replies'}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_showReplies)
                    Column(
                      children: [
                        ...widget.comment.replies.map((reply) {
                          return CommentItem(
                            comment: reply,
                            onReply: widget.onReply,
                            postId: widget.postId,
                          );
                        }),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showReplies = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                          ),
                          child: const Text(
                            'Hide replies',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
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

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
