import 'package:flutter/material.dart';
import 'package:vama_mobile/theme/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> comment;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onTapProfile;

  const CommentItem({
    super.key,
    required this.comment,
    required this.isLiked,
    required this.onLike,
    required this.onTapProfile,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime createdAt = DateTime.parse(comment['created_at']);
    final String timeAgo = timeago.format(createdAt);
    final int likes = comment['likes'] ?? 0;

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
                Text(
                  comment['causer'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  comment['content'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.text,
                    ),
                  
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onLike,
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: isLiked ? AppColors.like : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$likes",
                      style: const TextStyle(fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      timeAgo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
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
