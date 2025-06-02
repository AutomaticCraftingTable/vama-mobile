import 'package:flutter/material.dart';
import 'package:vama_mobile/theme/light_theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> comment;
  final bool isLiked;
  final VoidCallback onTapProfile;
  final VoidCallback? onReport;
  final VoidCallback? onDelete;
  final String currentUsername;

  const CommentItem({
    super.key,
    required this.comment,
    required this.isLiked,
    required this.onTapProfile,
    required this.currentUsername,
    this.onReport,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime createdAt = DateTime.parse(comment['created_at']);
    final String timeAgo = timeago.format(createdAt);
    final int likes = comment['likes'] ?? 0;
    final bool isOwnComment = comment['causer'] == currentUsername;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTapProfile,
            child: CircleAvatar(
              backgroundImage: NetworkImage(comment['logo']),
              radius: 20,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comment['causer'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    PopupMenuButton<int>(
                      icon: const Icon(Icons.more_vert, size: 20),
                      onSelected: (value) {
                        if (value == 1 && onReport != null) {
                          onReport!();
                        } else if (value == 2 && onDelete != null) {
                          onDelete!();
                        }
                      },
                      itemBuilder: (context) => isOwnComment
                          ? [
                              const PopupMenuItem<int>(
                                value: 2,
                                child: Text("Usuń komentarz"),
                              ),
                            ]
                          : [
                              const PopupMenuItem<int>(
                                value: 1,
                                child: Text("Zgłoś komentarz"),
                              ),
                            ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment['content'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: LightTheme.text,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Text(
                      timeAgo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: LightTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
