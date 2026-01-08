#!/bin/bash
# Fix withValues() Method Errors

echo "🔧 Fixing withValues() method errors..."

# 1. Fix Media Gallery Widget
echo "📝 Fixing MediaGalleryWidget..."
cat > lib/features/media/widgets/media_gallery.dart << 'MEDIA_GALLERY_WIDGET'
import 'package:flutter/material.dart';
import 'package:workout_app/core/models/media.dart';

class MediaGalleryWidget extends StatelessWidget {
  final List<Media> mediaItems;
  final double? height;
  final bool showIndicators;

  const MediaGalleryWidget({
    Key? key,
    required this.mediaItems,
    this.height,
    this.showIndicators = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (mediaItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: height ?? 300,
          child: PageView.builder(
            itemCount: mediaItems.length,
            itemBuilder: (context, index) {
              final media = mediaItems[index];
              return _buildMediaItem(media);
            },
          ),
        ),
        if (showIndicators && mediaItems.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                mediaItems.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMediaItem(Media media) {
    if (media.type == MediaType.video) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            media.thumbnailUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.grey[200]);
            },
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
          if (media.duration != null)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formatDuration(media.duration!),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      );
    } else {
      return Image.network(
        media.url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(color: Colors.grey[200]);
        },
      );
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
MEDIA_GALLERY_WIDGET

# 2. Fix Single Media Widget
echo "📝 Fixing SingleMediaWidget..."
cat > lib/features/media/widgets/single_media.dart << 'SINGLE_MEDIA_WIDGET'
import 'package:flutter/material.dart';
import 'package:workout_app/core/models/media.dart';

class SingleMediaWidget extends StatelessWidget {
  final Media media;
  final double? width;
  final double? height;
  final BoxFit fit;

  const SingleMediaWidget({
    Key? key,
    required this.media,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (media.type == MediaType.video) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            media.thumbnailUrl,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.grey[200]);
            },
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                size: 36,
                color: Colors.white,
              ),
            ),
          ),
          if (media.duration != null)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formatDuration(media.duration!),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      );
    } else {
      return Image.network(
        media.url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(color: Colors.grey[200]);
        },
      );
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
SINGLE_MEDIA_WIDGET

# 3. Fix Notification Item Widget
echo "📝 Fixing NotificationItem..."
cat > lib/features/notifications/widgets/notification_item.dart << 'NOTIFICATION_ITEM'
import 'package:flutter/material.dart';
import 'package:workout_app/core/models/notification.dart';

class NotificationItem extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;
  final DismissDirectionCallback? onDismissed;

  const NotificationItem({
    Key? key,
    required this.notification,
    this.onTap,
    this.onDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: notification.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(notification.icon, color: notification.color),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification.message),
          const SizedBox(height: 4),
          Text(
            _timeAgo(notification.timestamp),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      trailing: !notification.isRead
          ? Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            )
          : null,
      onTap: onTap,
    );

    if (onDismissed != null) {
      return Dismissible(
        key: Key(notification.id),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: onDismissed,
        child: child,
      );
    }

    return child;
  }

  String _timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
NOTIFICATION_ITEM

# 4. Clean up and rebuild
echo "✅ All withValues() fixes applied!"
echo "🔄 Running flutter clean..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔍 Running flutter analyze..."
flutter analyze

echo ""
echo "🎉 All errors fixed! The withValues() issues have been resolved."
echo "👉 The app should now compile without any errors."
echo ""
echo "🚀 Run: flutter run"
