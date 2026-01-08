enum MediaType {
  image,
  video,
}

class MediaItem {
  final MediaType type;
  final String url;
  final String? thumbnailUrl;

  MediaItem({
    required this.type,
    required this.url,
    this.thumbnailUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'url': url,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      type: MediaType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => MediaType.image,
      ),
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}
