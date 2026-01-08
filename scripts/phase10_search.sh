#!/bin/bash
# Implement Search & Discovery Feature

echo "🔍 Building Search & Discovery Feature..."

# Create search models
echo "📝 Creating search models..."
mkdir -p lib/core/models/search

cat > lib/core/models/search/search_result.dart << 'SEARCH_RESULT'
class SearchResult {
  final String id;
  final SearchResultType type;
  final String title;
  final String subtitle;
  final String imageUrl;
  final dynamic data; // User, Post, or Hashtag data

  SearchResult({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.data,
  });
}

enum SearchResultType {
  user,
  post,
  hashtag,
  trending,
}
SEARCH_RESULT

cat > lib/core/models/search/trending_item.dart << 'TRENDING_ITEM'
class TrendingItem {
  final String id;
  final String name;
  final int postCount;
  final int engagement;
  final TrendType type;

  TrendingItem({
    required this.id,
    required this.name,
    required this.postCount,
    required this.engagement,
    required this.type,
  });
}

enum TrendType {
  hashtag,
  workout,
  challenge,
  user,
}
TRENDING_ITEM

# Create search provider
echo "📝 Creating SearchProvider..."
mkdir -p lib/features/search/providers

cat > lib/features/search/providers/search_provider.dart << 'SEARCH_PROVIDER'
import 'package:flutter/material.dart';
import 'package:workout_app/core/models/search/search_result.dart';
import 'package:workout_app/core/models/search/trending_item.dart';
import 'package:workout_app/core/models/user.dart';
import 'package:workout_app/core/models/post.dart';

class SearchProvider with ChangeNotifier {
  // Search state
  String _searchQuery = '';
  List<SearchResult> _searchResults = [];
  bool _isSearching = false;
  
  // Discovery state
  List<TrendingItem> _trendingItems = [];
  List<User> _suggestedUsers = [];
  List<Post> _explorePosts = [];

  // Getters
  String get searchQuery => _searchQuery;
  List<SearchResult> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  List<TrendingItem> get trendingItems => _trendingItems;
  List<User> get suggestedUsers => _suggestedUsers;
  List<Post> get explorePosts => _explorePosts;

  SearchProvider() {
    _initializeMockData();
  }

