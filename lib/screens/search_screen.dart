import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = ['fitness', 'yoga', 'workout', 'gym'];
  List<String> _trendingHashtags = [
    '#fitness',
    '#workout',
    '#yoga',
    '#gym',
    '#health',
    '#wellness',
    '#training',
    '#cardio',
    '#strength',
    '#meditation'
  ];
  
  List<Map<String, dynamic>> _users = [
    {
      'id': 'user1',
      'name': 'FitnessPro',
      'avatar': 'https://ui-avatars.com/api/?name=Fitness+Pro&background=4CAF50&color=fff',
      'followers': 1250,
      'isFollowing': false,
    },
    {
      'id': 'user2',
      'name': 'YogaMaster',
      'avatar': 'https://ui-avatars.com/api/?name=Yoga+Master&background=2196F3&color=fff',
      'followers': 890,
      'isFollowing': true,
    },
    {
      'id': 'user3',
      'name': 'GymRat',
      'avatar': 'https://ui-avatars.com/api/?name=Gym+Rat&background=F44336&color=fff',
      'followers': 2100,
      'isFollowing': false,
    },
    {
      'id': 'user4',
      'name': 'FitMom',
      'avatar': 'https://ui-avatars.com/api/?name=Fit+Mom&background=9C27B0&color=fff',
      'followers': 1560,
      'isFollowing': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      });
    }
  }

  void _toggleFollow(int index) {
    setState(() {
      _users[index]['isFollowing'] = !_users[index]['isFollowing'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users, posts, hashtags...',
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                      },
                    )
                  : null,
            ),
            onSubmitted: _performSearch,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF4CAF50),
          labelColor: const Color(0xFF4CAF50),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Trending'),
            Tab(text: 'Users'),
            Tab(text: 'Tags'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Trending Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Trending Now',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final trendingPosts = [
                    {
                      'image': 'https://images.pexels.com/photos/2294361/pexels-photo-2294361.jpeg',
                      'title': 'Morning Workouts',
                      'posts': '1.2k posts',
                    },
                    {
                      'image': 'https://images.pexels.com/photos/8436665/pexels-photo-8436665.jpeg',
                      'title': 'Yoga Challenges',
                      'posts': '890 posts',
                    },
                    {
                      'image': 'https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg',
                      'title': 'Gym Progress',
                      'posts': '2.1k posts',
                    },
                    {
                      'image': 'https://images.pexels.com/photos/1954524/pexels-photo-1954524.jpeg',
                      'title': 'Home Workouts',
                      'posts': '1.5k posts',
                    },
                  ];
                  final post = trendingPosts[index];
                  
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Image.network(
                          post['image']!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
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
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                post['posts']!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _recentSearches.map((search) {
                  return ActionChip(
                    label: Text(search),
                    onPressed: () {
                      _searchController.text = search;
                      _performSearch(search);
                    },
                    backgroundColor: Colors.green[50],
                  );
                }).toList(),
              ),
            ],
          ),
          
          // Users Tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['avatar']),
                    radius: 24,
                  ),
                  title: Text(
                    user['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('${user['followers']} followers'),
                  trailing: SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () => _toggleFollow(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: user['isFollowing']
                            ? Colors.grey[200]
                            : const Color(0xFF4CAF50),
                        foregroundColor: user['isFollowing']
                            ? Colors.black
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Text(
                        user['isFollowing'] ? 'Following' : 'Follow',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Viewing ${user['name']}\'s profile'),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          
          // Tags Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Popular Hashtags',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _trendingHashtags.map((hashtag) {
                  return FilterChip(
                    label: Text(
                      hashtag,
                      style: const TextStyle(fontSize: 16),
                    ),
                    selected: false,
                    onSelected: (selected) {
                      _searchController.text = hashtag;
                      _performSearch(hashtag);
                    },
                    backgroundColor: Colors.grey[100],
                    selectedColor: Colors.green[100],
                    checkmarkColor: Colors.green,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const Text(
                'Suggested for You',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  _buildCategoryItem('🏋️ Strength Training', '125k posts'),
                  _buildCategoryItem('🧘 Yoga & Meditation', '89k posts'),
                  _buildCategoryItem('🏃 Cardio Workouts', '156k posts'),
                  _buildCategoryItem('💪 Bodyweight Exercises', '78k posts'),
                  _buildCategoryItem('🥗 Nutrition Tips', '92k posts'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, String count) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Text(
          count,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        onTap: () {
          _searchController.text = title.split(' ')[0];
          _performSearch(title.split(' ')[0]);
        },
      ),
    );
  }
}
