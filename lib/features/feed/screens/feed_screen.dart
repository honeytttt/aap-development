import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/auth/providers/auth_provider.dart';
import 'package:workout_app/features/feed/providers/feed_provider.dart';
import 'package:workout_app/features/feed/screens/comments_screen.dart';
import 'package:workout_app/features/feed/widgets/post_widget.dart';
import 'package:workout_app/features/create_post/screens/create_post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    print("📱 FeedScreen initialized - will rebuild when FeedProvider changes");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      Provider.of<FeedProvider>(context, listen: false).loadMorePosts();
    }
  }

  Future<void> _refreshFeed() async {
    print("🔄 Manually refreshing feed...");
    // Force a rebuild by calling setState
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("🔄 FeedScreen BUILD called");
    
    // This Consumer will rebuild when FeedProvider changes
    return Consumer<FeedProvider>(
      builder: (context, feedProvider, child) {
        print("📊 Consumer rebuilding - Feed has ${feedProvider.posts.length} posts");
        
        return Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Workout Feed'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _refreshFeed,
                    tooltip: 'Refresh',
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // Navigate to search screen
                    },
                  ),
                ],
              ),
              body: feedProvider.posts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.fitness_center,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No posts yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const Text(
                            'Be the first to share your workout!',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CreatePostScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Create First Post'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await _refreshFeed();
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: feedProvider.posts.length + (feedProvider.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= feedProvider.posts.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: feedProvider.isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text('No more posts'),
                              ),
                            );
                          }

                          final post = feedProvider.posts[index];
                          print("📄 Rendering post ${index + 1}: ${post.id} - ${post.caption.substring(0, min(30, post.caption.length))}...");
                          
                          return PostWidget(
                            post: post,
                            onLike: () {
                              final currentUserId = authProvider.currentUser?.id ?? '1';
                              if (post.isLiked) {
                                feedProvider.unlikePost(post.id);
                              } else {
                                feedProvider.likePost(post.id, currentUserId);
                              }
                            },
                            onSave: () {
                              final currentUserId = authProvider.currentUser?.id ?? '1';
                              print('Save post ${post.id} by user $currentUserId');
                            },
                            onComment: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentsScreen(post: post),
                                ),
                              );
                            },
                            onShare: () {
                              print('Share post ${post.id}');
                            },
                          );
                        },
                      ),
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreatePostScreen(),
                    ),
                  ).then((_) {
                    // When we return from CreatePostScreen, refresh the feed
                    print("↩️ Returned from CreatePostScreen, refreshing feed...");
                    _refreshFeed();
                  });
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            );
          },
        );
      },
    );
  }
  
  int min(int a, int b) => a < b ? a : b;
}
