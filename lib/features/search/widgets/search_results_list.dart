import 'package:flutter/material.dart';
import 'package:workout_app/features/search/providers/search_provider.dart';
import 'package:workout_app/core/models/user.dart';

class SearchResultsList extends StatelessWidget {
  final List<SearchResult> results;

  const SearchResultsList({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            Text(
              'Try different keywords',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return _buildResultItem(context, result);
      },
    );
  }

  Widget _buildResultItem(BuildContext context, SearchResult result) {
    switch (result.type) {
      case 'user':
        final user = result.data as User?;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                user?.avatarUrl ?? 'https://ui-avatars.com/api/?name=${result.title}&background=4CAF50&color=fff',
              ),
            ),
            title: Text(result.title),
            subtitle: Text(result.subtitle),
            trailing: user?.isFollowing == true
                ? OutlinedButton(
                    onPressed: () {
                      // Unfollow
                    },
                    child: const Text('Following'),
                  )
                : ElevatedButton(
                    onPressed: () {
                      // Follow
                    },
                    child: const Text('Follow'),
                  ),
            onTap: () {
              // Navigate to user profile
            },
          ),
        );

      case 'hashtag':
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.tag,
                color: Colors.green,
              ),
            ),
            title: Text(
              result.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(result.subtitle),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                // Navigate to hashtag feed
              },
            ),
          ),
        );

      case 'post':
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: result.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      result.imageUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.description,
                      color: Colors.green,
                    ),
                  ),
            title: Text(result.title),
            subtitle: Text(result.subtitle),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to post
            },
          ),
        );

      default:
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(result.title),
            subtitle: Text(result.subtitle),
          ),
        );
    }
  }
}