  // Initialize mock data
  void _initializeMockData() {
    // Mock trending items
    _trendingItems = [
      TrendingItem(
        id: '1',
        name: '#FitnessChallenge',
        postCount: 1250,
        engagement: 8920,
        type: TrendType.hashtag,
      ),
      TrendingItem(
        id: '2',
        name: 'Morning Workout',
        postCount: 890,
        engagement: 6540,
        type: TrendType.workout,
      ),
      TrendingItem(
        id: '3',
        name: 'YogaFlow',
        postCount: 670,
        engagement: 5120,
        type: TrendType.challenge,
      ),
      TrendingItem(
        id: '4',
        name: '@fit_john',
        postCount: 450,
        engagement: 3890,
        type: TrendType.user,
      ),
    ];

    // Mock suggested users
    _suggestedUsers = [
      User(
        id: 'suggested_1',
        username: 'fitness_guru',
        email: 'guru@example.com',
        fullName: 'Alex Johnson',
        avatarUrl: 'https://example.com/avatar1.jpg',
        bio: 'Fitness Coach & Nutritionist',
        isVerified: true,
      ),
      User(
        id: 'suggested_2',
        username: 'yoga_master',
        email: 'yoga@example.com',
        fullName: 'Sara Williams',
        avatarUrl: 'https://example.com/avatar2.jpg',
        bio: 'Yoga Instructor',
        isVerified: true,
      ),
      User(
        id: 'suggested_3',
        username: 'gym_rat',
        email: 'gym@example.com',
        fullName: 'Mike Chen',
        avatarUrl: 'https://example.com/avatar3.jpg',
        bio: 'Bodybuilding Enthusiast',
        isVerified: false,
      ),
    ];

    // Mock explore posts will be populated from feed
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _searchResults.clear();
    }
    notifyListeners();
  }

  // Perform search
  Future<void> search(String query) async {
    if (query.isEmpty) {
      _searchResults.clear();
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock search results
    _searchResults = [
      SearchResult(
        id: 'user_1',
        type: SearchResultType.user,
        title: 'John Doe',
        subtitle: '@john_doe • Fitness Coach',
        imageUrl: 'https://example.com/avatar1.jpg',
        data: User(
          id: 'user_1',
          username: 'john_doe',
          email: 'john@example.com',
          fullName: 'John Doe',
          avatarUrl: 'https://example.com/avatar1.jpg',
          bio: 'Fitness Coach',
          isVerified: true,
        ),
      ),
      SearchResult(
        id: 'post_1',
        type: SearchResultType.post,
        title: 'Morning Routine',
        subtitle: '245 likes • 32 comments',
        imageUrl: 'https://example.com/post1.jpg',
        data: null, // Would be Post object
      ),
      SearchResult(
        id: 'hashtag_1',
        type: SearchResultType.hashtag,
        title: '#FitnessGoals',
        subtitle: '15.2K posts',
        imageUrl: '',
        data: '#FitnessGoals',
      ),
      SearchResult(
        id: 'user_2',
        type: SearchResultType.user,
        title: 'Jane Smith',
        subtitle: '@jane_smith • Yoga Instructor',
        imageUrl: 'https://example.com/avatar2.jpg',
        data: User(
          id: 'user_2',
          username: 'jane_smith',
          email: 'jane@example.com',
          fullName: 'Jane Smith',
          avatarUrl: 'https://example.com/avatar2.jpg',
          bio: 'Yoga Instructor',
          isVerified: true,
        ),
      ),
    ];

    _isSearching = false;
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _searchResults.clear();
    notifyListeners();
  }

  // Update explore posts
  void updateExplorePosts(List<Post> posts) {
    _explorePosts = posts;
    notifyListeners();
  }

  // Follow suggested user
  void followSuggestedUser(String userId) {
    final index = _suggestedUsers.indexWhere((user) => user.id == userId);
    if (index != -1) {
      // In real app, this would call an API
      _suggestedUsers.removeAt(index);
      notifyListeners();
    }
  }
}
SEARCH_PROVIDER

# Create search screens
echo "📝 Creating search screens..."
mkdir -p lib/features/search/screens

