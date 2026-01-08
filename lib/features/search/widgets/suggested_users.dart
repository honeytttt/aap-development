import 'package:flutter/material.dart';
import 'package:workout_app/core/models/user.dart';

class SuggestedUsersWidget extends StatelessWidget {
  final List<User> users;
  final Function(String) onFollow;

  const SuggestedUsersWidget({
    super.key,
    required this.users,
    required this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: users.map((user) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                user.avatarUrl ?? 'https://ui-avatars.com/api/?name=${user.username}&background=4CAF50&color=fff',
              ),
            ),
            title: Text(user.displayName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@${user.username}'),
                const SizedBox(height: 4),
                if (user.bio != null && user.bio!.isNotEmpty)
                  Text(
                    user.bio!,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
            trailing: user.isFollowing
                ? OutlinedButton(
                    onPressed: () => onFollow(user.id),
                    child: const Text('Following'),
                  )
                : ElevatedButton(
                    onPressed: () => onFollow(user.id),
                    child: const Text('Follow'),
                  ),
            onTap: () {
              // Navigate to user profile
            },
          ),
        );
      }).toList(),
    );
  }
}
