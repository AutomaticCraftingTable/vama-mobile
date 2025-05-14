import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/components/buttons/custom_buttons.dart';
import 'package:vama_mobile/components/auth_provider.dart';
import 'package:vama_mobile/theme/app_colors.dart';

class ArticleAuthorCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTapProfile,
          child: CircleAvatar(
            backgroundImage: NetworkImage(article['logo']),
            radius: 24,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article['author'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.text
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text("${article['followers']} followers",
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
              onPressed: () async {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);

                if (!authProvider.isLoggedIn) {
                  Navigator.pushNamed(context, '/login');
                  return;
                }

                try {
                  final response = await ApiService().subscribeToArticle(articleId);

                  if (response.statusCode == 200 || response.statusCode == 201) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Zasubskrybowano!')),
                    );
                  } else {
                    throw Exception('Failed to subscribe');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Błąd przy subskrypcji')),
                  );
                }
                print("Zasubskrybowano");
              },
              child: const Text(
                "Zasubskrybuj",
                style: TextStyle(
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
                      articleId,
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
