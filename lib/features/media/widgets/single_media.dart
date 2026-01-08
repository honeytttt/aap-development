import 'package:flutter/material.dart';
import 'package:workout_app/core/models/media.dart';
import 'package:workout_app/core/models/media_gallery.dart'; // IMPORT FROM MODELS
import 'package:workout_app/features/media/widgets/media_gallery.dart' 
    show MediaViewerScreen; // IMPORT WIDGET

class SingleMediaWidget extends StatelessWidget {
  final Media media;
  final double? height;
  final BoxFit fit;
  final bool showCaption;
  final VoidCallback? onTap;

  const SingleMediaWidget({
    super.key,
    required this.media,
    this.height,
    this.fit = BoxFit.cover,
    this.showCaption = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: onTap ?? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MediaViewerScreen(
                  mediaGallery: MediaGallery(
                    media: [media],
                    currentIndex: 0,
                  ),
                ),
              ),
            );
          },
          child: Container(
            height: height ?? 250,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(200, 200, 200, 1),
              borderRadius: BorderRadius.circular(8),
              image: media.isImage
                  ? DecorationImage(
                      image: NetworkImage(media.url),
                      fit: fit,
                    )
                  : null,
            ),
            child: media.isVideo
                ? Stack(
                    children: [
                      // Video thumbnail
                      if (media.thumbnailUrl != null)
                        Image.network(
                          media.thumbnailUrl!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      // Video overlay
                      Container(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(0, 0, 0, 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : null,
          ),
        ),
        
        if (showCaption && media.caption != null && media.caption!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              media.caption!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          
        // Media info
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                media.isImage ? 'Image' : 'Video',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(96, 96, 96, 1),
                ),
              ),
              Text(
                '${media.width}×${media.height} • ${media.fileSizeFormatted}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(96, 96, 96, 1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
