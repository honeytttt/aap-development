import 'package:flutter/foundation.dart';
import 'package:workout_app/core/models/post.dart';
import 'package:workout_app/core/models/media.dart';

class CreatePostProvider with ChangeNotifier {
  // Draft post
  Post _draftPost = Post(
    id: 'draft_${DateTime.now().millisecondsSinceEpoch}',
    userId: 'current_user',
    userName: 'Current User',
    userAvatar: 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=U',
    content: '',
    media: [],
    hashtags: [],
    likes: [],
    comments: [],
    createdAt: DateTime.now(),
    isDraft: true,
  );

  // Get draft post
  Post get draftPost => _draftPost;

  // Update caption
  void updateCaption(String caption) {
    _draftPost = _draftPost.copyWith(content: caption);
    notifyListeners();
  }

  // Add media
  void addMedia(Media media) {
    _draftPost = _draftPost.copyWith(
      media: [..._draftPost.media, media],
    );
    notifyListeners();
  }

  // Remove media
  void removeMedia(String mediaId) {
    _draftPost = _draftPost.copyWith(
      media: _draftPost.media.where((m) => m.id != mediaId).toList(),
    );
    notifyListeners();
  }

  // Add hashtag
  void addHashtag(String hashtag) {
    final formattedHashtag = hashtag.startsWith('#') ? hashtag : '#$hashtag';
    if (!_draftPost.hashtags.contains(formattedHashtag)) {
      _draftPost = _draftPost.copyWith(
        hashtags: [..._draftPost.hashtags, formattedHashtag],
      );
      notifyListeners();
    }
  }

  // Remove hashtag
  void removeHashtag(String hashtag) {
    _draftPost = _draftPost.copyWith(
      hashtags: _draftPost.hashtags.where((h) => h != hashtag).toList(),
    );
    notifyListeners();
  }

  // Extract hashtags from caption
  void extractHashtagsFromCaption() {
    final regex = RegExp(r'#\w+');
    final matches = regex.allMatches(_draftPost.content);
    final hashtags = matches.map((m) => m.group(0)!).toSet().toList();
    
    _draftPost = _draftPost.copyWith(hashtags: hashtags);
    notifyListeners();
  }

  // Save draft
  void saveDraft() {
    _draftPost = _draftPost.copyWith(
      updatedAt: DateTime.now(),
      isDraft: true,
    );
    print('💾 Draft saved: ${_draftPost.id}');
    notifyListeners();
  }

  // Clear draft
  void clearDraft() {
    _draftPost = Post(
      id: 'draft_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'current_user',
      userName: 'Current User',
      userAvatar: 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=U',
      content: '',
      media: [],
      hashtags: [],
      likes: [],
      comments: [],
      createdAt: DateTime.now(),
      isDraft: true,
    );
    notifyListeners();
  }

  // Mock media for testing
  List<Media> get mockMediaList => [
    Media(
      id: 'media_1',
      type: MediaType.image,
      url: 'https://images.unsplash.com/photo-1536922246289-88c42f957773?w=800',
      thumbnailUrl: 'https://images.unsplash.com/photo-1536922246289-88c42f957773?w=400',
      caption: 'Workout session',
      uploadDate: DateTime.now(),
      width: 800,
      height: 600,
    ),
    Media(
      id: 'media_2',
      type: MediaType.image,
      url: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800',
      thumbnailUrl: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400',
      caption: 'Healthy meal prep',
      uploadDate: DateTime.now(),
      width: 800,
      height: 600,
    ),
    Media(
      id: 'media_3',
      type: MediaType.video,
      url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      caption: 'Workout tutorial',
      uploadDate: DateTime.now(),
      width: 800,
      height: 600,
      duration: 60,
    ),
    Media(
      id: 'media_4',
      type: MediaType.image,
      url: 'https://images.unsplash.com/photo-1594381898411-846e7d193883?w=800',
      thumbnailUrl: 'https://images.unsplash.com/photo-1594381898411-846e7d193883?w=400',
      caption: 'Gym equipment',
      uploadDate: DateTime.now(),
      width: 800,
      height: 600,
    ),
  ];
}
