import 'package:flutter/material.dart';
import 'package:workout_app/core/models/user.dart';
import 'package:workout_app/core/models/post.dart';

class SearchResult {
  final String id;
  final String type; // 'user' or 'post' or 'hashtag'
  final String title;
  final String subtitle;
  final String? imageUrl;
  final dynamic data;

  SearchResult({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.data,
  });
}

class SearchProvider with ChangeNotifier {
  String _searchQuery = '';
  List<SearchResult> _searchResults = [];
  List<SearchResult> _trendingItems = [];
  List<User> _suggestedUsers = [];

  String get searchQuery => _searchQuery;
  List<SearchResult> get searchResults => _searchResults;
  List<SearchResult> get trendingItems => _trendingItems;
  List<User> get suggestedUsers => _suggestedUsers;

  SearchProvider() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Mock trending items with working image URLs
    _trendingItems = [
      SearchResult(
        id: 'trending1',
        type: 'hashtag',
        title: '#MorningWorkout',
        subtitle: '15K posts',
        imageUrl: 'https://images.pexels.com/photos/1229356/pexels-photo-1229356.jpeg?auto=compress&cs=tinysrgb&w=400',
      ),
      SearchResult(
        id: 'trending2',
        type: 'hashtag',
        title: '#YogaEveryday',
        subtitle: '8.2K posts',
        imageUrl: 'https://images.pexels.com/photos/1812964/pexels-photo-1812964.jpeg?auto=compress&cs=tinysrgb&w=400',
      ),
      SearchResult(
        id: 'trending3',
        type: 'user',
        title: 'FitFamCommunity',
        subtitle: 'Fitness community',
        imageUrl: 'https://images.pexels.com/photos/2261477/pexels-photo-2261477.jpeg?auto=compress&cs=tinysrgb&w=400',
      ),
    ];

    // Mock suggested users with working avatar URLs
    _suggestedUsers = [
      User(
        id: 'suggested1',
        username: 'cardio_queen',
        displayName: 'Lisa Cardio',
        avatarUrl: 'https://i.pravatar.cc/150?img=65',
        bio: 'Cardio enthusiast | Marathon runner',
        followersCount: 856,
        followingCount: 123,
        postsCount: 42,
        isFollowing: false,
        joinedDate: DateTime(2023, 6, 10),
      ),
      User(
        id: 'suggested2',
        username: 'strong_lifts',
        displayName: 'Alex Power',
        avatarUrl: 'https://i.pravatar.cc/150?img=75',
        bio: 'Powerlifter | Strength coach',
        followersCount: 1245,
        followingCount: 89,
        postsCount: 67,
        isFollowing: false,
        joinedDate: DateTime(2023, 2, 15),
      ),
      User(
        id: 'suggested3',
        username: 'pilates_pro',
        displayName: 'Emma Core',
        avatarUrl: 'https://i.pravatar.cc/150?img=33',
        bio: 'Pilates instructor | Core specialist',
        followersCount: 932,
        followingCount: 210,
        postsCount: 38,
        isFollowing: false,
        joinedDate: DateTime(2023, 8, 22),
      ),
    ];
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _searchResults.clear();
    } else {
      _performSearch(query);
    }
    notifyListeners();
  }

  void _performSearch(String query) {
    // Mock search results with working image URLs
    _searchResults = [
      if (query.toLowerCase().contains('fit') || query.toLowerCase().contains('john'))
        SearchResult(
          id: 'search1',
          type: 'user',
          title: 'fitness_john',
          subtitle: 'John Fitness - Personal trainer',
          imageUrl: 'https://i.pravatar.cc/150?img=32',
          data: User(
            id: '1',
            username: 'fitness_john',
            displayName: 'John Fitness',
            avatarUrl: 'https://i.pravatar.cc/150?img=32',
            bio: 'Fitness enthusiast | Personal trainer',
            followersCount: 1243,
            followingCount: 342,
            postsCount: 56,
            joinedDate: DateTime(2023, 1, 15),
          ),
        ),
      if (query.toLowerCase().contains('yoga') || query.toLowerCase().contains('sarah'))
        SearchResult(
          id: 'search2',
          type: 'user',
          title: 'yoga_sarah',
          subtitle: 'Sarah Yoga - Yoga instructor',
          imageUrl: 'https://i.pravatar.cc/150?img=44',
          data: User(
            id: '2',
            username: 'yoga_sarah',
            displayName: 'Sarah Yoga',
            avatarUrl: 'https://i.pravatar.cc/150?img=44',
            bio: 'Yoga instructor | Wellness coach',
            followersCount: 892,
            followingCount: 210,
            postsCount: 34,
            joinedDate: DateTime(2023, 3, 22),
          ),
        ),
      if (query.toLowerCase().contains('workout'))
        SearchResult(
          id: 'search3',
          type: 'hashtag',
          title: '#Workout',
          subtitle: '45K posts',
        ),
      if (query.toLowerCase().contains('fitness'))
        SearchResult(
          id: 'search4',
          type: 'hashtag',
          title: '#Fitness',
          subtitle: '78K posts',
        ),
    ].where((result) => result.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  void followSuggestedUser(String userId) {
    final index = _suggestedUsers.indexWhere((user) => user.id == userId);
    if (index != -1) {
      final user = _suggestedUsers[index];
      _suggestedUsers[index] = user.copyWith(
        isFollowing: true,
        followersCount: user.followersCount + 1,
      );
      notifyListeners();
    }
  }

  void unfollowSuggestedUser(String userId) {
    final index = _suggestedUsers.indexWhere((user) => user.id == userId);
    if (index != -1) {
      final user = _suggestedUsers[index];
      _suggestedUsers[index] = user.copyWith(
        isFollowing: false,
        followersCount: user.followersCount - 1,
      );
      notifyListeners();
    }
  }
}
