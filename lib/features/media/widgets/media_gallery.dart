import 'package:flutter/material.dart';
import 'package:workout_app/core/models/media.dart' as media_model;

class MediaGallery extends StatefulWidget {
  final List<media_model.MediaItem> mediaItems;
  final int initialIndex;

  const MediaGallery({
    super.key,
    required this.mediaItems,
    this.initialIndex = 0,
  });

  @override
  State<MediaGallery> createState() => _MediaGalleryState();
}

class _MediaGalleryState extends State<MediaGallery> {
  late PageController _pageController;
  int _currentIndex = 0;

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${_currentIndex + 1}/${widget.mediaItems.length}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.mediaItems.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final mediaItem = widget.mediaItems[index];
                return _buildMediaItem(mediaItem);
              },
            ),
          ),
          if (widget.mediaItems.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.mediaItems.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaItem(media_model.MediaItem media) {
    if (media.type == media_model.MediaType.video) {
      return Stack(
        children: [
          Center(
            child: Image.network(
              media.thumbnailUrl ?? media.url,
              fit: BoxFit.contain,
            ),
          ),
          Center(
            child: IconButton(
              icon: const Icon(
                Icons.play_circle_filled,
                size: 64,
                color: Colors.white,
              ),
              onPressed: () {
                // Play video
              },
            ),
          ),
        ],
      );
    } else {
      return InteractiveViewer(
        panEnabled: true,
        minScale: 1,
        maxScale: 4,
        child: Center(
          child: Image.network(
            media.url,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
  }
}
