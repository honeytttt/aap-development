import 'package:flutter/material.dart';
import 'package:workout_app/core/models/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile userProfile;
  final bool isCurrentUser;
  final VoidCallback? onFollowToggle;

  const ProfileHeader({
    super.key,
    required this.userProfile,
    required this.isCurrentUser,
    this.onFollowToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF4CAF50),
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: userProfile.avatarUrl != null
                      ? NetworkImage(userProfile.avatarUrl!)
                      : null,
                  child: userProfile.avatarUrl == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
              if (isCurrentUser)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Display Name
          Text(
            userProfile.displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          
          // Username
          Text(
            '@${userProfile.displayName.toLowerCase().replaceAll(' ', '')}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCurrentUser)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to edit profile
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onFollowToggle,
                    icon: Icon(
                      userProfile.isFollowing 
                          ? Icons.check 
                          : Icons.person_add,
                    ),
                    label: Text(
                      userProfile.isFollowing ? 'Following' : 'Follow',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: userProfile.isFollowing
                          ? Colors.grey[300]
                          : const Color(0xFF4CAF50),
                      foregroundColor: userProfile.isFollowing
                          ? Colors.black87
                          : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              if (!isCurrentUser)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Message functionality would go here
                    },
                    icon: const Icon(Icons.message),
                    label: const Text('Message'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4CAF50),
                      side: const BorderSide(color: Color(0xFF4CAF50)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
