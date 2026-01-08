import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/core/models/media.dart';
import 'package:workout_app/features/create_post/providers/create_post_provider.dart';
import 'package:workout_app/features/media/widgets/single_media.dart';

class MediaPickerGrid extends StatelessWidget {
  const MediaPickerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreatePostProvider>(context);
    final mockMedia = provider.mockMediaList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Select Media',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 1,
          ),
          itemCount: mockMedia.length,
          itemBuilder: (context, index) {
            final media = mockMedia[index];
            final isSelected = provider.draftPost.media.any((m) => m.id == media.id);
            
            return GestureDetector(
              onTap: () {
                if (isSelected) {
                  provider.removeMedia(media.id);
                } else {
                  provider.addMedia(media);
                }
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SingleMediaWidget(media: media),
                  if (isSelected)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  if (media.type == MediaType.video)
                    const Positioned(
                      top: 4,
                      right: 4,
                      child: Icon(
                        Icons.videocam,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        if (provider.draftPost.media.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Selected: ${provider.draftPost.media.length} media items',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