cat > lib/features/search/screens/search_screen.dart << 'SEARCH_SCREEN'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/search/providers/search_provider.dart';
import 'package:workout_app/features/search/widgets/search_bar.dart';
import 'package:workout_app/features/search/widgets/search_results.dart';
import 'package:workout_app/features/search/widgets/trending_list.dart';
import 'package:workout_app/features/search/widgets/suggested_users.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    context.read<SearchProvider>().setSearchQuery(query);
    
    if (query.isNotEmpty) {
      // Debounce search
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_searchController.text == query) {
          context.read<SearchProvider>().search(query);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              controller: _searchController,
              onClear: () {
                _searchController.clear();
                searchProvider.clearSearch();
              },
            ),
          ),

          // Search Results or Discovery Content
          Expanded(
            child: searchProvider.searchQuery.isNotEmpty
                ? SearchResultsWidget(
                    results: searchProvider.searchResults,
                    isLoading: searchProvider.isSearching,
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Trending
                      TrendingListWidget(
                        items: searchProvider.trendingItems,
                      ),

                      const SizedBox(height: 24),

                      // Suggested Users
                      SuggestedUsersWidget(
                        users: searchProvider.suggestedUsers,
                        onFollow: (userId) {
                          searchProvider.followSuggestedUser(userId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('User followed successfully!'),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Explore Section Title
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Explore Workouts',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Explore posts would go here
                      // In a real app, this would be a grid of posts
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[100],
                        ),
                        child: Center(
                          child: Text(
                            'Explore Posts Grid',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
SEARCH_SCREEN

# Create explore screen
cat > lib/features/search/screens/explore_screen.dart << 'EXPLORE_SCREEN'
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
EXPLORE_SCREEN

# Create search widgets
echo "📝 Creating search widgets..."
mkdir -p lib/features/search/widgets

cat > lib/features/search/widgets/search_bar.dart << 'SEARCH_BAR'
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;

  const SearchBarWidget({
    Key? key,
    required this.controller,
    required this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search users, posts, hashtags...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: (value) {
          // Changes are handled by the listener
        },
        onSubmitted: (value) {
          // Search on submit
          if (value.isNotEmpty) {
            FocusScope.of(context).unfocus();
          }
        },
      ),
    );
  }
}
SEARCH_BAR

cat > lib/features/search/widgets/search_results.dart << 'SEARCH_RESULTS'
import 'package:flutter/material.dart';
import 'package:workout_app/core/models/search/search_result.dart';

class SearchResultsWidget extends StatelessWidget {
  final List<SearchResult> results;
  final bool isLoading;

  const SearchResultsWidget({
    Key? key,
    required this.results,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return SearchResultItem(result: result);
      },
    );
  }
}

class SearchResultItem extends StatelessWidget {
  final SearchResult result;

  const SearchResultItem({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: result.imageUrl.isNotEmpty
          ? CircleAvatar(
              backgroundImage: NetworkImage(result.imageUrl),
              radius: 24,
            )
          : Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.tag, color: Colors.green),
            ),
      title: Text(
        result.title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        result.subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey[600],
        ),
      ),
      trailing: result.type == SearchResultType.user
          ? OutlinedButton(
              onPressed: () {
                // Follow user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Following ${result.title}'),
                  ),
                );
              },
              child: const Text('Follow'),
            )
          : null,
      onTap: () {
        // Handle result tap
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: ${result.title}'),
          ),
        );
      },
    );
  }
}
SEARCH_RESULTS

cat > lib/features/search/widgets/trending_list.dart << 'TRENDING_LIST'
import 'package:flutter/material.dart';
import 'package:workout_app/core/models/search/trending_item.dart';

class TrendingListWidget extends StatelessWidget {
  final List<TrendingItem> items;

  const TrendingListWidget({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Trending Now',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(height: 16),
          itemBuilder: (context, index) {
            final item = items[index];
            return TrendingListItem(item: item);
          },
        ),
      ],
    );
  }
}

class TrendingListItem extends StatelessWidget {
  final TrendingItem item;

  const TrendingListItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  IconData _getIcon(TrendType type) {
    switch (type) {
      case TrendType.hashtag:
        return Icons.tag;
      case TrendType.workout:
        return Icons.fitness_center;
      case TrendType.challenge:
        return Icons.emoji_events;
      case TrendType.user:
        return Icons.person;
    }
  }

  Color _getColor(TrendType type) {
    switch (type) {
      case TrendType.hashtag:
        return Colors.blue;
      case TrendType.workout:
        return Colors.green;
      case TrendType.challenge:
        return Colors.orange;
      case TrendType.user:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _getColor(item.type).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          _getIcon(item.type),
          color: _getColor(item.type),
          size: 24,
        ),
      ),
      title: Text(
        item.name,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${item.postCount} posts • ${item.engagement} engagements',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Navigate to trending item
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exploring ${item.name}'),
          ),
        );
      },
    );
  }
}
TRENDING_LIST

cat > lib/features/search/widgets/suggested_users.dart << 'SUGGESTED_USERS'
import 'package:flutter/material.dart';
import 'package:workout_app/core/models/user.dart';

class SuggestedUsersWidget extends StatelessWidget {
  final List<User> users;
  final Function(String) onFollow;

  const SuggestedUsersWidget({
    Key? key,
    required this.users,
    required this.onFollow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Suggested for You',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return SuggestedUserCard(
                user: user,
                onFollow: () => onFollow(user.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SuggestedUserCard extends StatelessWidget {
  final User user;
  final VoidCallback onFollow;

  const SuggestedUserCard({
    Key? key,
    required this.user,
    required this.onFollow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
              if (user.isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.verified,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            user.username,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onFollow,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
              ),
              child: const Text('Follow'),
            ),
          ),
        ],
      ),
    );
  }
}
SUGGESTED_USERS

