// Ensure your main.dart has:

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        // Add other providers here
      ],
      child: MyApp(),
    ),
  );
}

// And in your FeedScreen:
Consumer<FeedProvider>(
  builder: (context, feedProvider, child) {
    return ListView.builder(
      itemCount: feedProvider.posts.length,
      itemBuilder: (context, index) {
        final post = feedProvider.posts[index];
        return PostWidget(post: post);
      },
    );
  },
)
