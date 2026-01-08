import 'package:flutter/material.dart';
import 'package:workout_app/features/feed/providers/feed_provider.dart';

void main() {
  print("Testing if posts are being added...");
  
  final provider = FeedProvider();
  print("Initial posts: ${provider.posts.length}");
  
  // Simulate adding a post
  provider.addPostFromCreate(
    caption: "Test post",
    hashtags: ["test"],
    media: [],
    user: User(
      id: 'test',
      username: 'test',
      displayName: 'Test User',
      avatarUrl: '',
      bio: '',
      followersCount: 0,
      followingCount: 0,
      postsCount: 0,
      joinedDate: DateTime.now(),
    ),
  );
  
  print("After adding post: ${provider.posts.length}");
  print("Latest post: ${provider.posts.first.caption}");
  print("✓ Test complete!");
}
