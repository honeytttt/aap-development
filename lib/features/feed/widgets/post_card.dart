import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/core/models/post.dart';
import 'package:workout_app/features/auth/providers/auth_provider.dart';
import 'package:workout_app/features/feed/providers/feed_provider.dart';
import 'package:workout_app/features/feed/screens/comments_screen.dart';
import 'package:workout_app/features/profile/screens/profile_screen.dart';
import 'package:workout_app/features/media/widgets/media_gallery.dart';
import 'package:workout_app/features/media/widgets/single_media.dart';
import 'package:workout_app/core/models/media_gallery.dart' show MediaGallery;

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final feedProvider = Provider.of<FeedProvider>(context);
    final isLiked = authProvider.user != null 
        ? post.likedBy.contains(authProvider.user!.id)
        : false;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info - NOW CLICKABLE
            InkWell(
              onTap: () {
                // Navigate to user profile
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(userId: post.userId),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(post.userAvatar),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _formatTimeAgo(post.createdAt),
                        style: const TextStyle(
                          color: Color.fromRGBO(96, 96, 96, 1),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Post content
            if (post.content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  post.content,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            
            // Media Gallery - REPLACED OLD IMAGE PLACEHOLDER
            if (post.hasMedia)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: post.hasMultipleMedia
                    ? MediaGalleryWidget(
                        media: post.media,
                        initialIndex: 0,
                        showControls: true,
                      )
                    : SingleMediaWidget(
                        media: post.media.first,
                        height: 250,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MediaViewerScreen(
                                mediaGallery: MediaGallery(
                                  media: post.media,
                                  currentIndex: 0,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            
            // Stats
            Row(
              children: [
                Icon(
                  Icons.favorite,
                  size: 16,
                  color: Colors.red[400],
                ),
                const SizedBox(width: 4),
                Text(
                  '${post.likes}',
                  style: const TextStyle(
                    color: Color.fromRGBO(96, 96, 96, 1),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.chat_bubble_outline,
                  size: 16,
                  color: const Color.fromRGBO(96, 96, 96, 1),
                ),
                const SizedBox(width: 4),
                Text(
                  '${post.commentCount}',
                  style: const TextStyle(
                    color: Color.fromRGBO(96, 96, 96, 1),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                if (post.hasMedia)
                  Row(
                    children: [
                      Icon(
                        post.hasImages ? Icons.photo : Icons.videocam,
                        size: 16,
                        color: const Color.fromRGBO(96, 96, 96, 1),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.media.length}',
                        style: const TextStyle(
                          color: Color.fromRGBO(96, 96, 96, 1),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Like button
                InkWell(
                  onTap: () {
                    if (authProvider.user != null) {
                      feedProvider.likePost(post.id, authProvider.user!.id);
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : const Color.fromRGBO(96, 96, 96, 1),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Like',
                        style: TextStyle(
                          color: isLiked ? Colors.red : const Color.fromRGBO(96, 96, 96, 1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Comment button
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(post: post),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: const Color.fromRGBO(96, 96, 96, 1),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Comment',
                        style: TextStyle(
                          color: Color.fromRGBO(96, 96, 96, 1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Share button
                InkWell(
                  onTap: () {
                    _showShareOptions(context, post);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.share,
                        color: const Color.fromRGBO(96, 96, 96, 1),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Share',
                        style: TextStyle(
                          color: Color.fromRGBO(96, 96, 96, 1),
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
    );
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  void _showShareOptions(BuildContext context, Post post) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.link, color: Color(0xFF4CAF50)),
                title: const Text('Copy Link'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Link copied to clipboard'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Color(0xFF4CAF50)),
                title: const Text('Share to...'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share functionality would open native share dialog'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.bookmark, color: Color(0xFF4CAF50)),
                title: const Text('Save Post'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Post saved to your collection'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: const Color.fromRGBO(220, 220, 220, 1),
                  foregroundColor: Colors.black87,
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }
}
