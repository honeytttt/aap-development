class TrendingItem {
  final String id;
  final String name;
  final int postCount;
  final int engagement;
  final TrendType type;

  TrendingItem({
    required this.id,
    required this.name,
    required this.postCount,
    required this.engagement,
    required this.type,
  });
}

enum TrendType {
  hashtag,
  workout,
  challenge,
  user,
}
