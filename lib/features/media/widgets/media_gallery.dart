import 'package:flutter/material.dart';
import 'package:workout_app/core/models/media.dart';
import 'package:workout_app/core/models/media_gallery.dart' 
    show MediaGallery; // IMPORT FROM MODELS

class MediaGalleryWidget extends StatefulWidget {
  final List<Media> media;
  final int initialIndex;
  final bool showControls;
  final bool autoPlayVideos;
  final Function(int)? onPageChanged;

  const MediaGalleryWidget({
    super.key,
    required this.media,
    this.initialIndex = 0,
    this.showControls = true,
    this.autoPlayVideos = false,
    this.onPageChanged,
  });

  @override
  State<MediaGalleryWidget> createState() => _MediaGalleryWidgetState();
}

class _MediaGalleryWidgetState extends State<MediaGalleryWidget> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.media.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(200, 200, 200, 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(
            Icons.photo_library,
            size: 50,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Media content
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.media.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              widget.onPageChanged?.call(index);
            },
            itemBuilder: (context, index) {
              final media = widget.media[index];
              return _buildMediaItem(media);
            },
          ),
        ),

        // Indicators
        if (widget.showControls && widget.media.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.media.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? const Color(0xFF4CAF50)
                        : const Color.fromRGBO(255, 255, 255, 0.5),
                  ),
                ),
              ),
            ),
          ),

        // Media count badge
        if (widget.media.length > 1)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentIndex + 1}/${widget.media.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // Media type indicators
        Positioned(
          top: 12,
          left: 12,
          child: Wrap(
            spacing: 4,
            children: [
              if (widget.media[_currentIndex].isVideo)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 0, 0, 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow, size: 12, color: Colors.white),
                      SizedBox(width: 2),
                      Text(
                        'VIDEO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMediaItem(Media media) {
    return GestureDetector(
      onTap: () {
        // Open full-screen viewer
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaViewerScreen(
              mediaGallery: MediaGallery(
                media: widget.media,
                currentIndex: _currentIndex,
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(200, 200, 200, 1),
          borderRadius: BorderRadius.circular(8),
          image: media.isImage
              ? DecorationImage(
                  image: NetworkImage(media.url),
                  fit: BoxFit.cover,
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
                    color: const Color.fromRGBO(0, 0, 0, 0.3),
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_filled,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}

// Full-screen media viewer
class MediaViewerScreen extends StatefulWidget {
  final MediaGallery mediaGallery;

  const MediaViewerScreen({super.key, required this.mediaGallery});

  @override
  State<MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<MediaViewerScreen> {
  late MediaGallery _gallery;

  @override
  void initState() {
    super.initState();
    _gallery = widget.mediaGallery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0 && _gallery.hasNext) {
            setState(() {
              _gallery = _gallery.next();
            });
          } else if (details.primaryVelocity! > 0 && _gallery.hasPrevious) {
            setState(() {
              _gallery = _gallery.previous();
            });
          }
        },
        child: Center(
          child: _gallery.media[_gallery.currentIndex].isImage
              ? Image.network(
                  _gallery.currentMedia.url,
                  fit: BoxFit.contain,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.play_circle_filled,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Video: ${_gallery.currentMedia.caption ?? "No caption"}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: _gallery.media.length > 1
          ? Container(
              padding: const EdgeInsets.all(16),
              color: const Color.fromRGBO(0, 0, 0, 0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: _gallery.hasPrevious
                        ? () {
                            setState(() {
                              _gallery = _gallery.previous();
                            });
                          }
                        : null,
                  ),
                  Text(
                    '${_gallery.currentIndex + 1}/${_gallery.media.length}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: _gallery.hasNext
                        ? () {
                            setState(() {
                              _gallery = _gallery.next();
                            });
                          }
                        : null,
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
