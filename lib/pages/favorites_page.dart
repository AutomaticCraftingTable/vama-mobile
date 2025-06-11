import 'package:flutter/material.dart';
import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/components/headers/header.dart';
import 'package:vama_mobile/theme/light_theme.dart';
import 'package:vama_mobile/pages/article_detail_page.dart';
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<dynamic> _articles = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final data = await ApiService().fetchFavoriteArticles();
      setState(() {
        _articles = data;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFromFavorites(int articleId) async {
    try {
      await ApiService().unlikeArticle(articleId);
      setState(() {
        _articles.removeWhere((article) => article['id'] == articleId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd podczas usuwania: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Expanded(
          child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadFavorites,
                child: _error != null
                  ? ListView( 
                      children: [Center(child: Text('Błąd: $_error'))],
                    )
                  : _articles.isEmpty
                    ? ListView(children: [const Center(child: Text('Brak ulubionych artykułów.'))])
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              itemCount: _articles.length,
                              itemBuilder: (context, index) {
                                final article = _articles[index];

                                bool isValidUrl(String? url) {
                                  return url != null &&
                                      (url.startsWith('http://') || url.startsWith('https://'));
                                }
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ArticleDetailPage(
                                          articleId: article['id'],
                                            initialArticleData: {
                                            'id': article['id'],
                                            'author': article['author'],
                                            'thumbnail': article['thumbnail'],
                                            'tags': article['tags'],
                                            'title': article['title'],
                                            'followers': article['followers'],
                                            'content': article['content'],
                                            'likes': article['likes'],
                                            'comments': article['comments'],
                                            'logo': article['logo'],
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          isValidUrl(article['thumbnail'])
                                              ? ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.network(
                                                  article['thumbnail'],
                                                  width: 80, height: 80, fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) => Container(
                                                    color: Colors.grey[300],
                                                    width: 80, height: 80,
                                                    child: const Icon(Icons.broken_image, color: LightTheme.textDimmed),
                                                  ),
                                                ),
                                              )
                                              : Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: const Icon(
                                                    Icons.image,
                                                    size: 40,
                                                    color: LightTheme.textDimmed,
                                                  ),
                                                ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              article['title'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: LightTheme.text,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          IconButton(
                                              icon: const Icon(Icons.close, color: LightTheme.primary),
                                              onPressed: () => _removeFromFavorites(article['id']),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
            )
          ],
        ),
      ),
    );
  }
}
