import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/feed/providers/feed_provider.dart';
import 'package:workout_app/features/search/widgets/explore_grid.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final feedProvider = context.watch<FeedProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        centerTitle: true,
      ),
      body: ExploreGrid(
        posts: feedProvider.posts,
        onPostTap: (post) {
          // Navigate to post detail
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening post: ${post.id}'),
            ),
          );
        },
      ),
    );
  }
}
