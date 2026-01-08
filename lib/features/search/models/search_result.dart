class SearchResult {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final SearchResultType type;
  final double relevanceScore;

  SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.type,
    this.relevanceScore = 0.0,
  });
}

enum SearchResultType {
  user,
  post,
  hashtag,
  challenge,
}
