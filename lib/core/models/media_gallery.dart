import 'package:workout_app/core/models/media.dart';

class MediaGallery {
  final List<Media> mediaList;
  final DateTime? uploadDate;

  MediaGallery({
    required this.mediaList,
    this.uploadDate,
  });

  // Factory method to create from JSON
  factory MediaGallery.fromJson(Map<String, dynamic> json) {
    return MediaGallery(
      mediaList: (json['mediaList'] as List<dynamic>?)
              ?.map((m) => Media.fromJson(m))
              .toList() ??
          [],
      uploadDate: json['uploadDate'] != null
          ? DateTime.parse(json['uploadDate'])
          : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'mediaList': mediaList.map((m) => m.toJson()).toList(),
      'uploadDate': uploadDate?.toIso8601String(),
    };
  }
}

class UploadStatus {
  final String mediaId;
  final double progress;
  final bool isUploading;
  final String? error;

  UploadStatus({
    required this.mediaId,
    required this.progress,
    required this.isUploading,
    this.error,
  });
}
