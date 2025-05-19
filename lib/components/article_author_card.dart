import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/components/buttons/custom_buttons.dart';
import 'package:vama_mobile/components/auth_provider.dart';
import 'package:vama_mobile/theme/app_colors.dart';

class ArticleAuthorCard extends StatefulWidget {
  final Map<String, dynamic> article;
  final int articleId;
  final VoidCallback onTapProfile;

  const ArticleAuthorCard({
    super.key,
    required this.article,
    required this.articleId,
    required this.onTapProfile,
  });

  @override
  State<ArticleAuthorCard> createState() => _ArticleAuthorCardState();
}

class _ArticleAuthorCardState extends State<ArticleAuthorCard> {
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    isSubscribed = widget.article['isSubscribed'] ?? false;
  }

  Future<void> toggleSubscription() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    try {
      if (isSubscribed) {
        final response = await ApiService().unsubscribeFromProfile(widget.articleId);
        if (response.statusCode == 200) {
          setState(() => isSubscribed = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Odsubskrybowano!')),
          );
        } else {
          throw Exception('Failed to unsubscribe');
        }
      } else {
        final response = await ApiService().subscribeToProfil(widget.articleId);
        if (response.statusCode == 200 || response.statusCode == 201) {
          setState(() => isSubscribed = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Zasubskrybowano!')),
          );
        } else {
          throw Exception('Failed to subscribe');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isSubscribed ? 'Błąd przy odsubskrypcji' : 'Błąd przy subskrypcji')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: widget.onTapProfile,
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.article['logo']),
            radius: 24,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.article['author'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.text,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "${widget.article['followers']} followers",
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textDimmed,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SecondaryButton(
              onPressed: toggleSubscription,
              child: Text(
                isSubscribed ? "Odsubskrybuj" : "Zasubskrybuj",
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.text,
                ),
              ),
            ),
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) async {
                if (value == 'report') {
                  try {
                    await ApiService().reportArticle(
                      widget.articleId,
                      'Zgłoszenie artykułu',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Article reported successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to report article')),
                    );
                  }
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'report',
                  child: Text('Zgłoś artykuł'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

