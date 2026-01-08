import 'package:flutter/material.dart';

class ProfileInterests extends StatelessWidget {
  final List<String> interests;

  const ProfileInterests({super.key, required this.interests});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interests',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: interests
                .map((interest) => Chip(
                      label: Text(interest),
                      backgroundColor: const Color(0xFFE8F5E9),
                      labelStyle: const TextStyle(color: Color(0xFF4CAF50)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
