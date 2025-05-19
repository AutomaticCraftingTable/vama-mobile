import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/components/article_author_card.dart';
import 'package:vama_mobile/components/auth_provider.dart';
import 'package:vama_mobile/components/comment_item.dart';
import 'package:vama_mobile/components/headers/header.dart';
import 'package:vama_mobile/theme/app_colors.dart';
import 'package:vama_mobile/components/article_action_bar.dart';

class ArticleDetailPage extends StatefulWidget {
  final int articleId;
  final Map<String, dynamic>? initialArticleData;

  const ArticleDetailPage({
    super.key,
    required this.articleId,
    this.initialArticleData,
  });

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  bool isLiked = false;
  late Future<Map<String, dynamic>> articleFuture;
  Map<String, dynamic>? article;

  Set<int> likedComments = {};
  bool isWritingComment = false;
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialArticleData != null) {
      article = widget.initialArticleData!;
      articleFuture = Future.value(article);
    } else {
      articleFuture = ApiService().fetchArticle(widget.articleId);
    }
  }

  void toggleLike() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    try {
      setState(() {
        isLiked = !isLiked;
        if (article != null) {
          article!['likes'] += isLiked ? 1 : -1;
        }
      });

      if (isLiked) {
        await ApiService().likeArticle(widget.articleId);
      } else {
        await ApiService().unlikeArticle(widget.articleId);
      }
    } catch (e) {
      setState(() {
        isLiked = !isLiked;
        if (article != null) {
          article!['likes'] += isLiked ? 1 : -1;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd przy aktualizacji polubienia')),
      );
    }
  }

  void toggleCommentLike(int commentId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    final comments = article?['comments'] as List<dynamic>;
    final comment = comments.firstWhere((c) => c['id'] == commentId);
    final alreadyLiked = likedComments.contains(commentId);

    setState(() {
      if (alreadyLiked) {
        likedComments.remove(commentId);
        comment['likes'] = (comment['likes'] ?? 0) - 1;
      } else {
        likedComments.add(commentId);
        comment['likes'] = (comment['likes'] ?? 0) + 1;
      }
    });

    try {
      if (alreadyLiked) {
        await ApiService().unlikeComment(commentId);
      } else {
        await ApiService().likeComment(commentId);
      }
    } catch (e) {
      setState(() {
        if (alreadyLiked) {
          likedComments.add(commentId);
          comment['likes'] += 1;
        } else {
          likedComments.remove(commentId);
          comment['likes'] -= 1;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd przy aktualizacji polubienia komentarza')),
      );
    }
  }

  void addComment() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    final text = commentController.text.trim();
    if (text.isEmpty) return;

    final articleId = article?['id'];
    if (articleId == null) return;

    setState(() {
      isWritingComment = false;
      commentController.clear();
    });
    try {
      await ApiService().addCommentToArticle(articleId, text);
      setState(() {
        final newComment = {
          'id': DateTime.now().millisecondsSinceEpoch,
           'causer': authProvider.nickname ?? 'Unknown',
          'content': text,
          'logo': 'https://example.com/your_avatar.png',
          'created_at': DateTime.now().toIso8601String(),
          'likes': 0,
        };
        article?['comments'].insert(0, newComment);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Błąd przy dodawaniu komentarza')),
      );
    }
  }
  void goToUserProfile() {
    print('User profile tapped!');
  }
  void reportComment(int commentId) async {
  try {
    await ApiService().reportComment(commentId, 'Komentarz jest nieodpowiedni'); 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Komentarz został zgłoszony')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Błąd przy zgłaszaniu komentarza')),
    );
  }
}
void deleteComment(int commentId) async {
  try {
    await ApiService().deleteComment(commentId);
    setState(() {
      article?['comments'].removeWhere((c) => c['id'] == commentId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Komentarz został usunięty')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Błąd przy usuwaniu komentarza')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final currentUsername = authProvider.nickname ?? 'Unknown';
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: articleFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No article available'));
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 80),
                      children: [                      
                          ArticleAuthorCard(
                          article: article!,
                          articleId: widget.articleId,
                          onTapProfile: goToUserProfile,
                        ),                      
                        const SizedBox(height: 16),
                        Text(
                          article!['title'],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          article!['content'],
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: AppColors.text
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Komentarzy: ${article?['comments']?.length ?? 0}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                            ),
                        ),
                        const SizedBox(height: 10),
                        ...article!['comments'].map<Widget>((comment) {
                          final int commentId = comment['id'];
                          return CommentItem(
                            comment: comment,
                            isLiked: likedComments.contains(commentId),
                            onLike: () => toggleCommentLike(commentId),
                            onTapProfile: goToUserProfile,
                            currentUsername: currentUsername,
                            onReport: () => reportComment(commentId),
                            onDelete: () => deleteComment(commentId),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isWritingComment
  ? Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Napisz komentarz...',
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: addComment,
            child: Icon(Icons.send, color: Colors.white),
            mini: true,
            backgroundColor: AppColors.primary,
          ),
        ],
      ),
    )
  : ArticleActionBar(
      isLiked: isLiked,
      likeCount: article?['likes'] ?? 0,
      onLike: toggleLike,
      onComment: () {
        setState(() {
          isWritingComment = true;
        });
      },
    ),
    );
  }
}




