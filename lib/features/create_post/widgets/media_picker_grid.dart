import 'package:flutter/material.dart';
import 'package:workout_app/core/models/media.dart';

class MediaPickerGrid extends StatelessWidget {
  final Function(Media) onMediaSelected;

  const MediaPickerGrid({
    Key? key,
    required this.onMediaSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 6, // Mock media items
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            final media = Media(
              id: 'mock_$index',
              type: MediaType.image,
              url: 'https://picsum.photos/300/300?random=$index',
              thumbnailUrl: 'https://picsum.photos/150/150?random=$index',
              width: 300,
              height: 300,
              uploadDate: DateTime.now(),
            );
            onMediaSelected(media);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: const Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
          ),
        );
      },
    );
  }
}
