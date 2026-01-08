class SearchResult {
  final String id;
  final SearchResultType type;
  final String title;
  final String subtitle;
  final String imageUrl;
  final dynamic data; // User, Post, or Hashtag data

  SearchResult({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.data,
  });
}

enum SearchResultType {
  user,
  post,
  hashtag,
  trending,
}
