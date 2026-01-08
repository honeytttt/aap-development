import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/auth/providers/auth_provider.dart';
import 'package:workout_app/features/profile/providers/profile_provider.dart';
import 'package:workout_app/features/profile/widgets/profile_header.dart';
import 'package:workout_app/features/profile/widgets/profile_stats.dart';
import 'package:workout_app/features/profile/widgets/profile_interests.dart';

class ProfileScreen extends StatelessWidget {
  final String? userId; // null for current user, userId for other users

  const ProfileScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    
    final isCurrentUser = userId == null || userId == 'current-user';
    final userProfile = isCurrentUser 
        ? profileProvider.currentUserProfile
        : profileProvider.getUserProfile(userId!);

    if (profileProvider.isLoading || userProfile == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          userProfile.displayName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
        centerTitle: true,
        actions: [
          if (isCurrentUser)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF4CAF50),
        onRefresh: () async {
          profileProvider.refreshProfile();
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeader(
                userProfile: userProfile,
                isCurrentUser: isCurrentUser,
                onFollowToggle: () {
                  if (!isCurrentUser) {
                    profileProvider.toggleFollowUser(userId!);
                  }
                },
              ),
              const SizedBox(height: 24),
              
              // Bio section
              if (userProfile.bio != null && userProfile.bio!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(240, 240, 240, 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      userProfile.bio!,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Stats
              ProfileStats(userProfile: userProfile),
              const SizedBox(height: 24),
              
              // Interests
              if (userProfile.interests.isNotEmpty)
                ProfileInterests(interests: userProfile.interests),
              const SizedBox(height: 24),
              
              // Joined date
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Joined ${_formatDate(userProfile.joinedDate)}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

// Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final settings = profileProvider.userSettings;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Section
          const Text(
            'ACCOUNT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          _buildSettingsItem(
            icon: Icons.person,
            title: 'Edit Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
          _buildSettingsItem(
            icon: Icons.photo_camera,
            title: 'Change Avatar',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeAvatarScreen(),
                ),
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // Notifications Section
          const Text(
            'NOTIFICATIONS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Email Notifications'),
            value: settings.emailNotifications,
            onChanged: (value) {
              profileProvider.updateSettings(
                settings.copyWith(emailNotifications: value),
              );
            },
            activeThumbColor: const Color(0xFF4CAF50),
            activeTrackColor: const Color(0xFFC8E6C9),
          ),
          SwitchListTile(
            title: const Text('Push Notifications'),
            value: settings.pushNotifications,
            onChanged: (value) {
              profileProvider.updateSettings(
                settings.copyWith(pushNotifications: value),
              );
            },
            activeThumbColor: const Color(0xFF4CAF50),
            activeTrackColor: const Color(0xFFC8E6C9),
          ),
          
          const SizedBox(height: 24),
          
          // Privacy Section
          const Text(
            'PRIVACY',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Private Profile'),
            subtitle: const Text('Only followers can see your posts'),
            value: settings.privateProfile,
            onChanged: (value) {
              profileProvider.updateSettings(
                settings.copyWith(privateProfile: value),
              );
            },
            activeThumbColor: const Color(0xFF4CAF50),
            activeTrackColor: const Color(0xFFC8E6C9),
          ),
          SwitchListTile(
            title: const Text('Show Online Status'),
            value: settings.showOnlineStatus,
            onChanged: (value) {
              profileProvider.updateSettings(
                settings.copyWith(showOnlineStatus: value),
              );
            },
            activeThumbColor: const Color(0xFF4CAF50),
            activeTrackColor: const Color(0xFFC8E6C9),
          ),
          
          const SizedBox(height: 24),
          
          // Appearance Section
          const Text(
            'APPEARANCE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Theme'),
            subtitle: Text(settings.themeMode.replaceFirst(
              settings.themeMode[0], 
              settings.themeMode[0].toUpperCase()
            )),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Theme picker would go here
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: const Text('English'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Language picker would go here
            },
          ),
          
          const SizedBox(height: 32),
          
          // Logout button
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4CAF50)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// Edit Profile Screen
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profileProvider = context.read<ProfileProvider>();
    final profile = profileProvider.currentUserProfile;
    if (profile != null) {
      _nameController.text = profile.displayName;
      _bioController.text = profile.bio ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                profileProvider.updateProfile(
                  displayName: _nameController.text.trim(),
                  bio: _bioController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a display name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value != null && value.length > 200) {
                    return 'Bio must be less than 200 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${_bioController.text.length}/200',
                  style: TextStyle(
                    color: _bioController.text.length > 200 
                        ? Colors.red 
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Change Avatar Screen
class ChangeAvatarScreen extends StatefulWidget {
  const ChangeAvatarScreen({super.key});

  @override
  State<ChangeAvatarScreen> createState() => _ChangeAvatarScreenState();
}

class _ChangeAvatarScreenState extends State<ChangeAvatarScreen> {
  bool _isUploading = false;

  void _simulateUpload() async {
    setState(() {
      _isUploading = true;
    });

    final profileProvider = context.read<ProfileProvider>();
    await profileProvider.uploadAvatar('mock_image_path');

    setState(() {
      _isUploading = false;
    });
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profile = profileProvider.currentUserProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Avatar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Current avatar
            CircleAvatar(
              radius: 60,
              backgroundImage: profile?.avatarUrl != null
                  ? NetworkImage(profile!.avatarUrl!)
                  : null,
              child: profile?.avatarUrl == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
            const SizedBox(height: 20),
            
            // Upload button (simulated)
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _simulateUpload,
              icon: _isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Icon(Icons.upload),
              label: Text(_isUploading ? 'Uploading...' : 'Upload New Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            
            // Demo message
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Note: This is a demo. In a real app, this would open the device gallery/camera.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
