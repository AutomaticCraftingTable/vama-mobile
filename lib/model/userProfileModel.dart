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

  Article({
    this.thumbnail,
    required this.tags,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    List<String> tagsList;
    if (json['tags'] is String) {
      tagsList = (json['tags'] as String)
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();
    } else if (json['tags'] is List) {
      tagsList = (json['tags'] as List<dynamic>)
          .map((tag) => tag.toString())
          .toList();
    } else {
      tagsList = [];
    }

    return Article(
      thumbnail: json['thumbnail'] as String?,
      tags: tagsList,
    );
  }
}
