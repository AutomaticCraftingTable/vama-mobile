
// models/author_model.dart
class AuthorModel {
  final int id;
  final String nickname;
  final String logo;

  AuthorModel({
    required this.id,
    required this.nickname,
    required this.logo,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'] is int
    ? json['id']
    : int.tryParse(json['id']?.toString() ?? '') ?? 0,

      nickname: json['nickname'] ?? '',
      logo: json['logo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'account_id': id,
        'nickname': nickname,
        'logo': logo,
      };
}

class CommentModel {
  final int id;
  final String causer;
  final int articleId;
  final String content;
  final String logo;
  final DateTime createdAt;
  final int likes;

  CommentModel({
    required this.id,
    required this.causer,
    required this.articleId,
    required this.content,
    required this.logo,
    required this.createdAt,
    required this.likes,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] is int
    ? json['id']
    : int.tryParse(json['id']?.toString() ?? '') ?? 0,

      causer: json['causer'] ?? '',
      articleId: json['article_id'] is int
          ? json['article_id']
          : int.parse(json['article_id'].toString()),
      content: json['content'] ?? '',
      logo: json['logo'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      likes: json['likes'] is int ? json['likes'] : int.parse(json['likes'].toString()),
    );
  }

  CommentModel copyWith({int? likes}) {
    return CommentModel(
      id: id,
      causer: causer,
      articleId: articleId,
      content: content,
      logo: logo,
      createdAt: createdAt,
      likes: likes ?? this.likes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'causer': causer,
        'article_id': articleId,
        'content': content,
        'logo': logo,
        'created_at': createdAt.toIso8601String(),
        'likes': likes,
      };
}




class ArticleDetail {
  final int id;
  final String title;
  final String content;
  final AuthorModel author;
  final int followersCount;
  final bool isSubscribed;
  final int likes;
  final DateTime createdAt;
  final List<CommentModel> comments;

  ArticleDetail({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.followersCount,
    required this.isSubscribed,
    required this.likes,
    required this.createdAt,
    required this.comments,
  });

  factory ArticleDetail.fromJson(Map<String, dynamic> json) {
    final authorJson = json['author'] as Map<String, dynamic>? ?? {};
    final author = AuthorModel.fromJson(authorJson);

    final rawComments = json['comments'] as List<dynamic>? ?? [];
    final comments = rawComments
        .map((c) => CommentModel.fromJson(c as Map<String, dynamic>))
        .toList();

    // Safely parse followersCount
    int followers = 0;
    if (json.containsKey('followers') && json['followers'] != null) {
      final f = json['followers'];
      if (f is int) followers = f;
      else {
        followers = int.tryParse(f.toString()) ?? 0;
      }
    }

    // Safely parse isSubscribed
    bool subscribed = false;
    if (json.containsKey('isSubscribed') && json['isSubscribed'] != null) {
      final s = json['isSubscribed'];
      if (s is bool) subscribed = s;
      else subscribed = s.toString().toLowerCase() == 'true';
    }

    return ArticleDetail(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      author: author,
      followersCount: followers,
      isSubscribed: subscribed,
      likes: json['likes'] is int ? json['likes'] : int.parse(json['likes'].toString()),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      comments: comments,
    );
  }

  ArticleDetail copyWith({
    int? likes,
    List<CommentModel>? comments,
    int? followersCount,
    bool? isSubscribed,
  }) {
    return ArticleDetail(
      id: id,
      title: title,
      content: content,
      author: author,
      followersCount: followersCount ?? this.followersCount,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      likes: likes ?? this.likes,
      createdAt: createdAt,
      comments: comments ?? List<CommentModel>.from(this.comments),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'author': author.toJson(),
        'followers': followersCount,
        'isSubscribed': isSubscribed,
        'likes': likes,
        'created_at': createdAt.toIso8601String(),
        'comments': comments.map((c) => c.toJson()).toList(),
      };
}
