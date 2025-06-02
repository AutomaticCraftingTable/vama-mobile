class UserProfile {
  final String nickname;
  final String logo;
  final String description;
  final int followers;
  final List<Article> articles;

  UserProfile({
    required this.nickname,
    required this.logo,
    required this.description,
    required this.followers,
    required this.articles,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final data = json['profile'] ?? json;

    final rawArticles = json['articles'] as List<dynamic>? ?? [];
    final articles = rawArticles
        .map((item) => Article.fromJson(item as Map<String, dynamic>))
        .toList();

    return UserProfile(
      nickname: data['nickname'] ?? '',
      logo: data['logo'] ?? '',
      description: data['description'] ?? '',
      followers: data['followers'] is int
          ? data['followers']
          : int.tryParse(data['followers'].toString()) ?? 0,
      articles: articles,
    );
  }
}

class Article {
  final String? thumbnail;
  final List<String> tags;
  final int id;

  Article({
    this.thumbnail,
    required this.tags,
    required this.id,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
     late List<String> tagsList;
    if (json['tags'] is String) {
      final raw = json['tags'] as String;
      if (raw.contains('#') && !raw.contains(',')) {
        tagsList = raw
            .split('#')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList();
      } else {
        tagsList = raw
            .split(',')
            .map((tag) => tag.replaceAll('#', '').trim())
            .where((tag) => tag.isNotEmpty)
            .toList();
      }
    } else if (json['tags'] is List) {
      tagsList = (json['tags'] as List<dynamic>)
          .map((tag) => tag.toString().trim())
          .where((tag) => tag.isNotEmpty)
          .toList();
    } else {
      tagsList = [];
    }

    return Article(
      thumbnail: json['thumbnail'] as String?,
      tags: tagsList,
       id: json['id'] as int,
    );
  }
}
