class UserProfile {
  final String userId;
  final String displayName;
  final String? bio;
  final String? avatarUrl;
  final int followerCount;
  final int followingCount;
  final int postCount;
  final DateTime joinedDate;
  final List<String> interests;
  final bool isFollowing;

  UserProfile({
    required this.userId,
    required this.displayName,
    this.bio,
    this.avatarUrl,
    this.followerCount = 0,
    this.followingCount = 0,
    this.postCount = 0,
    required this.joinedDate,
    this.interests = const [],
    this.isFollowing = false,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'],
      displayName: json['displayName'],
      bio: json['bio'],
      avatarUrl: json['avatarUrl'],
      followerCount: json['followerCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      postCount: json['postCount'] ?? 0,
      joinedDate: DateTime.parse(json['joinedDate']),
      interests: List<String>.from(json['interests'] ?? []),
      isFollowing: json['isFollowing'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'followerCount': followerCount,
      'followingCount': followingCount,
      'postCount': postCount,
      'joinedDate': joinedDate.toIso8601String(),
      'interests': interests,
      'isFollowing': isFollowing,
    };
  }

  UserProfile copyWith({
    String? userId,
    String? displayName,
    String? bio,
    String? avatarUrl,
    int? followerCount,
    int? followingCount,
    int? postCount,
    DateTime? joinedDate,
    List<String>? interests,
    bool? isFollowing,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      postCount: postCount ?? this.postCount,
      joinedDate: joinedDate ?? this.joinedDate,
      interests: interests ?? this.interests,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
