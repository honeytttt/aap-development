import 'package:flutter/material.dart';
import 'package:workout_app/core/models/search/search_result.dart';

class SearchResultsWidget extends StatelessWidget {
  final List<SearchResult> results;
  final bool isLoading;

  const SearchResultsWidget({
    Key? key,
    required this.results,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return SearchResultItem(result: result);
      },
    );
  }
}

class SearchResultItem extends StatelessWidget {
  final SearchResult result;

  const SearchResultItem({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: result.imageUrl.isNotEmpty
          ? CircleAvatar(
              backgroundImage: NetworkImage(result.imageUrl),
              radius: 24,
            )
          : Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.tag, color: Colors.green),
            ),
      title: Text(
        result.title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        result.subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey[600],
        ),
      ),
      trailing: result.type == SearchResultType.user
          ? OutlinedButton(
              onPressed: () {
                // Follow user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Following ${result.title}'),
                  ),
                );
              },
              child: const Text('Follow'),
            )
          : null,
      onTap: () {
        // Handle result tap
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: ${result.title}'),
          ),
        );
      },
    );
  }
}
