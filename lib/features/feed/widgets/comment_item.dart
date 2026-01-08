import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/core/models/comment.dart';
import 'package:workout_app/features/feed/providers/feed_provider.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final VoidCallback? onReply;

  const CommentItem({
    super.key,
    required this.comment,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context);
    
    final hasReplies = comment.replies.isNotEmpty;
    final isLiked = feedProvider.hasUserLikedComment(comment.id, 'user1'); // Mock user ID

    return Container(
      margin: EdgeInsets.only(
        bottom: 8,
        left: comment.depth * 24.0, // Indentation based on depth
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment content
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(240, 240, 240, 1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color.fromRGBO(200, 200, 200, 1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User info and time
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(comment.userAvatar),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            _formatTimeAgo(comment.createdAt),
                            style: const TextStyle(
                              color: Color.fromRGBO(96, 96, 96, 1),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Expand/collapse button for comments with replies
                    if (hasReplies)
                      IconButton(
                        icon: Icon(
                          comment.isExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          size: 16,
                          color: const Color.fromRGBO(96, 96, 96, 1),
                        ),
                        onPressed: () {
                          feedProvider.toggleCommentExpanded(comment.id);
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Comment content
                Text(
                  comment.content,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Row(
              children: [
                // Like button
                InkWell(
                  onTap: () {
                    feedProvider.likeComment(comment.id, 'user1'); // Mock user
                  },
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 14,
                        color: isLiked ? Colors.red : const Color.fromRGBO(96, 96, 96, 1),
                      ),
                      const SizedBox(width: 4),
                      if (comment.likes > 0)
                        Text(
                          '${comment.likes}',
                          style: const TextStyle(
                            color: Color.fromRGBO(96, 96, 96, 1),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                // Reply button
                InkWell(
                  onTap: onReply,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.reply,
                        size: 14,
                        color: Color.fromRGBO(96, 96, 96, 1),
                      ),
                      const SizedBox(width: 4),
                      if (comment.replies.isNotEmpty)
                        Text(
                          '${comment.replies.length}',
                          style: const TextStyle(
                            color: Color.fromRGBO(96, 96, 96, 1),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                // View replies button (for collapsed comments with replies)
                if (hasReplies && !comment.isExpanded)
                  InkWell(
                    onTap: () {
                      feedProvider.toggleCommentExpanded(comment.id);
                    },
                    child: Row(
                      children: [
                        Text(
                          'View ${comment.replies.length} ${comment.replies.length == 1 ? 'reply' : 'replies'}',
                          style: const TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward,
                          size: 12,
                          color: Color(0xFF4CAF50),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          // Reply indicator line
          if (comment.depth > 0)
            Container(
              margin: const EdgeInsets.only(left: 12, top: 4),
              height: 1,
              width: 16,
              color: const Color.fromRGBO(200, 200, 200, 1),
            ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
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
}
