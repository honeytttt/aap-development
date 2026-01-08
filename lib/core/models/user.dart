class User {
  final String id;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final String? bio;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isFollowing;
  final DateTime joinedDate;
  final List<String>? workoutPreferences;
  final Map<String, dynamic>? stats;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    this.avatarUrl,
    this.bio,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.isFollowing = false,
    required this.joinedDate,
    this.workoutPreferences,
    this.stats,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'postsCount': postsCount,
      'isFollowing': isFollowing,
      'joinedDate': joinedDate.toIso8601String(),
      'workoutPreferences': workoutPreferences,
      'stats': stats,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      displayName: json['displayName'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      postsCount: json['postsCount'] ?? 0,
      isFollowing: json['isFollowing'] ?? false,
      joinedDate: DateTime.parse(json['joinedDate']),
      workoutPreferences: List<String>.from(json['workoutPreferences'] ?? []),
      stats: json['stats'],
    );
  }

  User copyWith({
    String? id,
    String? username,
    String? displayName,
    String? avatarUrl,
    String? bio,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    bool? isFollowing,
    DateTime? joinedDate,
    List<String>? workoutPreferences,
    Map<String, dynamic>? stats,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      isFollowing: isFollowing ?? this.isFollowing,
      joinedDate: joinedDate ?? this.joinedDate,
      workoutPreferences: workoutPreferences ?? this.workoutPreferences,
      stats: stats ?? this.stats,
    );
  }
}
