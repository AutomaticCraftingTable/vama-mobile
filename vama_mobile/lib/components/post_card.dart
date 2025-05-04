import 'package:flutter/material.dart';
import 'package:vama_mobile/theme/app_colors.dart';

class PostCard extends StatelessWidget {
  final String username;
  final String imageUrl;
  final List<String> tags;
  final String title; 
  final int followers;

  const PostCard({
    super.key,
    required this.username,
    required this.imageUrl,
    required this.tags,
    required this.title, 
    required this.followers,
  });

  @override
  Widget build(BuildContext context) {
    void goToUserProfile() {
      print('User profile tapped!');
    }

    return InkWell(
      onTap: () {
        print('Entire post card tapped!');
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [

                  GestureDetector(
                    onTap: goToUserProfile,
                    child: const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person, color: AppColors.bg),
                    ),
                  ),

                  const SizedBox(width: 8),

                  GestureDetector(
                    onTap: goToUserProfile,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("$followers followers", style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 10),
        
              Wrap(
                spacing: 6,
                children: tags.map((tag) {
                  return Chip(
                    label: Text(tag, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.text)),
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
