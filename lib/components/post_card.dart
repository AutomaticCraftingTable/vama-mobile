import 'package:flutter/material.dart';
import 'package:vama_mobile/theme/light_theme.dart';
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
  final int accountId;

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
    required this.accountId,
  });

  @override
  Widget build(BuildContext context) {
      

    void goToUserProfile() {
      Navigator.pushNamed(
      context,
      '/profile',
      arguments: accountId,
    );
    }

    bool isValidUrl(String? url) {
      return url != null && (url.startsWith('http://') || url.startsWith('https://'));
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
                        Text(author, style: const TextStyle(fontWeight: FontWeight.bold, color: LightTheme.text)),
                        Text("$followers followers", style: const TextStyle(fontSize: 12, color: LightTheme.textDimmed)),
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

              isValidUrl(thumbnail)
                  ? ClipRRect(
                      borderRadius: BorderRadius.zero,
                      child: Image.network(
                        thumbnail,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.zero,
                      ),
                      child: const Icon(
                        Icons.image,
                        size: 40,
                        color: LightTheme.textDimmed,
                      ),
                    ),

              const SizedBox(height: 10),
        
              Wrap(
                spacing: 6,
                children: tags.map((tag) {
                  return Chip(
                    label: Text(tag, style: const TextStyle(fontWeight: FontWeight.bold, color: LightTheme.text)),
                    backgroundColor: LightTheme.secondary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
