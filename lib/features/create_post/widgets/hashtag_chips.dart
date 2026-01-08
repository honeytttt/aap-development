import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/create_post/providers/create_post_provider.dart';

class HashtagChips extends StatefulWidget {
  const HashtagChips({super.key});

  @override
  State<HashtagChips> createState() => _HashtagChipsState();
}

class _HashtagChipsState extends State<HashtagChips> {
  final TextEditingController _hashtagController = TextEditingController();

  void _addHashtag() {
    final text = _hashtagController.text.trim();
    if (text.isNotEmpty) {
      final provider = Provider.of<CreatePostProvider>(context, listen: false);
      provider.addHashtag(text);
      _hashtagController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreatePostProvider>(context);
    final hashtags = provider.draftPost.hashtags;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Hashtags',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(width: 8),
            Chip(
              label: Text('${hashtags.length}'),
              backgroundColor: Colors.green[100],
              labelStyle: TextStyle(color: Colors.green[800]),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Hashtag Input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _hashtagController,
                decoration: InputDecoration(
                  hintText: 'Add a hashtag...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green[500]!, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.green[50],
                  prefixIcon: const Icon(Icons.tag, color: Colors.green),
                ),
                onSubmitted: (_) => _addHashtag(),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton.small(
              onPressed: _addHashtag,
              backgroundColor: Colors.green[500],
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Hashtag Chips Display
        if (hashtags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: hashtags.map((hashtag) {
              return InputChip(
                label: Text(hashtag),
                backgroundColor: Colors.green[50],
                labelStyle: TextStyle(color: Colors.green[800]),
                deleteIconColor: Colors.green[700],
                onDeleted: () => provider.removeHashtag(hashtag),
                onPressed: () {},
              );
            }).toList(),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No hashtags added yet. Add some to increase visibility!',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
        
        // Suggested Hashtags
        const SizedBox(height: 16),
        Text(
          'Suggested:',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.green[700],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            '#workout',
            '#fitness',
            '#health',
            '#gym',
            '#motivation',
            '#training',
          ].map((hashtag) {
            return ActionChip(
              label: Text(hashtag),
              backgroundColor: Colors.green[100],
              labelStyle: TextStyle(color: Colors.green[800]),
              onPressed: () {
                final provider = Provider.of<CreatePostProvider>(context, listen: false);
                provider.addHashtag(hashtag);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
