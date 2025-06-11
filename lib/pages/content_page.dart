import 'package:flutter/material.dart';
import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/components/headers/header.dart';
import 'package:vama_mobile/components/post_card.dart';


class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: ApiService().fetchPosts(), 
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final articles = snapshot.data;
                  if (articles == null || articles.isEmpty) {
                    return const Center(child: Text('No posts available'));
                  }

                  return ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final post = articles[index] as Map<String, dynamic>;

                      final String thumbnailUrl = (post['thumbnail'] as String?)?.isNotEmpty == true
                          ? post['thumbnail']
                          : 'https://via.placeholder.com/150';
                          
                      final List<String> tags = (post['tags'] as String)
                          .split(',')
                          .map((t) => t.trim())
                          .where((t) => t.isNotEmpty)
                          .toList();

                      return PostCard(
                        nickname: post['author']['nickname'],
                        accountId: post['author']['account_id'],
                        logo: post['author']['logo'],
                        likes: post['likes'],
                        comments: post['comments'],
                        content: post['content'],
                        id: post['id'],
                        author: post['author']['nickname'],
                        thumbnail: thumbnailUrl,
                        tags: tags,
                        title: post['title'],
                        followers: post['author']['followers'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

