import 'package:flutter/material.dart';

// Import SearchResult from search_provider
import 'package:workout_app/features/search/providers/search_provider.dart';

class TrendingListWidget extends StatelessWidget {
  final List<dynamic> items;

  const TrendingListWidget({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildTrendingItem(context, item, index);
        },
      ),
    );
  }

  Widget _buildTrendingItem(BuildContext context, dynamic item, int index) {
    String title = '';
    String subtitle = '';
    String? imageUrl;
    String type = '';

    if (item is Map<String, dynamic>) {
      title = item['title'] ?? '';
      subtitle = item['subtitle'] ?? '';
      imageUrl = item['imageUrl'];
      type = item['type'] ?? '';
    } else if (item is SearchResult) {
      title = item.title;
      subtitle = item.subtitle;
      imageUrl = item.imageUrl;
      type = item.type;
    }

    return Container(
      width: 150,
      margin: EdgeInsets.only(
        right: index == items.length - 1 ? 0 : 12,
      ),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Handle trending item tap
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIconForType(type),
                      color: Colors.green,
                      size: 32,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'hashtag':
        return Icons.tag;
      case 'user':
        return Icons.people;
      case 'post':
        return Icons.description;
      default:
        return Icons.trending_up;
    }
  }
}
