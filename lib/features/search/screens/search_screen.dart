import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/features/search/providers/search_provider.dart';
import 'package:workout_app/features/search/widgets/search_results_list.dart';
import 'package:workout_app/features/search/widgets/trending_list.dart';
import 'package:workout_app/features/search/widgets/suggested_users.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    Provider.of<SearchProvider>(context, listen: false)
        .setSearchQuery(_searchController.text);
  }

  void _clearSearch() {
    _searchController.clear();
    Provider.of<SearchProvider>(context, listen: false).setSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search users, posts, hashtags...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                : const Icon(Icons.search),
          ),
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          if (provider.searchQuery.isNotEmpty) {
            return SearchResultsList(results: provider.searchResults);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trending Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TrendingListWidget(items: provider.trendingItems),
                const SizedBox(height: 24),
                const Text(
                  'Suggested for You',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SuggestedUsersWidget(
                  users: provider.suggestedUsers,
                  onFollow: (userId) {
                    Provider.of<SearchProvider>(context, listen: false)
                        .followSuggestedUser(userId);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
