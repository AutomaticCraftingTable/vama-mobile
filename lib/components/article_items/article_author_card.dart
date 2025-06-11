import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/components/%D1%81ustom_snack_bar.dart';
import 'package:vama_mobile/components/buttons/custom_buttons.dart';
import 'package:vama_mobile/provider/auth_provider.dart';
import 'package:vama_mobile/theme/light_theme.dart';

class ArticleAuthorCard extends StatefulWidget {
  final Map<String?, dynamic> article;
  final int articleId;
  final VoidCallback onTapProfile;
  final bool hideSubscribe;
  final void Function(String)? onNoteAdded;
  final String nickname;

  const ArticleAuthorCard({
    super.key,
    required this.nickname,
    required this.article,
    required this.articleId,
    required this.onTapProfile,
    this.hideSubscribe = false,
    this.onNoteAdded,
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

  if (!authProvider.hasProfile) {
    Navigator.pushNamed(context, '/settings');
    return;
  }

  try {
    if (isSubscribed) {
      final response = await ApiService().unsubscribeFromProfile(widget.nickname);
      if (response.statusCode == 200) {
        setState(() => isSubscribed = false);
        showCustomSnackBar(context, 'Odsubskrybowano!');
      } else {
        throw Exception('Failed to unsubscribe');
      }
    } else {
      final response = await ApiService().subscribeToProfil(widget.nickname);
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() => isSubscribed = true);
        showCustomSnackBar(context, 'Zasubskrybowano!');
      } else {
        throw Exception('Failed to subscribe');
      }
    }
  } catch (e) {
    showCustomSnackBar(
        context, isSubscribed ? 'Błąd przy odsubskrypcji' : 'Błąd przy subskrypcji');
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
            backgroundImage: NetworkImage(widget.article['author']['logo'] ?? ''),
            radius: 20,
            child: widget.article['author']['logo'] == null
                ? const Icon(Icons.person)
                : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.article['author']['nickname'] ?? 'Unknown Author',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: LightTheme.text,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "${widget.article['author']['followers']} followers",
                style: const TextStyle(
                  fontSize: 10,
                  color: LightTheme.textDimmed,
                ),
              ),
            ],
          ),
        ),
        if (!widget.hideSubscribe)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SecondaryButton(
                onPressed: toggleSubscription,
                child: Text(
                  isSubscribed ? "Odsubskrybuj" : "Zasubskrybuj",
                  style: const TextStyle(
                    fontSize: 11,
                    color: LightTheme.text,
                  ),
                ),
              ),
              const SizedBox(width: 4),
             PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) async {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);

                if (!authProvider.isLoggedIn) {
                  Navigator.pushNamed(context, '/login');
                  return;
                }

                if (!authProvider.hasProfile) {
                  Navigator.pushNamed(context, '/settings');
                  return;
                }

                if (value == 'report') {
                  try {
                    await ApiService().reportArticle(
                      widget.articleId,
                      'Zgłoszenie artykułu',
                    );
                    showCustomSnackBar(context, 'Artykuł został zgłoszony');
                  } catch (e) {
                    showCustomSnackBar(context, 'Nie udało się zgłosić artykułu');
                  }
                } else if (value == 'note') {
                  
                }
              },
              itemBuilder: (BuildContext context) {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                List<PopupMenuEntry<String>> items = [
                  const PopupMenuItem<String>(
                    value: 'report',
                    child: Text('Zgłoś artykuł'),
                  ),
                ];

                if (authProvider.isModerator) {
                  items.add(
                    const PopupMenuItem<String>(
                      value: 'note',
                      child: Text('Dodać notatkę'),
                    ),
                  );
                }
                return items;
              },
            ),
          ],
        ),
      ],
    );
  }
}

