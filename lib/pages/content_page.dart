import 'package:flutter/material.dart';
import 'package:vama_mobile/components/post_card.dart';
import 'package:vama_mobile/components/mock_posts.dart';
import 'package:vama_mobile/components/header.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(

       body: SafeArea(
        child: Column(
          children: [

            const Header(),

            const SizedBox(height: 10),
            
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostCard(
                    username: post['username'],
                    imageUrl: post['imageUrl'],
                    tags: List<String>.from(post['tags']),
                    title: post['title'],
                    followers: post['followers'],
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
