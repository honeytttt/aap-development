import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/feed/providers/feed_provider.dart';
import 'package:workout_app/features/feed/widgets/post_card.dart';
import 'package:workout_app/features/create_post/screens/create_post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialPosts();
  }

  Future<void> _loadInitialPosts() async {
    setState(() => _isLoading = true);
    final provider = Provider.of<FeedProvider>(context, listen: false);
    await provider.loadPosts();
    setState(() => _isLoading = false);
  }

  Future<void> _refreshPosts() async {
    final provider = Provider.of<FeedProvider>(context, listen: false);
    await provider.refreshPosts();
  }

  void _navigateToCreatePost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreatePostScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<FeedProvider>(context).posts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: _navigateToCreatePost,
            tooltip: 'Create Post',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        color: Colors.green,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.green),
                ),
              )
            : posts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No posts yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to share your workout!',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _navigateToCreatePost,
                          icon: const Icon(Icons.add),
                          label: const Text('Create First Post'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return PostCard(post: posts[index]);
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePost,
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
