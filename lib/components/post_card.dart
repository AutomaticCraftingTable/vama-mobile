import 'package:flutter/material.dart';
import 'package:vama_mobile/theme/app_colors.dart';
import 'package:vama_mobile/pages/article_detail_page.dart';

class PostCard extends StatelessWidget {
  final String author;
  final String thumbnail;
  final List<String> tags;
  final String title; 
  final int followers;
  final int id;
  final String content;
  final int likes;
  final List<dynamic> comments;
  final String logo;

  const PostCard({
    super.key,
    required this.logo,
    required this.likes,
    required this.comments,
    required this.content,
    required this.id,
    required this.author,
    required this.thumbnail,
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
         Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ArticleDetailPage(
        articleId: id,
        initialArticleData: {
          'id': id,
          'author': author,
          'thumbnail': thumbnail,
          'tags': tags,
          'title': title,
          'followers': followers,
          'content': content,
          'likes': likes,
          'comments': comments,
          'logo': logo,
        },
      ),
    ),
  );
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
                    child:  CircleAvatar(
                      backgroundImage: NetworkImage(logo),
                      radius: 24,
                    ),
                  ),

                  const SizedBox(width: 8),

                  GestureDetector(
                    onTap: goToUserProfile,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(author, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  thumbnail,
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
