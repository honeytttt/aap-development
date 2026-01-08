enum MediaType { image, video }

class Media {
  final String id;
  final MediaType type;
  final String url;
  final String thumbnailUrl;
  final String? caption;
  final DateTime uploadDate;
  final int? width;
  final int? height;
  final int? duration; // For videos only

  Media({
    required this.id,
    required this.type,
    required this.url,
    required this.thumbnailUrl,
    this.caption,
    required this.uploadDate,
    this.width,
    this.height,
    this.duration,
  });

  // Factory method to create from JSON
  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] ?? '',
      type: MediaType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => MediaType.image,
      ),
      url: json['url'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? json['url'] ?? '',
      caption: json['caption'],
      uploadDate: json['uploadDate'] != null
          ? DateTime.parse(json['uploadDate'])
          : DateTime.now(),
      width: json['width'],
      height: json['height'],
      duration: json['duration'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'caption': caption,
      'uploadDate': uploadDate.toIso8601String(),
      'width': width,
      'height': height,
      'duration': duration,
    };
  }

  // Check if media is a video
  bool get isVideo => type == MediaType.video;

  // Check if media is an image
  bool get isImage => type == MediaType.image;
}
