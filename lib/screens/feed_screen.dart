import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feed_provider.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<FeedProvider>(context, listen: false).reloadMockData();
            },
          ),
        ],
      ),
      body: Consumer<FeedProvider>(
        builder: (context, feedProvider, child) {
          if (feedProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (feedProvider.posts.isEmpty) {
            return const Center(
              child: Text('No posts yet'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await feedProvider.reloadMockData();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: feedProvider.posts.length,
              itemBuilder: (context, index) {
                final post = feedProvider.posts[index];
                return PostCard(post: post);
              },
            ),
          );
        },
      ),
    );
  }
}
