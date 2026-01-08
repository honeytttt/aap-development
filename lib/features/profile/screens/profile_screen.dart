import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/core/models/user.dart';
import 'package:workout_app/features/auth/providers/auth_provider.dart';
import 'package:workout_app/features/feed/providers/feed_provider.dart';
import 'package:workout_app/features/feed/widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final feedProvider = Provider.of<FeedProvider>(context);
    
    // For now, use current user or mock user
    final isCurrentUser = widget.userId == authProvider.currentUser?.id;
    
    // Mock user data for demo
    final user = User(
      id: widget.userId,
      username: isCurrentUser ? 'fitness_john' : 'yoga_sarah',
      displayName: isCurrentUser ? 'John Fitness' : 'Sarah Yoga',
      avatarUrl: isCurrentUser 
          ? 'https://i.pravatar.cc/150?img=32'
          : 'https://i.pravatar.cc/150?img=44',
      bio: isCurrentUser 
          ? 'Fitness enthusiast | Personal trainer\n🏋️‍♂️ Daily workouts | 🥗 Nutrition tips'
          : 'Yoga instructor | Wellness coach\n🧘‍♀️ Morning flows | 🌿 Mindful living',
      followersCount: isCurrentUser ? 1243 : 892,
      followingCount: isCurrentUser ? 342 : 210,
      postsCount: isCurrentUser ? 56 : 34,
      isFollowing: !isCurrentUser,
      joinedDate: DateTime(2023, 1, 15),
      workoutPreferences: isCurrentUser 
          ? ['Strength Training', 'Cardio', 'HIIT']
          : ['Yoga', 'Pilates', 'Meditation'],
      stats: {
        'workoutsThisWeek': isCurrentUser ? 5 : 7,
        'totalMinutes': isCurrentUser ? 225 : 180,
        'caloriesBurned': isCurrentUser ? 1850 : 1420,
        'currentStreak': isCurrentUser ? 14 : 21,
      },
    );
    
    final userPosts = feedProvider.posts
        .where((post) => post.user.id == widget.userId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (isCurrentUser)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  authProvider.logout();
                } else if (value == 'settings') {
                  // Navigate to settings
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'settings',
                  child: Text('Settings'),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ],
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[300]!, Colors.green[700]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(user.avatarUrl ?? ''),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@${user.username}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.bio ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn('Posts', '${user.postsCount}'),
                        _buildStatColumn('Followers', '${user.followersCount}'),
                        _buildStatColumn('Following', '${user.followingCount}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (!isCurrentUser)
                      ElevatedButton(
                        onPressed: () {
                          // Handle follow/unfollow
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          backgroundColor: user.isFollowing 
                              ? Colors.grey[300]
                              : Colors.green,
                          foregroundColor: user.isFollowing 
                              ? Colors.black
                              : Colors.white,
                        ),
                        child: Text(
                          user.isFollowing ? 'Following' : 'Follow',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    if (isCurrentUser)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Edit profile
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('Edit Profile'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              // Settings
                            },
                            icon: const Icon(Icons.settings),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),
                    const Text(
                      'Recent Posts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ]),
          ),
          if (userPosts.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return PostCard(post: userPosts[index]);
                },
                childCount: userPosts.length,
              ),
            )
          else
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.photo_library_outlined,
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
                    const SizedBox(height: 8),
                    Text(
                      isCurrentUser
                          ? 'Share your first workout!'
                          : '${user.displayName} hasn\'t posted yet',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
