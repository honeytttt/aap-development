import 'package:flutter/material.dart';
import 'package:workout_app/core/models/media.dart';

class CreatePostProvider with ChangeNotifier {
  List<Media> _selectedMedia = [];
  List<String> _hashtags = [];
  bool _isPosting = false;

  List<Media> get selectedMedia => _selectedMedia;
  List<String> get hashtags => _hashtags;
  bool get isPosting => _isPosting;

  void addMedia(Media media) {
    _selectedMedia.add(media);
    notifyListeners();
  }

  void removeMedia(Media media) {
    _selectedMedia.remove(media);
    notifyListeners();
  }

  void clearMedia() {
    _selectedMedia.clear();
    notifyListeners();
  }

  void addHashtag(String hashtag) {
    if (!_hashtags.contains(hashtag)) {
      _hashtags.add(hashtag);
      notifyListeners();
    }
  }

  void removeHashtag(String hashtag) {
    _hashtags.remove(hashtag);
    notifyListeners();
  }

  void clearHashtags() {
    _hashtags.clear();
    notifyListeners();
  }

  Future<void> createPost({
    required String caption,
    required List<String> hashtags,
  }) async {
    _isPosting = true;
    notifyListeners();

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Create a mock post
      final mockPost = {
        'id': 'post_${DateTime.now().millisecondsSinceEpoch}',
        'caption': caption,
        'hashtags': hashtags,
        'media': _selectedMedia,
        'createdAt': DateTime.now(),
      };

      print('Post created: $mockPost');
      
      // Clear the form
      _selectedMedia.clear();
      _hashtags.clear();
      _isPosting = false;
      notifyListeners();
    } catch (e) {
      _isPosting = false;
      notifyListeners();
      rethrow;
    }
  }
}
