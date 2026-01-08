import 'package:flutter/material.dart';

class HashtagChips extends StatelessWidget {
  final List<String> hashtags;
  final Function(String) onHashtagAdded;
  final Function(String) onHashtagRemoved;

  const HashtagChips({
    Key? key,
    required this.hashtags,
    required this.onHashtagAdded,
    required this.onHashtagRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hashtags',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...hashtags.map((hashtag) => Chip(
                  label: Text(hashtag),
                  onDeleted: () => onHashtagRemoved(hashtag),
                )),
            InputChip(
              label: const Text('Add hashtag'),
              onPressed: () {
                _showAddHashtagDialog(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  void _showAddHashtagDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Hashtag'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter hashtag (without #)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final hashtag = controller.text.trim();
              if (hashtag.isNotEmpty) {
                onHashtagAdded('#$hashtag');
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
