import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/components/%D1%81ustom_snack_bar.dart';
import 'package:vama_mobile/components/article_items/article_author_card.dart';
import 'package:vama_mobile/provider/auth_provider.dart';
import 'package:vama_mobile/components/article_items/comment_item.dart';
import 'package:vama_mobile/components/headers/header.dart';
import 'package:vama_mobile/theme/light_theme.dart';
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
  late Map<String?, dynamic> article;

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
          article['likes'] += isLiked ? 1 : -1;
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
          article['likes'] += isLiked ? 1 : -1;
        }
      });
      showCustomSnackBar(context, 'Błąd przy aktualizacji polubienia');
    }
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

    setState(() {
      isWritingComment = false;
      commentController.clear();
    });

    try {
      await ApiService().addCommentToArticle(articleId, text);
      setState(() {
        final newComment = {
          'id': DateTime.now().millisecondsSinceEpoch,
          'causer': {
            'account_id': authProvider.Id,
            'nickname': authProvider.nickname ?? 'Unknown',
            'logo': 'https://example.com/your_avatar.png',
          },
          'content': text,
          'created_at': DateTime.now().toIso8601String(),
          'likes': 0,
        };
        article?['comments'].insert(0, newComment);
      });
    } catch (e) {
      showCustomSnackBar(context, 'Błąd przy dodawaniu komentarza');
    }
  }

  void goToUserProfile() {
    final articleId = article['id'];
    Navigator.pushNamed(context, "/profile", arguments: articleId);
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
        article['comments'].removeWhere((c) => c['id'] == commentId);
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
      body: SafeArea(
        child: Column(
          children: [
            const Header(),

            Expanded(
              child: FutureBuilder<Map<String?, dynamic>>(
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

                  article = snapshot.data!;

                  final int? currentUserId = authProvider.isLoggedIn ? authProvider.Id : null;

                  final int authorId = article['author']['account_id'];

                  final bool isMyArticle = (currentUserId != null && currentUserId == authorId);

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 80),
                      children: [
                        if (_note != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: LightTheme.warning,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.note_alt,
                                  color: LightTheme.textWarnig,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _note!,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: LightTheme.textWarnig,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () async {
                                    try {
                                      await ApiService().deleteNote(widget.articleId);
                                      setState(() {
                                        _note = null;
                                      });
                                      showCustomSnackBar(context, 'Notatka została usunięta');
                                    } catch (e) {
                                      showCustomSnackBar(context, 'Nie udało się usunąć notatki');
                                    }
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                    color: LightTheme.textWarnig,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        ArticleAuthorCard(
                          article: article,
                          articleId: widget.articleId,
                          onTapProfile: goToUserProfile,
                          hideSubscribe: isMyArticle,
                          onNoteAdded: (note) {
                          setState(() {
                          _note = note;
                            });
                          }
                        ),                   
                        const SizedBox(height: 16),
                        Text(
                          (article['title'] ?? 'Brak tytułu').toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: LightTheme.text,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          (article['content'] ?? 'Brak treści').toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: LightTheme.text,
                          ),
                        ),
                        const SizedBox(height: 30),

                        Text(
                          "Komentarzy: ${article['comments']?.length ?? 0}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: LightTheme.text,
                          ),
                        ),

                        const SizedBox(height: 10),

                        ...article['comments'].map<Widget>((comment) {
                          final int commentId = comment['id'];
                          return CommentItem(
                            comment: comment,
                            isLiked: likedComments.contains(commentId),
                            onTapProfile: goToUserProfile,
                            currentUsername:
                                authProvider.nickname ?? 'Unknown',
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

      bottomNavigationBar: isWritingComment
    ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: commentController,
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
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: LightTheme.primary),
                    ),
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
    : Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: LightTheme.textPrimary,
          
        ),
        child: ArticleActionBar(
          isLiked: isLiked,
          likeCount: article['likes'] ?? 0,
          onLike: toggleLike,
          onComment: () {
            setState(() {
              isWritingComment = true;
            });
          },
        ),
      ),

    );
  }
}
