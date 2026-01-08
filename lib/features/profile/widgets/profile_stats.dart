import 'package:flutter/material.dart';
import 'package:workout_app/core/models/user_profile.dart';

class ProfileStats extends StatelessWidget {
  final UserProfile userProfile;

  const ProfileStats({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            count: userProfile.postCount,
            label: 'Posts',
          ),
          _buildStatItem(
            count: userProfile.followerCount,
            label: 'Followers',
          ),
          _buildStatItem(
            count: userProfile.followingCount,
            label: 'Following',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({required int count, required String label}) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4CAF50),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
