import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/create_post/providers/create_post_provider.dart';
import 'package:workout_app/features/create_post/widgets/caption_field.dart';
import 'package:workout_app/features/create_post/widgets/hashtag_chips.dart';
import 'package:workout_app/features/create_post/widgets/media_picker_grid.dart';
import 'package:workout_app/features/feed/providers/feed_provider.dart';
import 'package:workout_app/features/media/widgets/media_gallery.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPosting = false;

  Future<void> _handlePost(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isPosting = true);
      
      final createProvider = Provider.of<CreatePostProvider>(context, listen: false);
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);
      
      // Create final post from draft
      final draft = createProvider.draftPost;
      final newPost = draft.copyWith(
        id: 'post_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
        isDraft: false,
      );
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Add to feed
      feedProvider.addPost(newPost);
      
      // Clear draft
      createProvider.clearDraft();
      
      setState(() => _isPosting = false);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post published successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Navigate back
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _saveDraft(BuildContext context) async {
    final provider = Provider.of<CreatePostProvider>(context, listen: false);
    provider.saveDraft();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft saved successfully'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<bool> _confirmDiscard() async {
    final provider = Provider.of<CreatePostProvider>(context, listen: false);
    final draft = provider.draftPost;
    
    if (draft.content.isNotEmpty || draft.media.isNotEmpty || draft.hashtags.isNotEmpty) {
      return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.green[700]),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Discard',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ) ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreatePostProvider>(context);
    final draft = provider.draftPost;
    
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          if (await _confirmDiscard()) {
            provider.clearDraft();
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Post'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await _confirmDiscard()) {
                provider.clearDraft();
                if (mounted) Navigator.pop(context);
              }
            },
          ),
          actions: [
            TextButton.icon(
              onPressed: () => _saveDraft(context),
              icon: const Icon(Icons.save),
              label: const Text('Save Draft'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue[700],
              ),
            ),
            const SizedBox(width: 8),
          ],
          backgroundColor: Colors.green[50],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Preview Section
                if (draft.media.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preview',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: MediaGalleryWidget(
                          media: draft.media,
                          initialIndex: 0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.green[200]),
                      const SizedBox(height: 16),
                    ],
                  ),
                
                // Caption Section
                const CaptionField(),
                const SizedBox(height: 24),
                
                // Media Picker Section
                const MediaPickerGrid(),
                const SizedBox(height: 24),
                
                // Hashtags Section
                const HashtagChips(),
                const SizedBox(height: 32),
                
                // Post Button
                ElevatedButton(
                  onPressed: _isPosting ? null : () => _handlePost(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isPosting
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send),
                            SizedBox(width: 8),
                            Text(
                              'Publish Post',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
                
                const SizedBox(height: 16),
                
                // Draft Info
                if (draft.isDraft && (draft.content.isNotEmpty || draft.media.isNotEmpty || draft.hashtags.isNotEmpty))
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'This is a draft',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                              Text(
                                'Save or publish to keep your changes',
                                style: TextStyle(color: Colors.blue[700]),
                              ),
                            ],
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
      ),
    );
  }
}
