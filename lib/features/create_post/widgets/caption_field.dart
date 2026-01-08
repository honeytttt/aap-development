import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/create_post/providers/create_post_provider.dart';

class CaptionField extends StatefulWidget {
  const CaptionField({super.key});

  @override
  State<CaptionField> createState() => _CaptionFieldState();
}

class _CaptionFieldState extends State<CaptionField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CreatePostProvider>(context, listen: false);
    _controller.text = provider.draftPost.content;
    
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final provider = Provider.of<CreatePostProvider>(context, listen: false);
    provider.updateCaption(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreatePostProvider>(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Caption',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          maxLines: 5,
          maxLength: 2200,
          decoration: InputDecoration(
            hintText: 'Share your workout journey...',
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
          ),
          style: const TextStyle(fontSize: 16),
          onChanged: (value) {
            provider.updateCaption(value);
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              '${_controller.text.length}/2200',
              style: TextStyle(
                color: _controller.text.length > 2000 ? Colors.red : Colors.grey[700],
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                provider.extractHashtagsFromCaption();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Hashtags extracted from caption'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.tag, size: 18),
              label: const Text('Extract Hashtags'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.green[700],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
