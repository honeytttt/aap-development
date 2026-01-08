enum SearchResultType {
  user,
  post,
  hashtag,
  challenge,
}

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'type': type.toString(),
      'relevanceScore': relevanceScore,
    };
  }

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      imageUrl: json['imageUrl'],
      type: SearchResultType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      relevanceScore: json['relevanceScore']?.toDouble() ?? 0.0,
    );
  }
}
