import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/components/%D1%81ustom_snack_bar.dart';
import 'package:vama_mobile/components/article_items/article_author_card.dart';
import 'package:vama_mobile/provider/auth_provider.dart';
import 'package:vama_mobile/components/article_items/comment_item.dart';
import 'package:vama_mobile/components/%D1%81ustom_snack_bar.dart';
import 'package:vama_mobile/components/article_items/article_author_card.dart';
import 'package:vama_mobile/provider/auth_provider.dart';
import 'package:vama_mobile/components/article_items/comment_item.dart';
import 'package:vama_mobile/components/headers/header.dart';
import 'package:vama_mobile/theme/light_theme.dart';
import 'package:vama_mobile/components/article_items/article_action_bar.dart';
import 'package:vama_mobile/components/article_items/article_action_bar.dart';

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
  late Future<Map<String?, dynamic>> articleFuture;
  Map<String?, dynamic>? article;

  Set<int> likedComments = {};
  bool isWritingComment = false;
  final TextEditingController commentController = TextEditingController();
  String? _note;

  @override
  void initState() {
    super.initState();
    if (widget.initialArticleData != null) {
      article = widget.initialArticleData!;
    }
    articleFuture = ApiService().fetchArticle(widget.articleId).then((data) {
      setState(() {
        article = data;
      });
      return data;
    });
  }

  void toggleLike() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      Navigator.pushNamed(context, '/login');
      return;
    }
    if (!authProvider.hasProfile) {
      Navigator.pushNamed(context, '/settings');
      return;
    }
    try {
      setState(() {
        isLiked = !isLiked;
        if (article != null) {
          article?['likes'] += isLiked ? 1 : -1;
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
          article?['likes'] += isLiked ? 1 : -1;
        }
      });
      showCustomSnackBar(context, 'Błąd przy aktualizacji polubienia');
    }
  }

  Future<void> addComment() async {
  final auth = Provider.of<AuthProvider>(context, listen: false);

  if (!auth.isLoggedIn) {
    await Navigator.pushNamed(context, '/login');
    return;
  }

  if (!auth.hasProfile) {
    await Navigator.pushNamed(context, '/settings');
    return;
  }

  void addComment() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      Navigator.pushNamed(context, '/login');
      return;
    }
    if (!authProvider.hasProfile) {
      Navigator.pushNamed(context, '/settings');
      return;
    }

  final text = commentController.text.trim();
  if (text.isEmpty) return;

  final articleId = article?['id'];
  if (articleId == null) return; 

  setState(() => isWritingComment = false);

  final newComment = await ApiService().addCommentToArticle(articleId, text);

final enrichedComment = {
  ...newComment,
  'causer': {
    'account_id': auth.Id,
    'nickname': auth.nickname,
    'logo': 'https://example.com/your_avatar.png',
  },
};

commentController.clear();
setState(() {
  article?['comments']?.insert(0, enrichedComment);
});
}


  void goToUserProfile() {
    final nickname = article?['author']['nickname'];
    Navigator.pushNamed(context, "/profile", arguments: nickname);
  }

  void reportComment(int commentId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      Navigator.pushNamed(context, '/login');
      return;
    }
    if (!authProvider.hasProfile) {
      Navigator.pushNamed(context, '/settings');
      return;
    }
    try {
      await ApiService().reportComment(commentId, 'Komentarz jest nieodpowiedni');
      showCustomSnackBar(context, 'Komentarz został zgłoszony');
    } catch (e) {
      showCustomSnackBar(context, 'Błąd przy zgłaszaniu komentarza');
    }
  }

  void deleteComment(int commentId) async {
    try {
      await ApiService().deleteComment(commentId);
      setState(() {
        article?['comments'].removeWhere((c) => c['id'] == commentId);
      });
      showCustomSnackBar(context, 'Komentarz został usunięty');
    } catch (e) {
      showCustomSnackBar(context, 'Błąd przy usuwaniu komentarza');
    }
  }

  Future<void> deleteArticle() async {
    try {
      await ApiService().deleteArticle(widget.articleId);
      showCustomSnackBar(context, 'Artykuł został usunięty');
      Navigator.of(context).pop();
    } catch (e) {
      showCustomSnackBar(context, 'Błąд przy usuwaniu artykułu');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const Header(),

            Expanded(
              child: FutureBuilder<Map<String?, dynamic>>(
                future: articleFuture,
                builder: (context, snapshot) {
                  
                  final int? currentUserId = authProvider.isLoggedIn ? authProvider.Id : null;
                  
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No article available'));
                  }

                  article = snapshot.data!;

                  final int authorId = article?['author']['account_id'];

                  final bool isMyArticle = (currentUserId != null && currentUserId == authorId);

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 80),
                      children: [                
                        const SizedBox(height: 16),
                        ArticleAuthorCard(
                          article: article!,
                          articleId: widget.articleId,
                          onTapProfile: goToUserProfile,
                          hideSubscribe: isMyArticle,
                          onNoteAdded: (note) {
                          setState(() {
                          _note = note;
                            });
                          },
                          nickname: article?['author']['nickname'],
                        ),                   
                        const SizedBox(height: 16),
                        Text(
                          (article?['title'] ?? 'Brak tytułu').toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: LightTheme.text,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          (article?['content'] ?? 'Brak treści').toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: LightTheme.text,
                          ),
                        ),
                        const SizedBox(height: 30),

                        Text(
                          "Komentarzy: ${article?['comments']?.length ?? 0}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: LightTheme.text,
                          ),
                        ),

                        const SizedBox(height: 10),
                        
                        ...article?['comments'].map<Widget>((comment) {
                           
                          final int commentId = comment['id'];
                          return CommentItem(
                            comment: comment,
                            isLiked: likedComments.contains(commentId),
                            onTapProfile: goToUserProfile,
                            nickname: comment['causer']['nickname'] ?? 'Anon',
                            onReport: () => reportComment(commentId),
                            onDelete: () => deleteComment(commentId),
                          );
                        }).toList(),                  
                        const SizedBox(height: 80),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: isWritingComment
      ? Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Napisz komentarz...',
                    hintStyle: TextStyle(color: LightTheme.textSecondary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: LightTheme.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                onPressed: addComment,
                child: Icon(Icons.send, color: LightTheme.textPrimary),
                mini: true,
                backgroundColor: LightTheme.primary,
              ),
            ],
          ),
        )
      : null,
    bottomNavigationBar: !isWritingComment
      ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(color: LightTheme.textPrimary),
          child: ArticleActionBar(
            isLiked: isLiked,
            likeCount: article?['likes'] ?? 0,
            onLike: toggleLike,
            onComment: () {
              setState(() => isWritingComment = true);
            },
          ),
        )
      : null,
  );
}
}
