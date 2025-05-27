import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vama_mobile/api/api_service.dart';
import 'package:vama_mobile/components/auth_provider.dart';
import 'package:vama_mobile/components/buttons/custom_buttons.dart';
import 'package:vama_mobile/components/headers/header.dart';
import 'package:vama_mobile/model/userProfileModel.dart';
import 'package:vama_mobile/theme/light_theme.dart';


class UserProfilePage extends StatefulWidget {
  final int userId;
  

  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<UserProfile> _futureProfile;
  bool isSubscribed = false;
  bool isOwnProfile = false;


 @override
void initState() {
  super.initState();
  final auth = Provider.of<AuthProvider>(context, listen: false);
  isOwnProfile = widget.userId == auth.Id;
  _futureProfile = isOwnProfile
      ? ApiService().fetchOwnProfile().then((json) => UserProfile.fromJson(json))
      : ApiService().fetchUserProfile(widget.userId).then((json) => UserProfile.fromJson(json));
}


  Future<void> toggleSubscription() async {
    try {
      if (isSubscribed) {
        final response = await ApiService().unsubscribeFromProfile(widget.userId);
        if (response.statusCode == 200) {
          setState(() => isSubscribed = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Odsubskrybowano!')),
          );
        } else {
          throw Exception('Failed to unsubscribe');
        }
      } else {
        final response = await ApiService().subscribeToProfil(widget.userId);
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: profile.logo.isNotEmpty ? NetworkImage(profile.logo): null,
                      child: profile.logo.isEmpty ? const Icon(Icons.person, size: 35) : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.nickname,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: LightTheme.text),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${profile.followers} followers',
                            style: const TextStyle(color: LightTheme.textDimmed, fontSize: 10),
                          ),
                          if (profile.description.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              profile.description,
                              style: const TextStyle(fontSize: 10),
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
                              style: const TextStyle(fontSize: 11, color: LightTheme.text),
                            ),
                          ),
                          const SizedBox(height: 10),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, size: 20),
                            onSelected: (value) async {
                              if (value == 'report') {
                                try {
                                  await ApiService().reportProfile(
                                    widget.userId,
                                    'Zgłoszenie profilu',
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Profil został zgłoszony')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Nie udało się zgłosić Profilu')),
                                  );
                                }
                              }
                            },
                            itemBuilder: (context) => [
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
                  if (article.thumbnail != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        article.thumbnail!,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Wrap(
                    spacing: 8,
                    children: article.tags.map((tag) => Chip(label: Text(tag), visualDensity: VisualDensity.compact)).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
