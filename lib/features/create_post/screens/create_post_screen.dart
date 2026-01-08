import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/core/models/media.dart';
import 'package:workout_app/core/models/user.dart';
import 'package:workout_app/features/auth/providers/auth_provider.dart';
import 'package:workout_app/features/feed/providers/feed_provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _hashtagController = TextEditingController();
  final List<String> _hashtags = [];
  final List<MediaItem> _mediaItems = [];
  String? _workoutType;
  int? _duration;
  int? _calories;
  bool _isLoading = false;

  final List<String> workoutTypes = [
    'Strength Training',
    'Cardio',
    'Yoga',
    'HIIT',
    'CrossFit',
    'Running',
    'Cycling',
    'Swimming',
    'Pilates',
    'Other',
  ];

  @override
  void dispose() {
    _captionController.dispose();
    _hashtagController.dispose();
    super.dispose();
  }

  void _pickImage() {
    // For web, use mock images
    setState(() {
      _mediaItems.add(
        MediaItem(
          type: MediaType.image,
          url: 'https://images.pexels.com/photos/1229356/pexels-photo-1229356.jpeg?auto=compress&cs=tinysrgb&w=800',
          thumbnailUrl: 'https://images.pexels.com/photos/1229356/pexels-photo-1229356.jpeg?auto=compress&cs=tinysrgb&w=800',
        ),
      );
    });
    
    // Show a snackbar to inform user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mock image added for web demo.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addHashtag() {
    final hashtag = _hashtagController.text.trim();
    if (hashtag.isNotEmpty && !hashtag.startsWith('#')) {
      _hashtags.add('#$hashtag');
      _hashtagController.clear();
      setState(() {});
    } else if (hashtag.isNotEmpty) {
      _hashtags.add(hashtag);
      _hashtagController.clear();
      setState(() {});
    }
  }

  void _removeHashtag(int index) {
    _hashtags.removeAt(index);
    setState(() {});
  }

  void _removeMedia(int index) {
    _mediaItems.removeAt(index);
    setState(() {});
  }

  Future<void> _submitPost(BuildContext context) async {
    final caption = _captionController.text.trim();
    if (caption.isEmpty && _mediaItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a caption or media'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);

      // Get current user or use mock user
      final currentUser = authProvider.currentUser ?? User(
        id: 'current_user_${DateTime.now().millisecondsSinceEpoch}',
        username: 'current_user',
        displayName: 'Current User',
        avatarUrl: 'https://i.pravatar.cc/150?img=32',
        bio: 'Active fitness enthusiast',
        followersCount: 100,
        followingCount: 50,
        postsCount: 1,
        joinedDate: DateTime.now(),
      );

      print("Creating post with:");
      print("  User: ${currentUser.username}");
      print("  Caption: $caption");
      print("  Hashtags: $_hashtags");
      print("  Media count: ${_mediaItems.length}");

      // Create the post
      feedProvider.addPostFromCreate(
        caption: caption,
        hashtags: _hashtags,
        media: _mediaItems,
        user: currentUser,
        workoutType: _workoutType,
        duration: _duration,
        calories: _calories,
      );

      print("Post added to FeedProvider successfully!");

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Post created successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Clear form
      _captionController.clear();
      _hashtags.clear();
      _mediaItems.clear();
      _workoutType = null;
      _duration = null;
      _calories = null;
      
      // Navigate back
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e, stackTrace) {
      print("Error creating post: $e");
      print("Stack trace: $stackTrace");
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error creating post: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => _submitPost(context),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'POST',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Caption
            TextField(
              controller: _captionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "What's on your mind? Share your workout...",
                border: OutlineInputBorder(),
                labelText: 'Caption',
              ),
            ),
            const SizedBox(height: 20),
            
            // Media preview
            if (_mediaItems.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Media',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _mediaItems.length,
                      itemBuilder: (context, index) {
                        final media = _mediaItems[index];
                        return Stack(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(media.url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 12,
                              child: GestureDetector(
                                onTap: () => _removeMedia(index),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            
            // Add media button
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Add Mock Image'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.green[100],
                foregroundColor: Colors.green[800],
              ),
            ),
            const SizedBox(height: 20),
            
            // Hashtags
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hashtags',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _hashtagController,
                        decoration: const InputDecoration(
                          hintText: 'Add a hashtag...',
                          border: OutlineInputBorder(),
                          prefixText: '#',
                        ),
                        onSubmitted: (_) => _addHashtag(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addHashtag,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _hashtags.asMap().entries.map((entry) {
                    final index = entry.key;
                    final hashtag = entry.value;
                    return Chip(
                      label: Text(hashtag),
                      backgroundColor: Colors.green[50],
                      deleteIconColor: Colors.green,
                      onDeleted: () => _removeHashtag(index),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Workout details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Workout Details (Optional)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _workoutType,
                  decoration: const InputDecoration(
                    labelText: 'Workout Type',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: workoutTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _workoutType = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Duration (minutes)',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    _duration = int.tryParse(value);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Calories Burned',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    _calories = int.tryParse(value);
                  },
                ),
              ],
            ),
            
            // Debug info
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Debug Info:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Hashtags: ${_hashtags.length}'),
                  Text('Media: ${_mediaItems.length}'),
                  Text('Workout Type: $_workoutType'),
                  Text('Caption length: ${_captionController.text.length}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