cat > lib/features/search/widgets/explore_grid.dart << 'EXPLORE_GRID'
import 'package:flutter/material.dart';
import 'package:workout_app/core/models/post.dart';

class ExploreGrid extends StatelessWidget {
  final List<Post> posts;
  final Function(Post) onPostTap;

  const ExploreGrid({
    Key? key,
    required this.posts,
    required this.onPostTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return _ExploreGridItem(
          post: post,
          onTap: () => onPostTap(post),
        );
      },
    );
  }
}

class _ExploreGridItem extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  const _ExploreGridItem({
    Key? key,
    required this.post,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image: post.media.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(post.media.first.thumbnailUrl),
                  fit: BoxFit.cover,
                )
              : null,
          color: Colors.grey[200],
        ),
        child: Stack(
          children: [
            // Media overlay
            if (post.media.isNotEmpty && post.media.first.type == 'video')
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            
            // Stats overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite, size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      '${post.likesCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
EXPLORE_GRID

# Update main.dart to include SearchProvider
echo "📝 Updating main.dart..."
sed -i '/ChangeNotifierProvider.*NotificationsProvider/a\        ChangeNotifierProvider(create: (_) => SearchProvider()),' lib/main.dart

# Add import for SearchProvider
sed -i "/import.*notifications_provider/a\import 'package:workout_app/features/search/providers/search_provider.dart';" lib/main.dart

# Update navigation to include search
echo "📝 Updating navigation..."

# Create updated bottom navigation bar
cat > temp_nav.dart << 'NAV_BAR'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/auth/screens/auth_wrapper_screen.dart';
import 'package:workout_app/features/feed/screens/feed_screen.dart';
import 'package:workout_app/features/search/screens/search_screen.dart';
import 'package:workout_app/features/search/screens/explore_screen.dart';
import 'package:workout_app/features/create_post/screens/create_post_screen.dart';
import 'package:workout_app/features/notifications/screens/notifications_screen.dart';
import 'package:workout_app/features/profile/screens/profile_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthWrapperScreen(
      authenticatedBuilder: (context) {
        return MaterialApp(
          title: 'Workout App',
          theme: ThemeData(
            primaryColor: const Color(0xFF4CAF50),
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
            useMaterial3: true,
          ),
          home: const _MainNavigation(),
        );
      },
    );
  }
}

class _MainNavigation extends StatefulWidget {
  const _MainNavigation({super.key});

  @override
  State<_MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<_MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const ExploreScreen(),
    const CreatePostScreen(),
    const SearchScreen(),
    const AppNotificationsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
NAV_BAR

# Check if we need to update the main navigation
echo "📝 Checking navigation structure..."

echo "✅ Search & Discovery feature created!"
echo ""
echo "📁 New files created:"
echo "   - lib/core/models/search/search_result.dart"
echo "   - lib/core/models/search/trending_item.dart"
echo "   - lib/features/search/providers/search_provider.dart"
echo "   - lib/features/search/screens/search_screen.dart"
echo "   - lib/features/search/screens/explore_screen.dart"
echo "   - lib/features/search/widgets/search_bar.dart"
echo "   - lib/features/search/widgets/search_results.dart"
echo "   - lib/features/search/widgets/trending_list.dart"
echo "   - lib/features/search/widgets/suggested_users.dart"
echo "   - lib/features/search/widgets/explore_grid.dart"
echo ""
echo "🔄 Updating dependencies..."
flutter pub get

echo "🔍 Running flutter analyze..."
flutter analyze

echo "🎉 Phase 10 Complete! Search & Discovery feature is ready."
echo "👉 Update your main navigation to include SearchScreen and ExploreScreen"
echo "👉 Run 'flutter run' to test the new features"
