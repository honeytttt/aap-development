import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feed_provider.dart';
import '../models/post.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _captionController = TextEditingController();
  final _hashtagController = TextEditingController();
  List<String> _hashtags = [];
  List<String> _mediaUrls = [];
  bool _isPosting = false;
  
  final _workoutTypes = [
    'Running',
    'Weightlifting',
    'Yoga',
    'Cycling',
    'Swimming',
    'HIIT',
    'CrossFit',
    'Pilates',
    'Boxing',
    'Dance'
  ];
  String? _selectedWorkoutType;

  @override
  void dispose() {
    _captionController.dispose();
    _hashtagController.dispose();
    super.dispose();
  }

  void _addHashtag() {
    final tag = _hashtagController.text.trim();
    if (tag.isNotEmpty && !_hashtags.contains(tag)) {
      setState(() {
        _hashtags.add(tag.startsWith('#') ? tag : '#$tag');
        _hashtagController.clear();
      });
    }
  }

  void _removeHashtag(String tag) {
    setState(() {
      _hashtags.remove(tag);
    });
  }

  void _addMockImage() {
    const mockImages = [
      'https://images.pexels.com/photos/2294361/pexels-photo-2294361.jpeg',
      'https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg',
      'https://images.pexels.com/photos/8436665/pexels-photo-8436665.jpeg',
    ];
    setState(() {
      _mediaUrls.add(mockImages[_mediaUrls.length % mockImages.length]);
    });
  }

  Future<void> _submitPost(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isPosting = true;
    });

    debugPrint('🎨 Creating post from CreatePostScreen:');
    debugPrint('  Caption: ${_captionController.text}');
    debugPrint('  Hashtags: $_hashtags');

    // Create the post
    final newPost = Post(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_fitness_john',
      username: 'fitness_john',
      avatarUrl: 'https://ui-avatars.com/api/?name=fitness+john&background=4CAF50&color=fff',
      content: _captionController.text,
      timestamp: DateTime.now(),
      likes: 0,
      isLiked: false,
      commentsCount: 0,
      imageUrl: _mediaUrls.isNotEmpty ? _mediaUrls.first : null,
      hashtags: _hashtags,
    );

    // Add to feed provider
    try {
      await Provider.of<FeedProvider>(context, listen: false).addPost(newPost);
      debugPrint('✅ Post added successfully!');
      
      // Navigate back
      Navigator.of(context).pop();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post created successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('❌ Error adding post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
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
            onPressed: _isPosting ? null : () => _submitPost(context),
            child: _isPosting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'POST',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: const NetworkImage(
                    'https://ui-avatars.com/api/?name=fitness+john&background=4CAF50&color=fff',
                  ),
                ),
                title: const Text('fitness_john'),
                subtitle: const Text('Posting to feed'),
              ),
              const Divider(),
              
              // Caption field
              TextFormField(
                controller: _captionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "What's your workout achievement today?",
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a caption';
                  }
                  return null;
                },
              ),
              
              // Media section
              if (_mediaUrls.isNotEmpty) ...[
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _mediaUrls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Image.network(
                          _mediaUrls[index],
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ],
              
              // Add media button
              TextButton.icon(
                onPressed: _addMockImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('Add Photo'),
              ),
              
              // Hashtags
              const SizedBox(height: 16),
              const Text('Add Hashtags', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _hashtagController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., fitness, workout',
                      ),
                      onFieldSubmitted: (_) => _addHashtag(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addHashtag,
                  ),
                ],
              ),
              
              // Hashtag chips
              if (_hashtags.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  children: _hashtags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => _removeHashtag(tag),
                    );
                  }).toList(),
                ),
              ],
              
              // Workout type
              const SizedBox(height: 16),
              const Text('Workout Type', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: _selectedWorkoutType,
                hint: const Text('Select workout type'),
                items: _workoutTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedWorkoutType = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
