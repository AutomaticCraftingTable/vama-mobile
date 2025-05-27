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

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No posts available'));
                  }

                  final posts = snapshot.data!;

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return PostCard(
                        accountId: post['author']['account_id'],
                        logo: post['author']['logo'],
                        likes: post['likes'],
                        comments: post['comments'],
                        content: post['content'],
                        id: post['id'],
                        author: post['author']['nickname'],
                        thumbnail: post['thumbnail'],
                        tags: List<String>.from(post['tags'].split('#')),
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
