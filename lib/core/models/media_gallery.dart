import 'package:workout_app/core/models/media.dart';

class MediaGallery {
  final List<Media> mediaItems;

  MediaGallery({required this.mediaItems});

  // JSON serialization
  factory MediaGallery.fromJson(Map<String, dynamic> json) {
    final mediaItems = (json['mediaItems'] as List)
        .map((item) => Media.fromJson(item))
        .toList();
    return MediaGallery(mediaItems: mediaItems);
  }

  Map<String, dynamic> toJson() {
    return {
      'mediaItems': mediaItems.map((item) => item.toJson()).toList(),
    };
  }

  MediaGallery copyWith({
    List<Media>? mediaItems,
  }) {
    return MediaGallery(
      mediaItems: mediaItems ?? this.mediaItems,
    );
  }
}
