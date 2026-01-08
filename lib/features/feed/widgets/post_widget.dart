import 'package:flutter/material.dart';
import 'package:workout_app/core/models/post.dart';
import 'package:workout_app/features/feed/screens/comments_screen.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PostWidget({
    super.key,
    required this.post,
    required this.onLike,
    required this.onSave,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.user.avatarUrl ?? ''),
            ),
            title: Text(
              post.user.displayName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              '@${post.user.username} • ${_formatTime(post.createdAt)}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
          // Caption
          if (post.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                post.caption,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          // Media
          if (post.media.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: post.media.length,
                itemBuilder: (context, index) {
                  final media = post.media[index];
                  return Image.network(
                    media.url,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
          // Hashtags
          if (post.hashtags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                children: post.hashtags
                    .map((hashtag) => Chip(
                          label: Text(hashtag),
                          backgroundColor: Colors.green[50],
                        ))
                    .toList(),
              ),
            ),
          // Workout details
          if (post.workoutType != null ||
              post.duration != null ||
              post.calories != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (post.workoutType != null)
                    _buildStatColumn(Icons.fitness_center, post.workoutType!),
                  if (post.duration != null)
                    _buildStatColumn(Icons.timer, '${post.duration}m'),
                  if (post.calories != null)
                    _buildStatColumn(Icons.local_fire_department,
                        '${post.calories} cal'),
                ],
              ),
            ),
          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${post.likesCount} likes',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(post: post),
                      ),
                    );
                  },
                  child: Text(
                    '${post.commentsCount} comments',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: onLike,
                  icon: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: post.isLiked ? Colors.red : null,
                  ),
                  label: Text(post.isLiked ? 'Liked' : 'Like'),
                ),
                TextButton.icon(
                  onPressed: onComment,
                  icon: const Icon(Icons.comment_outlined),
                  label: const Text('Comment'),
                ),
                TextButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.bookmark_border),
                  label: const Text('Save'),
                ),
                TextButton.icon(
                  onPressed: onShare,
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
