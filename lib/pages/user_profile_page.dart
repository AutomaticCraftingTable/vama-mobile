import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/components/%D1%81ustom_snack_bar.dart';
import 'package:vama_mobile/provider/auth_provider.dart';
import 'package:vama_mobile/components/%D1%81ustom_snack_bar.dart';
import 'package:vama_mobile/provider/auth_provider.dart';
import 'package:vama_mobile/components/buttons/custom_buttons.dart';
import 'package:vama_mobile/components/headers/header.dart';
import 'package:vama_mobile/models/userProfileModel.dart';
import 'package:vama_mobile/pages/article_detail_page.dart';
import 'package:vama_mobile/models/userProfileModel.dart';
import 'package:vama_mobile/pages/article_detail_page.dart';
import 'package:vama_mobile/theme/light_theme.dart';

class UserProfilePage extends StatefulWidget {
  final String nickname;

  const UserProfilePage({Key? key, required this.nickname}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Future<UserProfile>? _futureProfile;
  bool isSubscribed = false;
  bool isOwnProfile = false;
  
@override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_futureProfile == null) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final isOwn = widget.nickname == auth.nickname;
      isOwnProfile = isOwn;

      _futureProfile = (isOwn
        ? ApiService().fetchOwnProfile()
        : ApiService().fetchUserProfile(widget.nickname)
      ).then((json) => UserProfile.fromJson(json));
    }
  }

Future<void> toggleSubscription() async {
  final auth = Provider.of<AuthProvider>(context, listen: false);

  if (!auth.isLoggedIn) {
    Navigator.pushNamed(context, '/login');
    return;
  }

  if (!auth.hasProfile) {
    Navigator.pushNamed(context, '/settings');
    return;
  }

  try {
    final profile = await _futureProfile; 

    if (isSubscribed) {
      final response = await ApiService().unsubscribeFromProfile(profile!.nickname);
      if (response.statusCode == 200) {
        setState(() => isSubscribed = false);
        showCustomSnackBar(context, 'Odsubskrybowano!');
      } else {
        throw Exception('Failed to unsubscribe'); 
      }
    } else {
      final response = await ApiService().subscribeToProfil(profile!.nickname);
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() => isSubscribed = true);
        showCustomSnackBar(context, 'Zasubskrybowano!');
      } else {
        throw Exception('Failed to subscribe');
      }
    }
  } catch (e) {
    showCustomSnackBar(
      context,
      isSubscribed ? 'Błąd przy odsubskrypcji' : 'Błąd przy subskrypcji',
    );
  }
}


  bool isValidUrl(String? url) {
    return url != null && (url.startsWith('http://') || url.startsWith('https://'));
  }
  Future<void> deleteArticle(int articleId) async {
  try {
    final response = await ApiService().deleteArticle(articleId);

    if (response.statusCode == 200 || response.statusCode == 204) {
      setState(() {
        _futureProfile = isOwnProfile
            ? ApiService().fetchOwnProfile().then((json) => UserProfile.fromJson(json))
            : ApiService().fetchUserProfile(widget.nickname).then((json) => UserProfile.fromJson(json));
      });
      showCustomSnackBar(context, 'Artykuł usunięty');
    } else {
      showCustomSnackBar(context, 'Nie udało się usunąć artykułu');
    }
  } catch (e) {
    showCustomSnackBar(context, 'Błąd podczas usuwania artykułu');
  }
}

  @override
  Widget build(BuildContext context) {
     final auth = Provider.of<AuthProvider>(context);
    final isOwnProfile = widget.nickname == auth.nickname;

    if (_futureProfile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: FutureBuilder<UserProfile>(
        future: _futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final profile = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                const SizedBox(height: 5),
                Header(),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: profile.logo.isNotEmpty
                          ? NetworkImage(profile.logo)
                          : null,
                      child: profile.logo.isEmpty ? const Icon(Icons.person, size: 35) : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.nickname,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: LightTheme.text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${profile.followers} followers',
                            style: const TextStyle(
                              color: LightTheme.textDimmed,
                              fontSize: 10,
                            ),
                          ),
                          if (profile.description.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              profile.description,
                              style: const TextStyle(fontSize: 10),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (!isOwnProfile)
                      Column(
                        children: [
                          SecondaryButton(
                            onPressed: toggleSubscription,
                            child: Text(
                              isSubscribed ? 'Odsubskrybuj' : 'Zasubskrybuj',
                              style: const TextStyle(
                                fontSize: 11,
                                color: LightTheme.text,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, size: 20),
                            onSelected: (value) async {
                              final auth = Provider.of<AuthProvider>(context, listen: false);

                              if (!auth.isLoggedIn) {
                                Navigator.pushNamed(context, '/login');
                                return;
                              }

                              if (!auth.hasProfile) {
                                Navigator.pushNamed(context, '/settings');
                                return;
                              }

                              if (!auth.isLoggedIn) {
                                Navigator.pushNamed(context, '/login');
                                return;
                              }

                              if (!auth.hasProfile) {
                                Navigator.pushNamed(context, '/settings');
                                return;
                              }

                              if (value == 'report') {
                                try {
                                  await ApiService().reportProfile(
                                    profile.nickname,
                                    'Zgłoszenie profilu',
                                  );
                                  showCustomSnackBar(context, 'Profil został zgłoszony');
                                  showCustomSnackBar(context, 'Profil został zgłoszony');
                                } catch (e) {
                                  showCustomSnackBar(context, 'Nie udało się zgłosić Profilu');                               
                                }
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem<String>(
                                value: 'report',
                                child: Text('Zgłoś profil'),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                for (var article in profile.articles) ...[
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ArticleDetailPage(articleId: article.id),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isValidUrl(article.thumbnail)) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  article.thumbnail!,
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ] else ...[
                              Container(
                                width: double.infinity,
                                height: 150,
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
                            ],
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 6,
                                    children: article.tags
                                        .map((tag) => Chip(
                                              label: Text(
                                                tag,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: LightTheme.text,
                                                ),
                                              ),
                                              visualDensity: VisualDensity.compact,
                                              backgroundColor: LightTheme.secondary,
                                            ))
                                        .toList(),
                                  ),
                                ),
                                if (isOwnProfile)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: LightTheme.primary,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      try {
                                        await deleteArticle(article.id);
                                        setState(() {
                                          profile.articles.removeWhere((a) => a.id == article.id);
                                        });
                                      } catch (e) {
                                        showCustomSnackBar(context, 'Nie udało się usunąć artykułu');
                                      }
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
              ],
            ),
          );
        },
      ),
    );
  }
}
